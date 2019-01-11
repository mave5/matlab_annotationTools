% import .bmp files, convert to frames, save as .mat files 
clc
close all
clear all

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

num_bf=numel(bmp_list);


% read images and store into array
for k=1:num_bf
    filename=bmp_list(k).name;      
    disp('please wait while reading frames ...')
    tmp=imread(filename);
    I(:,:,k) =tmp(:,:,1);    
end

% save images as .mat file into the folder
if num_bf>0
    fnm1=[filename(1:end-4),'_still.mat'];
    save(fnm1,'I');
    disp([filename(1:end-4),' was saved!']);
    disp(['images size: ',num2str(size(I))])
    clear I;
end

end

cd (gcd1)