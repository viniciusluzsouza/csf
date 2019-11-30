clear all
close all
clc

% parametros do canal
fd = 100;
Rs = 10e3;

M = 2;
info = randi([0 M-1], 2000, 1);
info_mod = pskmod(info, M);

info_mod_i = info_mod(1:2:end); % impares
info_mod_p = info_mod(2:2:end); % pares

info_tx_1 = zeros(1, length(info));
info_tx_2 = zeros(1, length(info));

info_tx_1(1:2:end) = info_mod_i;
info_tx_1(2:2:end) = -conj(info_mod_p);
info_tx_2(1:2:end) = info_mod_p;
info_tx_2(2:2:end) = conj(info_mod_i);

% canal sendo criado
canal1 = rayleighchan(1/Rs, fd);
canal1.StoreHistory = 1;
canal2 = rayleighchan(1/Rs, fd);
canal2.StoreHistory = 1;

% filter representa o processo de transmissao
sinal_rx1 = filter(canal1, info_tx_1);
ganho_canal1 = canal1.PathGains;
sinal_rx2 = filter(canal2, info_tx_2);
ganho_canal2 = canal2.PathGains;

% soma de awgn em diversas condicoes (SNR variando)
for SNR = 0:25
    sinal_rx1_awgn = awgn(sinal_rx1, SNR);
    sinal_rx2_awgn = awgn(sinal_rx2, SNR);
    
    % equalizacao (remover giro da constelacao)
    sinal_eq_1 = sinal_rx1_awgn./ganho_canal1;
    sinal_eq_2 = sinal_rx2_awgn./ganho_canal2;
    
    % comparacao para pegar o melhor canal
    % estimador canal
    for t = 1:length(info_mod)
        if abs(ganho_canal1(t)) > abs(ganho_canal2(t))
            sinal_demod(t) = pskdemod(sinal_eq_1(t), 2);
            ganho_eq(t) = ganho_canal1(t);
        else
            sinal_demod(t) = pskdemod(sinal_eq_2(t), 2);
            ganho_eq(t) = ganho_canal2(t);
        end
    end
    
    % combinador
    sinal_alam1 = ((conj(ganho_canal1)).*sinal_rx1_awgn) + ganho_canal2.*(conj(sinal_rx2_awgn));
    sinal_alam2 = ((conj(ganho_canal2)).*sinal_rx1_awgn) - ganho_canal1.*(conj(sinal_rx1_awgn));
    
    sinal_demod_alam_1 = pskdemod(sinal_alam1, 2);
    sinal_demod_alam_2 = pskdemod(sinal_alam2, 2);
    
    [num(SNR+1), taxa(SNR+1)] = biterr(info, transpose(sinal_demod_alam_1(1,:)));
    [num2(SNR+1), taxa2(SNR+1)] = biterr(info, transpose(sinal_demod_alam_2(1,:)));
end

figure(1)
plot(20*log10(abs(ganho_canal1)),'b')
hold on
plot(20*log10(abs(ganho_canal2)),'r')
hold on
plot(20*log10(abs(ganho_eq)),'y')

% figure(2)
% semilogy([0:25],taxa,'b', [0:25],taxa2,'r') 


