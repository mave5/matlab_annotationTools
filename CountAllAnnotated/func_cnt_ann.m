
function total_annotated=func_cnt_ann(pathname)

% get current working directory
gcd1=pwd;

% enter to pathname
cd(pathname);
list=dir('*.mat');

total_annotated=0;
for k1=1:numel(list)
    fnm=list(k1).name;
    if strcmp(fnm(1:6),'labels')
        disp(['loading ',fnm])
        load(fullfile(pathname,fnm));
        load(fullfile(pathname,fnm(8:end)));

        % add all labels together
        labels=label1+label2+label3+label4;

        % check which images are annotated
        ls_ind=[];
        for k2=1:size(labels,3)
            if ~isempty(find(labels(:,:,k2), 1))
                ls_ind=[ls_ind,k2];    
            end 
        end
        disp(['Annotated: ',num2str(ls_ind)])
        %disp(['number annotated:',num2str(numel(ls_ind))])
        total_annotated=numel(ls_ind)+total_annotated;
    end
    
end

disp(['total annotated for this subject:',num2str(total_annotated)])

cd(gcd1)
        
end