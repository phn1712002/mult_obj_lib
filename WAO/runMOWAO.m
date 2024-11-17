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

%% Đầu vào cho MO-WAO
%Whales_num     - Số lượng bầy cá voi
%MaxIt          - Số lượng vòng lặp
%Archive_size   - Số lượng kho lưu trữ
Whales_num = 5;               %So luong bay ca voi
MaxIt = 5;  					%So luong vong lap 
Archive_size = 5;   			%So luong kho luu tru

%% Các thông số này được lấy mặc định từ code MOPSO
alpha = 0.1;  		% Grid Inflation Parameter
nGrid = 7;   		% Number of Grids per each Dimension
beta = 2;     		% Leader Selection Pressure Parameter
gamma = 2;    		% Extra (to be deleted) Repository Member Selection Pressure

%% Run
MOWAO (fobj,nVar,lb,ub,Whales_num,MaxIt,Archive_size,alpha,nGrid,beta,gamma);