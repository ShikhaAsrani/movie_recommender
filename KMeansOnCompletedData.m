
clear all;
CompleteTestingData=load('CompletedTestingData.txt');
CompleteTrainingData=load('CompletedTrainingData.txt');

%%classifying movies
MovieData=load('movie.txt');
[idx,C]=kmeans(MovieData,64);
errorsum=0;

%%knowing users choice of movies
UserRatingToEachCluster=zeros(943,64);
for i=1:64
    MembersOfCluster=idx(idx(:,1)==i);
    for k=1:943
        sizev=0;
        for j=1:size(MembersOfCluster,1)
            if CompleteTrainingData(k,j)~=0
                UserRatingToEachCluster(k,i)=UserRatingToEachCluster(k,i)+CompleteTrainingData(k,j);
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
%%//can be used to take personal info
%%of users into account

%%classify users based on their choice of movies
UsersChoice=UserRatingToEachCluster;
[index,Classes]=kmeans(UsersChoice,64);


for i=1:943
    for j=1:1682
        if CompleteTestingData(i,j)~=0
            user=i;
            movie=j;
            ClusterToBeSearched=index(user,1);
            MembersOfCluster=(index(:,1)==ClusterToBeSearched);
            MembersOfCluster=find(MembersOfCluster);
            sum=0;
            for k=1:size(MembersOfCluster,1)
                if CompleteTrainingData(MembersOfCluster(k,1),movie)~=0
                    sum=sum+CompleteTrainingData(MembersOfCluster(k,1),movie);
                    sizev=sizev+1;
                end
            end
            if sizev~=0
                average=sum/sizev;
                error=abs(average-CompleteTestingData(i,j));
                errorsum=errorsum+error;
            end
        end
    end
end
