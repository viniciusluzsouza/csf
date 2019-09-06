close all
clear all
clc

% Exercicio 4.25 - Pagina 111

% Declaracoes
d = 1600;
n = 4;
d0 = 1; % metro

desvio_padrao_db = 6; % dB
desvio_padrao = 10^(desvio_padrao_db/10);

p0_dbm = 0; % dBm
p0 = 10^(p0_dbm/10);

Pr_min_dbm = -118; % dBm
Pr_min = 10^(Pr_min_dbm/10);

Pr_ho_dbm = -112; % dBm
Pr_ho = 10^(Pr_ho_dbm/10);


% Calculos
di1 = 0:d0:d;
di2 = d:-d0:0;
xi = randn(size(di1))*desvio_padrao_db;

mx1 = p0_dbm - (10*n*log10(di1/d0));
mx2 = p0_dbm - (10*n*log10(di2/d0));

Pr1 = mx1 + xi;
Pr2 = mx2 + xi;

Prob_r1_menor_prho = qfunc( (mx1 - Pr_ho_dbm)/desvio_padrao_db );
Prob_r2_maior_prmin = qfunc( (Pr_min_dbm - mx2)/desvio_padrao_db );

prob = Prob_r1_menor_prho.*Prob_r2_maior_prmin;

plot(di1, prob)
