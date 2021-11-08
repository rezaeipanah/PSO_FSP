function m_list_serv=merg_lists(list_serv1,list_serv2)
if (~(isempty(list_serv1)))
    
    list_serv1.mnode=list_serv2.mnode;
    list_serv1.nodes=list_serv2.nodes;
    list_serv1.node_id=list_serv2.node_id;
    list_serv1.nVar=list_serv1.nVar+list_serv2.jobs;
    list_serv1.population_jobe=[list_serv1.population_jobe list_serv2.population_jobe];
    list_serv1.population_node=list_serv2.population_node;
    list_serv1.mjob=[list_serv1.mjob list_serv2.mjob];
    list_serv1.jobs=list_serv1.jobs+list_serv2.jobs;
    list_serv1.cost_n=[list_serv1.cost_n; list_serv2.cost_n];
    list_serv1.possible_nj=[list_serv1.possible_nj; list_serv2.possible_nj];
    list_serv1.arrive_t=[list_serv1.arrive_t list_serv2.arrive_t];
    list_serv1.dl_servic=[list_serv1.dl_servic list_serv2.dl_servic];
    list_serv1.wait_t=[list_serv1.wait_t list_serv2.wait_t];
    list_serv1.done_t=[list_serv1.done_t list_serv2.done_t];
    list_serv1.old_cost=list_serv1.old_cost;
    m_list_serv=list_serv1;
    
else
    m_list_serv=list_serv2;
end
end