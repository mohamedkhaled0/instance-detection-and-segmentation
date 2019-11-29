
function  Result = iterthrsh(f)
f=f(:,:,1);
f = double(f);
% compute the first value for threshold  
T0 = (max(f(:)) + min(f(:)))/2 ;

delt = 1;
%Make segmented image 
th_img = f > T0 ;
%Make some iterations till reaching the best threshold value 
while delt >= .05
    T = T0; 
    %Separate image into two regions 
    G1 = double((f > T)) .* f ;
    G2 = double((f <= T)) .* f;
    % Compute mu for each region 
    M1 = (max(G1(:)) + min(G1(:)))/2;
    M2 = (max(G2(:)) + min(G2(:)))/2;
    %compute new threshold 
    T0= 0.5*(M1+M2);
    %new segmented image
    th_img = f > T0 ;
    %new delta value 
    delt = abs(T - T0);
end 
    %display(T0) ;
    
    %Mophorogical operations
y = strel('diamond',10);
th_img = imcomplement(th_img);

z1=imclose(th_img,y);
z=imclose(z1,y);

%Checking that left and right lung are seperate:

%calculate connectivity of result
L=bwlabeln(z,8);
q=0;
qq=[0 0 0];
s=1;
mm=zeros(1,max(L(:)));
    
%getting the number of pixels for every region.
%converting result from struct to double.
    for j=1:max(L(:))
    cc=struct2cell(regionprops(L==j,'Area') );
    mm(j)=cat(2,cc{:});
    end

    %getting number of regions with Area > 300 pixel.
    for i=1:max(L(:))

    if mm(i) >300
        
        q=q+1;
    end
    end

%Seperating the segmented image into three images each include one of 
%the lung regions, and work on each image and sum them at last.

%if our segmented image has only two regions > 300 pixel
if q < 3 
   L1=bwlabeln(th_img,8);    %connectivity of the segmented image
    m=zeros(1,max(L1(:)));

    %getting n.of pixel for every region.
for i=1:max(L1(:))
    xx=struct2cell(regionprops(L1==i,'Area') );
    m(i)=cat(2,xx{:});
end
   
for i=1:size(m,2)
if m(i)>300
  qq(s)=i ;  % the label number for every large region.
  s=s+1;
end
end


x1=L1==qq(1);   %1st region
x2=L1==qq(2);   %2nd region
x3=L1==qq(3);   %3rd region

%Morphological closing and opening for ever label.
y = strel('diamond',8);
%1st
finall1=imclose(x1,y);
final1=imopen(finall1,y);
%2nd
finall2=imclose(x2,y);
final2=imopen(finall2,y);
%3rd
finall3=imclose(x3,y);
final3=imopen(finall3,y);


    Result=final1+final2+final3;
   
else
    Result=z;
end

% Smoothing edes using kernel0
kernel = ones(5) / 5 ^ 2;
blurryImage = conv2(double(Result), kernel, 'same');
Result = blurryImage > 0.5;

  % imshow(Result) 
