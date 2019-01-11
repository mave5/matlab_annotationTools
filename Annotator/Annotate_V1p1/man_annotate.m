function varargout = man_annotate(varargin)
% MAN_ANNOTATE MATLAB code for man_annotate.fig
%      MAN_ANNOTATE, by itself, creates a new MAN_ANNOTATE or raises the existing
%      singleton*.
%
%      H = MAN_ANNOTATE returns the handle to a new MAN_ANNOTATE or the handle to
%      the existing singleton*.
%
%      MAN_ANNOTATE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAN_ANNOTATE.M with the given input arguments.
%
%      MAN_ANNOTATE('Property','Value',...) creates a new MAN_ANNOTATE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before man_annotate_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to man_annotate_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help man_annotate

% Last Modified by GUIDE v2.5 27-Dec-2015 14:10:59
% author: Michael Avendi

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @man_annotate_OpeningFcn, ...
                   'gui_OutputFcn',  @man_annotate_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before man_annotate is made visible.
function man_annotate_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to man_annotate (see VARARGIN)

% Choose default command line output for man_annotate
handles.output = hObject;

% global variables
handles.Images=NaN;
handles.framenum=0;
handles.label1=NaN;
handles.label2=NaN;
handles.label3=NaN;
handles.label4=NaN;
handles.FileName='';
handles.PathName=['C:\Users\michael\Desktop\Interscalene_Dataset'];

% do not dispaly axis lines and backgrounds 
%axes(handles.axis_image);
%axis off

%axes(handles.axis_label);
%axis off

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes man_annotate wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = man_annotate_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    
    % get slider position
    pos=get(hObject,'Value');
    pos=max([1,ceil(pos)]); % return a 
    %disp(['value:',num2str(pos)]);

    % update frame number
    handles.framenum=pos;
    
    % update the image panel
    axes(handles.axis_image);
    I1=handles.Images(:,:,handles.framenum);
    imshow(I1);

    % update the labels panel
    axes(handles.axis_label);
    all_labels=handles.label1(:,:,handles.framenum)+handles.label2(:,:,handles.framenum)+...
        handles.label3(:,:,handles.framenum)+handles.label4(:,:,handles.framenum);
    imshow(all_labels);

    % set frame number on text box
    set(handles.text_fnm, 'String',[num2str(pos),'/',num2str(size(handles.Images,3))]);
    
    
    % Update handles structure
    guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in open.
function open_Callback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    try
        % open dialog box and get the axis_image directory
        [handles.FileName,handles.PathName] = uigetfile(handles.PathName);
        load([handles.PathName,handles.FileName]);
        handles.Images=I;
    catch 
       return 
    end
      
    % check if labels file exists
    labels_fpn=[handles.PathName,'labels_',handles.FileName];       
    if exist(labels_fpn,'file')
        load(labels_fpn);
        handles.label1=label1;
        handles.label2=label2;
        handles.label3=label3;
        handles.label4=label4;
        l_ind=check_annotated(label1+label2+label3+label4);
        handles.framenum=l_ind;
    else
       % if there is no labels, all labels set to zero 
       handles.label1=zeros(size(handles.Images));
       handles.label2=zeros(size(handles.Images));
       handles.label3=zeros(size(handles.Images));
       handles.label4=zeros(size(handles.Images));
       handles.framenum=1;
    end
 
    % display image 
    axes(handles.axis_image);
    I1=handles.Images(:,:,handles.framenum);
    imshow(I1);
    
    % display labels
    axes(handles.axis_label);
    all_labels=handles.label1(:,:,handles.framenum)+handles.label2(:,:,handles.framenum)+...
        handles.label3(:,:,handles.framenum)+handles.label4(:,:,handles.framenum);
    imshow(all_labels);
    
    % set max of slider
    set(handles.slider1,'max',size(handles.Images,3));
    % set slider value
    set(handles.slider1,'Value',handles.framenum);

    % update static text box
    set(handles.text_fnm, 'String',[num2str(handles.framenum),'/',num2str(size(handles.Images,3))]);
         
    
    % Update handles structure
    guidata(hObject, handles);

    
    
    function text_fnm_CreateFcn(hObject, eventdata, handles)
    % update static text box   
    set(hObject, 'String',[num2str(0),'/',num2str(0)]);


% --- Executes on button press in annotate1.
function annotate1_Callback(hObject, eventdata, handles)
% hObject    handle to annotate1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% input annotation
axes(handles.axis_image); % set cuurent axis to the image panel
imshow(handles.Images(:,:,handles.framenum)); 
h = imfreehand(handles.axis_image,'closed',false);  

% create a binary mask
h_bw = createMask(h);

% store mask into label 1
handles.label1(:,:,handles.framenum)=h_bw;

% display annotations
axes(handles.axis_label);
all_labels=handles.label1(:,:,handles.framenum)+handles.label2(:,:,handles.framenum)+...
    handles.label3(:,:,handles.framenum)+handles.label4(:,:,handles.framenum);
