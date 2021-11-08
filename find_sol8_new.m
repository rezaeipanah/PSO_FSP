function sol=find_sol8_new(job_new,node_new,possible_new,a_nj)
c_j=0;
p=0;
job_id=[1:1:numel(job_new)];
sum_p=sum(possible_new,2);

while (numel(job_new)>0)
   j=1;
   p=0;
    while(j<=numel(job_new))
        if(sum_p(j)==1)
            [~,c]=find(possible_new(j,:)==1);
            node_new(c)=node_new(c)-job_new(j);
            a_nj(job_id(j),c)=1;
            c_j=c_j+1;
            job_new(j)=[];
            job_id(j)=[];
            possible_new(j,:)=[];
            p=1;
            for(i=1:numel(job_new))
                if (possible_new(i,c)==1)&&(node_new(c)<job_new(i))
                    
                    possible_new(i,c)=0;
                end
            end
            sum_p=sum(possible_new,2);
        else
            j=j+1;
        end
    end
    if (p==0)
        j=1;
        c=find(possible_new(j,:)==1,1);
        if c>0
            node_new(c)=node_new(c)-job_new(j);
            a_nj(job_id(j),c)=1;
            c_j=c_j+1;
            for(i=1:numel(job_new))
                if (possible_new(i,c)==1)&&(node_new(c)<job_new(i))
                    
                    possible_new(i,c)=0;
                    
                end
            end
        end
        job_new(j)=[];
        job_id(j)=[];
        possible_new(j,:)=[];
        sum_p=sum(possible_new,2);
    end
    
end
sol.a_nj=a_nj;
sol.c_j=c_j;
end

