clc
clear all
close all


xc=0;
yc=0;

%%to detect number of generes
fid = fopen('ugenre.txt','r');
type=textscan(fid,'%s %d\n','Delimiter','|');;
types=size(type{1},1)
fclose(fid);

%%to get the matrix regarding genres of movie,can be optimized,will do
%%later
sbs=zeros(1682,types);
fid = fopen('umovie.txt','r');
while 1
    xc=xc+1;
    yc=0;
            tline = fgetl(fid);
            if ~ischar(tline), break, end
            s=length(tline)
            pos=strfind(tline,'|')
            x=size(pos,2)
            y=x-types+1
            for i=y:x
                i
                yc=yc+1;
                if i~=x
                sbs(xc,yc)=tline(pos(1,i)+1:pos(1,i+1)-1)-48;
                else
                 sbs(xc,yc)=tline(pos(1,i)+1:s)-48;   
                end
                
            end
            
            size(sbs,1)

end
fclose(fid);

%%to get types of occupation
fid = fopen('uoccupation.txt','r');
typeofoccupation=textscan(fid,'%s\n');
a=char(typeofoccupation{1});
size(a)
fclose(fid);

%%to get user info eliminated uid and zip code
fid = fopen('uuser.txt','r');
c=textscan(fid,'%d %d %c %s %s\n','Delimiter','|');
uage=c{2};
ugender=c{3};
uoccup=c{4};
size(uage)
size(ugender)
size(uoccup)

lala=char(ugender);
lala1=char(uoccup);

uinfo=zeros(size(uage,1),3);
uinfo(:,1)=uage;
for i=1:size(uage,1)
    
    if lala(i,1)=='F'
        uinfo(i,2)=1;
    end
    
    for j=1:size(a,1)
        if strcmp(a(j,1),lala1(i,1))
            uinfo(i,3)=j;
            break;
        end
    end
    
end
 fclose(fid);
 dlmwrite('datamov.txt',sbs,'delimiter','\t')
 
%  fid=fopen('datamov.txt','a+');
% dlmwrite(fid,'%d ',sbs);
% fclose(fid);
 dlmwrite('datauser.txt',uinfo,'delimiter','\t')


%% user ka sara info includes age gender occupation /zip code/
%% movie ka sara info includes its type