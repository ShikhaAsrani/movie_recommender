function [idx,C] = NDistanceGenFunc(data,K)
KMI   = 40;
CENTS =data(ceil(rand(K,1)*size(data,1)),:);
DAL   = zeros(size(data,1),K+2);

for n = 1:KMI    
   for i = 1:size(data,1)
      for j = 1:K  
        DAL(i,j) =NTypeDistance(data(i,:),CENTS(j,:));      
      end
      [Distance CN] = min(DAL(i,1:K));                % 1:K are Distance from Cluster Centers 1:K 
      DAL(i,K+1) = CN;                                % K+1 is Cluster Label
      DAL(i,K+2) = Distance;                          % K+2 is Minimum Distance
   end
   for i = 1:K
      A = (DAL(:,K+1) == i);                          % Cluster K Points
      CENTS(i,:) = mean(data(A,:));                      % New Cluster Centers
      if sum(isnan(CENTS(:))) ~= 0                    % If CENTS(i,:) Is Nan Then Replace It With Random Point
         NC = find(isnan(CENTS(:,1)) == 1);           % Find Nan Centers
         for Ind = 1:size(NC,1)
         CENTS(NC(Ind),:) = data(randi(size(data,1)),:);
         end
      end
   end
   
end
idx=DAL(:,K+1);
C=CENTS;
end