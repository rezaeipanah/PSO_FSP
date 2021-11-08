function [software] =moveTopSoftwares(itr,nTopSoftware,nTopMovement,software,LBound,HBound,Iteration)
for i=1:nTopSoftware
    if software(i).secMovment==1
        for j=1:nTopMovement
            %Create Vector Condunctor
            vectorConductor=software(i).pos-software(i).prevPos;
            %Create Linear Equation
            itr2=5*itr/Iteration;
            normal=HBound*(0.2+((1/(sqrt(5)*sqrt(2*pi)))*exp(-1*(power(itr2,2)/10))));
            rnd=1+unifrnd(0,1)*(normal);
            newPos=(rnd.*vectorConductor)+software(i).pos;
            newPos=min(newPos,HBound);
            newPos=max(newPos,LBound);
            %Compute fitness
            y=fitness(newPos);
            if y <= software(i).fit
                software(i).prevPos=software(i).pos;
                software(i).prevFit=software(i).fit;
                software(i).pos=newPos;
                software(i).fit=y;
            end
            radian=unifrnd(0,1)*(pi/4);
            newPos=software(i).pos.*cos(radian);
            y=fitness(newPos);
            if y <= software(i).fit
                software(i).prevPos=software(i).pos;
                software(i).prevFit=software(i).fit;
                software(i).pos=newPos;
                software(i).fit=y;
            end
            
        end
    end
end
[~,index]=sort([software.fit]);
software=software(index);
end