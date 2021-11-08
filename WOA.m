function [TargetFitness,TargetAssign,TargetPj,TargetPosition,TargetNFE,Convergence_curve,Convergence_curve_pj,Trajectories,fitness_history, position_history]=WOA(Max_iteration,model,kind)
global NFE;
global seri_serv_mix;
global Best_pos;

NFE=0;

CostFunction=@(assign_t) cost_assigin2(assign_t,model,kind);

if kind==3
nVar=model.jobs;        % number of optimization var
else
nVar=model.nVar;        % number of optimization var
end

VarSize=[1 nVar];       % Decision Variables Matrix Size

SearchAgents_no=model.SearchAgents_no;

Max_iter=Max_iteration;
lb=model.VarMin;    %Lower Bound
ub=model.VarMax;    %Upper Bound
dim=nVar;

% initialize position vector and score for the leader
% Leader_pos=zeros(1,dim);
% Leader_score=inf; %change this to -inf for maximization problems
Leader_pos=zeros(1,dim);
Leader_score=inf; %change this to -inf for maximization problems
Leader_Sol.pj=0;
Leader_Sol.assign=[];

% 
% 
% %Initialize the positions of search agents
% Positions=initialization(SearchAgents_no,dim,ub,lb);
if kind==3
Positions=model.population(:,1:model.jobs);
else
Positions=model.population;
end

% 
% Convergence_curve=zeros(1,Max_iter);
Convergence_curve=zeros(1,Max_iter);
Convergence_curve_pj=zeros(1,Max_iter);


fitness_history=zeros(SearchAgents_no,Max_iter);
position_history=zeros(SearchAgents_no,dim,Max_iter);
Trajectories=zeros(1,dim,Max_iter);

nfe = zeros(1,Max_iter);

% 
% t=0;% Loop counter

% Main loop
for t=1:Max_iter
    for i=1:size(Positions,1)
        
        % Return back the search agents that go beyond the boundaries of the search space
        Flag4ub=Positions(i,:)>ub;
        Flag4lb=Positions(i,:)<lb;
        Positions(i,:)=(Positions(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        
%         % Calculate objective function for each search agent
%         fitness=fobj(Positions(i,:));
        % Calculate objective function for each search agent
        sort_j=Positions(i,:);
        [fitness ,Sol]=CostFunction(sort_j);
        
        fitness_history(i,t)=fitness;
        position_history(i,:,t)=Positions(i,:);

        
%         % Update the leader
%         if fitness<Leader_score % Change this to > for maximization problem
%             Leader_score=fitness; % Update alpha
%             Leader_pos=Positions(i,:);
%         end
        if (fitness<Leader_score)&&(Sol.pj>=Leader_Sol.pj)
            Leader_score=fitness; % Update alpha
            Leader_Sol=Sol;
            Leader_pos=Positions(i,:);
        end        
    end
    
    a=2-t*((2)/Max_iter); % a decreases linearly fron 2 to 0 in Eq. (2.3)
    
    % a2 linearly dicreases from -1 to -2 to calculate t in Eq. (3.12)
    a2=-1+t*((-1)/Max_iter);
    
    % Update the Position of search agents 
    for i=1:size(Positions,1)
        r1=rand(); % r1 is a random number in [0,1]
        r2=rand(); % r2 is a random number in [0,1]
        
        A=2*a*r1-a;  % Eq. (2.3) in the paper
        C=2*r2;      % Eq. (2.4) in the paper
        
        
        b=1;               %  parameters in Eq. (2.5)
        l=(a2-1)*rand+1;   %  parameters in Eq. (2.5)
        
        p = rand();        % p in Eq. (2.6)
        
        for j=1:size(Positions,2)
            
            if p<0.5   
                if abs(A)>=1
                    rand_leader_index = floor(SearchAgents_no*rand()+1);
                    X_rand = Positions(rand_leader_index, :);
                    D_X_rand=abs(C*X_rand(j)-Positions(i,j)); % Eq. (2.7)
                    Positions(i,j)=X_rand(j)-A*D_X_rand;      % Eq. (2.8)
                    
                elseif abs(A)<1
                    D_Leader=abs(C*Leader_pos(j)-Positions(i,j)); % Eq. (2.1)
                    Positions(i,j)=Leader_pos(j)-A*D_Leader;      % Eq. (2.2)
                end
                
            elseif p>=0.5
              
                distance2Leader=abs(Leader_pos(j)-Positions(i,j));
                % Eq. (2.5)
                Positions(i,j)=distance2Leader*exp(b.*l).*cos(l.*2*pi)+Leader_pos(j);
                
            end
            
        end
    end
%     t=t+1;
    Convergence_curve(t)=Leader_score;
    [t Leader_score];
    
    nfe(t) = NFE;
    Convergence_curve(t)=Leader_score;
    Convergence_curve_pj(t)=Leader_Sol.pj;
end
Trajectories(1,:,:)=position_history(1,:,:);
TargetFitness=Leader_score;
    TargetPosition=Leader_pos;
    TargetAssign=Leader_Sol.assign;
    TargetPj=Leader_Sol.pj;
    TargetNFE=nfe;

seri_serv_mix.population=Positions;

end




