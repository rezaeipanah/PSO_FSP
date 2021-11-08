function [Target_score,Target_assign,Target_Pj,Target_pos,Target_NFE,cg_curve,pj_curve, Trajectories,fitness_history, position_history]=mix_G_P(Max_iteration,model,kind)
global seri_serv_mix;

    seri_serv_mix=model;
    tic();
    [Target_score1,Target_assign1,Target_Pj1,Target_pos1,Target_NFE1,cg_curve1,pj_curve1, Trajectories1,fitness_history1, position_history1]=PSO(Max_iteration/2,model,kind);
    seri_serv= seri_serv_mix;
    [Target_score2,Target_assign2,Target_Pj2,Target_pos2,Target_NFE2,cg_curve2,pj_curve2, Trajectories2,fitness_history2, position_history2]=GWO(Max_iteration/2,seri_serv,kind);

Target_score=Target_score2;
Target_assign=Target_assign2;
Target_Pj=Target_Pj2;
Target_pos=Target_pos2;
Target_NFE2=Target_NFE2+Target_NFE1(end);
Target_NFE=[Target_NFE1 Target_NFE2];
cg_curve=[cg_curve1 cg_curve2];
pj_curve=[pj_curve1 pj_curve2];
Trajectories=cat(3,Trajectories1,Trajectories2);
fitness_history=[fitness_history1 fitness_history2];
position_history=cat(3,position_history1, position_history2);


end
