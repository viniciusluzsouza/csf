clear all;
close all;
clc;

Rs = 10e3;                              % taxa de transmissÃ£o de simbolos
Tb = 1/Rs;                               % tempo de simbolo, nesse caso tempo de bit, pois a transmissÃ£o Ã© binÃ¡ria
doppler = 4;                           % simula 3 hertz = modelo de uma pessoa caminhando
K = 1;                                  % parÃ¢metro Riciano
M = 2;                                   %ordem da modulaÃ§aÃµ
SNR = 10;

imagem = imread('fusca.jpeg');
[linha, coluna, dim] = size(imagem);
imagem_serial = reshape(imagem, 1, (linha*coluna*dim));
imagem_bin = de2bi(imagem_serial);
imagem_bin_serial = reshape(imagem_bin, 1, size(imagem_bin,1)*size(imagem_bin,2));

info = transpose(double(imagem_bin_serial));
info_mod = pskmod(info,M);               %modula a informaÃ§Ã£o, nesse caso PSK

figure(1)
image(imagem)

SNR_V = [100 100 0 10];
K_V = [1 1000 1000 1];
for i=1:4
    snr = SNR_V(i);
    k = K_V(i);

    canal_ric = ricianchan(1/Rs,doppler,k);
    canal_ric.StoreHistory = 1;
    sinal_recebido_ric = filter(canal_ric,info_mod);
    ganho_ric = canal_ric.PathGains;

    sinalRx_ric_awgn = awgn(sinal_recebido_ric, snr);
    sinalEq_ric = sinalRx_ric_awgn./ganho_ric;

    sinal_demodulado_ric = pskdemod(sinalEq_ric,M);

    [linha_s, coluna_s] = size(imagem_bin);
    imagem_rx = uint8(sinal_demodulado_ric);
    imagem_rx = reshape(imagem_rx, linha_s, coluna_s);
    imagem_rx = bi2de(imagem_rx);
    imagem_rx = reshape(imagem_rx, linha, coluna, dim);

    
    figure(i+1)
    image(imagem_rx)
    title_str = strcat({'SNR = '}, num2str(snr), ', K = ', num2str(k));
    title(title_str)
end