imshow(all_labels);


% Update handles structure
guidata(hObject, handles);




% --- Executes on button press in annotate2.
function annotate2_Callback(hObject, eventdata, handles)
% hObject    handle to annotate2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% input annotation
axes(handles.axis_image);
imshow(handles.Images(:,:,handles.framenum));
h = imfreehand(handles.axis_image,'closed',false);  

% create a binary mask
h_bw = createMask(h);

% store annotation
handles.label2(:,:,handles.framenum)=h_bw;

% display annotations
axes(handles.axis_label);
all_labels=handles.label1(:,:,handles.framenum)+handles.label2(:,:,handles.framenum)+...
    handles.label3(:,:,handles.framenum)+handles.label4(:,:,handles.framenum);
imshow(all_labels);


% Update handles structure
guidata(hObject, handles);




% --- Executes on button press in Annotate3.
function Annotate3_Callback(hObject, eventdata, handles)
% hObject    handle to Annotate3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% input annotation
axes(handles.axis_image);
imshow(handles.Images(:,:,handles.framenum));
h = imfreehand(handles.axis_image,'closed',false);  

% create a binary mask
h_bw = createMask(h);

% store annotation
handles.label3(:,:,handles.framenum)=h_bw;

% display annotations
axes(handles.axis_label);
all_labels=handles.label1(:,:,handles.framenum)+handles.label2(:,:,handles.framenum)+...
    handles.label3(:,:,handles.framenum)+handles.label4(:,:,handles.framenum);
imshow(all_labels);

% Update handles structure
guidata(hObject, handles);




% --- Executes on button press in annotate4.
function annotate4_Callback(hObject, eventdata, handles)
% hObject    handle to annotate4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% input annotation
axes(handles.axis_image);
imshow(handles.Images(:,:,handles.framenum));
h = imfreehand(handles.axis_image,'closed',false);  

% create a binary mask
h_bw = createMask(h);

% store annotation
handles.label4(:,:,handles.framenum)=h_bw;

% display annotations
axes(handles.axis_label);
all_labels=handles.label1(:,:,handles.framenum)+handles.label2(:,:,handles.framenum)+...
    handles.label3(:,:,handles.framenum)+handles.label4(:,:,handles.framenum);
imshow(all_labels);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% disable open file
set(handles.open,'Enable','off');

% store labels into local variables
label1=handles.label1;
label2=handles.label2;
label3=handles.label3;
label4=handles.label4;

% save labels into a .mat file: labels_filename
labels_fpn=[handles.PathName,'labels_',handles.FileName(1:end-4),'.mat'];
save(labels_fpn,'label1','label2','label3','label4');
msgbox('Operation Completed','Success');

% enable open file
set(handles.open,'Enable','on');


% --- Executes on button press in Next.
function Next_Callback(hObject, eventdata, handles)
% hObject    handle to Next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % update frame number
    step=1;
    if handles.framenum<size(handles.Images,3)
        handles.framenum=handles.framenum+step;
    end
    
    % update the image panel
    axes(handles.axis_image);
    I1=handles.Images(:,:,handles.framenum);
    imshow(I1);

    % update the labels panel
    axes(handles.axis_label);
    all_labels=handles.label1(:,:,handles.framenum)+handles.label2(:,:,handles.framenum)+...
        handles.label3(:,:,handles.framenum)+handles.label4(:,:,handles.framenum);
    imshow(all_labels);

    % set frame number on text box
    set(handles.text_fnm, 'String',[num2str(handles.framenum),'/',num2str(size(handles.Images,3))]);
    
    set(handles.slider1,'Value',handles.framenum);
    
    % Update handles structure
    guidata(hObject, handles);


% --- Executes on button press in previous.
function previous_Callback(hObject, eventdata, handles)
% hObject    handle to previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % update frame number
    step=-1;
    if handles.framenum>1
        handles.framenum=handles.framenum+step;
    end
    
    % update the image panel
    axes(handles.axis_image);
    I1=handles.Images(:,:,handles.framenum);
    imshow(I1);

    % update the labels panel
    axes(handles.axis_label);
    all_labels=handles.label1(:,:,handles.framenum)+handles.label2(:,:,handles.framenum)+...
        handles.label3(:,:,handles.framenum)+handles.label4(:,:,handles.framenum);
    imshow(all_labels);

    % set frame number on text box
    set(handles.text_fnm, 'String',[num2str(handles.framenum),'/',num2str(size(handles.Images,3))]);
    
    set(handles.slider1,'Value',handles.framenum);
    
    % Update handles structure
    guidata(hObject, handles);
    
  
% --  check annotated images
% check which images are annotated
    function [l_ind]=check_annotated(label)
        
        for k=1:size(label,3)
            if ~isempty(find(label(:,:,k), 1))
                l_ind=k;
                return
            end
        end
    
    
