
clc
clear all
close all

training_data =load('training_data.txt');
testing_data=load('testing_data.txt');

user_movie_mx=zeros(943,1682);
for i=1:size(training_data,1)
   user_movie_mx(training_data(i,1),training_data(i,2))=training_data(i,25);
end

for i=1:size(testing_data,1)
   user_movie_mx(testing_data(i,1),testing_data(i,2))=testing_data(i,25);
end

PerMovieSum=sum(user_movie_mx,1);
for i=1:1682
    countuser=find(user_movie_mx(:,i));
    PerMovieSum(i)=PerMovieSum(i)/size(countuser,1);
    for j=1:943
        if user_movie_mx(j,i)==0
            user_movie_mx(j,i)=PerMovieSum(i);
        end
    end
end

dlmwrite('completedata.txt',user_movie_mx);

actual_testing_data=zeros(943,1682);
i=0;
while i<317230
xy(1,1)=randi(943,1,1);
xy(1,2)=randi(1682,1,1);
if user_movie_mx(xy(1,1),xy(1,2))~=0
    actual_testing_data(xy(1,1),xy(1,2))=user_movie_mx(xy(1,1),xy(1,2));
    user_movie_mx(xy(1,1),xy(1,2))=0;
    i=i+1;
end
end
actual_training_data=user_movie_mx;


dlmwrite('CompletedTrainingData.txt',actual_training_data);
dlmwrite('CompletedTestingData.txt',actual_testing_data);
% fileID = fopen('completedata.txt','w');
% fprintf(fileID,fmt);
% fclose(fileID);