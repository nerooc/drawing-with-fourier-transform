function varargout = rysowanie_dft_ui(varargin)
%RYSOWANIE_DFT_UI MATLAB code file for rysowanie_dft_ui.fig
%      RYSOWANIE_DFT_UI, by itself, creates a new RYSOWANIE_DFT_UI or raises the existing
%      singleton*.
%
%      H = RYSOWANIE_DFT_UI returns the handle to a new RYSOWANIE_DFT_UI or the handle to
%      the existing singleton*.
%
%      RYSOWANIE_DFT_UI('Property','Value',...) creates a new RYSOWANIE_DFT_UI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to rysowanie_dft_ui_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      RYSOWANIE_DFT_UI('CALLBACK') and RYSOWANIE_DFT_UI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in RYSOWANIE_DFT_UI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rysowanie_dft_ui

% Last Modified by GUIDE v2.5 08-Jan-2021 14:38:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rysowanie_dft_ui_OpeningFcn, ...
                   'gui_OutputFcn',  @rysowanie_dft_ui_OutputFcn, ...
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


% --- Executes just before rysowanie_dft_ui is made visible.
function rysowanie_dft_ui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for rysowanie_dft_ui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes rysowanie_dft_ui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = rysowanie_dft_ui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, filepath] = uigetfile({'*.png';'*.jpg';'*.jpeg'},...
'Wybierz plik do zbinaryzowania');
if ~isempty(filename)
    prepareForFourier(filename, filepath);
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, filepath] = uigetfile({'*.mat','MATLAB Files'},...
  'Wybierz plik ze zbinaryzowanym obrazem');
if ~isempty(filename)
    data = load([filepath, filename]);
    if ~isfield(data, 'X')
        errordlg('Plik nie zawiera wektora X!');
    elseif ~isfield(data, 'Y')
        errordlg('Plik nie zawiera wektora Y!');
    else
        if length(data.X) ~= length(data.Y)
            errordlg('Wektory X i Y mają różną długość!');
        else
            mainFourier(data.X, data.Y);
        end
    end
end

