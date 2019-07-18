function varargout = start_gui(varargin)
%UNTITLED1 MATLAB code file for untitled1.fig
%      UNTITLED1, by itself, creates a new UNTITLED1 or raises the existing
%      singleton*.
%
%      H = UNTITLED1 returns the handle to a new UNTITLED1 or the handle to
%      the existing singleton*.
%
%      UNTITLED1('Property','Value',...) creates a new UNTITLED1 using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to untitled1_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      UNTITLED1('CALLBACK') and UNTITLED1('CALLBACK',hObject,...) call the
%      local function named CALLBACK in UNTITLED1.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled1

% Last Modified by GUIDE v2.5 17-Jul-2019 22:36:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled1_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled1_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before untitled1 is made visible.
function untitled1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for untitled1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled1_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start_pushbutton.
function start_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to start_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Input
pfad=get(handles.pfad_edit,'Userdata');
ndisp=get(handles.ndisp_edit,'Userdata');
Fixed_win=get(handles.Fixed_win,'Userdata');
Variable_win=get(handles.Variable_win,'Userdata');
if Variable_win == 1
    algorithm=1;
else
    algorithm=0;
end

Window_radius=get(handles.Window_radius_edit,'Userdata');
min_window_radius=get(handles.min_window_radius_edit,'Userdata');
max_window_radius=get(handles.max_window_radius_edit,'Userdata');

beta=get(handles.beta_edit,'Userdata');
gamma=get(handles.gamma_edit,'Userdata');

pri_MV=get(handles.pri_MV_edit,'Userdata');
pri_MV_r=get(handles.pri_MV_r_edit,'Userdata');
pos_MV=get(handles.pos_MV_edit,'Userdata');
pos_MV_r=get(handles.pos_MV_r_edit,'Userdata');
HF=get(handles.HF_edit,'Userdata');
HF_r=get(handles.HF_r_edit,'Userdata');
BGF=get(handles.BGF_checkbox,'Userdata');
calib = get(handles.Disparity_calibration_edit,'Userdata');

% Display im0 & im1
path_im0=[pfad,'\im0.png'];
path_im1=[pfad,'\im1.png'];
show = imtile({path_im0,path_im1});
imshow(show);
drawnow;
% Disparity map
tic;
[D,R,T] = disparity_map(pfad,'ndisp',ndisp,'calib',calib,'algorithm',algorithm,'window_radius',Window_radius,'min_window_radius',min_window_radius,'max_window_radius',max_window_radius,'beta',beta,'gamma',gamma,'pri_MV',pri_MV,'pri_MV_r',pri_MV_r,'pos_MV',pos_MV,'pos_MV_r',pos_MV_r,'HF',HF,'HF_r',HF_r,'BGF',BGF);
time_taken=toc;
D_plot=set(handles.start_pushbutton,'Userdata',D);

% PSNR
path_GT=[pfad,'\disp0.pfm'];
if ~exist(path_GT,'file')
    PSNR=('no GT');
else
    GT = readpfm([pfad,'/disp0.pfm']); % '/disp0GT.pfm'
    GT_u = uint8(GT);
    PSNR = verify_dmap(D,GT_u,max(max(D(:),max(GT(:)))));
end

% Output
% R
set(handles.R11,'string',R(1,1)); 
set(handles.R12,'string',R(1,2));
set(handles.R13,'string',R(1,3));
set(handles.R21,'string',R(2,1));
set(handles.R22,'string',R(2,2));
set(handles.R23,'string',R(2,3));
set(handles.R31,'string',R(3,1));
set(handles.R32,'string',R(3,2));
set(handles.R33,'string',R(3,3));
% T
set(handles.T1,'string',T(1));% Transform_uitable   % T_edit,'string'
set(handles.T2,'string',T(2));
set(handles.T3,'string',T(3));
% PSNR & Time
set(handles.p_edit,'string',PSNR);
set(handles.time_edit,'string',time_taken);
% Image_show
D=double(D);
imshow(D/max(D(:))) ;   % /max(D(:))
colormap(gca,jet)
drawnow;



