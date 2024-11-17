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

%% Đầu vào cho MOPSO
%GreyWolves_num - Số lượng bầy sói
%MaxIt          - Số lượng vòng lặp
%Archive_size   - Số lượng kho lưu trữ
GreyWolves_num = 5;		
MaxIt = 10;  					
Archive_size = 5;   			

%% Các thông số này được lấy mặc định từ code MOPSO
alpha = 0.1;  		% Grid Inflation Parameter
nGrid = 7;   		% Number of Grids per each Dimension
beta = 2;     		% Leader Selection Pressure Parameter
gamma = 2;    		% Extra (to be deleted) Repository Member Selection Pressure

%% Run
MOGWO (fobj,nVar,lb,ub,GreyWolves_num,MaxIt,Archive_size,alpha,nGrid,beta,gamma);





