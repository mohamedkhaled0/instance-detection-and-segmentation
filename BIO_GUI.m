% Developers:    Groub(1)

             %   Mahmoud GHonem
             %   Youssef saad 
             %   Mohamed Khaled
             %   Hend Elshal
             %   Zahraa Elsay
             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = BIO_GUI(varargin)
% BIO_GUI MATLAB code for BIO_GUI.fig
%      BIO_GUI, by itself, creates a new BIO_GUI or raises the existing
%      singleton*.
%
%      H = BIO_GUI returns the handle to a new BIO_GUI or the handle to
%      the existing singleton*.
%
%      BIO_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BIO_GUI.M with the given input arguments.
%
%      BIO_GUI('Property','Value',...) creates a new BIO_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BIO_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BIO_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BIO_GUI

% Last Modified by GUIDE v2.5 14-Dec-2018 21:20:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BIO_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @BIO_GUI_OutputFcn, ...
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


% --- Executes just before BIO_GUI is made visible.
function BIO_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BIO_GUI (see VARARGIN)
set(handles.axes2,'visible','off')
set(handles.axes3,'visible','off')
set(handles.axes4,'visible','off')
set(handles.p2,'visible','off')
set(handles.p3,'visible','off')
set(handles.p4,'visible','off')
set(handles.p5,'visible','off')
set(handles.iteretive,'visible','off')
set(handles.supervised,'visible','off')
set(handles.EM,'visible','off')
set(handles.start,'visible','on')
set(handles.DICE,'visible','off')
set(handles.MU_Lung,'visible','off')
set(handles.MU_Chest,'visible','off')
set(handles.Var_Lung,'visible','off')
set(handles.Var_Chest,'visible','off')
set(handles.diceedit,'visible','off')
set(handles.varlung,'visible','off')
set(handles.muchest,'visible','off')
set(handles.varchest,'visible','off')
set(handles.mulung,'visible','off')
set(handles.message,'visible','off')
set(handles.load_img,'visible','off')
set(handles.compare_gt,'visible','off')
set(handles.kfold,'visible','off')

x=imread('back.jpg');
imshow(x,'parent',handles.axes1);

% Choose default command line output for BIO_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BIO_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BIO_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in iteretive.
function iteretive_Callback(hObject, eventdata, handles)
% hObject    handle to iteretive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes2,'reset')
cla(handles.axes3,'reset')
cla(handles.axes4,'reset')

set(handles.MU_Lung,'visible','off')
set(handles.MU_Chest,'visible','off')
set(handles.Var_Lung,'visible','off')
set(handles.Var_Chest,'visible','off')
set(handles.diceedit,'visible','off')
set(handles.varlung,'visible','off')
set(handles.muchest,'visible','off')
set(handles.varchest,'visible','off')
set(handles.mulung,'visible','off')
set(handles.DICE,'visible','off')
set(handles.diceedit,'visible','off')
set(handles.message,'visible','on')


global result ;
global i ;

% using sup_classifier function with enhancement.
[result,p_lung,p_chest]=sup_classifier(i);
%oRIGINAL M4
axes(handles.axes2);
imshow(i,[])
%disp result
axes(handles.axes3);
imshow(result,[])

%plotting
axes(handles.axes4);
q = 0:1:255; % Gray Level
plot(q,p_lung,'r')
hold on
plot(q,p_chest,'b')

g4=imread('Ground_Truth_CT_004.bmp');

%calculate Dice
d1=dsc(g4,result);
text11 = sprintf('The model is trained using images M1,M2,M3 ');
set(handles.message,'String',text11);

% --- Executes on button press in supervised.
function supervised_Callback(hObject, eventdata, handles)
% hObject    handle to supervised (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.MU_Lung,'visible','off')
set(handles.MU_Chest,'visible','off')
set(handles.Var_Lung,'visible','off')
set(handles.Var_Chest,'visible','off')
set(handles.diceedit,'visible','off')
set(handles.varlung,'visible','off')
set(handles.muchest,'visible','off')
set(handles.varchest,'visible','off')
set(handles.mulung,'visible','off')
set(handles.DICE,'visible','off')
set(handles.diceedit,'visible','off')
set(handles.message,'visible','off')


%--
global i ;
global result ;
% using itrative segmentation function with enhancement.
result=MySegment(i);
axes(handles.axes3);
imshow(result,[])

%image histogram
axes(handles.axes4);
imhist(i) ;
title('Image Histogram')

% --- Executes on button press in EM.
function EM_Callback(hObject, eventdata, handles)
% hObject    handle to EM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.message,'visible','off')
set(handles.DICE,'visible','off')
set(handles.diceedit,'visible','off')
set(handles.MU_Lung,'visible','on')
set(handles.MU_Chest,'visible','on')
set(handles.Var_Lung,'visible','on')
set(handles.Var_Chest,'visible','on')
set(handles.diceedit,'visible','off')
set(handles.varlung,'visible','on')
set(handles.muchest,'visible','on')
set(handles.varchest,'visible','on')
set(handles.mulung,'visible','on')