function pfad_edit_Callback(hObject, eventdata, handles)
% hObject    handle to pfad_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pfad=get(handles.pfad_edit,'string');
set(handles.pfad_edit,'Userdata',pfad);
% Hints: get(hObject,'String') returns contents of pfad_edit as text
%        str2double(get(hObject,'String')) returns contents of pfad_edit as a double


% --- Executes during object creation, after setting all properties.
function pfad_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pfad_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end











function R_edit_Callback(hObject, eventdata, handles)
% hObject    handle to R_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set()
% Hints: get(hObject,'String') returns contents of R_edit as text
%        str2double(get(hObject,'String')) returns contents of R_edit as a double


% --- Executes during object creation, after setting all properties.
function R_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function T_edit_Callback(hObject, eventdata, handles)
% hObject    handle to time_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time_edit as text
%        str2double(get(hObject,'String')) returns contents of time_edit as a double


% --- Executes during object creation, after setting all properties.
function T_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function p_edit_Callback(hObject, eventdata, handles)
% hObject    handle to p_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p_edit as text
%        str2double(get(hObject,'String')) returns contents of p_edit as a double


% --- Executes during object creation, after setting all properties.
function p_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function time_edit_Callback(hObject, eventdata, handles)
% hObject    handle to time_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time_edit as text
%        str2double(get(hObject,'String')) returns contents of time_edit as a double


% --- Executes during object creation, after setting all properties.
function time_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ndisp_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ndisp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ndisp=get(handles.ndisp_edit,'string');
set(handles.ndisp_edit,'Userdata',ndisp);
% Hints: get(hObject,'String') returns contents of ndisp_edit as text
%        str2double(get(hObject,'String')) returns contents of ndisp_edit as a double


% --- Executes during object creation, after setting all properties.
function ndisp_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ndisp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Disparity_calibration_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Disparity_calibration_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Disparity_calibration=get(handles.Disparity_calibration_edit,'string');
set(handles.Disparity_calibration_edit,'Userdata',Disparity_calibration);
% Hints: get(hObject,'String') returns contents of Disparity_calibration_edit as text
%        str2double(get(hObject,'String')) returns contents of Disparity_calibration_edit as a double


% --- Executes during object creation, after setting all properties.
function Disparity_calibration_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Disparity_calibration_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BGF_checkbox.
function BGF_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to BGF_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
BGF=get(handles.BGF_checkbox,'string');
set(handles.BGF_checkbox,'Userdata',BGF);
% Hint: get(hObject,'Value') returns toggle state of BGF_checkbox



function pri_MV_edit_Callback(hObject, eventdata, handles)
% hObject    handle to pri_MV_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pri_MV=get(handles.pri_MV_edit,'string');
set(handles.pri_MV_edit,'Userdata',pri_MV);
% Hints: get(hObject,'String') returns contents of pri_MV_edit as text
%        str2double(get(hObject,'String')) returns contents of pri_MV_edit as a double


% --- Executes during object creation, after setting all properties.
function pri_MV_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pri_MV_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pri_MV_r_edit_Callback(hObject, eventdata, handles)
% hObject    handle to pri_MV_r_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pri_MV_r=get(handles.pri_MV_r_edit,'string');
set(handles.pri_MV_r_edit,'Userdata',pri_MV_r);
% Hints: get(hObject,'String') returns contents of pri_MV_r_edit as text
%        str2double(get(hObject,'String')) returns contents of pri_MV_r_edit as a double


% --- Executes during object creation, after setting all properties.
function pri_MV_r_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pri_MV_r_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function HF_edit_Callback(hObject, eventdata, handles)
% hObject    handle to HF_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
HF=get(handles.HF_edit,'string');
set(handles.HF_edit,'Userdata',HF);
% Hints: get(hObject,'String') returns contents of HF_edit as text
%        str2double(get(hObject,'String')) returns contents of HF_edit as a double


% --- Executes during object creation, after setting all properties.
function HF_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HF_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function HF_r_edit_Callback(hObject, eventdata, handles)
% hObject    handle to HF_r_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
HF_r=get(handles.HF_r_edit,'string');
set(handles.HF_r_edit,'Userdata',HF_r);
% Hints: get(hObject,'String') returns contents of HF_r_edit as text
%        str2double(get(hObject,'String')) returns contents of HF_r_edit as a double


