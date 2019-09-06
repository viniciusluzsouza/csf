close all
clear all
clc

% Exemplo desvanecimento

tau = [0 1 2 5]*1e-6; % tempo
pdb = [-20 -10 -10 -0]; % potencia
info = randint(1, 100, 2); % em 100 transmissoes (amostras)
% info = randi([0 1], 1, 5000);
info_mod = pskmod(info, 2);

 % 3 (Hz) de doppler - pessoa caminhando (canal estatico):
canal = rayleighchan(1/1000, 30, tau, pdb);
canal.StoreHistory = 1; % simular canal sendo alterado (dinamico)
sinal_rec = filter(canal, info_mod);

plot(canal)
