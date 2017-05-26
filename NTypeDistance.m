function dist = NTypeDistance(x,y)
N=size(x,2);
Nup=(x-y).^N;
Nup=sum(Nup);
dist=Nup^(1/N);
end