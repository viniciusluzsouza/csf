close all
clear all
clc

% Exemplo desvanecimento

info = randint(1, 5000, 2);
% info = randi([0 1], 1, 5000);
info_mod = pskmod(info, 2);
canal = rayleighchan(1/10000, 3); % 3 (Hz) de doppler - pessoa caminhando (canal estatico)
canal.StoreHistory = 1; % simular canal sendo alterado (dinamico)
sinal_rec = filter(canal, info_mod);

