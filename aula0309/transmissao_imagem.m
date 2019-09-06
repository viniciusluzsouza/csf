clear all;
close all;
clc;

Rs = 10e3;                              % taxa de transmissÃ£o de simbolos
Tb = 1/Rs;                               % tempo de simbolo, nesse caso tempo de bit, pois a transmissÃ£o Ã© binÃ¡ria
doppler = 4;                           % simula 3 hertz = modelo de uma pessoa caminhando
k = 1;                                  % parÃ¢metro Riciano
num_sym = 1e6;                           %nÃºmero de simbolos a ser transmitido
M = 2;                                   %ordem da modulaÃ§aÃµ
SNR = 10;

imagem = imread('ifsc.png');
[linha, coluna, dim] = size(imagem);
imagem_serial = reshape(imagem, 1, (linha*coluna*dim));
imagem_bin = de2bi(imagem_serial);
imagem_bin_serial = reshape(imagem_bin, 1, size(imagem_bin,1)*size(imagem_bin,2));

info = transpose(double(imagem_bin_serial));
% info = randi([0,1],num_sym,1);           %cria a informaÃ§Ã£o aleatÃ³ria, nesse caso cria uma informaÃ§Ã£o aleatÃ³ria binÃ¡ria
info_mod = pskmod(info,M);               %modula a informaÃ§Ã£o, nesse caso PSK

%gera o objeto que representa o canal      
canal_ric = ricianchan(1/Rs,doppler,k);
%habilitando a gravaÃ§Ã£o dos ganhos do canal
canal_ric.StoreHistory = 1;
%filter representa o ato de transmitir por um canal sem fio
sinal_recebido_ric = filter(canal_ric,info_mod);
%salvando os ganhos do canal
ganho_ric = canal_ric.PathGains;

%modelando a inserÃ§Ã£o do ruÃ­do nos sinais recebidos
sinalRx_ric_awgn = awgn(sinal_recebido_ric, SNR);

%(equalizaÃ§Ã£o) = elimina os efeitos de rotaÃ§Ã£o de fase e alteraÃ§Ã£o de amplitude do sinal recebido 
sinalEq_ric = sinalRx_ric_awgn./ganho_ric;

%sinais demodulados
sinal_demodulado_ric = pskdemod(sinalEq_ric,M);

% aaa
[linha_s, coluna_s] = size(imagem_bin);
imagem_rx = uint8(sinal_demodulado_ric);
imagem_rx = reshape(imagem_rx, linha_s, coluna_s);
imagem_rx = bi2de(imagem_rx);
imagem_rx = reshape(imagem_rx, linha, coluna, dim);

figure(1)
image(imagem)
figure(2)
image(imagem_rx)
