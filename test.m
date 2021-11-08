    job_nodes_se=randi(20,1,20);
    jobs=15;
[~,S_J_N]=sort(job_nodes_se);
    a=find(S_J_N>jobs);    %% find jobs sequence
    nodes_se=S_J_N(a);
    
    S_J_N(a)=[];
    job_se=S_J_N;       %% find nodes sequence
 nodes_se=nodes_se-jobs;