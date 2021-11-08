function main10(n,Max_iteration,seri_serv,node_c,xx,kind,t,sum_job)

xx1={'Cuckoo' 'GWO' 'GOA' 'PSO','ODMA'};
leg=["Cuckoo","GWO","GOA","PSO","ODMA"];
leg1=[];


[M_T_wait_ok1,T_wait_ok1,T1,T_score1,T_score_ok1,T_service_fp1,T_service1,T_service_ok1,T_service_re1,T_service_failed1,fail_list_serv1,s_p1]=planner(@COUCKO,seri_serv,Max_iteration,n,node_c,t,kind);
[M_T_wait_ok2,T_wait_ok2,T2,T_score2,T_score_ok2,T_service_fp2,T_service2,T_service_ok2,T_service_re2,T_service_failed2,fail_list_serv2,s_p2]=planner(@GWO,seri_serv,Max_iteration,n,node_c,t,kind);
[M_T_wait_ok3,T_wait_ok3,T3,T_score3,T_score_ok3,T_service_fp3,T_service3,T_service_ok3,T_service_re3,T_service_failed3,fail_list_serv3,s_p3]=planner(@GOA,seri_serv,Max_iteration,n,node_c,t,kind);
[M_T_wait_ok4,T_wait_ok4,T4,T_score4,T_score_ok4,T_service_fp4,T_service4,T_service_ok4,T_service_re4,T_service_failed4,fail_list_serv4,s_p4]=planner(@PSO,seri_serv,Max_iteration,n,node_c,t,kind);
[M_T_wait_ok5,T_wait_ok5,T5,T_score5,T_score_ok5,T_service_fp5,T_service5,T_service_ok5,T_service_re5,T_service_failed5,fail_list_serv5,s_p5]=planner(@ODMA,seri_serv,Max_iteration,n,node_c,t,kind);
%*********************************

%===============================================================
aa1=['Mean Wait Time in every time period - (Number of Nodes is ' num2str(node_c) ')'];
bb1='Second';
cc1='Time Period(second) - Number services is monitored';
filename1 = 'Wait_Time';
filename1 = append(filename1,num2str(node_c));
% filename1 = append(filename1,'.fig');
nemodar3([T_wait_ok1 ; T_wait_ok2 ; T_wait_ok3 ; T_wait_ok4 ; T_wait_ok5 ],aa1,bb1,cc1,xx,leg,filename1,kind);
%***************************************************************
aa2=['Mean Wait for Services is done - (Number of Nodes is ' num2str(node_c) ')'];
bb2='Second';
cc2='Alghoritmes';
filename2 = 'mean_Wait_Time';
filename2 = append(filename2,num2str(node_c));
% filename2 = append(filename2,'.fig');
nemodar3([M_T_wait_ok1 M_T_wait_ok2 M_T_wait_ok3 M_T_wait_ok4 M_T_wait_ok5 ],aa2,bb2,cc2,xx1,leg1,filename2,kind);

%===============================================================
aa1=['Planning Time in every time period - (Number of Nodes is ' num2str(node_c) ')'];
bb1='Second';
cc1='Time Period(second) - Number services is monitored';
filename1 = 'plann_Time';
filename1 = append(filename1,num2str(node_c));
% filename1 = append(filename1,'.fig');
nemodar3([T1 ; T2 ; T3 ; T4 ; T5 ],aa1,bb1,cc1,xx,leg,filename1,kind);
%***************************************************************
aa2=['SUM of Planning Time - (Number of Nodes is ' num2str(node_c) ')'];
bb2='Second';
cc2='Alghoritmes';
filename2 = 'Total_plann_Time';
filename2 = append(filename2,num2str(node_c));
% filename2 = append(filename2,'.fig');
nemodar3([sum(T1) sum(T2) sum(T3) sum(T4) sum(T5)],aa2,bb2,cc2,xx1,leg1,filename2,kind);

