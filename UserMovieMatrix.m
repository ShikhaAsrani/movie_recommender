clc
clear all
close all

training_data =load('training_data.txt');
testing_data=load('testing_data.txt');

user_movie_mx=zeros(943,1682);
for i=1:size(training_data,1)
   user_movie_mx(training_data(i,1),training_data(i,2))=training_data(i,25);
end

%%classify movie wise
% data_for_training=load('movie.txt');
% [idx,C]=kmeans(data_for_training,64);
% errorsum=0;
% 
% for i=1:20000
%     sum=0;
%     sizev=0;
%     user=testing_data(i,1);
%     movie=testing_data(i,2);
%     ClusterToBeSearched=idx(movie,1);
%     MembersOfCluster=(idx(:,1)==ClusterToBeSearched);
%     MembersOfCluster=find(MembersOfCluster);
%     for j=1:size(MembersOfCluster)
%         if user_movie_mx(user,MembersOfCluster(j,1))~=0
%         sum=sum+user_movie_mx(user,MembersOfCluster(j,1));
%         sizev=sizev+1;
%         end
%     end
%     if sizev~=0
%     average=sum/sizev;
%     error=abs(average-testing_data(i,25));
%     errorsum=errorsum+error;
%     end
%     
% end

%%classify user wise
% data_for_training=load('user.txt');
% [idx,C]=kmeans(data_for_training,64);
% errorsum=0;
% 
% for i=1:20000
%     sum=0;
%     sizev=0;
%     user=testing_data(i,1);
%     movie=testing_data(i,2);
%     ClusterToBeSearched=idx(user,1);
%     MembersOfCluster=(idx(:,1)==ClusterToBeSearched);
%     MembersOfCluster=find(MembersOfCluster);
%     for j=1:size(MembersOfCluster)
%         if user_movie_mx(MembersOfCluster(j,1),movie)~=0
%         sum=sum+user_movie_mx(MembersOfCluster(j,1),movie);
%         sizev=sizev+1;
%         end
%     end
%     if sizev~=0
%     average=sum/sizev;
%     error=abs(average-testing_data(i,25));
%     errorsum=errorsum+error;
%     end
%     
% end

%%classify user according to movie choice

data_for_training=load('movie.txt');
[idx,C]=kmeans(data_for_training,64);
errorsum=0;

UserRatingToEachCluster=zeros(943,64);
for i=1:64
    
 MembersOfCluster=idx(:,1)==i;
  MembersOfCluster=find(MembersOfCluster);
  for k=1:943
      sizev=0;
  for j=1:size(MembersOfCluster,1)
      if user_movie_mx(k,MembersOfCluster(j))~=0
      UserRatingToEachCluster(k,i)=UserRatingToEachCluster(k,i)+user_movie_mx(k,MembersOfCluster(j));
      sizev=sizev+1;
      end
  end 
  if sizev~=0
  UserRatingToEachCluster(k,i)=UserRatingToEachCluster(k,i)/sizev;
  else
  UserRatingToEachCluster(k,i)=0;   
  end
  end 
end

user_personal_info=load('user.txt');
data_for_training_users=UserRatingToEachCluster;
[index,Classes]=kmeans(data_for_training_users,64);

for i=1:20000
    sum=0;
    sizev=0;
    user=testing_data(i,1);
    movie=testing_data(i,2);
    ClusterToBeSearched=index(user,1);
    MembersOfCluster=(index(:,1)==ClusterToBeSearched);
    MembersOfCluster=find(MembersOfCluster);
    for j=1:size(MembersOfCluster,1)
        if user_movie_mx(MembersOfCluster(j,1),movie)~=0
        sum=sum+user_movie_mx(MembersOfCluster(j,1),movie);
        sizev=sizev+1;
        end
    end
    if sizev~=0
    average=sum/sizev;
    error=abs(average-testing_data(i,25));
    error=error*error;
    errorsum=errorsum+error;
    end
end
 
errorsum/20000