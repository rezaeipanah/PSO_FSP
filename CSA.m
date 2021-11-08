function [TargetFitness,TargetAssign,TargetPj,TargetPosition,TargetNFE,Convergence_curve,Convergence_curve_pj,Trajectories,fitness_history, position_history]=CSA(Max_iteration,model,kind)
global NFE;
NFE=0;

CostFunction = @(assign_t) cost_assigin2(assign_t,model,kind);
if kind==3
    nVar=model.jobs;        % number of optimization var
else
    nVar=model.nVar;        % number of optimization var
end


VarSize=[1 nVar];       % Decision Variables Matrix Size

Max_iter=Max_iteration;

VarMin = model.VarMin; % Lower Bound of Variable
VarMax =  model.VarMax; % Upper Bound of Variable
dim=nVar;

%%  Parameters


nPop = model.SearchAgents_no;         % Population Size
AZ=zeros(size(nPop));

%% Initialization
empty_CROW.Position = [];
empty_CROW.Cost = 0;
empty_CROW.Sol.pj = 0;
empty_CROW.Sol.assign = [];

nfe = zeros(1,Max_iter);
fitness_history=zeros(nPop,Max_iter);
position_history=zeros(nPop,dim,Max_iter);
Trajectories=zeros(1,dim,Max_iter);
Convergence_curve=zeros(1,Max_iter);
Convergence_curve_pj=zeros(1,Max_iter);

pd=dim; % Problem dimension (number of decision variables)
N=nPop; % Flock (population) size
AP=0.1; % Awareness probability
fl=2; % Flight length (fl)
l=VarMin;
u=VarMax;
    BestCost = zeros(1,Max_iter);

CROWS = repmat(empty_CROW,nPop,1);
if kind==3
    Positions=model.population(:,1:model.jobs);
else
    Positions=model.population;
end

for i = 1:nPop % Generation of initial solutions (position of crows)
    % Initialize Position
    CROWS(i).Position = Positions(i,:);
    sort_j=CROWS(i).Position;
    % Evaluate
    [fitness ,Sol]=CostFunction(sort_j);
    CROWS(i).Cost = fitness;
    CROWS(i).Sol=Sol;
    
    fitness_history(i,1)=fitness;
    position_history(i,:,1)=CROWS(i).Position();
    
end


xn=CROWS;

mem=CROWS; % Memory initialization

tmax=Max_iter; % Maximum number of iterations (itermax)
for t=1:tmax
    
        num=ceil(N*rand(1,N)); % Generation of random candidate crows for following (chasing)
      for i=1:N  
        ri=rand;
        if ri>=AP
            xnew(i).Position= CROWS(i).Position+fl*ri*(mem(num(i)).Position-CROWS(i).Position); % Generation of a new position for crow i (state 1)
            sort_j=xnew(i).Position;
            % Evaluate
            [fitness ,Sol]=CostFunction(sort_j);
            xnew(i).Cost = fitness;
            xnew(i).Sol=Sol;
            
        else
            
                xnew(i).Position=rand(1,dim).*(u-l)+l; %=l-(l-u)*rand; % Generation of a new position for crow i (state 2)
                sort_j=xnew(i).Position;
                % Evaluate
                [fitness ,Sol]=CostFunction(sort_j);
                xnew(i).Cost = fitness;
                xnew(i).Sol=Sol;
                
            
        end
    end
    
    xn=xnew;
    %     ft=fitness(xn,N,pd,fobj); % Function for fitness evaluation of new solutions
    
    for i=1:N % Update position and memory
        if xnew(i).Position>=l & xnew(i).Position<=u
            x(i)=xnew(i); % Update position
            if (mem(i).Cost>xn(i).Cost)&&(mem(i).Sol.pj<=xn(i).Sol.pj) %(fitness<Alpha_score)&&(Sol.pj>=Alpha_Sol.pj)
                mem(i)=xnew(i); % Update memory
                %                 fit_mem(i)=ft(i);
            end
        end
    end
    
    
    for az=1:nPop
        AZ(az)=mem(az).Sol.pj;
    end
    AA=[AZ;mem.Cost]';
    [~, QQ]=sortrows(AA,[1 2],{'descend' 'ascend'});
    indx=QQ(1);
    TargetGH = mem(indx);   % Target GrassHopper
    
    
    BestCost(t) = TargetGH.Cost;
    nfe(t) = NFE;
    Convergence_curve(t)=BestCost(t);
    Convergence_curve_pj(t)=TargetGH.Sol.pj;
    
%     ffit(t)=min(fit_mem); % Best found value until iteration t
    %     min(fit_mem)
end

% ngbest=find(fit_mem== min(fit_mem));
% best_pos=mem(ngbest(1),:); % Solutin of the problem
% best_fit=min(fit_mem);
% Convergence_curve=ffit;

Trajectories(1,:,:)=position_history(1,:,:);
TargetFitness=TargetGH.Cost;
TargetPosition=TargetGH.Position;
TargetAssign=TargetGH.Sol.assign;
TargetPj=TargetGH.Sol.pj;
TargetNFE=nfe;


end