function [EggLayingRadius,EggPosition]=CreatEggs(TotalEggs,CuckooPop)
global ProblemSetting;
global CuckooSetting;
NumOfPar=ProblemSetting.npar;
VarMin=ProblemSetting.VarMin;
VarMax=ProblemSetting.VarMax;
MinNumberOfEggs=CuckooSetting.MinNumberOfEggs;
MaxNumberOfEggs=CuckooSetting.MaxNumberOfEggs;
RadiusCoeff=CuckooSetting.RadiusCoeff;
EggLayingRadius=RadiusCoeff*CuckooPop.NumberOfEggs/TotalEggs*(VarMax-VarMin);
EggLayingRadius=EggLayingRadius*rand(CuckooPop.NumberOfEggs,1);
Angles=linspace(0,2*pi,CuckooPop.NumberOfEggs);
EggPosition=[];
for I=1:CuckooPop.NumberOfEggs
    for J=1:NumOfPar
        num=floor(2*rand)+1;
        Position(J)=(-1)^num*EggLayingRadius(I)*cos(Angles(I))+EggLayingRadius(I)*sin(Angles(I));
    end
    EggPosition=[EggPosition;Position];
end
tmpCuckooPop=[];
for II=1:CuckooPop.NumberOfEggs
    tmpCuckooPop=[tmpCuckooPop;CuckooPop.Center];
end
EggPosition=EggPosition+tmpCuckooPop;
EggPosition(find(EggPosition<VarMin))=VarMin;
EggPosition(find(EggPosition>VarMax))=VarMax;
end