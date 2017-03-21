clc
clear all
close all


training_data =load('training_data.txt');
testing_data=load('testing_data.txt');

data_for_training=training_data(:,3:end-1);
data_for_testing=testing_data(:,3:(end-1));


sumv=zeros(20000,1);
sizev=zeros(20000,1);

index=zeros(943,1);
K=68;

[idx,C]=kmeans(data_for_training,K);

for i=1:943
    clusters_of_i=idx(training_data(:,1)==i);
    M=mode(clusters_of_i,1);
    index(i,1)=M;
end
index;



for i=1:20000
    
    cluster_to_be_searched=index(testing_data(i,1),1);
    members_of_cluster=(index(:,1)==cluster_to_be_searched);
    members_of_cluster=find(members_of_cluster);
    
    x=0;
    xvf=0;
    for j=1:size(members_of_cluster,1)
        index_of_member=(training_data(:,1)==members_of_cluster(j,1));
        data_of_member=training_data(index_of_member,:);
        members_same_movie=(data_of_member(:,2)==testing_data(i,2));
        members_same_movie=data_of_member(members_same_movie,:);
        if size(members_same_movie,1)~=0
            x=x+members_same_movie(1,25);
            xvf=xvf+1;
        end
    end
    sumv(i,1)=x;
    sizev(i,1)=xvf;
end

for i=1:size(sizev)
    if(sizev(i,1)~=0)
avg_rating(i,1)=sumv(i,1)/sizev(i,1);
    end
end

for i=1:size(sizev)
    if(sizev(i,1)~=0)
mae(i,1)=abs(avg_rating(i,1)-testing_data(i,25));
    end
end