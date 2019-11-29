function   [final_result,p_lung,p_chest]=sup_classifier1(M1,GT1,M2,GT2,M3,GT3,M4)
    
% M is the original images, GT is the corresponding Ground truth image.
%M4 is the original image we want to get its segmentation
%using the classifier.
 
%intialization 
muLung=zeros(3,1);
muChest=zeros(3,1);                  
sigmaLung=zeros(3,1);
sigmaChest=zeros(3,1);         
pLung=zeros(3,1);



%seperate lung using GT
LT1=nonzeros(M1 .*uint8(boolean(GT1.*uint8(GT1==255))));                    
LT2=nonzeros(M2 .* uint8(boolean(GT2.*uint8(GT2==255))));
LT3=nonzeros(M3 .*uint8(boolean(GT3.*uint8(GT3==255))));


%seperate chest using GT
CHT1=nonzeros(M1 .*uint8(boolean(GT1.*uint8(GT1==78))));   
CHT2=nonzeros(M2 .*uint8(boolean(GT2.*uint8(GT2==78))));
CHT3=nonzeros(M3 .*uint8(boolean(GT3.*uint8(GT3==78))));

%calculating the mean and variace  
[muLung(1),sigmaLung(1)] = normfit(LT1);
[muLung(2),sigmaLung(2)] = normfit(LT2);
[muLung(3),sigmaLung(3)] = normfit(LT3);
[muChest(1),sigmaChest(1)] = normfit(CHT1);
[muChest(2),sigmaChest(2)] = normfit(CHT2);
[muChest(3),sigmaChest(3)] = normfit(CHT3);
MuLung=mean(muLung);  
SigmaLung=mean(sigmaLung);            
MuChest=mean(muChest);
SigmaChest=mean(sigmaChest);     

%prior probability of lung and chest tissues.
pLung(1)= length(LT1)/(length(LT1)+length(CHT1)); 
pLung(2)= length(LT2)/(length(LT1)+length(CHT2)); 
pLung(3)= length(LT3)/(length(LT1)+length(CHT3)); 
PLungF = mean(pLung); %for lung 
pCHest(1)= length(CHT1)/(length(CHT1)+length(CHT1)); 
pCHest(2)= length(CHT2)/(length(CHT2)+length(CHT2)); 
pCHest(3)= length(CHT3)/(length(CHT3)+length(CHT3)); 
PCHestF = mean(pCHest); %for Chest 



%plotting
q = 0:1:255; % Gray Level
p_lung = PLungF.*(1./sqrt(2.*pi.*SigmaLung)).*exp(-((q - MuLung).^2)./(2.*SigmaLung));
%plot(q,p_lung,'r')
hold on
p_chest = PCHestF.*( (1./sqrt(2.*pi.*SigmaChest)).*exp(-((q-MuChest).^2)./(2.*SigmaChest)));
%plot(q,p_chest,'b')


%test 
o4=double(M4);
m4(:,:)= o4(:,:,1);

[h , w] = size(m4);

result=zeros(size(m4));
%Bayesian Theory Decision
for k1 = 1:1:h
for k2 = 1:1:w
q = m4(k1,k2);
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

%figure(2); 
%imshow(final_result);




