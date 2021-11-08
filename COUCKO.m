function [TargetFitness,TargetAssign,TargetPj,TargetPosition,TargetNFE,Convergence_curve,Convergence_curve_pj,Trajectories,fitness_history, position_history]=COUCKO(Max_iteration,model,kind)
global NFE;
NFE=0;
CostFunction=@(assign_t) cost_assigin2(assign_t,model,kind);

%% Set Algorithm Parameter
if kind==3
npar=model.jobs;        % number of optimization var
else
npar=model.nVar;        % number of optimization var
end
dim=npar;

VarMin=model.VarMin;     % Minimum value
VarMax=model.VarMax;      %Maximum value

NumCuckoos=model.SearchAgents_no;
MinNumberOfEggs=2;
MaxNumberOfEggs=3;
NumberOfCluster=3;
MaxNumOfCuckoo=model.SearchAgents_no+2;
RadiusCoeff=5;
MotionCoeff=5;
MaxIter=Max_iteration;
globalsetting;

Convergence_curve=zeros(1,MaxIter);
Convergence_curve_pj=zeros(1,MaxIter);

fitness_history=zeros(NumCuckoos,MaxIter);
position_history=zeros(NumCuckoos,dim,MaxIter);
Trajectories=zeros(1,dim,MaxIter);

nfe = zeros(1,MaxIter);

%% Intialize  Cuckoo Population
% Positions=model.population;
if kind==3
Positions=model.population(:,1:model.jobs);
else
Positions=model.population;
end

% CuckooPop=CreatCuckooPop();
for NumCu=1:NumCuckoos
    CuckooPop{NumCu}.Center=Positions(NumCu,:);
end
goalPoint=rand(1,npar).*(VarMax-VarMin)+VarMin;
% [~,sort_j]=sort(goalPoint);
sort_j=goalPoint;
[fitness ,Sol]=CostFunction(sort_j);

globalBestCuckoo_pos=goalPoint;
globalBestCuckoo_score=fitness;
globalBestCuckoo_Sol=Sol;


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
        [CuckooPop{CuNum}.EggLayingRadius,CuckooPop{CuNum}.EggPosition]=CreatEggs(TotalEggs,CuckooPop{CuNum});
    end
    %% Evalute Egg Position and Cuckoo Center
    for CuNum=1:NumCuckoos
%         [~,sort_j]=sort(CuckooPop{CuNum}.Center);
        sort_j=CuckooPop{CuNum}.Center;
        [fitness ,Sol]=CostFunction(sort_j);
        CuckooPop{CuNum}.CostValue = fitness;
        CuckooPop{CuNum}.Sol=Sol;
        for j = 1:CuckooPop{CuNum}.NumberOfEggs
