clc
clear
X=xlsread('指标数据.xlsx','B:I');%将数据导入进来
cluster_n=3;%进行FCM聚类
[center, U, obj_fcn] = fcm(X, cluster_n);
figure
plot(obj_fcn)
xlabel('iteration')
ylabel('obj.fcn_value')
[~,group]=max(U);
disp('分类结束')
fprintf('第一类划分了%d个\n',length(find(group==1)))
fprintf('第二类划分了%d个\n',length(find(group==2)))
fprintf('第三类划分了%d个\n',length(find(group==3)))
%进行单因素方差分析
Y=xlsread('指标数据.xlsx','J:AH');%将数据导入进来
Z=[];
% clc
% clear
% Data = readtable("2022_APMCM_C_Data.csv",'Format','%s%f%f%s%s%s%s');%按指定格式读取数据赋值给变量Data
% Data_cell = table2cell(Data);%为方便后面后面使用数据，将表格转换为数组
% CTY_L = Data_cell(:,4);
% CTY_L_cat = categorical(CTY_L);
% CTY_L_int = double(CTY_L_cat);
% TotalCTY_N = size(unique(CTY_L_int),1);
% Contry_L = Data_cell(:,5);
% Contry_L_cat = categorical(Contry_L);
% Contry_L_int = double(Contry_L_cat);
% TotalContry_N = size(unique(Contry_L_int),1);
% [N,M] = size(Data);%数据的维度
% Data_int = zeros(N,10);%原始数据预设矩阵
% for i = 1:N
%     timeTemp = regexp(Data_cell{i,1},'[/-]','split');
%     Data_int(i,1) = str2double(timeTemp{1,1});
%     Data_int(i,2) = str2double(timeTemp{1,2});
%     Data_int(i,3) = double(Data_cell{i,2});
%     Data_int(i,4) = double(Data_cell{i,3});
%     Data_int(i,5) = CTY_L_int(i);
%     Data_int(i,6) = Contry_L_int(i);
%     La = regexp(Data_cell{i,6},'[NESW]','split');
%     Data_int(i,7) = str2double(La{1});
%     Data_int(i,8) = Data_cell{i,6}(length(Data_cell{i,6})) == 'N';
%     Lo = regexp(Data_cell{i,7},'[NESW]','split');
%     Data_int(i,9) = str2double(Lo{1});
%     Data_int(i,10) = Data_cell{i,7}(length(Data_cell{i,7})) == 'E';
% end
for i=1:size(Y,2)
    A=Y(:,i)';
    [p,anovatab,stats]=anova1(A,group,'off');
    financeadvisor=finv(0.95,anovatab{2,3},anovatab{3,3});
    F=anovatab{2,5};
    if p<=0.01 && F>financeadvisor
        disp(['第',num2str(i),'个指标非常显著'])
    elseif p<=0.05 && F>financeadvisor
        disp(['第',num2str(i),'显著'])
    else
        disp(['第',num2str(i),'不显著'])
    end
    Z=[Z;"指标"+num2str(i),anovatab{2,2},anovatab{2,4},anovatab{2,5},anovatab{2,6}];
end
Z=["指标","SS","MS","F值","p值";Z];