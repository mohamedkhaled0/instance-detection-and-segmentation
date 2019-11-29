function [r,p_lung,p_chest,M,G,x]=k_fold()

%<< K-fold cross validation for k = 4  >>  

clear
clc
% read image and gt 

M1=imread('CT_001.bmp');                                         
GT1=imread('Ground_Truth_CT_001.bmp');
M2=imread('CT_002.bmp');
GT2=imread('Ground_Truth_CT_002.bmp');
M3=imread('CT_003.bmp');
GT3=imread('Ground_Truth_CT_003.bmp');
M4=imread('CT_003.bmp');
GT4=imread('Ground_Truth_CT_003.bmp');
error=zeros(1,4); 

%for 1st stage
[r,p_lung,p_chest]=sup_classifier1(M4,GT4,M2,GT2,M3,GT3,M1);
error(1)=sqrt(mean(mean((r-GT1).^2)));
M=M1;
G=GT1;
x=1;
%for 2nd stage
[r1]=sup_classifier1(M1,GT1,M3,GT3,M4,GT4,M2);
error(2)=sqrt(mean(mean((r1-GT2).^2)));

if error(2)<error(1)
 [r,p_lung,p_chest]=sup_classifier1(M1,GT1,M3,GT3,M4,GT4,M2);
 M=M2;G=GT2;
 x=2;
end

%for 3rd stage
[r1]=sup_classifier1(M1,GT1,M2,GT2,M4,GT4,M3);
error(3)=sqrt(mean(mean((r1-GT3).^2)));

if error(3)<error(2)
    M=M3;G=GT3;
    [r,p_lung,p_chest]=sup_classifier1(M1,GT1,M2,GT2,M4,GT4,M3);
    x=3;
end

%for 4rth stage
[r1]=sup_classifier1(M1,GT1,M2,GT2,M3,GT3,M4);
error(4)=sqrt(mean(mean((r1-GT4).^2)));

if error(4)<error(3)
        M=M4;G=GT4;
    [r,p_lung,p_chest]=sup_classifier1(M1,GT1,M2,GT2,M3,GT3,M4);
    x=4;
end
for i=1:4
fprintf('The mean squere error for the stage number %d is   \t  %.5f   \n \n',i,error(i));
end
fprintf('\n The Best Case When we used   M%d  for the test  and the others for training\n',x);