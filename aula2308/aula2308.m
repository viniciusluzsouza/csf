close all
clear all
clc

% Exemplo desvanecimento

% tau = [0 1 2 5]*1e-6; % tempo
% pdb = [-20 -10 -10 -0]; % potencia em db relativa
Rs = 100e3;
num_bits = 1e6;
t = [0:1/Rs:num_bits/Rs-(1/Rs)];
fd = 30; % frequencia doppler

info = randint(1, num_bits, 2); % em 100 transmissoes (amostras)
% info = randi([0 1], 1, 5000);
info_mod = pskmod(info, 2);

 % 3 (Hz) de doppler - pessoa caminhando (canal estatico):
% canal = rayleighchan(1/1000, 30, tau, pdb);
canal = rayleighchan(1/Rs, fd);
canal.StoreHistory = 1; % simular canal sendo alterado (dinamico)
sinal_rec = filter(canal, info_mod); % a transmissao em si (gera os ganhos)

plot(canal)

ganho = canal.PathGains;
% hist(real(ganho), 100); % ver distribuicao
% hist(abs(ganho), 100); % rayleighchan 
% hist(angle(ganho), 100); % fase uniforme
% plot(20*log10(abs(ganho))); % fase uniforme

plot(t, 20*log10(abs(ganho)));


