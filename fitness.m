function y=fitness(x)
%% Spher
y=sum(x.^2);

%% Ackley
%{
y=1;
z=1;
y=sum(x.^2);
y=(1/size(x,2))*y;
y=sqrt(y);
y=-0.2*y;
y=exp(y);
y=-20*y;
z=sum(cos(2*pi.*x));
z=(1/size(x,2))*z;
z=exp(z);
y=y+20+exp(1)-z;
%}

%% Rastrigin
%{
y=sum((x.^2)-(10*cos(2*pi.*x)));
y=y+10*size(x,2);
%}

%% Beale
%y = (1.5-x(1)*(1-x(2)))^2+(2.25-x(1)*(1-x(2)^2))^2+(2.625-x(1)*(1-x(2)^3))^2;

%% Booth
% y  = (x(1)+2*x(2)-7)^2+(2*x(1)+x(2)-5)^2;

%% Zakharof
% n = 2;
% s1 = 0;
% s2 = 0;
% for j = 1:n;
%     s1 = s1+x(j)^2;
%     s2 = s2+0.5*j*x(j);
% end
% y = s1+s2^2+s2^4;
end