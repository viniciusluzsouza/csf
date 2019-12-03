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
canal11 = rayleighchan(1/Rs, fd);
canal11.StoreHistory = 1;
canal12 = rayleighchan(1/Rs, fd);
canal12.StoreHistory = 1;
canal21 = rayleighchan(1/Rs, fd);
canal21.StoreHistory = 1;
canal22 = rayleighchan(1/Rs, fd);
canal22.StoreHistory = 1;

% filter representa o processo de transmissao
sinal_rx11 = filter(canal11, info_tx_1);
ganho_canal11 = canal11.PathGains;
sinal_rx12 = filter(canal12, info_tx_1);
ganho_canal12 = canal12.PathGains;
sinal_rx21 = filter(canal21, info_tx_2);
ganho_canal21 = canal21.PathGains;
sinal_rx22 = filter(canal22, info_tx_2);
ganho_canal22 = canal22.PathGains;

% soma de awgn em diversas condicoes (SNR variando)
for SNR = 0:25
    sinal_rx_awgn1 = transpose(awgn(sinal_rx11 + sinal_rx21, SNR));
    sinal_rx_awgn2 = transpose(awgn(sinal_rx12 + sinal_rx22, SNR));
    
    % equalizacao (remover giro da constelacao)
    s1 = (conj(ganho_canal11(1:2:end)).*sinal_rx_awgn1(1:2:end)) + (ganho_canal21(2:2:end).*conj(sinal_rx_awgn1(2:2:end)));
    s1 = s1 + (conj(ganho_canal12(1:2:end)).*sinal_rx_awgn2(1:2:end)) + (ganho_canal22(2:2:end).*conj(sinal_rx_awgn2(2:2:end)));
    
    s2 = (conj(ganho_canal21(1:2:end)).*sinal_rx_awgn1(1:2:end)) - (ganho_canal11(2:2:end).*conj(sinal_rx_awgn1(2:2:end)));
    s2 = s2 + ((conj(ganho_canal22(1:2:end)).*sinal_rx_awgn2(1:2:end)) - (ganho_canal12(2:2:end).*conj(sinal_rx_awgn2(2:2:end))));
    
    sinal_demod = zeros(1, length(info));
    sinal_demod(1:2:end) = s1;
    sinal_demod(2:2:end) = s2;
    sinal_demod_alam = pskdemod(sinal_demod, 2);
    
    [num(SNR+1), taxa(SNR+1)] = biterr(info, transpose(sinal_demod_alam));
end

figure(1)
semilogy([0:25],taxa,'b') 
title('Desempenho BER X SNR'); ylabel('BER');xlabel('SNR [dB]');

