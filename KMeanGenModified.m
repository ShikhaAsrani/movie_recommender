function [idx,C] = KMeanGenModified(K)
data=load('movie.txt');
CENTS=mean(data,1);
n=size(data,1);
for i=1:K
    [idx,C]=kmeanGenFuncModified(data,i,CENTS);
    n=n/(i+1);
    marker=zeros(size(data,1),1);
    for j=1:i
        for l=1:size(data,1) 
        distanceFromThisCentre(l,1)=NTypeDistance(data(l,:),C(j));
        end
        [sorted Idx]=sort(distanceFromThisCentre);
        Idx=Idx(1:n,:);
        for l=1:size(Idx)
            marker(Idx(l,1),1)=1;
        end
    end
    x=ones(size(marker));
    x(find(marker))=0;
    marker=x;
    NextCent=mean(data(find(marker),:),1);
    CENTS=[CENTS ; NextCent];
end
end