%% Testing the architecture with specified images

%% Since inceptionv3 is used, its input size is stored in a variable
inputSize = [299   299     3];

%% Read the authorized users from file (or declare them)
% authorized_drivers = ["sema","ibrahim","11"];
authorized_file = textread('users.txt','%s', 'delimiter','\n','whitespace','');
authorized_drivers = string(authorized_file);

%% Image input: select the test subject image with file picker

[file,path] = uigetfile('*.*');
% I = imread("C:\_FaceTesting\split_test\test_sema\sema-11.jpg");
% I = imread("C:\Users\ibrah\Desktop\Temp_Files\SP\Eye\6\3_2.jpg");
% I = imread('C:\Users\ibrah\Desktop\Ibrahim\i_3\image1.jpg');
I = imread(fullfile(path,file));
I = imresize(I,inputSize(1:2));

%% Load pretrained architecture to memory
load('trainedNet.mat')

%% Show subject image
figure
imshow(I)

%% Prediction process
classNames = trainedNet.Layers(end).ClassNames;
numClasses = numel(classNames);
[label,scores] = classify(trainedNet,I);
label_str = string(label);
num2str(100*scores(classNames == label),3)

%% Granting access depending on prediction score

predictionThreshold = 60;

if any(strcmp(authorized_drivers,label_str)) & (100*scores(classNames == label) > predictionThreshold)
    title("User: " + string(label) + " [Access granted] ");   
else
    title("[Not authorized]");
end

% title(string(label) + ", " + num2str(100*scores(classNames == label),3) + "%");

%% Prediction without authorization (just console output)
if any(strcmp(authorized_drivers,label_str)) & (100*scores(classNames == label) > predictionThreshold)
    fprintf('Welcome driver %s\n',label_str);
else
    fprintf('Not authorized..\n');
end

%% Display top five strongest predictions
[~,idx] = sort(scores,'descend');
idx = idx(5:-1:1);
classNamesTop = trainedNet.Layers(end).ClassNames(idx);
scoresTop = scores(idx);
figure
barh(scoresTop)
xlim([0 1])
title('Top 5 Predictions')
xlabel('Probability')
yticklabels(classNamesTop)