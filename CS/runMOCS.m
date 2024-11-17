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

%% Đầu vào cho MO-CS
%Cuckoos_num    - Số lượng bầy chim
%MaxIt          - Số lượng vòng lặp
%Archive_size   - Số lượng kho lưu trữ
%Pa             - Hệ số xác xuất phá hủy tổ chim
Cuckoos_num = 5;              
MaxIt = 5;  					
Archive_size = 5;   			
Pa = 0.1;                       

%% Các thông số này được lấy mặc định từ code MOPSO
alpha = 0.1;  		% Grid Inflation Parameter
nGrid = 7;   		% Number of Grids per each Dimension
beta = 2;     		% Leader Selection Pressure Parameter
gamma = 2;    		% Extra (to be deleted) Repository Member Selection Pressure

%% Run
MOCS (fobj,nVar,lb,ub,Cuckoos_num,Pa,MaxIt,Archive_size,alpha,nGrid,beta,gamma);