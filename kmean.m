clc
clear all
close all


training_data =load('training_data.txt');
testing_data=load('testing_data.txt');

data_for_training=training_data(:,3:end);
data_for_testing=testing_data(:,3:(end-1));


mae=zeros(20000,1);
%% Cluster Numbers
%% Adding this comment on 09/14/2021 for ASE Fall 21 Course

for K=70:170  %%to store distance of training data from centres
    
    [idx,C]=kmeans(data_for_training,K);
    
    dis= zeros(1,K);
    sum=0;
    
    for i=1:size(data_for_testing,1)
        
        for j=1:K
            dis(1,j) = norm(data_for_testing(i,:) - C(j,1:(end-1)));
        end
        [Distance CN] = min(dis(1,1:K));
        rows_of_cluster = (idx(:) == CN);
        data_of_cluster=training_data(rows_of_cluster,:);
        
        rows_same_movie=(data_of_cluster(:,2)==testing_data(i,2));
        data_same_movie=data_of_cluster(rows_same_movie,:);
        
        s=size(data_same_movie,1);
        
        if s~= 0
            mmean=mean(data_same_movie(:,25));
            %%mmean
            sum=sum+abs(mmean-testing_data(i,25));
        end
    end
    %%sum/20000
    fid=fopen('mae70.txt','a+');
fprintf(fid,'%0.3f',sum/20000);
fprintf(fid,'\n');
fclose(fid);
end
