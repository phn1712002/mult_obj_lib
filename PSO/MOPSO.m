%%
% Người chỉnh sửa       : Phạm Hoàng Nam
% Gmail                 : phn1712002@gmail.com 
% Tài liệu tham khảo    : 
% - MOPSO (Code)  
%       https://www.mathworks.com/matlabcentral/fileexchange/52870-multi-objective-particle-swarm-optimization-mopso?s_tid=srchtitle
%       By Yarpiz
% Tất cả nguyên lý dựa trên Single Objective Optimization kết hợp 2 thành phần: 
% Kho lưu trữ (Archive) và Lựa chọn nhà lãnh đạo(SelectLeader) 
% Được dựa trên code gốc của MOPSO để tạo ra các bản Multi Objective Optimization
%% MOPSO
function MOPSO(Fobj,nVar,Lb,Ub,Pop_num,MaxIt,Weight,Weightdamp,personalCoefficient,globalCoefficient,mutationRate,Archive_size,alphaF,nGrid,betaF,gammaF)
% Chạy model
if exist(Fobj,'file') == 2
    load(Fobj); 
else
    return
end

% Khởi tạo bầy chim
Pop=CreateEmptyParticle(Pop_num);
VarSize=[1 nVar];
for i=1:Pop_num
    Pop(i).Velocity = 0; 
    Pop(i).Position=zeros(1,nVar);
    for j=1:nVar
        Pop(i).Position(1,j)=unifrnd(Lb(j),Ub(j),1);
    end
    Pop(i).Cost=net(Pop(i).Position')';
    Pop(i).Best.Position=Pop(i).Position;
    Pop(i).Best.Cost=Pop(i).Cost;
end

% Khởi tạo kho lưu trữ để lưu các giải pháp
Pop=DetermineDomination(Pop);
Archive=GetNonDominatedParticles(Pop);
Archive_costs=GetCosts(Archive);
G=CreateHypercubes(Archive_costs,nGrid,alphaF);
for i=1:numel(Archive)
    [Archive(i).GridIndex, Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
end

% MOPSO bắt đầu vòng lặp
for it = 1:MaxIt
    
    for i=1:Pop_num
        leaderPop=SelectLeader(Archive,betaF);
        
        Pop(i).Velocity = Weight*Pop(i).Velocity ...
            +personalCoefficient*rand(VarSize).*(Pop(i).Best.Position-Pop(i).Position) ...
            +globalCoefficient*rand(VarSize).*(leaderPop.Position-Pop(i).Position);
        
        Pop(i).Position = Pop(i).Position + Pop(i).Velocity;
        
        Pop(i).Position = max(Pop(i).Position, Lb);
        Pop(i).Position = min(Pop(i).Position, Ub);
        
        Pop(i).Cost=net(Pop(i).Position')';
    % Thực hiện đột biến
        pm=(1-(it-1)/(MaxIt-1))^(1/mutationRate);
        if rand < pm
            NewSol.Position=Mutate(Pop(i).Position,pm,Lb,Ub);
            NewSol.Cost=net(NewSol.Position')';
            if Dominates(NewSol,Pop(i))
                Pop(i).Position=NewSol.Position;
                Pop(i).Cost=NewSol.Cost;
            elseif Dominates(Pop(i),NewSol)
               % Không làm gì cả 
            else
                if rand<0.5
                    Pop(i).Position=NewSol.Position;
                    Pop(i).Cost=NewSol.Cost;
                end
            end
        end
        
        if Dominates(Pop(i),Pop(i).Best)
            Pop(i).Best.Position=Pop(i).Position;
            Pop(i).Best.Cost=Pop(i).Cost;
            
        elseif Dominates(Pop(i).Best,Pop(i))
            % Không làm gì cả  
        else
            if rand<0.5
                Pop(i).Best.Position=Pop(i).Position;
                Pop(i).Best.Cost=Pop(i).Cost;
            end
        end
    end
     % Lưu lại giải pháp tốt nhất
     [Pop,Archive,G] = AddNewSolToArchive(Pop,Archive,Archive_size,G,nGrid,alphaF,gammaF);
     Weight=Weight*Weightdamp;  
     
    disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    save results
end
% Xuất kết quả
OutResults(Archive);
end




