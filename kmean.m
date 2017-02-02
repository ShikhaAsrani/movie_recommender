clc
clear all
close all

accuracy=0;
data = load('3_train.txt');
tdata=load('3_test.txt');
udata=load('user.txt');
mdata=load('movie.txt');
%%training data
d=data(:,1:3);
%%testing data
td=tdata(:,1:2);
%%answers
answer=tdata(:,3);
% 
% addusertdata=udata(td(1,1),:);
% addmovietdata=mdata(td(1,2),:);
% 
% for i=2:size(td,1)
%     addusertdata=[addusertdata;udata(d(i,1),:)];
%     addmovietdata=[addmovietdata;mdata(d(i,2),:)];
% end


addUserData=load('user_3.txt');
addmoviedata=load('mov_3.txt');
d=[d(:,1:2) adduserdata addmoviedata d(:,3)];

addusertdata=load('user_3_test.txt');
addmovietdata=load('mov_3_test.txt');
td=[td addusertdata addmovietdata];

dproxy=d;
tdproxy=td;
d=d(:,3:end);
td=td(:,3:end);

K     =125;                                            % Cluster Numbers
KMI   = 40;                                           % K-means Iteration
CENTS = d( ceil(rand(K,1)*size(d,1)) ,:);             % Cluster Centers
DAL   = zeros(size(d,1),K+2);                         % Distances and Labels

dis= zeros(1,K);  

[idx,C]=kmeans(d,K);

sum=0;

for i=1:size(tdata,1)

    for j=1:K

        dis(1,j) = norm(td(i,:) - C(j,1:(end-1)));
    end
    [Distance CN] = min(dis(1,1:K));
    A = (idx(:) == CN);
    A=dproxy(A,:);
   
    B=(A(:,2)==tdproxy(i,2));
    B=A(B,:);
    s=size(B,1);
    if s~= 0
        mmean=mean(B(:,23));
        mmean
        sum=sum+abs(mmean-tdata(i,3));
    else
        i
    end
end

%%125 1.8071 3