function [m_list_serv,r_list_serv,f_s_list_serv]=select_list(list_serv,T,T_service)
check_p=0;
if sum(list_serv.mnode) >= sum(list_serv.mjob)
    m_list_serv=list_serv;
    r_list_serv=[];
    check_p=1;
else
    count_list_serv=list_serv.jobs;
    sum_res=sum(list_serv.mnode);
    t=1;
    m_list_serv=list_serv;
    r_list_serv=list_serv;
    t_r=1;
    t_m=1;
    
    while (t<=count_list_serv)&&(sum_res>0)
        I=find(list_serv.mnode>=list_serv.mjob(t),1);
        if ~isempty(I)&&(sum_res>=list_serv.mjob(t))
            sum_res=sum_res-list_serv.mjob(t);
            
            r_list_serv.jobs=r_list_serv.jobs-1;
            r_list_serv.nVar=r_list_serv.nVar-1;
            r_list_serv.population(:,t_r)=[];
            r_list_serv.mjob(t_r)=[];
            r_list_serv.cost_n(t_r,:)=[];
            r_list_serv.possible_nj(t_r,:)=[];
            r_list_serv.arrive_t(t_r)=[];
            r_list_serv.dl_servic(t_r)=[];
            r_list_serv.wait_t(t_r)=[];
            t_m=t_m+1;
            
        else
            m_list_serv.jobs=m_list_serv.jobs-1;
            m_list_serv.nVar=m_list_serv.nVar-1;
            m_list_serv.population(:,t_m)=[];
            m_list_serv.mjob(t_m)=[];
            m_list_serv.cost_n(t_m,:)=[];
            m_list_serv.possible_nj(t_m,:)=[];
            m_list_serv.arrive_t(t_m)=[];
            m_list_serv.dl_servic(t_m)=[];
            m_list_serv.wait_t(t_m)=[];
            t_r=t_r+1;
            
        end
        t=t+1;
    end
    m_list_serv.population(:,t_m:(end-m_list_serv.nodes))=[];
    m_list_serv.mjob(t_m:end)=[];
    m_list_serv.cost_n(t_m:end,:)=[];
    m_list_serv.possible_nj(t_m:end,:)=[];
    m_list_serv.arrive_t(t_m:end)=[];
    m_list_serv.dl_servic(t_m:end)=[];
    m_list_serv.wait_t(t_m:end)=[];
    m_list_serv.jobs=numel(m_list_serv.mjob);
    m_list_serv.nVar=m_list_serv.jobs+m_list_serv.nodes;
    check_p=2;
end
count_T=numel(T);
count_ch_list_serv=m_list_serv.jobs;
time_need=min(T(find(T_service==count_ch_list_serv)));
if isempty(time_need)
    if count_T<3
        time_need=0;
    elseif count_T==3
        [A,B,C]=find_abc(T,T_service);
        time_need=A*count_ch_list_serv*count_ch_list_serv+B*count_ch_list_serv+C;
    elseif count_T>3
        [sort_T_service,sort_seq]=sort(T_service);
        sort_T=T(sort_seq);
        first_t=find(sort_T_service>count_ch_list_serv,1);
        if isempty(first_t)
            [A,B,C]=find_abc(sort_T((end-2):end),sort_T_service((end-2):end));
            
        elseif (first_t==1)
            [A,B,C]=find_abc(sort_T(1:3),sort_T_service(1:3));
        elseif (first_t==numel(sort_T_service))
            [A,B,C]=find_abc(sort_T((end-2):end),sort_T_service((end-2):end));
        else
            [A,B,C]=find_abc(sort_T((first_t-1):(first_t+1)),sort_T_service((first_t-1):(first_t+1)));
        end
        time_need=A*count_ch_list_serv*count_ch_list_serv+B*count_ch_list_serv+C;
    end
end
k=0;
i=1;
time_need=15;
while(i<=m_list_serv.jobs)
    if(time_need+m_list_serv.wait_t(i)+min(m_list_serv.cost_n(i,:)))>(m_list_serv.dl_servic(i))
        k=k+1;
        f_s_list_serv(k).j=m_list_serv.mjob(i);
        f_s_list_serv(k).dl=m_list_serv.dl_servic(i);
        f_s_list_serv(k).w=m_list_serv.wait_t(i);
        
        sum_res=sum_res+m_list_serv.mjob(i);
        m_list_serv.nVar=m_list_serv.nVar-1;
        m_list_serv.population(:,i)=[];
        m_list_serv.mjob(i)=[];
        m_list_serv.jobs=m_list_serv.jobs-1;
        m_list_serv.cost_n(i,:)=[];
        m_list_serv.possible_nj(i,:)=[];
        m_list_serv.arrive_t(i)=[];
        m_list_serv.dl_servic(i)=[];
        m_list_serv.wait_t(i)=[];
    else
        i=i+1;
    end
end
f_s_list_serv=[];

end
