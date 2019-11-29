function [final_result,mu_chest_old,mu_lung_old,var_chest,var_lung,p_lung,p_chest] = EM_algorithm(img) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ojective : Apply Estimation Maximizatio algorithm To CT images 
% Input : CT image 
% Output : Model Parameters & using it in baysian algorithm 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input:
%--------------------
% read the image and find the location of peaks and consider it as MU
My_image= img(:,:,1);
x = imhist(My_image);
[pks,locs] = findpeaks(x,'MinPeakDistance',100);
%pd=fitdist(x(:),'normal');
[r,c] = size(My_image);
im_1 = zeros(r,c);
im_2 = zeros(r,c);
mu1_vary =zeros(1,50);
mu2_vary =zeros(1,50);

%%%%%%%%%%%%%%%%%%%%%%
%Initialization 
mu_lung_old = locs(1);    sigma1 = 100 ;    pw_lung_old = .5;
mu_chest_old = locs(2);    sigma2 = 100 ;    pw_chest_old = .5;
My_image = double(My_image);
%Iterations 
for index = 1:50
    %E-Step
    for i = 1:r
        for j =1:c
            pixel = My_image(i,j);
            if pixel < 255
                p1_kernal = pw_lung_old .* normpdf(pixel,mu_lung_old,sigma1);
                p2_kernal = pw_chest_old .* normpdf(pixel,mu_chest_old,sigma2);
                %Calculation of resposiility 
                im_1(i,j) = p1_kernal ./ (p1_kernal + p2_kernal); 
                im_2(i,j) = p2_kernal ./ (p1_kernal + p2_kernal);
            else
                im_1(i,j) = 0;
                im_2(i,j) = 0;
            end
        end
    end
    %M-Step 
    
    %New prior propability 
    pw1_new = sum(im_1(:))./ (sum(im_1(:)) + sum(im_2(:)));
    pw2_new = sum(im_2(:))./(sum(im_1(:)) + sum(im_2(:)));
    %-------------------------------------------------
    %New mean
    imt1 = im_1 .* My_image;
    imt2 = im_2 .* My_image;
    mu1_new = sum(imt1(:))./sum(im_1(:));
    mu2_new = sum(imt2(:))./sum(im_2(:));
    %--------------------------------------------------
    %New Variance
    numerator1 = im_1 .* ((My_image - mu_lung_old).^2) ; 
    numerator2 = im_2 .* ((My_image - mu_chest_old).^2) ; 
    var_lung = sum(numerator1(:))./sum(im_1(:));
    var_chest = sum(numerator2(:))./sum(im_2(:));
    %---------------------------------------------------
    %Updating values 
    pw_lung_old = pw1_new;
    pw_chest_old = pw2_new;
    
    mu_lung_old = mu1_new;
    mu_chest_old = mu2_new;
    
    sigma1 = sqrt(var_lung);
    sigma2 = sqrt(var_chest);
    
    %----------------------------------------------
    mu1_vary(index) = mu_lung_old;
    mu2_vary(index) = mu_chest_old;

end 

%fprintf('MU_Chest is : %.3f  \n',mu_chest_old);
%fprintf('MU_Lung is : %.3f  \n',mu_lung_old);
%fprintf('variance_Chest is : %.3f  \n',var_chest);
%fprintf('Variance_Lung is : %.3f \n',var_lung);
%fprintf('P_Lung is : %.3f \n',pw_lung_old);
%fprintf('P_Chest is : %.3f  \n',pw_chest_old);

%-----------------------------------------------------------------
                    %% plotting 
q = 0:1:255; % Gray Level
p_lung = pw_lung_old.*(1./sqrt(2.*pi.*var_lung)).*exp(-((q - mu_lung_old).^2)./(2.*var_lung));
%plot(q,p_lung,'r')
%hold on
p_chest = pw_chest_old.*((1./sqrt(2.*pi.*var_chest)).*exp(-((q - mu_chest_old).^2)./(2.*var_chest)));
%plot(q,p_chest,'b')

%test 
o4=double(img);
img(:,:)= o4(:,:,1);

[h , w] = size(img);

result=zeros(size(img));
%Bayesian Theory Decision
for k1 = 1:1:h
for k2 = 1:1:w
q = img(k1,k2);
if q==255
    result(k1,k2)=0;    %backGround
    
else if  (p_lung(q+1)>=p_chest(q+1))
 result(k1,k2)=1;
else
 result(k1,k2)=.5;
end
end
end
end

%Result Enhancement

x1=result==0;
x3=result==1;

%background enhancement
y = strel('diamond',2);
z=imopen(x1,y);
L=bwlabeln(z,8);
b1=(L==L(1,1))+(L==L(1,end))+(L==L(end,1))+(L==L(end,end));
b1=logical(b1);
%lung enhancement
b3=lung_enhance(x3);
b3=logical(b3);
%enhanced chest
b2=ones(size(result))- (b1+b3) ;

%result
final_result = ((78/255)*b2 + b3) ;

final_result=im2uint8(final_result);

%compute DICE  OR accuracy 
%dice = dsc(img,GT);




