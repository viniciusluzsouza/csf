clear all;
close all;
clc;

Rs = 100e3;                              % taxa de transmissÃ£o de simbolos
Tb = 1/Rs;                               % tempo de simbolo, nesse caso tempo de bit, pois a transmissÃ£o Ã© binÃ¡ria
doppler = 300;                           % simula 3 hertz = modelo de uma pessoa caminhando
k = 10;                                  % parÃ¢metro Riciano
num_sym = 1e6;                           %nÃºmero de simbolos a ser transmitido
M = 2;                                   %ordem da modulaÃ§aÃµ
SNR = 10;

imagem = imread('ifsc.png');
[a, b, c] = size(imagem)
imagem_serial = reshape(imagem, 1, (a*b*c));
imagem_bin = de2bi(imagem_serial);
imagem_bin_serial = reshape(imagem_bin, 1, size(imagem_bin,1)*size(imagem_bin,2));

info = transpose(double(imagem_bin_serial));
% info = randi([0,1],num_sym,1);           %cria a informaÃ§Ã£o aleatÃ³ria, nesse caso cria uma informaÃ§Ã£o aleatÃ³ria binÃ¡ria
info_mod = pskmod(info,M);               %modula a informaÃ§Ã£o, nesse caso PSK
%gera o objeto que representa o canal
canal_ray = rayleighchan(1/Rs,30);          
canal_ric = ricianchan(1/Rs,doppler,k);
%habilitando a gravaÃ§Ã£o dos ganhos do canal
canal_ray.StoreHistory = 1;
canal_ric.StoreHistory = 1;
%filter representa o ato de transmitir por um canal sem fio
sinal_recebido_ray = filter(canal_ray,info_mod);
sinal_recebido_ric = filter(canal_ric,info_mod);
%salvando os ganhos do canal
ganho_ray = canal_ray.PathGains;
ganho_ric = canal_ric.PathGains;


%loop representa a variaÃ§Ã£o do SNR
%modelando a inserÃ§Ã£o do ruÃ­do nos sinais recebidos
sinalRx_ray_awgn = awgn(sinal_recebido_ray, SNR);
sinalRx_ric_awgn = awgn(sinal_recebido_ric, SNR);
%(equalizaÃ§Ã£o) = elimina os efeitos de rotaÃ§Ã£o de fase e alteraÃ§Ã£o de amplitude do sinal recebido
sinalEq_ray = sinalRx_ray_awgn./ganho_ray;      
sinalEq_ric = sinalRx_ric_awgn./ganho_ric;
%sinais demodulados
sinal_demodulado_ray = pskdemod(sinalEq_ray,M);
sinal_demodulado_ric = pskdemod(sinalEq_ric,M);
%comparando a sequÃªncia de informaÃ§Ã£o gerada com a informaÃ§Ã£o demodulada, para anÃ¡lise de erros
[num_ray, taxa_ray]= symerr(info,sinal_demodulado_ray)
[num_ric, taxa_ric]= symerr(info,sinal_demodulado_ric)

%plot
% semilogy([0:30],taxa_ray,'r',[0:30], taxa_ric,'b');grid on;
% title('Desempenho BER X SNR'); ylabel('BER');xlabel('SNR [dB]');


% A = imread('ifsc.png')
% A_serial = reshape(A, 1, (300*300*3));
% A_bin = de2bi(A_serial);
% A_bin_serial = reshape(A_bin, 1, (270000*8));
% info = double(A_bin_serial);