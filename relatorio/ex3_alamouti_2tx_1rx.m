clear all
close all
clc

% parametros do canal
fd = 100;
Rs = 10e3;

M = 2;
info = randi([0 M-1], 1e6, 1);
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
sinal_rx = sinal_rx1 + sinal_rx2;

% soma de awgn em diversas condicoes (SNR variando)
for SNR = 0:25
    sinal_rx_awgn = transpose(awgn(sinal_rx, SNR));
    
    % equalizacao (remover giro da constelacao)
    s1 = (conj(ganho_canal1(1:2:end)).*sinal_rx_awgn(1:2:end)) + (ganho_canal2(2:2:end).*conj(sinal_rx_awgn(2:2:end)));
    s2 = (conj(ganho_canal2(1:2:end)).*sinal_rx_awgn(1:2:end)) - (ganho_canal1(2:2:end).*conj(sinal_rx_awgn(2:2:end)));
    
    sinal_demod = zeros(1, length(info));
    sinal_demod(1:2:end) = s1;
    sinal_demod(2:2:end) = s2;
    sinal_demod_alam = pskdemod(sinal_demod, 2);
    
    [num(SNR+1), taxa(SNR+1)] = biterr(info, transpose(sinal_demod_alam));
end

figure(1)
semilogy([0:25],taxa,'b') 
title('Desempenho BER X SNR'); ylabel('BER');xlabel('SNR [dB]');

