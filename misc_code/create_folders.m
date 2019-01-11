clc
clear all
close all
%%

% select path
pathname=uigetdir;

% set the start and end of the folder numbers
for k=21:87
    % convert number to string
    nums=num2str(k);
    
    % stuff zeros at the beginning
    if k<10
    numz='000';
    elseif k<100
        numz='00';
    elseif k<1000
        numz='0';
    end
    dirnm=['Subject_',numz,nums];
    mkdir (pathname,dirnm)
end