%-------
cla(handles.axes3,'reset')
cla(handles.axes4,'reset')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global i ;
global result;
[result,mu_chest_old,mu_lung_old,var_chest,var_lung,p_lung,p_chest] = EM_algorithm(i) ;

axes(handles.axes2);
imshow(i,[])

%disp result
axes(handles.axes3);
imshow(result,[])

%plotting
axes(handles.axes4);
q = 0:1:255; % Gray Level
plot(q,p_lung,'r')
hold on
plot(q,p_chest,'b')

%Text
text_mulung=sprintf('%0.3f ',mu_lung_old);
set(handles.mulung,'String',text_mulung);

text_varlung=sprintf('%0.3f ',var_lung);
set(handles.varlung,'String',text_varlung);

text_muchest=sprintf('%0.3f',mu_chest_old);
set(handles.muchest,'String',text_muchest);

text_varchest=sprintf('%0.3f ',var_chest);
set(handles.varchest,'String',text_varchest);

% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.axes1,'reset')
set(handles.axes1,'visible','off')
set(handles.p2,'visible','on')
set(handles.p3,'visible','on')
set(handles.p4,'visible','on')
set(handles.p5,'visible','on')
set(handles.iteretive,'visible','on')
set(handles.supervised,'visible','on')
set(handles.EM,'visible','on')
set(handles.start,'visible','off')
set(handles.load_img,'visible','on')
set(handles.compare_gt,'visible','on')
set(handles.kfold,'visible','on')

% --- Executes on button press in load_img.
function load_img_Callback(hObject, eventdata, handles)
% hObject    handle to load_img (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.MU_Lung,'visible','off')
set(handles.MU_Chest,'visible','off')
set(handles.Var_Lung,'visible','off')
set(handles.Var_Chest,'visible','off')
set(handles.diceedit,'visible','off')
set(handles.varlung,'visible','off')
set(handles.muchest,'visible','off')
set(handles.varchest,'visible','off')
set(handles.mulung,'visible','off')
set(handles.DICE,'visible','off')
set(handles.diceedit,'visible','off')
set(handles.message,'visible','off')
set(handles.axes3,'visible','off')
set(handles.axes4,'visible','off')



%---
cla(handles.axes2,'reset')
cla(handles.axes3,'reset')
cla(handles.axes4,'reset')
%---
tex=sprintf(' ');
set(handles.diceedit,'String',tex);
set(handles.message,'String',tex);



%read image
global i ;
path =imgetfile();
i=imread(path);
i=i(:,:,1);

%show image
axes(handles.axes2);
imshow(i,[])

%image histogram
axes(handles.axes4);
imhist(i) ;
title('Image Histogram')


% --- Executes on button press in compare_gt.
function compare_gt_Callback(hObject, eventdata, handles)
% hObject    handle to compare_gt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.MU_Lung,'visible','off')
set(handles.MU_Chest,'visible','off')
set(handles.Var_Lung,'visible','off')
set(handles.Var_Chest,'visible','off')
set(handles.diceedit,'visible','off')
set(handles.varlung,'visible','off')
set(handles.muchest,'visible','off')
set(handles.varchest,'visible','off')
set(handles.mulung,'visible','off')
set(handles.DICE,'visible','on')
set(handles.diceedit,'visible','on')
set(handles.message,'visible','on')


global result ;

%read Ground Truth image
path =imgetfile();
x=imread(path);
x=x(:,:,1);

%calculate Dice

d=dsc(x,result);
tex=sprintf('%0.3f %%',d*100);
set(handles.diceedit,'String',tex);

text11 = sprintf('The Dice similarity for the Result equal \t %0.3f %% ', d*100);
set(handles.message,'String',text11);



% --- Executes on button press in kfold.
function kfold_Callback(hObject, eventdata, handles)
% hObject    handle to kfold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes2,'reset')
cla(handles.axes3,'reset')
cla(handles.axes4,'reset')

set(handles.MU_Lung,'visible','off')
set(handles.MU_Chest,'visible','off')
set(handles.Var_Lung,'visible','off')
set(handles.Var_Chest,'visible','off')
set(handles.diceedit,'visible','off')
set(handles.varlung,'visible','off')
set(handles.muchest,'visible','off')
set(handles.varchest,'visible','off')
set(handles.mulung,'visible','off')
set(handles.DICE,'visible','on')
set(handles.diceedit,'visible','on')
set(handles.message,'visible','on')
global result;
[result,p_lung,p_chest,M,G,x]=k_fold();

%oRIGINAL M4
axes(handles.axes2);
imshow(M,[])
%disp result
axes(handles.axes3);
imshow(result,[])

%plotting
axes(handles.axes4);
q = 0:1:255; % Gray Level
plot(q,p_lung,'r')
hold on
plot(q,p_chest,'b')


%calculate Dice
d1=dsc(G,result);
text12 = sprintf('The Best Case When we used   M%d  for the test  and the others for training \n The Dice similarity for the Result equal \t %0.3f %% ',x, d1*100);
set(handles.message,'String',text12);
tex=sprintf('%0.3f %%',d1*100);
set(handles.diceedit,'String',tex);