%             [~,sort_j]=sort(CuckooPop{CuNum}.EggPosition(j,:));
            sort_j=CuckooPop{CuNum}.EggPosition(j,:);
            [fitness ,Sol]=CostFunction(sort_j);
            CuckooPop{CuNum}.CostValue = [CuckooPop{CuNum}.CostValue;fitness];
            CuckooPop{CuNum}.Sol=[CuckooPop{CuNum}.Sol;Sol];
        end
    end
    Position=[];
    E_Position=[];
    tmpCost=[];
    tmpPj=[];
    sortedSol=[];
    sortedCost=[];
    if NumCuckoos>MaxNumOfCuckoo
        for CuNum=1:NumCuckoos
            Position=[Position; [CuckooPop{CuNum}.Center;CuckooPop{CuNum}.EggPosition]];
            tmpCost=[tmpCost;CuckooPop{CuNum}.CostValue];
            tmpPj=[tmpPj ;CuckooPop{CuNum}.Sol];
        end
        AA=[[tmpPj.pj]'  tmpCost];
        [~, SortIndex]=sortrows(AA,[1 2],{'descend' 'ascend'});
        bestCuckooCenter=Position(SortIndex(1),:);%result
        currentBestMinCost=tmpCost(SortIndex(1));
        currentBestMinSol=tmpPj(SortIndex(1));
        
        Position=Position(SortIndex(1:MaxNumOfCuckoo),:);
        sortedCost=tmpCost(SortIndex(1:MaxNumOfCuckoo));
        sortedSol=tmpPj(SortIndex(1:MaxNumOfCuckoo));
        clear CuckooPop
        for CuNum=1:MaxNumOfCuckoo
            CuckooPop{CuNum}.Center=Position(CuNum,:);
            CuckooPop{CuNum}.EggPosition=Position(CuNum,:);
            CuckooPop{CuNum}.CostValues=sortedCost(CuNum);
            CuckooPop{CuNum}.Sol=sortedSol(CuNum);
        end
        NumCuckoos=MaxNumOfCuckoo;
    else
        for CuNum=1:NumCuckoos
            E_Position=[E_Position; [CuckooPop{CuNum}.Center;CuckooPop{CuNum}.EggPosition]];
            tmpCost=[tmpCost;CuckooPop{CuNum}.CostValue];
            tmpPj=[tmpPj ;CuckooPop{CuNum}.Sol];
            Position=[Position;[CuckooPop{CuNum}.EggPosition]];
            sortedCost=[sortedCost;CuckooPop{CuNum}.CostValue(2:end)];
            sortedSol=[sortedSol;CuckooPop{CuNum}.Sol(2:end)];
        end
        AA=[[tmpPj.pj]'  tmpCost];
        [~, SortIndex]=sortrows(AA,[1 2],{'descend' 'ascend'});
        bestCuckooCenter=E_Position(SortIndex(1),:);%result
        currentBestMinCost=tmpCost(SortIndex(1));
        currentBestMinSol=tmpPj(SortIndex(1));
    end
    if (currentBestMinCost<globalBestCuckoo_score) &&(currentBestMinSol.pj>=globalBestCuckoo_Sol.pj)
        globalBestCuckoo_pos=bestCuckooCenter;
        globalBestCuckoo_score=currentBestMinCost;
        globalBestCuckoo_Sol=currentBestMinSol;
    end
    Cost=sortedCost;
    [clusterNumbers,clusterCenters]=kmeans(Position,NumberOfCluster);
    cluster=cell(NumberOfCluster,1);
    for II=1:NumberOfCluster
        cluster{II}.Position=[];
        cluster{II}.Cost=[];
        cluster{II}.Sol=[];
    end
    for II=1:length(clusterNumbers)
        cluster{clusterNumbers(II)}.Position=[cluster{clusterNumbers(II)}.Position;Position(II,:)];
        cluster{clusterNumbers(II)}.Cost=[cluster{clusterNumbers(II)}.Cost;Cost(II)];
        cluster{clusterNumbers(II)}.Sol=[cluster{clusterNumbers(II)}.Sol;sortedSol(II)];
    end
      F_Mean=zeros(NumberOfCluster,1);
      S_Mean=zeros(NumberOfCluster,1);
    for II=1:NumberOfCluster
      F_Mean(II)=mean(cluster{II}.Cost);
      S_Mean(II)=mean([cluster{II}.Sol.pj]);
    end
    AA=[S_Mean F_Mean];
    [~, SortIndex]=sortrows(AA,[1 2],{'descend' 'ascend'});
    IndexOfBestCluster=SortIndex(1);
    
    AA=[[cluster{IndexOfBestCluster}.Sol.pj]' cluster{IndexOfBestCluster}.Cost];
    [~, IndexOfBestCuckoo]=sortrows(AA,[1 2],{'descend' 'ascend'});
    
    goalPoint=cluster{IndexOfBestCluster}.Position(IndexOfBestCuckoo(1),:);
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
    CuckooPop{end}.Center=globalBestCuckoo_pos;
    randCuckoo=rand(1,npar).*globalBestCuckoo_pos;
    randCuckoo(find(randCuckoo>VarMax))=VarMax;
    randCuckoo(find(randCuckoo<VarMin))=VarMin;
   CuckooPop{end+1}.Center=randCuckoo;
   NumCuckoos=numOfNewCuckoo+1;
    
    
    nfe(It) = NFE;
        Convergence_curve(It)=globalBestCuckoo_score;
        Convergence_curve_pj(It)=globalBestCuckoo_Sol.pj;
    
end
    TargetFitness=globalBestCuckoo_score;
    TargetPosition=globalBestCuckoo_pos;
    TargetAssign=globalBestCuckoo_Sol.assign;
    TargetPj=globalBestCuckoo_Sol.pj;
    TargetNFE=nfe;


end