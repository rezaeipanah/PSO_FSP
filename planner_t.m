function [T,T_P,T_s,T_curve,T_NFE]=planner_t(funcIn,seri_serv,Max_iteration,n,kind)
T = zeros(1,n);
T_P = zeros(1,n);
T_s = zeros(1,n);
T_curve = zeros(n,Max_iteration);
T_NFE = zeros(n,Max_iteration);

for(j=1:n)
    
    tic();
    [Target_score,Target_assign,Target_Pj,Target_pos,Target_NFE,cg_curve,pj_curve, Trajectories,fitness_history, position_history]=funcIn(Max_iteration,seri_serv(j),kind);
    time_planning =toc();
    T(j)=time_planning;
    T_P(j)=Target_Pj;
    T_s(j)=Target_score;
    T_curve(j,:)=cg_curve;
    T_NFE(j,:)=Target_NFE;

end
end