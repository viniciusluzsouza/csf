clear all;
close all;
clc;

Rs = 100e3;                              %taxa de transmissÃ£o de simbolos
Tb = 1/Rs;                               %tempo de simbolo, nesse caso tempo de bit, pois a transmissÃ£o Ã© binÃ¡ria
doppler = 300;                           %simula 3 hertz = modelo de uma pessoa caminhando
k = 10;                                   %parÃ¢metro Riciano
num_sym = 1e6;                           %nÃºmero de simbolos a ser transmitido
M = 2;                                   %ordem da modulaÃ§aÃµ

info = randi([0,1],num_sym,1);           %cria a informaÃ§Ã£o aleatÃ³ria, nesse caso cria uma informaÃ§Ã£o aleatÃ³ria binÃ¡ria
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
for SNR = 0:30  
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
    [num_ray(SNR+1), taxa_ray(SNR+1)]= symerr(info,sinal_demodulado_ray);
    [num_ric(SNR+1), taxa_ric(SNR+1)]= symerr(info,sinal_demodulado_ric);
end;

%plot
semilogy([0:30],taxa_ray,'r',[0:30], taxa_ric,'b');grid on;
title('Desempenho BER X SNR'); ylabel('BER');xlabel('SNR [dB]');