clear all
close all
clc

num_sym = 1e6;
info = randi([0 1],num_sym,1);
info_mod = pskmod(info, 2);
% parametros do canal
fd = 100;
Rs = 10e3;

% canal sendo criado
canal1 = rayleighchan(1/Rs, fd);
canal1.StoreHistory = 1;
canal2 = rayleighchan(1/Rs, fd);
canal2.StoreHistory = 1;

% filter representa o processo de transmissao
sinal_rx1 = filter(canal1, info_mod);
ganho_canal1 = canal1.PathGains;
sinal_rx2 = filter(canal2, info_mod);
ganho_canal2 = canal2.PathGains;

% soma de awgn em diversas condicoes (SNR variando)
for SNR = 0:25
    sinal_rx1_awgn = awgn(sinal_rx1, SNR);
    sinal_rx2_awgn = awgn(sinal_rx2, SNR);
    
    % equalizacao (remover giro da constelacao)
    sinal_eq_1 = sinal_rx1_awgn./ganho_canal1;
    sinal_eq_2 = sinal_rx2_awgn./ganho_canal2;
    
    % comparacao para pegar o melhor canal
    for t = 1:length(info_mod)
        if abs(ganho_canal1(t)) > abs(ganho_canal2(t))
            sinal_demod(t) = pskdemod(sinal_eq_1(t), 2);
            ganho_eq(t) = ganho_canal1(t);
        else
            sinal_demod(t) = pskdemod(sinal_eq_2(t), 2);
            ganho_eq(t) = ganho_canal2(t);
        end
    end
    
    sinal_MRC = (sinal_rx1_awgn.*conj(ganho_canal1)) + (sinal_rx2_awgn.*conj(ganho_canal2));
    sinal_demod_MRC = pskdemod(sinal_MRC, 2);
    
    sinal_demod_1Tx1Rx = pskdemod(sinal_eq_1, 2);
    [num(SNR+1), taxa(SNR+1)] = biterr(info, transpose(sinal_demod));
    [num2(SNR+1), taxa2(SNR+1)] = biterr(info, sinal_demod_1Tx1Rx);
    [num_MRC(SNR+1), taxa_MRC(SNR+1)] = biterr(info, (sinal_demod_MRC));
end

figure(1)
plot(20*log10(abs(ganho_canal1)),'b')
hold on
plot(20*log10(abs(ganho_canal2)),'r')
hold on
plot(20*log10(abs(ganho_eq)),'y')
title('Sinal recebido'); ylabel('Potência (dBm)');xlabel('tempo (s)');
legend('Ganho Rx 1', 'Ganho Rx 2', 'Ganho Equivalente')

figure(2)
semilogy([0:25],taxa,'b', [0:25],taxa2,'r', [0:25],taxa_MRC,'y') 
title('Desempenho BER X SNR'); ylabel('BER');xlabel('SNR [dB]');
legend('Sinal demodulado', 'Sinal demodulado Rx 1', 'Sinal MRC')
