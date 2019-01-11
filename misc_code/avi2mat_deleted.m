% avi to mat for delete .mat files  
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

% 
if num_fs==1
    avi_list=dir('*.avi');
    filename=avi_list(1).name;  
    v = VideoReader(filename);
    
    
fnm1=[filename(1:end-4),'.mat'];
    if exist(fnm1,'file')
        disp('file exists!');
    else
        disp('please wait while reading frames ...')
        % convert to frames
        k=0;
        while hasFrame(v)
            k=k+1;
            tmp=readFrame(v);
            I(:,:,k) =tmp(:,:,1);    
        end
       
        % save avi as .mat file into the folder
        save(fnm1,'I');
        disp([filename(1:end-4),' was saved!']);
        disp(['images size: ',num2str(size(I))])
    end

end

end
cd (gcd1)