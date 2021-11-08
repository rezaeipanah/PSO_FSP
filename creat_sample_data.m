function [seri_serv,node_c]=creat_sample_data(TT,tedad)

N_C=5;%node count
N_R1=100;%node's resource min
N_R2=200;%node's resource max
j_C=20;%job kind difference
N_J1=10;%job's need min
N_J2=20;%job's need max
C_J1=round(TT*0.5);%job's cost min
C_J2=round(0.8*TT);%job's cost max
D_J1=2*TT;%job's deadline min
D_J2=4*TT;%job's deadline max
model_nj=creat_n_j3(N_C,N_R1,N_R2,j_C,N_J1,N_J2,C_J1,C_J2,D_J1,D_J2);

max_service=60;
% c=randi([20 max_service],[1 tedad]);
for (i=1:tedad)
c=randi([20 max_service]);
entekhab=randi(j_C,[1 c]);
seri_serv(i)=creat_m4(model_nj,entekhab,c,TT);
end
node_c=N_C;
% seri_serv=seri_serv
end
