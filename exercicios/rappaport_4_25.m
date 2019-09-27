close all
clear all
clc

d = 1600;
n = 4;
d0 = 1;

desvio_padrao_db = 6;
desvio_padrao = 10^(desvio_padrao_db/10);

p0_dbm = 0;
p0 = 10^(p0_dbm/10);

Pr_min_dbm = -118;
Pr_min = 10^(Pr_min_dbm/10);

Pr_ho_dbm = -112;
Pr_ho = 10^(Pr_ho_dbm/10);

di1 = 0:d0:d;
di2 = d:-d0:0;
xi = randn(size(di1))*desvio_padrao_db;

Pr1 = p0_dbm - (10*n*log10(di1/d0)) + xi;
Pr2 = p0_dbm - (10*n*log10(di2/d0)) + xi;

Prob_r1_menor_prho = qfunc( (Pr1 - Pr_ho_dbm)/desvio_padrao_db );
Prob_r2_maior_prho = qfunc( (Pr_ho_dbm - Pr2)/desvio_padrao_db );

prob = Prob_r1_menor_prho.*Prob_r2_maior_prho;
plot(di1, prob);

