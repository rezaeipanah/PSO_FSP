clc;
clear;
close all;
n = 1;
t=20;%seconds wait time for monitor
Max_iteration=100; % Maximum numbef of iterations
node_c=5;
kind1=1;%nodes & services
kind2=2;%nodes + services
kind3=3;%just services
[seri_serv,xx]=creat_sample_data2(t,n,node_c);
%---------------------------------------------
for(j=1:1)
    compare_D(n,Max_iteration,seri_serv,node_c,xx,kind3);   %just services

    node_c=node_c-5;
    for(i=1:n)
        seri_serv(i).nVar=seri_serv(i).nVar-5;
        seri_serv(i).nodes=seri_serv(i).nodes-5;
        seri_serv(i).node_id(end-4:end)=[];
        seri_serv(i).cost_n(:,end-4:end)=[];
        seri_serv(i).possible_nj(:,end-4:end)=[];
        seri_serv(i).population_node(:,end-4:end)=[];
        seri_serv(i).population(:,end-4:end)=[];
    end
end



