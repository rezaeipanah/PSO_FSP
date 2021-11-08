clc
clear
close all
%%
%%me
n = 1;
t=20;%seconds wait time for monitor
node_c=5;
[seri_serv,xx]=creat_sample_data2(t,n,node_c);
Max_iteration=50; % Maximum numbef of iterations


%% Set Problem Parameter
CostFunction=@(assign_t) cost_assigin2(assign_t,seri_serv);
npar=seri_serv.nVar;   % number of optimization var
VarMin=seri_serv.VarMin;     % Minimum value
VarMax=seri_serv.VarMax;      %Maximum value

%CostFunction='Rosenbrock';
%npar=10;        % number of optimization var
%VarMin=-1;     % Minimum value
%VarMax=1;      %Maximum value

%% Set Algorithm Parameter
NumCuckoos=seri_serv.SearchAgents_no;
MaxNumOfCuckoo=seri_serv.SearchAgents_no+5;

% NumCuckoos=10;
MinNumberOfEggs=5;
MaxNumberOfEggs=8;
NumberOfCluster=5;
% MaxNumOfCuckoo=15;
RadiusCoeff=5;
MotionCoeff=5;
% MaxIter=55;

MaxIter=Max_iteration;
globalsetting;

%% Intialize  Cuckoo Population

% CuckooPop=CreatCuckooPop();
CuckooPop=cell(NumCuckoos,1);
for NumCu=1:NumCuckoos
    CuckooPop{NumCu}.Center=seri_serv.population(NumCu,:);
end
% CuckooPop=seri_serv.population;
goalPoint=rand(1,npar).*(VarMax-VarMin)+VarMin; %unifrnd(VarMin,VarMax,[1 npar]);
% globalBestCuckoo=goalPoint;

globalBestCuckoo_pos=zeros(1,npar);
globalBestCuckoo_score=inf; %change this to -inf for maximization problems
globalBestCuckoo_Sol=[];

[~,sort_j]=sort(goalPoint);
[fitness ,Sol]=CostFunction(sort_j);

globalBestCuckoo_pos=goalPoint;
globalBestCuckoo_score=fitness;
globalBestCuckoo_Sol=Sol;
%globalCost=feval(CostFunction,globalBestCuckoo);
%% Main Loop
CostVector=[];
for It=1:MaxIter
    TotalEggs=0;
    for CuNum=1:NumCuckoos
        CuckooPop{CuNum}.NumberOfEggs=floor(unifrnd(MinNumberOfEggs,MaxNumberOfEggs,1));
        TotalEggs=TotalEggs+CuckooPop{CuNum}.NumberOfEggs;
    end
    % Eggs Position
    for CuNum=1:NumCuckoos
        [CuckooPop{CuNum}.EggLayingRadius,CuckooPop{CuNum}.EggPosition]=...
            CreatEggs(TotalEggs,CuckooPop{CuNum});
    end
    %% Evalute Egg Position and Cuckoo Center
    for CuNum=1:NumCuckoos
        [~,sort_j]=sort(CuckooPop{CuNum}.Center);
        % Evaluate
        [fitness ,Sol]=CostFunction(sort_j);
        CuckooPop{CuNum}.CostValue = fitness;
        CuckooPop{CuNum}.Sol=Sol;
        for j = 1:CuckooPop{CuNum}.NumberOfEggs
            [~,sort_j]=sort(CuckooPop{CuNum}.EggPosition(j,:));
            % Evaluate
            [fitness ,Sol]=CostFunction(sort_j);
            CuckooPop{CuNum}.CostValue = [CuckooPop{CuNum}.CostValue;fitness];
            CuckooPop{CuNum}.Sol=[CuckooPop{CuNum}.Sol;Sol];
        end
        %         CuckooPop{CuNum}.CostValue=feval(CostFunction,[CuckooPop{CuNum}.Center;...
        %         CuckooPop{CuNum}.EggPosition]);
    end
