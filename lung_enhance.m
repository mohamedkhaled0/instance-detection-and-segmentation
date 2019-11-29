function  R = lung_enhance(f)

% This code enhance segmented lung.
% it's almost the same code used in iterthresh function.


    %Mophorogical operations
y = strel('diamond',10);
%th_img = imcomplement(th_img);

z1=imclose(f,y);
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
   L1=bwlabeln(f,8);    %connectivity of the segmented image
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


    R=final1+final2+final3;
   
else
    R=z;
end
kernel = ones(5) / 5 ^ 2;
blurryImage = conv2(double(R), kernel, 'same');
R = blurryImage > 0.5;

