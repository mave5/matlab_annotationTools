clc
close all
clear all
addpath ..\functions
%%
l1_ind=[];
l2_ind=[];
l3_ind=[];
l4_ind=[];

% load images and labels
[filename,pathname]=uigetfile('*.mat');
load([pathname,filename]);
load([pathname,'labels_',filename]);


% check which images are annotated
for k=1:size(label1,3)
 if ~isempty(find(label1(:,:,k), 1))
     l1_ind=[l1_ind,k];
     disp(['label1 ',num2str(k),' is annotated.'])
 end
 
 if ~isempty(find(label2(:,:,k), 1))
     l2_ind=[l2_ind,k];
     disp(['label2 ',num2str(k),' is annotated.'])
 end
 
 if ~isempty(find(label3(:,:,k), 1))
     l3_ind=[l3_ind,k];
     disp(['label3 ',num2str(k),' is annotated.'])
 end
 
  if ~isempty(find(label4(:,:,k), 1))
     l4_ind=[l4_ind,k];
     disp(['label4 ',num2str(k),' is annotated.'])
 end

end

% show annotated images
labels=label1(:,:,l1_ind)+label2(:,:,l1_ind)+label3(:,:,l1_ind)+label4(:,:,l1_ind);
I1=I(:,:,l1_ind);
showCurveAndI(I1,labels)

