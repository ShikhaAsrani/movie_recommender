function [similarity]=generateSimilarity(user_res_matrix)
similarity=zeros(size(user_res_matrix,1));
for i=1:1689
    for j=i+1:1689
        vsum=sum(user_res_matrix(i,:).*user_res_matrix(j,:));
        den=sqrt(sum(user_res_matrix(i,:).*user_res_matrix(i,:)))*sqrt(sum(user_res_matrix(j,:).*user_res_matrix(j,:)));
        similarity(i,j)=double(vsum)/double(den);
        similarity(j,i)=similarity(i,j);
    end
end