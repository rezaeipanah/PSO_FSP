function model_nj=creat_n_j3(N_C,N_R1,N_R2,j_C,N_J1,N_J2,C_J1,C_J2,D_J1,D_J2)
node_c=N_C; %randi(50);
node_id=(1:1:N_C);%sort(randperm(N_C));
node=randi([N_R1,N_R2],[1,node_c]);
job_c=j_C;
n_job= randi([N_J1,N_J2],[1,job_c]);
cost_nj=randi([C_J1,C_J2],[job_c, node_c]);
dl_j=randi([D_J1,D_J2],[1,job_c]);%numel(job)
model_nj.cost_nj=cost_nj;
model_nj.node=node;
model_nj.node_id=node_id;
model_nj.servic=n_job;
model_nj.dl_servic=dl_j;
end


