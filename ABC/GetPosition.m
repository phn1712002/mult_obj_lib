function posi=GetPosition(pop)

    nobj=numel(pop(1).Position);
    posi=reshape([pop.Position],nobj,[]);

end