% --- Executes during object creation, after setting all properties.
function HF_r_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HF_r_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pos_MV_edit_Callback(hObject, eventdata, handles)
% hObject    handle to pos_MV_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pos_MV=get(handles.pos_MV_edit,'string');
set(handles.pos_MV_edit,'Userdata',pos_MV);
% Hints: get(hObject,'String') returns contents of pos_MV_edit as text
%        str2double(get(hObject,'String')) returns contents of pos_MV_edit as a double


% --- Executes during object creation, after setting all properties.
function pos_MV_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pos_MV_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pos_MV_r_edit_Callback(hObject, eventdata, handles)
% hObject    handle to pos_MV_r_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pos_MV_r=get(handles.pos_MV_r_edit,'string');
set(handles.pos_MV_r_edit,'Userdata',pos_MV_r);
% Hints: get(hObject,'String') returns contents of pos_MV_r_edit as text
%        str2double(get(hObject,'String')) returns contents of pos_MV_r_edit as a double


% --- Executes during object creation, after setting all properties.
function pos_MV_r_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pos_MV_r_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beta_edit_Callback(hObject, eventdata, handles)
% hObject    handle to beta_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
beta=get(handles.beta_edit,'string');
set(handles.beta_edit,'Userdata',beta);

% Hints: get(hObject,'String') returns contents of beta_edit as text
%        str2double(get(hObject,'String')) returns contents of beta_edit as a double


% --- Executes during object creation, after setting all properties.
function beta_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beta_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gamma_edit_Callback(hObject, eventdata, handles)
% hObject    handle to gamma_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gamma=get(handles.gamma_edit,'string');
set(handles.gamma_edit,'Userdata',gamma);

% Hints: get(hObject,'String') returns contents of gamma_edit as text
%        str2double(get(hObject,'String')) returns contents of gamma_edit as a double


% --- Executes during object creation, after setting all properties.
function gamma_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gamma_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function min_window_radius_edit_Callback(hObject, eventdata, handles)
% hObject    handle to min_window_radius_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
min_window_radius=get(handles.min_window_radius_edit,'string');
set(handles.min_window_radius_edit,'Userdata',min_window_radius);
% Hints: get(hObject,'String') returns contents of min_window_radius_edit as text
%        str2double(get(hObject,'String')) returns contents of min_window_radius_edit as a double


% --- Executes during object creation, after setting all properties.
function min_window_radius_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min_window_radius_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function max_window_radius_edit_Callback(hObject, eventdata, handles)
% hObject    handle to max_window_radius_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
max_window_radius=get(handles.max_window_radius_edit,'string');
set(handles.max_window_radius_edit,'Userdata',max_window_radius);
% Hints: get(hObject,'String') returns contents of max_window_radius_edit as text
%        str2double(get(hObject,'String')) returns contents of max_window_radius_edit as a double


% --- Executes during object creation, after setting all properties.
function max_window_radius_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_window_radius_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Window_radius_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Window_radius_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Window_radius=get(handles.Window_radius_edit,'string');
set(handles.Window_radius_edit,'Userdata',Window_radius);
% Hints: get(hObject,'String') returns contents of Window_radius_edit as text
%        str2double(get(hObject,'String')) returns contents of Window_radius_edit as a double


