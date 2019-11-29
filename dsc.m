function  dcs_2= dsc(m,z)
%Take the Ground truth image(m) and my segmented lung(z) 
%and compute the accuracy of my output


TP_2=sum(sum(and(m,z)))   ;                 %intersection between A&z
FP_2=sum(sum(and(m,~z)))  ;                %A-z what found in A and not found in z
FN_2=sum(sum(and(~m,z)))  ;                 %z-A what found inz and not found in A
dcs_2=(2*TP_2)/(FP_2+FN_2+2*TP_2) ;  
%fprintf('the Result accuracy equal  \t %.3f %% \n',dcs_2 *100);