clc
clear all
close all

training_data =load('training_data.txt');
testing_data=load('testing_data.txt');

user_movie_mx=zeros(943,1682);
for i=1:size(training_data,1)
    user_movie_mx(training_data(i,1),training_data(i,2))=training_data(i,25);
end

% for i=1:1682
%     AverageRating=0;
%     count=0;
%     for j=1:943
%         AverageRating=user_movie_mx(j,i)+AverageRating;
%         count=count+1;
%     end
%     AverageRatings(i)=AverageRating/count;
%     for j=1:943
%         if user_movie_mx(j,i)~=0
%         user_movie_mx(j,i)=user_movie_mx(j,i)-AverageRatings(i);
%         end
%     end
% end
data_for_training=load('movie.txt');
[idx,C]=NDistanceGenFunc(data_for_training,64);

%
% for i=1:1682
%     AverageRating=0;
%     count=0;
%     for j=1:943
%         AverageRating=user_movie_mx(j,i)+AverageRating;
%         count=count+1;
%     end
%     AverageRatings(i)=AverageRating/count;
%     for j=1:943
%         if user_movie_mx(j,i)~=0
%         user_movie_mx(j,i)=user_movie_mx(j,i)-AverageRatings(i);
%         end
%     end
% end


errorsum=0;
sizev=zeros(943,64);
%%UserRatingToEachCluster=zeros(943,64);
for i=1:64
    MembersOfCluster=idx(idx(:,1)==i);
    for k=1:943
        UserTotalToEachCluster(k,i)=0;
        for j=1:size(MembersOfCluster,1)
            if user_movie_mx(k,MembersOfCluster(j))~=0
                UserTotalToEachCluster(k,i)=UserTotalToEachCluster(k,i)+user_movie_mx(k,MembersOfCluster(j));
                sizev(k,i)=sizev(k,i)+1;
            end
        end
        if sizev(k,i)~=0
            UserRatingToEachCluster(k,i)=double(UserTotalToEachCluster(k,i))/double(sizev(k,i));
        else
            UserRatingToEachCluster(k,i)=0;
        end
    end
end

%%calculating pcr between two users.
UserTotalRating=zeros(943);
for i=1:943
    count=0;
    for j=1:64
        if UserRatingToEachCluster(i,j)~=0
            UserTotalRating(i)=UserTotalRating(i)+UserRatingToEachCluster(i,j);
            count=count+1;
        end
    end
    if count~=0
        UserAverageRating(i)=UserTotalRating(i)/count;
    else
        UserAverageRating=0;
    end
    
end;


for i=1:943
    StdDevForEachUser(i)=0.0;
    for j=1:64
        StdDevForEachUser(i)=StdDevForEachUser(i)+(UserRatingToEachCluster(i,j)-UserAverageRating(i))^2;
    end
    StdDevForEachUser(i)=sqrt(StdDevForEachUser(i));
end

for i=1:943
    for j=1:943
        num=0;
        for k=1:64
            for l=1:64
                num=num+((UserRatingToEachCluster(i,k)-UserAverageRating(i))*(UserRatingToEachCluster(j,l)-UserAverageRating(j)));
            end
        end
        Denominator=StdDevForEachUser(i)*StdDevForEachUser(j);
        if Denominator~=0
            UserPCR(i,j)=num/Denominator;
        end
    end
end

for i=1:20000
    user=testing_data(i,1);
    movie=testing_data(i,2);
    SimilarUsers=UserPCR(user,:);
    [Y,I]=sort(SimilarUsers,'descend');
    sum=0;
    sumcount=0;
    j=1;
    l=1;
    while l<=30
        sum=sum+user_movie_mx(I(j),movie);
        if user_movie_mx(I(j),movie)~=0
            sumcount=sumcount+1;
            l=l+1;
        end
        
        j=j+1;
        if j==943
            break;
        end
    end
    if sumcount~=0
        GuessRating=sum/sumcount;
    else
        GuessRating=UserAverageRating(user);
    end
%   GuessRating=GuessRating+AverageRatings(movie);
    ActualRating=testing_data(i,25);
    error=abs(GuessRating-ActualRating);
    error=error*error;
    errorsum=errorsum+error;
end

errorsum/20000
sqrt(errrorsum)
