function varargout = Registering_Driver(varargin)
% REGISTERING_DRIVER MATLAB code for Registering_Driver.fig
%      REGISTERING_DRIVER, by itself, creates a new REGISTERING_DRIVER or raises the existing
%      singleton*.
%
%      H = REGISTERING_DRIVER returns the handle to a new REGISTERING_DRIVER or the handle to
%      the existing singleton*.
%
%      REGISTERING_DRIVER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REGISTERING_DRIVER.M with the given input arguments.
%
%      REGISTERING_DRIVER('Property','Value',...) creates a new REGISTERING_DRIVER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Registering_Driver_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Registering_Driver_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Registering_Driver

% Last Modified by GUIDE v2.5 05-Jun-2020 07:10:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Registering_Driver_OpeningFcn, ...
                   'gui_OutputFcn',  @Registering_Driver_OutputFcn, ...
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


% --- Executes just before Registering_Driver is made visible.
function Registering_Driver_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Registering_Driver (see VARARGIN)

% Choose default command line output for Registering_Driver

axes(handles.abu_logo);
matlabImage = imread('ABU.png');
image(matlabImage);
axis off;
axis image;

handles.output = hObject;
axes(handles.camera);
imshow('blank.jpg');
axis off;

% start
handles.vid = videoinput('winvideo' , 1, 'YUY2_640X480');

% Update handles structure
guidata(hObject, handles);



% UIWAIT makes Registering_Driver wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Registering_Driver_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.vid = videoinput('winvideo' , 1, 'YUY2_640X480');
%preview(handles.vid);
guidata(hObject, handles);

% --- Executes on button press in face.
function face_Callback(hObject, eventdata, handles)
% hObject    handle to face (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles.vid = videoinput('winvideo' , 1, 'YUY2_640X480');

% successMessage appears
set(handles.successMessage, 'String', '');

% make directory
driver = get(handles.driverName, 'String');
if (driver == "")  % if name is not provided, we do not create directory
    disp 'Do NOT leave the name empty'
else
    mkdir(driver)
end

if ~(driver == "")
    % disable driverName (textbox)
    set(handles.driverName, 'enable', 'off')
    
    triggerconfig(handles.vid ,'manual');
    set(handles.vid, 'TriggerRepeat',inf);
    set(handles.vid, 'FramesPerTrigger',1);
    handles.vid.ReturnedColorspace = 'rgb';
    handles.vid.Timeout = 5;
    start(handles.vid);
    
    while(1)
        facedetector = vision.CascadeObjectDetector;                                                 
        trigger(handles.vid); 
        handles.im = getdata(handles.vid, 1);
        bbox = step(facedetector, handles.im);
        faceAnnotation = insertObjectAnnotation(handles.im,'rectangle',bbox,'Face');
        imshow(faceAnnotation);
    end
end


guidata(hObject, handles);


% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

count = str2num(get(handles.imageCount, 'String'));
if ~(count == 0) % then we were able to register it
    driver = get(handles.driverName, 'String');
    % successMessage appears
    set(handles.successMessage, 'String', 'Driver is registered successfully.');
    % enable back driverName (textbox)
    set(handles.driverName, 'enable', 'on')
    set(handles.imageCount, 'String', '0');
end

handles.output = hObject;
stop(handles.vid),
clear handles.vid %, ,delete(handles.vid)
% 
% objects = imaqfind %find video input objects in memory
% delete(objects) %delete a video input object from memor

guidata(hObject, handles);




% --- Executes when user attempts to close myCameraGUI.
function testing_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to myCameraGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
stop_Callback()

clc; clear;
close all; objects = imaqfind %find video input objects in memory
delete(objects) %delete a video input object from memor



function driverName_Callback(hObject, eventdata, handles)
% hObject    handle to driverName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of driverName as text
%        str2double(get(hObject,'String')) returns contents of driverName as a double


% --- Executes during object creation, after setting all properties.
function driverName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to driverName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonTakePhoto.
function buttonTakePhoto_Callback(hObject, eventdata, handles)
% hObject    handle to buttonTakePhoto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% snapshot = getsnapshot(handles.vid);
% imagesc(snapshot)
% imwrite(snapshot, 'ibrahim.png');

snapshot = getsnapshot(handles.vid);

driver = get(handles.driverName, 'String');

if ~(driver == "")
    count = str2num(get(handles.imageCount, 'String'));
    incremented = count + 1;
    
    file_name = sprintf('%s/image%d', driver, incremented);
    
    imwrite(snapshot, [file_name,'.jpg']);

    set(handles.imageCount, 'String', incremented);
end





% imagesc(snapshot)
% imwrite(snapshot, 'aaaa.png');


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over imageCount.
function imageCount_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to imageCount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
