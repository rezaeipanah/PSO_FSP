function [Cost ,Sol]=cost_assigin2(job_nodes_se,model,kind)
global NFE;
if isempty(NFE)
    NFE=0;
end

NFE=NFE+1;
mo=zeros(model.jobs,model.nodes);
cost_j_n=model.possible_nj;
jobs=model.jobs;

if kind==1
    [~,S_J_N]=sort(job_nodes_se);
    a=find(S_J_N>jobs);    %% find jobs sequence
    nodes_se=S_J_N(a);
    nodes_se=nodes_se-jobs;
    S_J_N(a)=[];
    job_se=S_J_N;       %% find nodes sequence
    
elseif kind==2
    [~,job_se]=sort(job_nodes_se(1:jobs));    %% find jobs sequence
    [~,nodes_se]=sort(job_nodes_se(jobs+1:end));   %% find nodes sequence
    
else
    [~,job_se]=sort(job_nodes_se); %% find jobs sequence
    nodes_se=(1:1:model.nodes);   %% nodes sequence
    
end

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