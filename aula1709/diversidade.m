clear all
close all
clc

%tau = [0 1 2 5]*1e-6;
%pdb = [-20 -10 -10 0];
Rs = 10e3;
num_bits = 1e4;
fd = 10;
% t = [0:1/Rs:num_bits/Rs-(1/Rs)];
% info = randint(1,num_bits,2);
info = randi([0 1], num_bits, 1);
info_mod = pskmod(info,2); 
%canal = rayleighchan(1/1000, 30, tau, pdb);
canal_ray_1 = rayleighchan(1/Rs,fd);
canal_ray_2 = rayleighchan(1/Rs,fd);
canal_ray_3 = rayleighchan(1/Rs,fd);
canal_ray_4 = rayleighchan(1/Rs,fd);
canal_ray_5 = rayleighchan(1/Rs,fd);
canal_ray_6 = rayleighchan(1/Rs,fd);
canal_ray_1.StoreHistory = 1;
canal_ray_2.StoreHistory = 1;
canal_ray_3.StoreHistory = 1;
canal_ray_4.StoreHistory = 1;
canal_ray_5.StoreHistory = 1;
canal_ray_6.StoreHistory = 1;

sinal_rec_ray_1 = filter(canal_ray_1, info_mod);
sinal_rec_ray_2 = filter(canal_ray_2, info_mod);
sinal_rec_ray_3 = filter(canal_ray_3, info_mod);
sinal_rec_ray_4 = filter(canal_ray_4, info_mod);
sinal_rec_ray_5 = filter(canal_ray_5, info_mod);
sinal_rec_ray_6 = filter(canal_ray_6, info_mod);
ganho_ray_1 = canal_ray_1.PathGains;
ganho_ray_2 = canal_ray_2.PathGains;
ganho_ray_3 = canal_ray_3.PathGains;
ganho_ray_4 = canal_ray_4.PathGains;
ganho_ray_5 = canal_ray_5.PathGains;
ganho_ray_6 = canal_ray_6.PathGains;

figure(1)
% plot(t,20*log10(abs(ganho_ray_1)))
plot(20*log10(abs(ganho_ray_1)))
hold on
plot(20*log10(abs(ganho_ray_2)))
hold on
plot(20*log10(abs(ganho_ray_3)))
hold on
plot(20*log10(abs(ganho_ray_4)))
hold on
plot(20*log10(abs(ganho_ray_5)))
hold on
plot(20*log10(abs(ganho_ray_6)))


ganho_eq = max(ganho_ray_1, ganho_ray_2);
ganho_eq3 = max(ganho_eq, ganho_ray_3);
ganho_eq = max(ganho_eq3, ganho_ray_4);
ganho_eq = max(ganho_eq, ganho_ray_5);
ganho_eq = max(ganho_eq, ganho_ray_6);
hold on
plot(20*log10(abs(ganho_eq)), '.', 'LineWidth', 1)
hold on
plot(20*log10(abs(ganho_eq3)), '*', 'LineWidth', 1)
