function compare_D(n,Max_iteration,seri_serv,node_c,xx,kind)
global Best_pos;
Best_pos=[];
T1=[];
T2=[];
T3=[];
T4=[];
T5=[];

T_s1=[];
T_s2=[];
T_s3=[];
T_s4=[];
T_s5=[];

T_P1=[];
T_P2=[];
T_P3=[];
T_P4=[];
T_P5=[];
T_NFE1=[];
T_NFE2=[];
T_NFE3=[];
T_NFE4=[];
T_NFE5=[];
T_curve1=[];
T_curve2=[];
T_curve3=[];
T_curve4=[];
T_curve5=[];
leg=[];
xx1={'PSO' 'COUCKO' 'ODMA' 'WOA' 'CSA'};
cc2='Alghoritmes';
[T1,T_P1,T_s1,T_curve1,T_NFE1]=planner_t(@PSO,seri_serv,Max_iteration,n,kind);
[T2,T_P2,T_s2,T_curve2,T_NFE2]=planner_t(@COUCKO,seri_serv,Max_iteration,n,kind);
[T3,T_P3,T_s3,T_curve3,T_NFE3]=planner_t(@ODMA,seri_serv,Max_iteration,n,kind);
[T4,T_P4,T_s4,T_curve4,T_NFE4]=planner_t(@WOA,seri_serv,Max_iteration,n,kind);
[T5,T_P5,T_s5,T_curve5,T_NFE5]=planner_t(@CSA,seri_serv,Max_iteration,n,kind);
disp(' finish ');
%===============================================================

aa=['Convergence curve - (Number of Nodes is ' num2str(node_c) ' and Number of Services is ' num2str(xx(end)) ')'];
bb='Cost';
cc='Iteration';
filename = 'resp_curve';
filename = append(filename,num2str(node_c));
nemodar_NFE(T_curve1(end,:),T_curve2(end,:),T_curve3(end,:),T_curve4(end,:),T_curve5(end,:),aa,bb,cc,xx,filename,kind);

%===============================================================
aa=['NFE: Number of Function Evaluations - (Number of Nodes is ' num2str(node_c) ' and Number of Services is ' num2str(xx(end)) ')'];
bb='Runtime(second)';
cc='Iteration';
filename = 'resp_NFE';
filename = append(filename,num2str(node_c));
nemodar_NFE(T_NFE1(end,:),T_NFE2(end,:),T_NFE3(end,:),T_NFE4(end,:),T_NFE5(end,:),aa,bb,cc,xx,filename,kind);
%===============================================================

aa=['Cost obtained - (Number of Nodes is ' num2str(node_c) ')'];
aa=['Cost obtained - (Number of Nodes is ' num2str(node_c) ' and Number of Services is ' num2str(xx(end)) ')'];
bb='Cost';
cc='Number of Services';
filename = 'resp_T_S';
filename = append(filename,num2str(node_c));
% nemodar(T_s1,T_s2,T_s3,T_s4,T_s5,aa,bb,cc,xx,filename,kind);
nemodar3([T_s1,T_s2,T_s3,T_s4,T_s5],aa,bb,cc2,xx1,leg,filename,kind);

%===============================================================

aa=['Runtime obtained - (Number of Nodes is ' num2str(node_c) ')'];
aa=['Runtime obtained - (Number of Nodes is ' num2str(node_c) ' and Number of Services is ' num2str(xx(end)) ')'];
bb='Runtime(second)';
cc='Number of Services';
filename = 'resp_T';
filename = append(filename,num2str(node_c));
% nemodar(T1,T2,T3,T4,T5,aa,bb,cc,xx,filename,kind);
nemodar3([T1,T2,T3,T4,T5],aa,bb,cc2,xx1,leg,filename,kind);

%===============================================================

aa=['Percent services is planned - (Number of Nodes is ' num2str(node_c) ')'];
aa=['Percent services is planned - (Number of Nodes is ' num2str(node_c) ' and Number of Services is ' num2str(xx(end)) ')'];
bb='Planned(Percent)';
cc='Number of Services';
filename = 'resp_T_P';
filename = append(filename,num2str(node_c));
% nemodar(T_P1,T_P2,T_P3,T_P4,T_P5,aa,bb,cc,xx,filename,kind);
nemodar3([T_P1,T_P2,T_P3,T_P4,T_P5],aa,bb,cc2,xx1,leg,filename,kind);

%===============================================================
if kind==1
filename='E:\result_kind1\res_compare_D';
elseif kind==2
filename='E:\result_kind2\res_compare_D';
else
filename='E:\result_kind3\res_compare_D';
end

% filename = 'E:\result\compare_D';
filename = append(filename,num2str(node_c));
filename = append(filename,'.mat');
save(filename);
end
