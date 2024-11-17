%%
% Người chỉnh sửa       : Phạm Hoàng Nam
% Gmail                 : phn1712002@gmail.com 
% Tài liệu tham khảo    : 
% - MOPSO (Code)  
%       https://www.mathworks.com/matlabcentral/fileexchange/52870-multi-objective-particle-swarm-optimization-mopso?s_tid=srchtitle
%       By Yarpiz
% - MOGWO (Code)
%       https://www.mathworks.com/matlabcentral/fileexchange/55979-multi-objective-grey-wolf-optimizer-mogwo
%       By Seyedali Mirjalili
% Tất cả nguyên lý dựa trên Single Objective Optimization kết hợp 2 thành phần: 
% Kho lưu trữ (Archive) và Lựa chọn nhà lãnh đạo(SelectLeader) 
% Được dựa trên code gốc của MOPSO để tạo ra các bản Multi Objective Optimization
%% MOGWO
function MOGWO(fobj,nVar,lb,ub,GreyWolves_num,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF)

% Chạy model
if exist(fobj,'file') == 2
    load(fobj); 
else
    return
end
% Khởi tạo một bầy sói
GreyWolves=CreateEmptyParticle(GreyWolves_num);
for i=1:GreyWolves_num
    GreyWolves(i).Position=zeros(1,nVar);
    for j=1:nVar
        GreyWolves(i).Position(1,j)=unifrnd(lb(j),ub(j),1);
    end
    GreyWolves(i).Cost = net(GreyWolves(i).Position')';
    GreyWolves(i).Best.Position=GreyWolves(i).Position;
    GreyWolves(i).Best.Cost=GreyWolves(i).Cost;
end

% Khởi tạo kho lưu trữ
GreyWolves=DetermineDomination(GreyWolves);
Archive=GetNonDominatedParticles(GreyWolves);
Archive_costs=GetCosts(Archive);
G=CreateHypercubes(Archive_costs,nGrid,alphaF);
for i=1:numel(Archive)
    [Archive(i).GridIndex, Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
end

% MOGWO bắt đầu
for it=1:MaxIt
    a=2-it*((2)/MaxIt);
    for i=1:GreyWolves_num
        
        clear rep2
        clear rep3
        
        % Lựa chọn 3 sói đầu đàn
        Delta=SelectLeader(Archive,betaF);
        Beta=SelectLeader(Archive,betaF);
        Alpha=SelectLeader(Archive,betaF);

        if size(Archive,1)>1
            counter=0;
            for newi=1:size(Archive,1)
                if sum(Delta.Position~=Archive(newi).Position)~=0
                    counter=counter+1;
                    rep2(counter,1)=Archive(newi);
                end
            end
            Beta=SelectLeader(rep2,betaF);
        end 
    
        if size(Archive,1)>2
            counter=0;
            for newi=1:size(rep2,1)
                if sum(Beta.Position~=rep2(newi).Position)~=0
                    counter=counter+1;
                    rep3(counter,1)=rep2(newi);
                end
            end
            Alpha=SelectLeader(rep3,betaF);
        end
        
        
        % Quá trình đi săn
        c=2.*rand(1, nVar);
        D=abs(c.*Delta.Position-GreyWolves(i).Position);
        A=2.*a.*rand(1, nVar)-a;
        X1=Delta.Position-A.*abs(D);
        
        c=2.*rand(1, nVar);
        D=abs(c.*Beta.Position-GreyWolves(i).Position);
        A=2.*a.*rand()-a;
        X2=Beta.Position-A.*abs(D);
        
        c=2.*rand(1, nVar);
        D=abs(c.*Alpha.Position-GreyWolves(i).Position);
        A=2.*a.*rand()-a;
        X3=Alpha.Position-A.*abs(D);
        
        GreyWolves(i).Position=(X1+X2+X3)./3;
        
        % Cập nhật quá trình sau chuyến đi săn
        GreyWolves(i).Position=min(max(GreyWolves(i).Position,lb),ub);
        GreyWolves(i).Cost = net(GreyWolves(i).Position')';
    end
    % Lưu lại các sói có phù hợp vào kho lưu trữ
    [GreyWolves,Archive,G] = AddNewSolToArchive(GreyWolves,Archive,Archive_size,G,nGrid,alphaF,gammaF);
    
    % Xuất kết quả
    disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    save results
end
    OutResults(Archive);
end


