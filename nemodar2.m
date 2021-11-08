function nemodar(T1,T2,T3,T4,T5,T6,aa,bb,cc,xx,filename,kind)
yy1=T1;
yy2=T2;
yy3=T3;
yy4=T4;
yy5=T5;
yy6=T6;

scrsz = get(0,'ScreenSize');
figure('Position',[40 60 (scrsz(3)-250) scrsz(4)-220]);%4
if ~isempty(yy1)
plot(xx,yy1,'-rs');
hold on;
end
if ~isempty(yy2)
plot(xx,yy2,'--gd');
hold on;
end
if ~isempty(yy3)
plot(xx,yy3,':bp');
hold on;
end
if ~isempty(yy4)
plot(xx,yy4,'-.mh');
hold on;
end
if ~isempty(yy5)
plot(xx,yy5,'-.k*');
hold on;
end
if ~isempty(yy6)
plot(xx,yy6,'-.co');
hold on;
end
title(aa)
ylabel(bb);
xlabel(cc);
xticks(xx);
legend('GWO','GOA','PSO','GA-real','GA-discrete','BA');
% legend('GWO','GOA','PSO','GA-real','GA-discrete');
legend('Location','northwestoutside');

grid on;

saveas(gcf,filename)
% close all

end




