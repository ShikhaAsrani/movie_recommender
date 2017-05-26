fid=fopen('restaurant_ratings_n>=4.csv');
tline = fgetl(fid);
tline = fgetl(fid);
i=1;
user_id={};
while ischar(tline)
    if i==1105 || i==1790 || i==4708 || i==5228 || i==7911 || i==7937 || i==11183
        x=strfind(tline,',');
        user_id{i}=[tline(1:x(1)-1)];
        res_name{i}=[tline(x(2)+2:x(end)-2)];
        res_id(i)=str2num(tline(x(1)+1:x(2)-1));
        rating(i)=str2num(tline(x(end)+1:end));
        i=i+1;
        tline = fgetl(fid);
        continue;
        
    end
    %disp(tline)
    a=strfind(tline,'",');
    x=tline(2:a(1)-1);
     user_id{i}=[x];
     y=tline(a(2)+2:end);
     y=str2num(y);
     z=tline(a(1)+2:a(2)-1);
     a=strfind(z,',');
     num=str2num(z(1:a(1)-1));
     z=z(a(1)+2:end);
     res_id(i)=num;
     res_name{i}=z;
    rating(i)=y;
     i=i+1;
    
    tline = fgetl(fid);    
end
fclose(fid);


users={};
j=1;
for i=1:size(user_id,2)
    if ~any(strcmp(users,user_id(i)))
        users(j)=[user_id(i)]; 
        j=j+1;
    end
    user_i(i)=j;
end



x=unique(res_id);
sort(x);
for i=1:size(res_id,2)
    res_i(i)=find(x(:)==res_id(i));
end

inst=zeros(size(res_id,2));
user_res_matrix=zeros(size(users,2),size(x,2));
for i=1:size(rating,2)
       user_res_matrix(user_i(i),res_i(i))=rating(i);
       inst(res_i(i))=inst(res_i(i))+1;
end



sim=generateSimilarity(user_res_matrix);

testing_data=zeros(size(user_res_matrix));
for i=1:size(user_i)
    taken=0;
    for j=size(res_i)
        if user_res_matrix(i,j)~=0 && inst(j)>10
            testing_data(i,j)=user_res_matrix(i,j);
            user_res_matrix(i,j)=0;
            inst(j)=inst(j)-1;
            taken=taken+1;
            if taken==10
                break;
            end
        end
    end  
end
diffsqrsum=0;
total=0;
for i=1:size(testing_data,1)
    for j=1:size(testing_data,2)
        if testing_data(i,j)~=0
            r=predict(user_res_matrix,i,j,sim)
            testing_data(i,j)
            diff=abs(testing_data(i,j)+r);
            diffsqrsum=diffsqrsum+(diff*diff);
            total=total+1;
        end
    end
end

rmserror=double(diffsqrsum)/double(total)

