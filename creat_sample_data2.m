function [seri_serv,xx]=creat_sample_data2(TT,tedad,node_c)
xx=zeros(1,tedad);
N_C=node_c;%node count
N_R1=2000;%node's resource min
N_R2=2500;%node's resource max
j_C=20;%job kind difference
N_J1=10;%job's need min
N_J2=20;%job's need max
C_J1=8;%job's cost min
C_J2=15;%job's cost max
D_J1=10;%job's deadline min
D_J2=20;%job's deadline max
model_nj=creat_n_j3(N_C,N_R1,N_R2,j_C,N_J1,N_J2,C_J1,C_J2,D_J1,D_J2);

% max_service=60;
for (i=1:tedad)
c=1000*i;
entekhab=randi(j_C,[1 c]);
seri_serv(i)=creat_m4(model_nj,entekhab,c,TT);
seri_serv(i).population=[seri_serv(i).population_jobe seri_serv(i).population_node];
xx(i)=c;
end
% seri_serv=seri_serv
end
