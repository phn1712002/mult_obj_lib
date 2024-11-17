function [newSol,Archive,G]=AddNewSolToArchive(newSol,Archive,Archive_size,G,nGrid,alpha,gammaF)
    newSol = DetermineDomination(newSol);
    non_dominated_newSol = GetNonDominatedParticles(newSol);

    Archive=[Archive
        non_dominated_newSol];

    Archive=DetermineDomination(Archive);
    Archive=GetNonDominatedParticles(Archive);

    for i=1:numel(Archive)
        [Archive(i).GridIndex, Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
    end

    if numel(Archive)>Archive_size
        EXTRA=numel(Archive)-Archive_size;
        Archive=DeleteFromRep(Archive,EXTRA,gammaF);

        Archive_costs=GetCosts(Archive);
        G=CreateHypercubes(Archive_costs,nGrid,alpha);
    end
end