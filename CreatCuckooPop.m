function CuckooPop=CreatCuckooPop()
global ProblemSetting;
global CuckooSetting;
NumOfPar=ProblemSetting.npar;
VarMin=ProblemSetting.VarMin;
VarMax=ProblemSetting.VarMax;
NumOfCuckoo=CuckooSetting.NumCuckoos;
CuckooPop=cell(NumOfCuckoo,1);
for NumCu=1:NumOfCuckoo
    CuckooPop{NumCu}.Center=rand(SearchAgents_no,NumOfPar).*(VarMax-VarMin)+VarMin;
    unifrnd(VarMin,VarMax,[1 NumOfPar]);
end
end