% --- Executes during object creation, after setting all properties.
function Window_radius_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Window_radius_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Fixed_win.
function Fixed_win_Callback(hObject, eventdata, handles)
% hObject    handle to Fixed_win (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Fixed_win=get(hObject,'Value');
if Fixed_win == 1
    set(handles.Variable_win,'Userdata',0);
end
set(handles.Fixed_win,'Userdata',Fixed_win);
% Hint: get(hObject,'Value') returns toggle state of Fixed_win


% --- Executes on button press in Variable_win.
function Variable_win_Callback(hObject, eventdata, handles)
% hObject    handle to Variable_win (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Variable_win=get(hObject,'Value');
if Variable_win == 1
    set(handles.Fixed_win,'Userdata',0);
end
set(handles.Variable_win,'Userdata',Variable_win);
% Hint: get(hObject,'Value') returns toggle state of Variable_win


% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when entered data in editable cell(s) in Rolation_uitable.
function Rolation_uitable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to Rolation_uitable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function Rolation_uitable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rolation_uitable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when entered data in editable cell(s) in Transform_uitable.
function Transform_uitable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to Transform_uitable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)



function R11_Callback(hObject, eventdata, handles)
% hObject    handle to R11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R11 as text
%        str2double(get(hObject,'String')) returns contents of R11 as a double


% --- Executes during object creation, after setting all properties.
function R11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function R12_Callback(hObject, eventdata, handles)
% hObject    handle to R12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R12 as text
%        str2double(get(hObject,'String')) returns contents of R12 as a double


% --- Executes during object creation, after setting all properties.
function R12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function R13_Callback(hObject, eventdata, handles)
% hObject    handle to R13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R13 as text
%        str2double(get(hObject,'String')) returns contents of R13 as a double


% --- Executes during object creation, after setting all properties.
function R13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function R23_Callback(hObject, eventdata, handles)
% hObject    handle to R23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R23 as text
%        str2double(get(hObject,'String')) returns contents of R23 as a double


% --- Executes during object creation, after setting all properties.
function R23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function R21_Callback(hObject, eventdata, handles)
% hObject    handle to R21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R21 as text
%        str2double(get(hObject,'String')) returns contents of R21 as a double


% --- Executes during object creation, after setting all properties.
function R21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function R31_Callback(hObject, eventdata, handles)
% hObject    handle to R31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R31 as text
%        str2double(get(hObject,'String')) returns contents of R31 as a double


% --- Executes during object creation, after setting all properties.
function R31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function R32_Callback(hObject, eventdata, handles)
% hObject    handle to R32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R32 as text
%        str2double(get(hObject,'String')) returns contents of R32 as a double


% --- Executes during object creation, after setting all properties.
function R32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function R33_Callback(hObject, eventdata, handles)
% hObject    handle to R33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R33 as text
%        str2double(get(hObject,'String')) returns contents of R33 as a double


% --- Executes during object creation, after setting all properties.
function R33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function R22_Callback(hObject, eventdata, handles)
% hObject    handle to R22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R22 as text
%        str2double(get(hObject,'String')) returns contents of R22 as a double


% --- Executes during object creation, after setting all properties.
function R22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function T1_Callback(hObject, eventdata, handles)
% hObject    handle to T1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T1 as text
%        str2double(get(hObject,'String')) returns contents of T1 as a double


% --- Executes during object creation, after setting all properties.
function T1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function T2_Callback(hObject, eventdata, handles)
% hObject    handle to T2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T2 as text
%        str2double(get(hObject,'String')) returns contents of T2 as a double


% --- Executes during object creation, after setting all properties.
function T2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function T3_Callback(hObject, eventdata, handles)
% hObject    handle to T3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T3 as text
%        str2double(get(hObject,'String')) returns contents of T3 as a double


% --- Executes during object creation, after setting all properties.
function T3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function image_axis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to image_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
white=ones(994,1482);
imshow(white);
drawnow;
% Hint: place code in OpeningFcn to populate image_axis


% --- Executes on button press in Clear_pushbutton.
function Clear_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Clear_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
white=ones(994,1482);
imshow(white);

set(handles.R11,'string','');
set(handles.R12,'string','');
set(handles.R13,'string','');
set(handles.R21,'string','');
set(handles.R22,'string','');
set(handles.R23,'string','');
set(handles.R31,'string','');
set(handles.R32,'string','');
set(handles.R33,'string','');
set(handles.T1,'string','');
set(handles.T2,'string','');
set(handles.T3,'string','');
set(handles.p_edit,'string','');
set(handles.time_edit,'string','');


% --- Executes on button press in plot_pushbutton.
function plot_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to plot_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pfad=get(handles.pfad_edit,'Userdata'); 
im0=imread([pfad,'\im0.png']); 
D=get(handles.start_pushbutton,'Userdata');
plot_3D(D,im0);
