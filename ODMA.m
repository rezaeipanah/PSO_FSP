function [TargetFitness,TargetAssign,TargetPj,TargetPosition,TargetNFE,Convergence_curve,Convergence_curve_pj,Trajectories,fitness_history, position_history]=ODMA(Max_iteration,model,kind)
global NFE;
NFE=0;
CostFunction=@(assign_t) cost_assigin2(assign_t,model,kind);

%% change CONSTANT

if kind==3
nVar=model.jobs;        % number of optimization var
else
nVar=model.nVar;        % number of optimization var
end
dim=nVar;

VarMin=model.VarMin;     % Minimum value
VarMax=model.VarMax;      %Maximum value
LBound=VarMin*ones(1,nVar);%Low bound
HBound=VarMax*ones(1,nVar);%High bound
nSoftware=model.SearchAgents_no;%Number of population
nTopMovement=5;%Number of movement that each leading softwares can do
nTopSoftware=5;%Number of leading softwares
alpha=0.5;
divide=10;

Iteration=Max_iteration;

Convergence_curve=zeros(1,Iteration);
Convergence_curve_pj=zeros(1,Iteration);

fitness_history=zeros(nSoftware,Iteration);
position_history=zeros(nSoftware,dim,Iteration);
Trajectories=zeros(1,dim,Iteration);

nfe = zeros(1,Iteration);

nWeakSoftware=floor(nSoftware/2);%Number of weak softwares
nSubSoftware=floor(nSoftware/2);%Number of sub softwares
bestFit=zeros(Iteration,1);

if kind==3
Positions=model.population(:,1:model.jobs);
else
Positions=model.population;
end

%% Properties of softwares
empty.pos=[];
empty.fit=[];
empty.Sol=[];
empty.point2=1;
empty.prevPos=[];
empty.secMovment=0;

%% Initialize
% software=model.population;
software=repmat(empty,nSoftware,1);
for i=1:nSoftware
%     software(i).pos=model.population(i,:);
    software(i).pos=Positions(i,:);

%     [~,sort_j]=sort(software(i).pos);
    sort_j=software(i).pos;
    [fitness ,Sol]=CostFunction(sort_j);
    software(i).fit=fitness;
    software(i).Sol=Sol;
end
tmpCost=[software.fit];
tmpPj=[software.Sol];
 
AA=[tmpPj.pj; tmpCost]';
[~, SortIndex]=sortrows(AA,[1 2],{'descend' 'ascend'});
software=software(SortIndex);

%% START

for itr=1:Iteration
    
    software=tryToBetter(software,nTopSoftware,nSoftware,LBound,HBound,model,kind);
    moveTopSoftwares(itr,nTopSoftware,nTopMovement,software,LBound,HBound,Iteration);
    if mod(itr,(Iteration/3))==0
        nTopSoftware=nTopSoftware-1;
    end
    if itr>1 && mod(itr,3)==3
        createSubSoftwares(software,nSubSoftware,nTopSoftware,nVar,alpha);
    end
    bestFit(itr)=software(1).fit;
    nfe(itr) = NFE;
        Convergence_curve(itr)=software(1).fit;
        Convergence_curve_pj(itr)=software(1).Sol.pj;
end
    TargetFitness=software(1).fit;
    TargetPosition=software(1).pos;
    TargetAssign=software(1).Sol.assign;
    TargetPj=software(1).Sol.pj;
    TargetNFE=nfe;

% plot(bestFit)
% software(1).fit
% software(1).pos
end
