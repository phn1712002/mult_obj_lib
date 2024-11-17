%%
% Người sáng tạo        : Phạm Hoàng Nam
% Gmail                 : phn1712002@gmail.com 
% Tài liệu tham khảo    : 
%   
% - A Cuckoo Search Algorithm (PDF)
%       https://www.hindawi.com/journals/tswj/2014/497514/
%       By Erik Cuevas
% - MOCS (Code)
%       https://www.mathworks.com/matlabcentral/fileexchange/74752-multiobjective-cuckoo-search-mocs
%       By XS Yang
% - MOPSO (Code)  
%       https://www.mathworks.com/matlabcentral/fileexchange/52870-multi-objective-particle-swarm-optimization-mopso?s_tid=srchtitle
%       By Yarpiz
% - MOGWO (Code)
%       https://www.mathworks.com/matlabcentral/fileexchange/55979-multi-objective-grey-wolf-optimizer-mogwo
%       By Seyedali Mirjalili
% Tất cả nguyên lý dựa trên Single Objective Optimization kết hợp 2 thành phần: 
% Kho lưu trữ (Archive) và Lựa chọn nhà lãnh đạo(SelectLeader) 
% Được dựa trên code gốc của MOPSO để tạo ra các bản Multi Objective Optimization 
%% MOCS
function MOCS(fobj,nVar,lb,ub,nestsCuckoos_num,pa,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF)

% Chạy model
if exist(fobj,'file') == 2
    load(fobj);
else
    return
end

% Khởi tạo một quần thể chim và tổ chim, coi tổ chim và chim Cuckoo là như nhau
nestsCuckoos=CreateEmptyParticle(nestsCuckoos_num);
for i=1:nestsCuckoos_num
    nestsCuckoos(i).Position=zeros(1,nVar);
    for j=1:nVar
        nestsCuckoos(i).Position(1,j)=unifrnd(lb(j),ub(j),1);
    end
    nestsCuckoos(i).Cost=net(nestsCuckoos(i).Position')';
    nestsCuckoos(i).Best.Position=nestsCuckoos(i).Position;
    nestsCuckoos(i).Best.Cost=nestsCuckoos(i).Cost;
end

% Khởi tạo kho lưu trữ các giải pháp
nestsCuckoos=DetermineDomination(nestsCuckoos);
Archive=GetNonDominatedParticles(nestsCuckoos);
Archive_costs=GetCosts(Archive);
G=CreateHypercubes(Archive_costs,nGrid,alphaF);
for i=1:numel(Archive)
    [Archive(i).GridIndex, Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
end

% MOCS bắt đầu 
for it=1:MaxIt

    LeaderNestsCuckoos=SelectLeader(Archive,betaF);
    
    beta=3/2;
    sigma=(gamma(1+beta)*sin(pi*beta/2)/(gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);
    for j=1:nestsCuckoos_num
        % Thực hiện chuyến bay Levy
        s=nestsCuckoos(j).Position;
        u=randn(size(s))*sigma;
        v=randn(size(s));
        step=u./abs(v).^(1/betaF);
        stepsize=0.01*step.*(s-LeaderNestsCuckoos.Position);
        s=s+stepsize.*randn(size(s));
        nestsCuckoos(j).Position=SimpleBounds(s,lb,ub);
        nestsCuckoos(j).Cost=net(nestsCuckoos(i).Position')';
        nestsCuckoos(j).Best.Position=nestsCuckoos(j).Position;
        nestsCuckoos(j).Best.Cost=nestsCuckoos(j).Cost;
        % Thực hiện phá hủy tổ Pa
        if rand > pa
            r1 = floor(nestsCuckoos_num*rand()+1);
            r2 = floor(nestsCuckoos_num*rand()+1);
            stepsize=rand*(nestsCuckoos(r1).Position-nestsCuckoos(r2).Position);
            nestsCuckoos(j).Position=nestsCuckoos(j).Position+stepsize;
            nestsCuckoos(j).Position=SimpleBounds(nestsCuckoos(j).Position,lb,ub);
        end 
    end
    % Lưu lại những giải pháp tốt nhất
    [nestsCuckoos,Archive,G] = AddNewSolToArchive(nestsCuckoos,Archive,Archive_size,G,nGrid,alphaF,gammaF);
    
    disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    save results
    
end
% Xuất kết quả
OutResults(Archive);
end




