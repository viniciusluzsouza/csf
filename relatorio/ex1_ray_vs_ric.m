clear all;
close all;
clc;

Rs = 100e3;                              %taxa de transmissÃ£o de simbolos
Tb = 1/Rs;                               %tempo de simbolo, nesse caso tempo de bit, pois a transmissÃ£o Ã© binÃ¡ria
doppler = 300;                           %simula 3 hertz = modelo de uma pessoa caminhando
num_sym = 1e6;                           %nÃºmero de simbolos a ser transmitido
M = 2;                                   %ordem da modulaÃ§aÃµ

info = randi([0,1],num_sym,1);           %cria a informaÃ§Ã£o aleatÃ³ria, nesse caso cria uma informaÃ§Ã£o aleatÃ³ria binÃ¡ria
info_mod = pskmod(info,M);               %modula a informaÃ§Ã£o, nesse caso PSK


canal_ray = rayleighchan(1/Rs,doppler);          
canal_ray.StoreHistory = 1;
sinal_recebido_ray = filter(canal_ray,info_mod);
ganho_ray = canal_ray.PathGains;

for SNR = 0:30
    sinalRx_ray_awgn = awgn(sinal_recebido_ray, SNR);
    sinalEq_ray = sinalRx_ray_awgn./ganho_ray;
    sinal_demodulado_ray = pskdemod(sinalEq_ray,M);
    [num_ray(SNR+1), taxa_ray(SNR+1)]= symerr(info,sinal_demodulado_ray);
    
    for k = [1 10 50 100]
        canal_ric = ricianchan(1/Rs,doppler,k);
        canal_ric.StoreHistory = 1;
        sinal_recebido_ric = filter(canal_ric,info_mod);
        ganho_ric = canal_ric.PathGains;
        
        sinalRx_ric_awgn = awgn(sinal_recebido_ric, SNR);
        sinalEq_ric = sinalRx_ric_awgn./ganho_ric;
        sinal_demodulado_ric = pskdemod(sinalEq_ric,M);
        
        if k == 1
            [k_1(SNR+1), taxa_ric1(SNR+1)] = symerr(info,sinal_demodulado_ric);
        elseif k == 10
            [k_10(SNR+1), taxa_ric10(SNR+1)] = symerr(info,sinal_demodulado_ric);
        elseif k == 50
            [k_50(SNR+1), taxa_ric50(SNR+1)] = symerr(info,sinal_demodulado_ric);
        else
            [k_100(SNR+1), taxa_ric100(SNR+1)] = symerr(info,sinal_demodulado_ric);
        end
    end
end

figure(1)
semilogy([0:30],taxa_ray,'r',[0:30], taxa_ric1,'b',[0:30], taxa_ric10,'y',[0:30], taxa_ric50,'g',[0:30], taxa_ric100,'k');grid on;
title('Desempenho BER X SNR'); ylabel('BER');xlabel('SNR [dB]');
legend('Rayleigh', 'Rician K=1', 'Rician K=10', 'Rician K=50', 'Rician K=100')