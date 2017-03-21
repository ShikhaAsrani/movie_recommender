clc
clear all
close all

training_data =load('training_data.txt');
testing_data=load('testing_data.txt');

user_movie_mx=zeros(943,1682);
for i=1:size(training_data,1)
    user_movie_mx(training_data(i,1),training_data(i,2))=training_data(i,25);
end

MovieData=load('movie.txt');
[idx,C]=kmeans(MovieData,60);
errorsum=0;

UserRatingToEachCluster=zeros(943,60);
for i=1:60
    MembersOfCluster=idx(idx(:,1)==i);
    for k=1:943
        sizev=0;
        for j=1:size(MembersOfCluster,1)
            if user_movie_mx(k,j)~=0
                UserRatingToEachCluster(k,i)=UserRatingToEachCluster(k,i)+user_movie_mx(k,j);
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

%%user_personal_info=load('user.txt');
data_for_training_users=UserRatingToEachCluster;
[index,Classes]=kmeans(data_for_training_users,30);

count=0;
for i=1:943
    for j=1:1682
        if user_movie_mx(i,j)==0
            sum=0;
            sizev=0;
            user=i;
            movie=j;
            ClusterToBeSearched=index(user,1);
            MembersOfCluster=(index(:,1)==ClusterToBeSearched);
            MembersOfCluster=find(MembersOfCluster);
            for k=1:size(MembersOfCluster,1)
                if user_movie_mx(MembersOfCluster(k,1),movie)~=0
                    sum=sum+user_movie_mx(MembersOfCluster(k,1),movie);
                    sizev=sizev+1;
                end
            end
            if sizev~=0
                average=sum/sizev;
                user_movie_mx(i,j)=average;
                if average~=0
                    errorsum=errorsum+1;
                end
            else
                count=count+1;
            end
            
        end
    end
end

