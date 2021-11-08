clc;
clear;
N_C=15;
N_R1=200;
N_R2=300;
j_C=250
N_J1=10;
N_J2=20;
C_J1=5;
C_J2=10;
D_J1=40;
D_J2=60;

model_nj=creat_n_j3(N_C,N_R1,N_R2,j_C,N_J1,N_J2,C_J1,C_J2,D_J1,D_J2);
% sum(model_nj.node)
% sum(model_nj.servic)