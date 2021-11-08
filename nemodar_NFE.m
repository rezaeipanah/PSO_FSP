function nemodar_NFE(T1,T2,T3,T4,T5,aa,bb,cc,xx,filename,kind)
yy1=T1;
yy2=T2;
yy3=T3;
yy4=T4;
yy5=T5;


scrsz = get(0,'ScreenSize');
figure('Position',[40 60 (scrsz(3)-250) scrsz(4)-220]);%4
if ~isempty(yy1)
semilogy(yy1,'-rs');
hold on;
end
if ~isempty(yy2)
semilogy(yy2,'--gd');
hold on;
end
if ~isempty(yy3)
semilogy(yy3,':bp');
hold on;
end
if ~isempty(yy4)
semilogy(yy4,'-.mh');
hold on;
end
if ~isempty(yy5)
semilogy(yy5,'-.k*');
hold on;
end

title(aa)
ylabel(bb);
xlabel(cc);
% xticks(xx);
legend('PSO', 'COUCKO' ,'ODMA' ,'WOA', 'CSA');
legend('Location','northwestoutside');

grid on;
if kind==1
r_folder1='E:\result_kind1\fig\';
r_folder2='E:\result_kind1\pic\';
elseif kind==2
r_folder1='E:\result_kind2\fig\';
r_folder2='E:\result_kind2\pic\';
else
r_folder1='E:\result_kind3\fig\';
r_folder2='E:\result_kind3\pic\';
end

% r_folder1='E:\result\fig\';
filename1 = append(r_folder1,filename);
filename1 = append(filename1,'.fig');
saveas(gcf,filename1);

% r_folder2='E:\result\pic\';
filename2 = append(r_folder2,filename);
filename2 = append(filename2,'.png');
saveas(gcf,filename2);

% close all

end




