function [M_T_wait_ok,T_wait_ok,T,T_score,T_score_ok,T_service_fp,T_service,T_service_ok,T_service_re,T_service_failed,fail_list_serv,s_p]=planner(funcIn,seri_serv,Max_iteration,nn,node_c,t,kind)
W_T_S=0;
W_T_C=0;
n=nn;
T = zeros(1,n);
% T_Pj = zeros(1,n);
T_score = zeros(1,n);
T_wait_ok = zeros(1,n);
T_score_ok = zeros(1,n);
T_service_fp=zeros(1,n);
T_service=zeros(1,n);
T_service_ok=zeros(1,n);
T_service_re=zeros(1,n);
T_service_failed=zeros(1,n);
% t=5;%seconds wait time for monitor

m_list_serv=[];
fail_list_serv=[];
params.d=zeros(1,node_c);%resource usage
params.c_d=zeros(1,node_c);%cost done
params.d_time=[];%done time
params.a_time=[];%arrive time
params.w_time=[];%wait time
s_p = repmat(params,1,n);%keep results
% seri_serv=creat_sample_data(t,n);
time_planning=0;
for(j=1:n)
    %     display(['j: ',num2str(j)]);
    
    
    %calculate wait time befor
    if j<=nn
        seri_serv(j).wait_t=t-seri_serv(j).arrive_t;
        seri_serv(j).arrive_t=t*(j-1)+seri_serv(j).arrive_t;%real arrived time
    end
    if ~isempty(m_list_serv)
        for (k=1:m_list_serv.jobs)
            m_list_serv.wait_t(k)=m_list_serv.wait_t(k)+t;
        end
    end
    if(j==1)
        m_list_serv=seri_serv(1);
        Resource_node=seri_serv(1).mnode;
        Resource_node_id=seri_serv(1).node_id;
        Resource_node_p=seri_serv(1).population_node;
        
    else
        if j<=nn
            m_list_serv=merg_lists(m_list_serv,seri_serv(j));
        end
    end
    
    for(k=1:j-1)% calculate how much resource is remained
        m_list_serv.mnode=m_list_serv.mnode-sum(s_p(k).d,1);
    end
    if time_planning<=t
        m_list_serv.wait_t=m_list_serv.wait_t+time_planning;
        [p_list_serv,f_list_serv,r_list_serv]=analyz_service(m_list_serv);
        if ~(isempty(f_list_serv))
            fail_list_serv=[fail_list_serv f_list_serv];
            T_service_failed(j)=numel(f_list_serv.j);
        end
        m_list_serv=r_list_serv;
        
        if (p_list_serv.jobs>0)
            
            % % planner
            tic();
            [Target_score,Target_assign,Target_Pj,Target_pos,Target_NFE,cg_curve,pj_curve, Trajectories,fitness_history, position_history]=funcIn(Max_iteration,p_list_serv,kind);
            time_planning =toc();
            T(j)=time_planning;
            %       T_Pj(j)=Target_Pj;
            T_score(j)=Target_score;
            T_service_fp(j)=p_list_serv.jobs;
            T_service(j)=sum(max(Target_assign,[],2));
            %             disp('Planning is ok');
            %             display(['T(j): ',num2str(T(j))]);
            %             display(['service_count is going to planning: ',num2str(T_service_fp(j))]);
            %             display(['service_count is planned: ',num2str(T_service(j))]);
            %             display(['service_score is planned: ',num2str(T_score(j))]);
            for(y=1:p_list_serv.jobs)
                
                [B,A]=max(Target_assign(y,:));
                if B>0
                    if (p_list_serv.wait_t(y)+time_planning+p_list_serv.cost_n(y,A))>p_list_serv.dl_servic(y)
                        Target_assign(y,A)=0;
                        p_list_serv.wait_t(y)=p_list_serv.wait_t(y)+t;
                    else
                        p_list_serv.wait_t(y)=p_list_serv.wait_t(y)+time_planning;
                        p_list_serv.done_t(y)=p_list_serv.wait_t(y)+p_list_serv.cost_n(y,A);
                    end
                else
                    p_list_serv.wait_t(y)=p_list_serv.wait_t(y)+t;
                end
            end
            
            D=max(Target_assign,[],2);%fail service
            fail=find(D==0);
            pass=find(D>0);
            r_list_serv=p_list_serv;
            %depend to node
            r_list_serv.cost_n=r_list_serv.old_cost;
            r_list_serv.population_node=Resource_node_p;
            r_list_serv.mnode=Resource_node;
            r_list_serv.node_id=Resource_node_id;
            r_list_serv.possible_nj=zeros(numel(fail),numel(Resource_node));
            %---------
            %       r_list_serv.possible_nj(pass,:)=[];
            r_list_serv.cost_n(pass,:)=[];
            r_list_serv.mjob(pass)=[];
            r_list_serv.arrive_t(pass)=[];
            r_list_serv.dl_servic(pass)=[];
            r_list_serv.wait_t(pass)=[];
            r_list_serv.done_t(pass)=[];
            r_list_serv.population_jobe(:,pass)=[];
            r_list_serv.jobs=numel(r_list_serv.mjob);
            r_list_serv.nodes=numel(r_list_serv.mnode);
            r_list_serv.nVar=r_list_serv.jobs+r_list_serv.nodes;
            r_list_serv.population=[];
            m_list_serv=merg_lists(m_list_serv,r_list_serv);
            %16 items we have
            p_list_serv.population_jobe(:,fail)=[];
            p_list_serv.mjob(fail)=[];
            p_list_serv.cost_n(fail,:)=[];
            p_list_serv.possible_nj(fail,:)=[];
            p_list_serv.arrive_t(fail)=[];
            p_list_serv.dl_servic(fail)=[];
            p_list_serv.wait_t(fail)=[];
            p_list_serv.done_t(fail)=[];
            p_list_serv.jobs=numel(p_list_serv.mjob);
            p_list_serv.nVar=p_list_serv.jobs+p_list_serv.nodes;
            Target_assign(fail,:)=[];
            T_service_ok(j)=p_list_serv.jobs;
            T_service_re(j)=m_list_serv.jobs;
            %to find which service is planned
            node_id=p_list_serv.node_id;
            R_U_S=p_list_serv.mjob'.*Target_assign;%resource usage by services
            T_U_S=(p_list_serv.cost_n).*(Target_assign);%time_cost usage by services
            T_score_ok(j)=sum(sum(T_U_S));
            
            Z_C1=zeros(p_list_serv.jobs,numel(Resource_node));
            Z_C1(:,node_id)=R_U_S;
            
            Z_C2=zeros(p_list_serv.jobs,numel(Resource_node));
            Z_C2(:,node_id)=T_U_S;
            
            s_p(j).d=Z_C1;%resource usage by services (R_U_S)
            s_p(j).c_d=Z_C2;%time_cost usage by services (T_U_S)
            s_p(j).w_time=p_list_serv.wait_t+T(j);%wait time by services
            s_p(j).a_time=p_list_serv.arrive_t;%arrive time by services
            s_p(j).d_time=p_list_serv.wait_t+T(j)+sum(T_U_S,2)';%done time by services
            W_T_S=W_T_S+sum(s_p(j).w_time);
            W_T_C=W_T_C+p_list_serv.jobs;
            
            T_wait_ok(j)=mean(s_p(j).w_time);
            if time_planning<=t
                past_t=t-time_planning;
                s_p(j).c_d=s_p(j).c_d-past_t;
                time_planning=0;
                md=find(s_p(j).c_d<=0);
                s_p(j).d(md)=0;
                s_p(j).c_d(md)=0;
            else
                s_p(j).c_d=s_p(j).c_d-time_planning;
                md=find(s_p(j).c_d<=0);
                s_p(j).d(md)=0;
                s_p(j).c_d(md)=0;   
            end
            
            %             display(['service_count is ok: ',num2str(T_service_ok(j))]);
            %             display(['service_score is ok: ',num2str(T_score_ok(j))]);
            %             display(['service_count is going to next t: ',num2str( T_service_re(j))]);
            %             disp('================');
        else
            %             display(['j: ',num2str(j)]);
            %             disp('Planning is fail');
            %             display(['service_count is fail: ',num2str(numel(fail_list_serv.j))]);
        end
    else
        time_planning=time_planning-t;
        m_list_serv.wait_t=m_list_serv.wait_t+t;

        %         display(['time_planning is too long:',num2str(time_planning)]);
        %         display(['service_count is going to next t: ',num2str( m_list_serv.jobs)]);
        %         disp('================');
    end
    for(k=1:j-1)
        s_p(k).c_d=s_p(k).c_d-t;
        md=find(s_p(k).c_d<=0);
        s_p(k).d(md)=0;
        s_p(k).c_d(md)=0;
    end
end

M_T_wait_ok=W_T_S/W_T_C;
m=sum(T);
display(funcIn);
display([' : finish time planning up to now is: ', num2str(m)]);
disp('================');
% display(['service_count is fail: ',num2str(f_list_serv.jobs)]);
end