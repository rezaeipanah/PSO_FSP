function model_m=creat_m4(model_nj,entekhab,tedad,TT)
arrive_time=randi(TT-1,[1 tedad]);
n_job=zeros(1,tedad);%job count
dl_servic=zeros(1,tedad);
wait_time=zeros(1,tedad);
done_t=zeros(1,tedad);
n_cost_nj=zeros(tedad,numel(model_nj.node));

job=model_nj.servic;
cost_nj=model_nj.cost_nj;
dl=model_nj.dl_servic;
node=model_nj.node;
node_id=model_nj.node_id;
node_c=numel(model_nj.node);%node count

for(i=1:tedad)
    n_job(i)=job(entekhab(i));
    n_cost_nj(i,:)=cost_nj(entekhab(i),:);
    dl_servic(i)=dl(entekhab(i));
end

VarMin = 0; % Lower Bound of Variable
VarMax =  100; % Upper Bound of Variable
nVar = numel(n_job)+node_c;    % Number of Decision Variable
SearchAgents_no=25;
population_node=initialization(SearchAgents_no,node_c,VarMax,VarMin);
population_jobe=initialization(SearchAgents_no,numel(n_job),VarMax,VarMin);

possible_nj=zeros(tedad,node_c); %possibility for job on node

for (i=1:numel(n_job))% calculate possible matrix
    for (j=1:node_c)
        if (wait_time(i)+n_cost_nj(i,j))<(dl_servic(i)) && (n_job(i)<=node(j))
            possible_nj(i,j)=1;
        else
            possible_nj(i,j)=0;
        end
    end
end


model_m.SearchAgents_no=SearchAgents_no;
model_m.VarMin=VarMin;
model_m.VarMax=VarMax;
model_m.nVar=nVar;

model_m.mjob=n_job;
model_m.mnode=node;

model_m.jobs=numel(n_job);
model_m.nodes=node_c;
model_m.node_id=node_id;
model_m.cost_n=n_cost_nj;
model_m.possible_nj=possible_nj;
model_m.population_node=population_node;
model_m.population_jobe=population_jobe;
model_m.population=[];
model_m.arrive_t=arrive_time;
model_m.dl_servic=dl_servic;
model_m.wait_t=wait_time;
model_m.done_t=done_t;

end

