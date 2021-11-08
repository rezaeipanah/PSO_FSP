function [p_list_serv,f_list_serv,r_list_serv]=analyz_service(list_serv)
p_list_serv=[];
f_list_serv=[];
f_list_node=[];
A_list_node=[];
r_list_serv=[];
r2_list_serv=[];
mp=list_serv.possible_nj;
for (i=1:list_serv.jobs)% at first calculate possible matrix
    for (j=1:list_serv.nodes)
        if (list_serv.wait_t(i)+list_serv.cost_n(i,j))<(list_serv.dl_servic(i))% && (list_serv.mjob(i)<=list_serv.mnode(j))
            list_serv.possible_nj(i,j)=1;
            if (list_serv.mjob(i)<=list_serv.mnode(j))
            mp(i,j)=1;
            else
            mp(i,j)=0; 
            end
        else
            list_serv.possible_nj(i,j)=0;
        end
    end
end
D=max(list_serv.possible_nj,[],2);%fail service
fail=find(D==0);
if ~(isempty(fail))
    f_list_serv.n=list_serv.mnode;
    f_list_serv.j=list_serv.mjob(fail);
    f_list_serv.dl=list_serv.dl_servic(fail);
    f_list_serv.w=list_serv.wait_t(fail);
    f_list_serv.a=list_serv.arrive_t(fail);
    f_list_serv.cost=min(list_serv.cost_n(fail,:),[],2);
    %16 items we have
    %4
    %8
    mp(fail,:)=[];
    list_serv.population_jobe(:,fail)=[];
    list_serv.mjob(fail)=[];
    list_serv.cost_n(fail,:)=[];
    list_serv.possible_nj(fail,:)=[];
    list_serv.arrive_t(fail)=[];
    list_serv.dl_servic(fail)=[];
    list_serv.wait_t(fail)=[];
    list_serv.done_t(fail)=[];
    list_serv.jobs=numel(list_serv.mjob);
    list_serv.nVar=list_serv.jobs+list_serv.nodes;
    list_serv.possible_nj=mp;
end
D=max(mp,[],2);%fail service
fail=find(D==0);
nfail=find(D==1);
if ~(isempty(fail))
    r_list_serv=list_serv;
    r_list_serv.population_jobe(:,nfail)=[];
    r_list_serv.mjob(nfail)=[];
    r_list_serv.cost_n(nfail,:)=[];
    r_list_serv.possible_nj(nfail,:)=[];
    r_list_serv.arrive_t(nfail)=[];
    r_list_serv.dl_servic(nfail)=[];
    r_list_serv.wait_t(nfail)=[];
    r_list_serv.done_t(nfail)=[];
    r_list_serv.jobs=numel(r_list_serv.mjob);
    r_list_serv.nVar=r_list_serv.jobs+r_list_serv.nodes;

    %16 items we have
    %4
    %8
    list_serv.population_jobe(:,fail)=[];
    list_serv.mjob(fail)=[];
    list_serv.cost_n(fail,:)=[];
    list_serv.possible_nj(fail,:)=[];
    list_serv.arrive_t(fail)=[];
    list_serv.dl_servic(fail)=[];
    list_serv.wait_t(fail)=[];
    list_serv.done_t(fail)=[];
    list_serv.jobs=numel(list_serv.mjob);
    list_serv.nVar=list_serv.jobs+list_serv.nodes;
end


p_list_serv=list_serv;
if list_serv.jobs>0
    
    alpha=0.3;
    dl_servic=list_serv.dl_servic;
    wait_t=list_serv.wait_t;
    % pr=zeros(1,list_serv.jobs);
    
    pr=(alpha./dl_servic)+((1-alpha)./wait_t);
    [~ ,index_pr]=sort(pr);
    
    list_serv.possible_nj=list_serv.possible_nj(index_pr,:);
    list_serv.cost_n=list_serv.cost_n(index_pr,:);
    list_serv.mjob=list_serv.mjob(index_pr);
    list_serv.arrive_t=list_serv.arrive_t(index_pr);
    list_serv.dl_servic=list_serv.dl_servic(index_pr);
    list_serv.done_t=list_serv.done_t(index_pr);
    list_serv.wait_t=list_serv.wait_t(index_pr);
    list_serv.population_jobe=list_serv.population_jobe(:,index_pr);
    list_serv.old_cost=list_serv.cost_n;
    %1
    
    DD=max(list_serv.possible_nj,[],1);
  
    count_list_serv=list_serv.jobs;
    not_fail=find(DD>0);
    sum_res=sum(list_serv.mnode(not_fail));
    t=1;
    while (t<=count_list_serv)&&(sum_res>0)
        sum_res=sum_res-list_serv.mjob(t);
        t=t+1;
    end
    
    if (t>count_list_serv)
        t=t-1;
    end
    p_list_serv=list_serv;
    p_list_serv.possible_nj((t+1):end,:)=[];
    p_list_serv.cost_n((t+1):end,:)=[];
    p_list_serv.mjob((t+1):end)=[];
    p_list_serv.arrive_t((t+1):end)=[];
    p_list_serv.dl_servic((t+1):end)=[];
    p_list_serv.wait_t((t+1):end)=[];
    p_list_serv.done_t((t+1):end)=[];
    p_list_serv.population_jobe(:,(t+1):end)=[];
    p_list_serv.jobs=numel(p_list_serv.mjob);
    p_list_serv.old_cost((t+1):end,:)=[];
    if (t<count_list_serv)
    r2_list_serv=list_serv;
    r2_list_serv.possible_nj(1:t,:)=[];
    r2_list_serv.cost_n(1:t,:)=[];
    r2_list_serv.old_cost(1:t,:)=[];
    r2_list_serv.mjob(1:t)=[];
    r2_list_serv.arrive_t(1:t)=[];
    r2_list_serv.dl_servic(1:t)=[];
    r2_list_serv.wait_t(1:t)=[];
    r2_list_serv.done_t(1:t)=[];
    r2_list_serv.population_jobe(:,1:t)=[];
    r2_list_serv.jobs=numel(r2_list_serv.mjob);
    r2_list_serv.nVar=r2_list_serv.jobs+r2_list_serv.nodes;
    r_list_serv=merg_lists(r_list_serv,r2_list_serv);
    end
    
    DD=max(p_list_serv.possible_nj,[],1);%find not enough node
    p_list_serv.old_cost=p_list_serv.cost_n;
    if max(DD)>0
        f_list_node=find(DD==0);
        A_list_node=find(DD>0);
        %3
        p_list_serv.mnode(f_list_node)=[];
        p_list_serv.node_id(f_list_node)=[];
        p_list_serv.population_node(:,f_list_node)=[];
        p_list_serv.cost_n(:,f_list_node)=[];
        p_list_serv.possible_nj(:,f_list_node)=[];
        p_list_serv.nodes=numel(p_list_serv.mnode);
    end
    %1
    p_list_serv.population=[p_list_serv.population_jobe p_list_serv.population_node];
    p_list_serv.nVar=p_list_serv.jobs+p_list_serv.nodes;
end

end