function xnew=Mutate(x,pm,lb,ub)
    nVar=numel(x);
    j=randi([1 nVar]);
    dx=pm*(ub-lb);
    
    VarMin=x(j)-dx;
    if VarMin<lb
        VarMin=lb;
    end
    
    VarMax=x(j)+dx;
    if VarMax>ub
        VarMax=ub;
    end
    
    xnew=x;
    xnew(j)=unifrnd(VarMin(j),VarMax(j));
end