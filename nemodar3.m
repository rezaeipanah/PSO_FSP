function nemodar3(yy,aa,bb,cc,xx,leg,filename,kind)
% yy=[T1 T2 T3 T4 T5 T6];
% xx={'GWO' 'GOA' 'PSO' 'GA-real' 'GA-discrete' 'BA'};
% leg=["GWO","GOA","PSO","GA-real","GA-discrete","BA"];
zz=categorical(xx,xx);%valueset is xx


scrsz = get(0,'ScreenSize');
figure('Position',[40 60 (scrsz(3)-250) scrsz(4)-220]);%4
bar(zz,yy);
title(aa)
ylabel(bb);
xlabel(cc);
if ~isempty(leg)
legend(leg);
% legend('GWO','GOA','PSO','GA-real','GA-discrete','BA');
legend('Location','northwestoutside');
end 
grid on;
if kind==1
r_folder1='E:\result_kind1\senario\fig\';
r_folder2='E:\result_kind1\senario\pic\';
elseif kind==2
r_folder1='E:\result_kind2\senario\fig\';
r_folder2='E:\result_kind2\senario\pic\';
else
r_folder1='E:\result_kind3\senario\fig\';
r_folder2='E:\result_kind3\senario\pic\';
end

% r_folder1='E:\result\fig\';
filename1 = append(r_folder1,filename);
filename1 = append(filename1,'.fig');
saveas(gcf,filename1);

% r_folder2='E:\result\pic\';
filename2 = append(r_folder2,filename);
filename2 = append(filename2,'.png');
saveas(gcf,filename2);

% saveas(gcf,filename)
% close all

end




