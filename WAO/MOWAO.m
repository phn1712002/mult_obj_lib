%%
% Người sáng tạo        : Phạm Hoàng Nam
% Gmail                 : phn1712002@gmail.com 
% Tài liệu tham khảo    : 
%   
% - Multi-Objective Whale Optimization Algorithm (PDF)
%       https://www.mdpi.com/1424-8220/21/8/2628
%       By Mengxing Huang
% - Whale Optimization Algorithm
%       https://en.wikiversity.org/wiki/Whale_Optimization_Algorithm
%       By Wikiversity
% - WAO (Code)
%       https://www.mathworks.com/matlabcentral/fileexchange/55667-the-whale-optimization-algorithm
%       By Seyedali Mirjalili
% - MOPSO (Code)  
%       https://www.mathworks.com/matlabcentral/fileexchange/52870-multi-objective-particle-swarm-optimization-mopso?s_tid=srchtitle
%       By Yarpiz
% - MOGWO (Code)
%       https://www.mathworks.com/matlabcentral/fileexchange/55979-multi-objective-grey-wolf-optimizer-mogwo
%       By Seyedali Mirjalili
% Tất cả nguyên lý dựa trên Single Objective Optimization kết hợp 2 thành phần: 
% Kho lưu trữ (Archive) và Lựa chọn nhà lãnh đạo(SelectLeader) 
% Được dựa trên code gốc của MOPSO để tạo ra các bản Multi Objective Optimization  
%% MOWAO
function MOWAO(fobj,nVar,lb,ub,Whales_num,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF)
% Chạy model
if exist(fobj,'file') == 2
    load(fobj);
else
    return
end

% Khởi tạo bầy cá voi
Whales=CreateEmptyParticle(Whales_num);
for i=1:Whales_num
    Whales(i).Position=zeros(1,nVar);
    for j=1:nVar
        Whales(i).Position(1,j)=unifrnd(lb(j),ub(j),1);
    end
    Whales(i).Cost=net(Whales(i).Position')';
    Whales(i).Best.Position=Whales(i).Position;
    Whales(i).Best.Cost=Whales(i).Cost;
end

% Khởi tạo kho lưu trữ
Whales=DetermineDomination(Whales);
Archive=GetNonDominatedParticles(Whales);
Archive_costs=GetCosts(Archive);
G=CreateHypercubes(Archive_costs,nGrid,alphaF);
for i=1:numel(Archive)
    [Archive(i).GridIndex, Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
end

% MOWAO bắt đầu
for it=1:MaxIt
    a=2-it*((2)/MaxIt);
    a2=-1+it*((-1)/MaxIt);
    for i=1:Whales_num
        
        % Lựa chọn cá voi tốt nhất
        LeaderWhales=SelectLeader(Archive,betaF);
        
        % Quá trình đi săn 
        r1=rand(); 
        r2=rand(); 
        
        A=2*a*r1-a;  
        C=2*r2;      

        b=1;               
        l=(a2-1)*rand+1;   
        p = rand();        
        
        % Lựa chọn cách thức săn mồi
        if p<0.5 % Phương pháp bao vây con mồi 
            if abs(A)>=1 % Tìm kiếm con mồi
                rand_leader_index = floor(Whales_num*rand()+1);
                X_rand = Whales(rand_leader_index).Position;
                D_X_rand=abs(C*X_rand-Whales(i).Position); 
                Whales(i).Position=X_rand-A*D_X_rand;     
                
            elseif abs(A)<1 % Săn con mồi
                D_Leader=abs(C*LeaderWhales.Position-Whales(i).Position);
                Whales(i).Position=LeaderWhales.Position-A*D_Leader;     
            end
            
        elseif p>=0.5 % Phương pháp tấn công mạng bong bóng
            distance2Leader=abs(LeaderWhales.Position-Whales(i).Position);
            Whales(i).Position=distance2Leader*exp(b.*l).*cos(l.*2*pi)+LeaderWhales.Position;
        end
        % Cập nhật giá trị sau khi đi chuyến săn
        Whales(i).Position=min(max(Whales(i).Position,lb),ub);
        Whales(i).Cost=net(Whales(i).Position')';
    end
    
    % Lưu lại các cá voi có phù hợp vào kho lưu trữ
    [Whales,Archive,G] = AddNewSolToArchive(Whales,Archive,Archive_size,G,nGrid,alphaF,gammaF);
    
    disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    save results
end
% Xuất kết quả
OutResults(Archive);
end




