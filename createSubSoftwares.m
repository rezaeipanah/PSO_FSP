function [software] = createSubSoftwares(software,nSubSoftware,nTopSoftware,nVar,alpha)
counter=nSubSoftware+1;
for i=1:nTopSoftware
    for j=1:nTopSoftware
        newPos=zeros(1,nVar);
        rnd=unifrnd(0,1,[1,nVar]);
        rnd=rnd<alpha;
        newPos=rnd.*software(i).pos;
        index1=find(newPos==0);
        count=numel(index1);
        R=floor(nSubSoftware*abs(normrnd(0,1,[1,count])));
        rr=R<=nSubSoftware;
        R=R.*rr;
        index2=find(R==0);
        R(index2)=nSubSoftware;
        newPos(index1)=software(R).pos(index1);
        y=fitness(newPos);
        software(counter).pos=newPos;
        software(counter).fit=y;
        software(counter).point2=1;
        software(counter).prevPos=[];
        software(counter).prevFit=[];
        software(counter).secMovment=0;
        counter=counter+1;
    end
end
[~,index]=sort([software.fit]);
software=software(index);
end