%===============================================================
aa1=['Failed Services in every time period - (Number of Nodes is ' num2str(node_c) ')'];
bb1='Number Services';
cc1='Time Period(second) - Number services is monitored';
filename1 = 'Failed_Service';
filename1 = append(filename1,num2str(node_c));
% filename1 = append(filename1,'.fig');
nemodar3([T_service_failed1 ; T_service_failed2 ; T_service_failed3 ; T_service_failed4; T_service_failed5],aa1,bb1,cc1,xx,leg,filename1,kind);
%***************************************************************
aa2=['Total Failed Services - (Number of Nodes is ' num2str(node_c) ')'];
bb2='Number Services';
cc2='Alghoritmes';
filename2 = 'Total_Failed_Service';
filename2 = append(filename2,num2str(node_c));
% filename2 = append(filename2,'.fig');
nemodar3([sum(T_service_failed1) sum(T_service_failed2) sum(T_service_failed3) sum(T_service_failed4) sum(T_service_failed5)],aa2,bb2,cc2,xx1,leg1,filename2,kind);

%===============================================================
aa1=['Done Services in every time period - (Number of Nodes is ' num2str(node_c) ')'];
bb1='Number Services';
cc1='Time Period(second) - Number services is monitored';
filename1 = 'Done_Service';
filename1 = append(filename1,num2str(node_c));
% filename1 = append(filename1,'.fig');
nemodar3([T_service_ok1 ; T_service_ok2 ; T_service_ok3 ; T_service_ok4  ; T_service_ok5 ],aa1,bb1,cc1,xx,leg,filename1,kind);
%***************************************************************
aa2=['Total Done Services - (Number of Nodes is ' num2str(node_c) ')'];
bb2='Number Services';
cc2='Alghoritmes';
filename2 = 'Total_Done_Service';
filename2 = append(filename2,num2str(node_c));
% filename2 = append(filename2,'.fig');
nemodar3([sum(T_service_ok1) sum(T_service_ok2) sum(T_service_ok3) sum(T_service_ok4) sum(T_service_ok5)],aa2,bb2,cc2,xx1,leg1,filename2,kind);

%===============================================================
aa1=['Done Services Score in every time period - (Number of Nodes is ' num2str(node_c) ')'];
bb1='Number Services';
cc1='Time Period(second) - Number services is monitored';
filename1 = 'Score_Done_Service';
filename1 = append(filename1,num2str(node_c));
% filename1 = append(filename1,'.fig');
nemodar3([T_score_ok1 ; T_score_ok2 ; T_score_ok3 ; T_score_ok4; T_score_ok5 ],aa1,bb1,cc1,xx,leg,filename1,kind);
%***************************************************************
aa2=['Total Done Services Score - (Number of Nodes is ' num2str(node_c) ')'];
bb2='Number Services';
cc2='Alghoritmes';
filename2 = 'Total_Score_Done_Service';
filename2 = append(filename2,num2str(node_c));
% filename2 = append(filename2,'.fig');
nemodar3([mean(T_score_ok1) mean(T_score_ok2) mean(T_score_ok3) mean(T_score_ok4) mean(T_score_ok5)],aa2,bb2,cc2,xx1,leg1,filename2,kind);

%===============================================================
aa2=['Remained Services For Next Period - (Number of Nodes is ' num2str(node_c) ')'];
bb2='Number Services';
cc2='Alghoritmes';
filename2 = 'Remined_Service';
filename2 = append(filename2,num2str(node_c));
% filename2 = append(filename2,'.fig');
nemodar3([T_service_re1(end) T_service_re2(end) T_service_re3(end) T_service_re4(end) T_service_re5(end)],aa2,bb2,cc2,xx1,leg1,filename2,kind);

%(done/failed/wait/score)/
% sum_job=135;
D_S=[sum(T_service_ok1) sum(T_service_ok2) sum(T_service_ok3) sum(T_service_ok4) sum(T_service_ok5)];
D_S=round(100*(D_S/sum(sum_job)));

W_D_S=[M_T_wait_ok1 M_T_wait_ok2 M_T_wait_ok3 M_T_wait_ok4 M_T_wait_ok5];
W_D_S=(W_D_S/D_S);

F_S=[sum(T_service_failed1) sum(T_service_failed2) sum(T_service_failed3) sum(T_service_failed4) sum(T_service_failed5)];
F_S=round(100*(F_S/sum(sum_job)));

R_S=[T_service_re1(end) T_service_re2(end) T_service_re3(end) T_service_re4(end) T_service_re5(end)];
R_S=round(100*(R_S/sum(sum_job)));
if kind==1
filename='E:\result_kind1\senario';
elseif kind==2
filename='E:\result_kind2\senario';
else
filename='E:\result_kind3\senario';
end

% filename = 'E:\result\res_main10';
filename = append(filename,num2str(node_c));
filename = append(filename,'.mat');
save(filename);
end
