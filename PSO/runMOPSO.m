clear
close all
clc

%% Khai báo hàm mục tiêu
% fobj  - Thông tin của hàm
% nVar  - Số lượng chiều của hàm 
% lb,ub - Điều kiện biên  
fobj = '';
nVar = 4;
lb = [0 0 0 0];	
ub = [1 1 1 1];

%% Đầu vào cho MO-ABC
%Pop_num                - Số lượng bầy chim
%MaxIt                  - Số lượng vòng lặp
%Archive_size           - Số lượng kho lưu trữ
% Weight                - Trọng lượng quán tính
% Weightdamp            - Tỷ lệ giảm xóc theo quán tính
% personalCoefficient   - Hệ số học tập cá nhân
% globalCoefficient     - Hệ số học tập toàn cầu
% mutationRate          - Tỷ lệ đột biến
Pop_num = 5;                         
MaxIt = 5;                           
Archive_size = 5;                    
Weight = 0.5;
Weightdamp = 0.99;
Personal_Coefficient = 1;
Global_Coefficient = 2;
Mutation_Rate = 0.1;
%% Các thông số này được lấy mặc định từ code MOPSO
alpha = 0.1;  		% Grid Inflation Parameter
nGrid = 7;   		% Number of Grids per each Dimension
beta = 2;     		% Leader Selection Pressure Parameter
gamma = 2;    		% Extra (to be deleted) Repository Member Selection Pressure

%% Run
MOPSO (fobj,nVar,lb,ub,Pop_num,MaxIt,Weight,Weightdamp,Personal_Coefficient,Global_Coefficient,Mutation_Rate,Archive_size,alpha,nGrid,beta,gamma);