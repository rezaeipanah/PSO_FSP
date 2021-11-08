function [software] = tryToBetter(software,nTopSoftware,nSoftware,LBound,HBound,model,kind)
sPoint=sum([software(1:nTopSoftware).point2]);
for i=nTopSoftware:nSoftware
    nTop=floor((software(i).point2/sPoint)*10);

    if nTop > nTopSoftware
        nTop=nTopSoftware;
    end
    leadingSoftwareIndex=nTopSoftware-nTop;
    if leadingSoftwareIndex<=1
        index=1;
    elseif leadingSoftwareIndex > nTopSoftware
        index=nTopSoftware-1;
    else
        index=randi(leadingSoftwareIndex);
    end
   
    radian=unifrnd(0,1)*(pi/4);
    rnd1=unifrnd(0,1);
    rnd2=unifrnd(0,1);
    tempPos=software(i).pos;
    dist=(((software(i).point2/software(index).point2)+rnd1+rnd2).*abs(tempPos-software(index).pos))./cos(radian);
    tempPos=min(dist,HBound);
    tempPos=max(tempPos,LBound);
    sort_j=tempPos;
%     [~,sort_j]=sort(tempPos);
    [fitness ,Sol]=cost_assigin2(sort_j,model,kind);
    y=fitness;
    
    if y<=software(i).fit && Sol.pj>=software(i).Sol.pj
        software(i).point2=software(i).point2+1;
        software(index).point2=software(index).point2+1;
    end
    software(i).prevPos=software(i).pos;
    software(i).prevFit=software(i).fit;
    software(i).pos=tempPos;
    software(i).fit=y;
    software(i).secMovment=1;
    software(i).Sol=Sol;

end
tmpCost=[software.fit];
tmpPj=[software.Sol];
 
AA=[tmpPj.pj; tmpCost]';
[~, SortIndex]=sortrows(AA,[1 2],{'descend' 'ascend'});
software=software(SortIndex);

% [~,index]=sort([software.fit]);
% software=software(index);
end