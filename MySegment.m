
function  result = MySegment(f)

% This function use theiterthrsh function's lung result , and get the
% backgroung of the original omage and use them to calculate chest
% then it give      lung >> 255 , chest >> 78 , background >> 0

%get sedmented lung
R = iterthrsh(f);
R=logical(R);

% get background
y = strel('diamond',2);
z=imopen(f==255,y);
L=bwlabeln(z,8);
b=(L==L(1,1))+(L==L(1,end))+(L==L(end,1))+(L==L(end,end));
b=logical(b);

chest=1-b-R;                    %chest 

result=chest*(78/255) + R ;     % sum chest + lung
result=im2uint8(result);
%imshow(result)