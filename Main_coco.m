clc
clear
close all
%% Set Problem Parameter
CostFunction='Sphere';
npar=10;        % number of optimization var
VarMin=-1;     % Minimum value
VarMax=1;      %Maximum value

%% Set Algorithm Parameter
NumCuckoos=10;
MinNumberOfEggs=3;
MaxNumberOfEggs=5;
NumberOfCluster=5;
MaxNumOfCuckoo=15;
RadiusCoeff=5;
MotionCoeff=5;
MaxIter=55;
globalsetting;


%% Intialize  Cuckoo Population
CuckooPop=CreatCuckooPop();
goalPoint=unifrnd(VarMin,VarMax,[1 npar]);
globalBestCuckoo=goalPoint;
globalCost=feval(CostFunction,globalBestCuckoo);
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
        CuckooPop{CuNum}.CostValue=feval(CostFunction,[CuckooPop{CuNum}.Center;...
            CuckooPop{CuNum}.EggPosition]);
    end
    Position=[];
    tmpCost=[];
    if NumCuckoos>MaxNumOfCuckoo
        for CuNum=1:NumCuckoos
            Position=[Position; [CuckooPop{CuNum}.Center;...
                CuckooPop{CuNum}.EggPosition]];
            tmpCost=[tmpCost;CuckooPop{CuNum}.CostValue];
        end
        [sortedCost,SortIndex]=sort(tmpCost,'ascend');
        bestCuckooCenter=Position(SortIndex(1),:);
        Position=Position(SortIndex(1:MaxNumOfCuckoo),:);
        sortedCost=sortedCost(1:MaxNumOfCuckoo);
        clear CuckooPop
        for CuNum=1:MaxNumOfCuckoo
           CuckooPop{CuNum}.Center=Position(CuNum,:);
           CuckooPop{CuNum}.EggPosition=Position(CuNum,:);
           CuckooPop{CuNum}.CostValues=sortedCost(CuNum);
        end
        NumCuckoos=MaxNumOfCuckoo;
    else
         for CuNum=1:NumCuckoos
            Position=[Position; [CuckooPop{CuNum}.Center;...
                CuckooPop{CuNum}.EggPosition]];
            tmpCost=[tmpCost;CuckooPop{CuNum}.CostValue];
         end
        [sortedCost,SortIndex]=sort(tmpCost,'ascend');
         bestCuckooCenter=Position(SortIndex(1),:);
    end
    MinCost=sortedCost(1);
    currentBestCuckoo=bestCuckooCenter;
    currentMinCost=feval(CostFunction,currentBestCuckoo);
    if currentMinCost<globalCost
        globalBestCuckoo=currentBestCuckoo;
        globalCost=currentMinCost;
    end
    hold on
    plot(It,globalCost,'-ks','linewidth',4,'MarkerEdgeColor','g','MarkerFaceColor','r','MarkerSize',10);
    xlabel 'Iteration'
    ylabel 'Cost'
    pause(0.1)
    CostVector=[CostVector;globalCost];
  %###########################
    Position=[];
    for CuNum=1:NumCuckoos
        Position=[Position;  CuckooPop{CuNum}.EggPosition];
    end
    Cost=feval(CostFunction,Position);
    [clusterNumbers,clusterCenters]=kmeans(Position,NumberOfCluster);
    cluster=cell(NumberOfCluster,1);
    for II=1:NumberOfCluster
        cluster{II}.Position=[];
        cluster{II}.Cost=[];
    end
    for II=1:length(clusterNumbers)
        cluster{clusterNumbers(II)}.Position=[cluster{clusterNumbers(II)}.Position;...
            Position(II,:)];
        cluster{clusterNumbers(II)}.Cost=[cluster{clusterNumbers(II)}.Cost;Cost(II)];
    end
    f_Mean=zeros(NumberOfCluster,1);
    for II=1:NumberOfCluster
      f_Mean(II)=mean(cluster{II}.Cost);
    end
    [sorted_f_mean,sortindex]=sort(f_Mean,'ascend');
    MinCost_Mean=sorted_f_mean(1);
    IndexOfBestCluster=sortindex(1);
    [MinCostInBestCluster,IndexOfBestCuckoo]=min(cluster{IndexOfBestCluster}.Cost);
    goalPoint=cluster{IndexOfBestCluster}.Position(IndexOfBestCuckoo,:);
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
%     currentMinCost=feval(CostFunction,currentBestCuckoo);
%     if currentMinCost<globalCost
%         globalBestCuckoo=currentBestCuckoo;
%         globalCost=currentMinCost;
%     end
    CuckooPop{end}.Center=globalBestCuckoo;
%     CuckooPop{end}.CostValue=currentMinCost;
    randCuckoo=rand(1,npar).*globalBestCuckoo;
    randCuckoo(find(randCuckoo>VarMax))=VarMax;
    randCuckoo(find(randCuckoo<VarMin))=VarMin;
   CuckooPop{end+1}.Center=randCuckoo;
%    CuckooPop{end+1}.CostValue=feval(CostFunction,randCuckoo);
   NumCuckoos=numOfNewCuckoo+1;
end
figure
plot(CostVector,'-ks','linewidth',4,'MarkerEdgeColor','g','MarkerFaceColor','r','MarkerSize',10);
xlabel 'Iteration'
ylabel 'Cost'


