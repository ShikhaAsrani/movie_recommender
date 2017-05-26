clc
clear all
close all

training_data =load('training_data.txt');
testing_data=load('testing_data.txt');

user_movie_mx=zeros(943,1682);
for i=1:size(training_data,1)
   user_movie_mx(training_data(i,1),training_data(i,2))=training_data(i,25);
end

for i=1:1682
    AverageRating=0;
    count=0;
    for j=1:943
        AverageRating=user_movie_mx(j,i)+AverageRating;
        count=count+1;
    end
    AverageRatings(i)=AverageRating/count;
    for j=1:943
        if user_movie_mx(j,i)~=0
        user_movie_mx(j,i)=user_movie_mx(j,i)-AverageRatings(i);
        end
    end
end

data_for_training=load('movie.txt');
[centers,U] = fcm(data_for_training,64);
errorsum=0;


errorsum=0;

for i=1:64
    MembersOfCluster=U(i,:);
    for k=1:943
        fractionintoratingforclusteri=user_movie_mx(k,:).*MembersOfCluster;
        UserTotalToEachCluster(k,i)=sum(fractionintoratingforclusteri);
        TotalOfRatios=sum(MembersOfCluster);
        
        if TotalOfRatios~=0
            UserRatingToEachCluster(k,i)=double(UserTotalToEachCluster(k,i))/double(TotalOfRatios);
        else
            UserRatingToEachCluster(k,i)=0;
        end
    end
end

user_personal_info=load('user.txt');
data_for_training_users=UserRatingToEachCluster;
[centersu,Uu] = fcm(data_for_training_users,50);

ClusterTotalForMovie=zeros(50,1682);
countc=zeros(50,1682);
for i=1:50
   clusterUnderConsideration=Uu(i,:);
   for j=1:943
       if clusterUnderConsideration(1,j)~=0
          ClusterTotalForMovie(i,:)=ClusterTotalForMovie(i,:)+user_movie_mx(j,:)*clusterUnderConsideration(j);
          countc(i,:)=countc(i,:)+(clusterUnderConsideration(j)*(user_movie_mx(j,:)~=0));    
       end
   end
end

ClusterRatingForMovie=double(ClusterTotalForMovie)./double(countc);
for i=1:50
    for j=1:1682
        if (countc(i,j)==0)
            ClusterRatingForMovie(i,j)=0;
        end
    end
end

for i=1:20000
    sum=0;
    sizev=0;
    user=testing_data(i,1);
    movie=testing_data(i,2);
    
    ClusterToBeSearched=Uu(:,user);
    for j=1:50
        if ClusterToBeSearched(j)~=0
         sum=sum+ClusterRatingForMovie(j,movie)*ClusterToBeSearched(j);
         sizev=sizev+ClusterToBeSearched(j);
        end
    end
    
    if sizev~=0
    average=sum/sizev;
    average=average+AverageRatings(movie);
    error=abs(average-testing_data(i,25));
    error=error*error;
    errorsum=errorsum+error;
    end
end

 errorsum/20000