%################################################################
    Position=[];
    tmpCost=[];
    sol_assign=[];
    Cost_EggPosition=[];
    Sol_EggPosition=[];
    if NumCuckoos>MaxNumOfCuckoo
        for CuNum=1:NumCuckoos
            Position=[Position; [CuckooPop{CuNum}.Center;...
                CuckooPop{CuNum}.EggPosition]];
            tmpCost=[tmpCost;CuckooPop{CuNum}.CostValue];
            sol_assign=[sol_assign;CuckooPop{CuNum}.Sol];
        end
        AA=[sol_assign.pj;[tmpCost]']';
        [~, SortIndex]=sortrows(AA,[1 2],{'descend' 'ascend'});
        indx=SortIndex(1);
        
        bestCuckooCenter=Position(SortIndex(1),:);%result
        currentBestMinCost=tmpCost(SortIndex(1));
        currentBestMinSol=sol_assign(SortIndex(1));
        
        Position=Position(SortIndex(1:MaxNumOfCuckoo),:);
        sortedCost=tmpCost(SortIndex(1:MaxNumOfCuckoo));
        sorted_sol_assign=sol_assign(SortIndex(1:MaxNumOfCuckoo));
        
        Cost_EggPosition=sortedCost;
        Sol_EggPosition=sorted_sol_assign;
        clear CuckooPop
        for CuNum=1:MaxNumOfCuckoo
            CuckooPop{CuNum}.Center=Position(CuNum,:);
            CuckooPop{CuNum}.EggPosition=Position(CuNum,:);
            CuckooPop{CuNum}.CostValues=sortedCost(CuNum);
            CuckooPop{CuNum}.Sol=sorted_sol_assign(CuNum);
        end
        NumCuckoos=MaxNumOfCuckoo;
    else
        for CuNum=1:NumCuckoos
            Position=[Position; [CuckooPop{CuNum}.Center;...
                CuckooPop{CuNum}.EggPosition]];
            tmpCost=[tmpCost;CuckooPop{CuNum}.CostValue];
            sol_assign=[sol_assign;CuckooPop{CuNum}.Sol];
            
            Cost_EggPosition=[Cost_EggPosition;CuckooPop{CuNum}.CostValue(2:end)];
            Sol_EggPosition=[Sol_EggPosition;CuckooPop{CuNum}.Sol(2:end)];
        end
        AA=[sol_assign.pj;[tmpCost]']';
        [~, SortIndex]=sortrows(AA,[1 2],{'descend' 'ascend'});
        indx=SortIndex(1);
        
        bestCuckooCenter=Position(SortIndex(1),:); %result
        currentBestMinCost=tmpCost(SortIndex(1));
        currentBestMinSol=sol_assign(SortIndex(1));
    end
    %     MinCost=sortedCost(1);
%     currentBestCuckoo=bestCuckooCenter;
%     currentBestMinCost=currentMinCost;
%     currentBestMinSol=currentMinSol;
    
    if (currentBestMinCost<globalBestCuckoo_score) &&(currentBestMinSol.pj>=globalBestCuckoo_Sol.pj)   %globalCost
        globalBestCuckoo_pos=bestCuckooCenter;
        globalBestCuckoo_score=currentBestMinCost;
        globalBestCuckoo_Sol=currentBestMinSol;
        
    end
    CostVector=[CostVector;globalBestCuckoo_score];
    Position=[];
    Cost=[];
    sol_assign=[];
    for CuNum=1:NumCuckoos
        Position=[Position; CuckooPop{CuNum}.EggPosition];
    end
    sol_assign=Sol_EggPosition;
    Cost=Cost_EggPosition;  
% %     for j = 1:size(Position,1)
% %         [~,sort_j]=sort(position(j,:));
% %         % Evaluate
% %         [fitness ,Sol]=CostFunction(sort_j);
% %         tmpCost = [Cost;fitness];
% %         sol_assign=[sol_assign;Sol];
% %     end
    %     Cost=feval(CostFunction,Position);
    
    [clusterNumbers,clusterCenters]=kmeans(Position,NumberOfCluster);
    cluster=cell(NumberOfCluster,1);
    for II=1:NumberOfCluster
        cluster{II}.Position=[];
        cluster{II}.Cost=[];
        cluster{II}.Sol=[];
    end
    for II=1:length(clusterNumbers)
        cluster{clusterNumbers(II)}.Position=[cluster{clusterNumbers(II)}.Position;...
            Position(II,:)];
        cluster{clusterNumbers(II)}.Cost=[cluster{clusterNumbers(II)}.Cost;Cost(II)];
        cluster{clusterNumbers(II)}.Sol=[cluster{clusterNumbers(II)}.Sol;sol_assign(II)];
    end
    f_Mean_Cost=zeros(NumberOfCluster,1);
    f_Mean_pj=zeros(NumberOfCluster,1);
    for II=1:NumberOfCluster
        f_Mean_Cost(II)=mean(cluster{II}.Cost);
        f_Mean_pj(II)=mean([cluster{II}.Sol.pj]);
    end
    AA=[f_Mean_pj f_Mean_Cost];
    [~, SortIndex]=sortrows(AA,[1 2],{'descend' 'ascend'});
    IndexOfBestCluster=SortIndex(1);
    
    AA=[[cluster{IndexOfBestCluster}.Sol.pj]' cluster{IndexOfBestCluster}.Cost];
    [~, IndexOfBestCuckoo]=sortrows(AA,[1 2],{'descend' 'ascend'});
    goalPoint=cluster{IndexOfBestCluster}.Position(IndexOfBestCuckoo(1),:);
    
%     globalBestCuckoo_pos=goalPoint;
%     globalBestCuckoo_score=cluster{IndexOfBestCluster}.Cost(IndexOfBestCuckoo(1));
%     globalBestCuckoo_Sol=cluster{IndexOfBestCluster}.Sol(IndexOfBestCuckoo(1));

    numOfNewCuckoo=0;
    for NumCl=1:NumberOfCluster
        tmpCluster=cluster{NumCl};
        tmpPosition=tmpCluster.Position;
        for II=1:size(tmpPosition,1)
            tmpPosition(II,:)=tmpPosition(II,:)+MotionCoeff*rand(1,npar).*(goalPoint-tmpPosition(II,:));
        end
        tmpPosition(find(tmpPosition<VarMin))=VarMin;
        tmpPosition(find(tmpPosition>VarMax))=VarMax;
        cluster{NumCl}.Position=tmpPosition;
        cluster{NumCl}.Center=mean(tmpPosition);
        numOfNewCuckoo=numOfNewCuckoo+size(tmpPosition,1);
    end
    NumCuckoos=numOfNewCuckoo;
    clear CuckooPop
    CuckooPop=cell(NumCuckoos,1);
    cnt=1;
    for II=1:NumberOfCluster
        for NumCu=1:size(cluster{II}.Position,1)
            CuckooPop{cnt}.Center=cluster{II}.Position(NumCu,:);
            cnt=cnt+1;
        end
    end
%     currentBestCuckoo=bestCuckooCenter;
%     bestCuckooCenter=Position(SortIndex(1),:);
%     currentMinCost=tmpCost(SortIndex(1));
%     currentMinSol=sol_assign(SortIndex(1));

%     currentMinCost=feval(CostFunction,currentBestCuckoo);
%     if (currentMinCost<globalBestCuckoo_score)&&(currentBestMinSol.pj>=globalBestCuckoo_Sol.pj)
%         globalBestCuckoo_pos=currentBestCuckoo;
%         globalBestCuckoo_score=currentMinCost;
%         globalBestCuckoo_Sol=currentBestMinSol;
%     end
    CuckooPop{end}.Center=globalBestCuckoo_pos;
%     CuckooPop{end}.CostValue=globalBestCuckoo_score;
%     CuckooPop{end}.Sol=globalBestCuckoo_Sol;
    randCuckoo=rand(1,npar).*globalBestCuckoo_pos;
    randCuckoo(find(randCuckoo>VarMax))=VarMax;
    randCuckoo(find(randCuckoo<VarMin))=VarMin;
    CuckooPop{end+1}.Center=randCuckoo;
%     [~,sort_j]=sort(randCuckoo);
%     [fitness ,Sol]=CostFunction(sort_j);

%     CuckooPop{end+1}.CostValue=fitness;
%     CuckooPop{end+1}.Sol=Sol;
    NumCuckoos=numOfNewCuckoo+1;
end
figure
plot(CostVector,'-ks','linewidth',4,'MarkerEdgeColor','g','MarkerFaceColor','r','MarkerSize',10);
xlabel 'Iteration'
ylabel 'Cost'


