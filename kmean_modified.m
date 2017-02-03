clc
clear all
close all


training_data =load('training_data.txt');
testing_data=load('testing_data.txt');

data_for_training=training_data(:,3:end);
data_for_testing=testing_data(:,3:(end-1));
mae=zeros(20000,1);
index=zeros(943,1);
K=64;

[idx,C]=kmeans(data_for_training,K);
for i=1:943
    index_of_i=(testing_data(:,1)==1);
    clusters_of_i=idx(index_of_i);
    M=mode(clusters_of_i,1);
    index(i,1)=M;
end