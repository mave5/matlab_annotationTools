% delete .mat files generate from bmp files 
clc
close all
clear

%%

% get current directory
gcd1=pwd;

% get the image folder
pathname=uigetdir('C:\Users\michael\Desktop\Interscalene_Dataset');


% get the number of sub-folders
sub_list=dir(pathname);

for sub_ind=3:numel(sub_list)
sub_ind
    
% sub folder name
sfnm=sub_list(sub_ind).name;

% cd to the images folder
cd([pathname,'\',sfnm]);
bmp_list=dir('*.bmp');

num_fs=numel(bmp_list);

% read images and store into array
for k=1:num_fs
    filename=bmp_list(k).name;      
    %disp('please wait while reading frames ...')
    tmp=imread([filename]);
    I(:,:,k) =tmp(:,:,1);    
end

% save images as .mat file into the folder
if num_fs>0
    fnm1=[filename(1:end-4),'.mat'];
    if exist(fnm1,'file') 
        delete(fnm1);
        disp([filename(1:end-4),' was deleted!']);
    end
end

end
cd (gcd1)