function [rate]=predict(user_res_matrix,i,j,similarity)
numer=0;
denom=0;
for x=1:size(user_res_matrix,1)
    numer=numer+(user_res_matrix(x,j)*similarity(i,x));
    denom=denom+similarity(i,x);
end
if denom==0
    rate=0;
else
    rate=double(numer)/double(denom);
end
end