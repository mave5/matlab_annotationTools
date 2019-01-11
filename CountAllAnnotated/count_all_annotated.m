% count total number of annotated images for all subjects
clc
close all
clear
%%

% get current directory
gcd1=pwd;

% get the image folder
%pathname=uigetdir('C:\Users\michael\Desktop\Interscalene_Dataset');

% select path
[pathname]=uigetdir;


% get the number of sub-folders
sub_list=dir(pathname);
subj_ind=0;
for sub_ind=3:numel(sub_list)

    subj_ind=subj_ind+1;
    
    % sub folder name
    sfnm=sub_list(sub_ind).name;
    disp(sfnm)

    % function to count number of annotated pictures per subject
    ffnm=fullfile(pathname,sfnm);
    total_annotated(subj_ind)=func_cnt_ann(ffnm);

end

% total annotated images for all subjects
total_annotated;
sum(total_annotated)

% save results into excel file
sub_num=[1:numel(total_annotated)];
A=[sub_num',total_annotated'];
xlswrite('summary.xlsx',A);

