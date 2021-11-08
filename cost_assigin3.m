function [Cost ,Sol]=cost_assigin3(job_nodes_se,model)
global NFE;
    if isempty(NFE)
        NFE=0;
    end
    
    NFE=NFE+1;
mo=zeros(model.jobs,model.nodes);
cost_j_n=model.possible_nj;

a=find(job_nodes_se>model.jobs);    %% find jobs sequence
nodes_se=job_nodes_se(a);
nodes_se=nodes_se-model.jobs;

b=find(job_nodes_se<=model.jobs);       %% find nodes sequence
job_se=job_nodes_se(b);
%-----------------------------
new_node=model.mnode(nodes_se);
new_job=model.mjob(job_se);
new_possible=model.possible_nj(job_se,nodes_se);
L=find_sol8_new(new_job,new_node,new_possible,mo);
new_cost=model.cost_n(job_se,nodes_se);
Cost=sum(sum(L.a_nj.*new_cost));
[~,zb]=sort(nodes_se);
[~,zc]=sort(job_se);
Sol.assign=L.a_nj(zc,zb);
Sol.pj=round((L.c_j/model.jobs)*100);

%-----------------------------
% % L=find_sol8(job_se,nodes_se,model.mnode,model.mjob,mo);
% % 
% % Cost=sum(sum(L.a_nj.*model.cost_n));%+(model.jobs-L.c_j)*10000;
% % 
% % Sol.pj=round((L.c_j/model.jobs)*100);
% % Sol.assign=L.a_nj;
end