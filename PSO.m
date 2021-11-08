function [TargetFitness,TargetAssign,TargetPj,TargetPosition,TargetNFE,Convergence_curve,Convergence_curve_pj,Trajectories,fitness_history, position_history]=GOA(Max_iteration,model,kind)
%% Problem Definition
global NFE;
global seri_serv_mix;

NFE=0;

CostFunction = @(assign_t) cost_assigin2(assign_t,model,kind);

if kind==3
nVar=model.jobs;        % number of optimization var
else
nVar=model.nVar;        % number of optimization var
end

VarSize=[1 nVar];   % Size of Decision Variables Matrix
MaxIt=Max_iteration;      % Maximum Number of Iterations

VarMin = model.VarMin; % Lower Bound of Variable
VarMax =  model.VarMax; % Upper Bound of Variable

dim=nVar;

%% PSO Parameters

nPop=model.SearchAgents_no;        % Population Size (Swarm Size)

% % w=1;            % Inertia Weight
% % wdamp=0.99;     % Inertia Weight Damping Ratio
% % c1=2;           % Personal Learning Coefficient
% % c2=2;           % Global Learning Coefficient
% % w=1;            % Inertia Weight
% % wdamp=.03;     % Inertia Weight Damping Ratio
% % c1=2.33;         % Personal Learning Coefficient
% % c2=1.33;         % Global Learning Coefficient

% Constriction Coefficients
phi1=2.05;
phi2=2.05;
phi=phi1+phi2;
chi=2/(phi-2+sqrt(phi^2-4*phi));
w=chi;          % Inertia Weight
wdamp=0.98;        % Inertia Weight Damping Ratio
c1=chi*phi1;    % Personal Learning Coefficient
c2=chi*phi2;    % Global Learning Coefficient

% Velocity Limits
VelMax=0.1*(VarMax-VarMin);
VelMin=-VelMax;

%% Initialization

empty_particle.Position=[];
empty_particle.Cost=inf;
empty_particle.Velocity=[];
empty_particle.Sol.pj=0;
empty_particle.Sol.assign = [];

empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];
empty_particle.Best.Sol=[];
Pre_Positions=zeros(nPop,nVar);
fitness_history=zeros(nPop,MaxIt);
position_history=zeros(nPop,dim,MaxIt);
Trajectories=zeros(1,dim,MaxIt);
Convergence_curve=zeros(1,MaxIt);
Convergence_curve_pj=zeros(1,MaxIt);


particle=repmat(empty_particle,nPop,1);

GlobalBest.Cost=inf;
GlobalBest.Sol.pj = 0;
GlobalBest.Sol.assign = [];
if kind==3
Positions=model.population(:,1:model.jobs);
else
Positions=model.population;
end

for i=1:nPop
    
    % Initialize Position
%     particle(i).Position=model.population(i,:);     %%unifrnd(VarMin,VarMax,VarSize);
    particle(i).Position=Positions(i,:); 
    % Initialize Velocity
    particle(i).Velocity=zeros(VarSize);
    
    % Evaluation
%     [~,sort_j]=sort(particle(i).Position);
    sort_j=particle(i).Position;
    [fitness ,Sol]=CostFunction(sort_j);
    particle(i).Cost=fitness;
    particle(i).Sol = Sol;
    fitness_history(i,1)=fitness;
    position_history(i,:,1)=particle(i).Position();
    
    
    % Update Personal Best
    particle(i).Best.Position=particle(i).Position;
    particle(i).Best.Cost=particle(i).Cost;
    particle(i).Best.Sol=particle(i).Sol;

    % Update Global Best
    if (particle(i).Best.Cost<GlobalBest.Cost) &&(particle(i).Best.Sol.pj>=GlobalBest.Sol.pj)
        GlobalBest=particle(i).Best;
    end
    
end

BestCost=zeros(1,MaxIt);
BestCostpj=zeros(1,MaxIt);
% nfe=zeros(MaxIt,1);
nfe = zeros(1,MaxIt);

    BestCost(1)=GlobalBest.Cost;
    BestCostpj(1)=GlobalBest.Sol.pj;
    nfe(1)=NFE;
%% PSO Main Loop

for it=2:MaxIt
    
    for i=1:nPop
        
        % Update Velocity
        particle(i).Velocity = w*particle(i).Velocity ...
            +c1*rand(VarSize).*(particle(i).Best.Position-particle(i).Position) ...
            +c2*rand(VarSize).*(GlobalBest.Position-particle(i).Position);
        
        % Apply Velocity Limits
        particle(i).Velocity = max(particle(i).Velocity,VelMin);
        particle(i).Velocity = min(particle(i).Velocity,VelMax);
        
        % Update Position
        particle(i).Position = particle(i).Position + particle(i).Velocity;
        
        % Velocity Mirror Effect
        IsOutside=(particle(i).Position<VarMin | particle(i).Position>VarMax);
        particle(i).Velocity(IsOutside)=-particle(i).Velocity(IsOutside);
        
        % Apply Position Limits
        particle(i).Position = max(particle(i).Position,VarMin);
        particle(i).Position = min(particle(i).Position,VarMax);
        
        % Evaluation
%         [~,sort_j]=sort(particle(i).Position);
        sort_j=particle(i).Position;
        [fitness ,Sol]=CostFunction(sort_j);
        particle(i).Cost=fitness;
        particle(i).Sol = Sol;
        
        fitness_history(i,it)=fitness;
        position_history(i,:,it)=particle(i).Position();

        
        
        % Update Personal Best
        if (particle(i).Cost<particle(i).Best.Cost)&&(particle(i).Sol.pj>=particle(i).Best.Sol.pj)
            
            particle(i).Best.Position=particle(i).Position;
            particle(i).Best.Cost=particle(i).Cost;
            particle(i).Best.Sol=particle(i).Sol;
            
            % Update Global Best
            if particle(i).Best.Cost<GlobalBest.Cost
                
                GlobalBest=particle(i).Best;
                
            end
            
        end
        
    end
    
    BestCost(it)=GlobalBest.Cost;
    BestCostpj(it)=GlobalBest.Sol.pj;
    nfe(it)=NFE;

% %     disp(['Iteration ' num2str(it) ': NFE = ' num2str(nfe(it)) ', Best Cost = ' num2str(BestCost(it))]);
% %     disp(['Iteration: ',num2str(it),' Best Cost = ',num2str(BestCost(it)) ', Best count_job = ' num2str(BestCostpj(it))]);

    w=w*wdamp;
    
end
    Convergence_curve=BestCost;
    Convergence_curve_pj=BestCostpj;

Trajectories(1,:,:)=position_history(1,:,:);
TargetFitness=GlobalBest.Cost;
TargetPosition=GlobalBest.Position;
TargetAssign=GlobalBest.Sol.assign;
TargetPj=GlobalBest.Sol.pj;
TargetNFE=nfe;
for ii=1:nPop
 Pre_Positions(ii,:)=particle(ii).Position;
end
seri_serv_mix.population=Pre_Positions;
end

