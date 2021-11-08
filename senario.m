clc;
clear;
close all;

Max_iteration=100; % Maximum numbef of iterations
t=5;%seconds wait time for monitor
kind1=1;%nodes & services
kind2=2;%nodes + services
kind3=3;%just services

n = 10;
[seri_serv,node_c,sum_job]=creat_sample_data3(t,n);
tj=(t:t:(n)*t);

xx=repmat("",1,n);

for (i=1:n)
xx(i)=append(num2str(tj(i))," - ");
xx(i)=append(xx(i),num2str(sum_job(i)));

end
main10(n,Max_iteration,seri_serv,node_c,xx,kind1,t,sum_job);
main10(n,Max_iteration,seri_serv,node_c,xx,kind2,t,sum_job);
main10(n,Max_iteration,seri_serv,node_c,xx,kind3,t,sum_job);

