%%   Training network using transfer learning with cross validation: 
%    + inceptionv3 is selected
%    + K-fold of 5 is selected
%%
clear all
close all

%%  Add database directory path

imds = imageDatastore("C:\_FaceData_D", ...
    'IncludeSubfolders',true,'LabelSource','foldernames');
[imd1, imd2, imd3, imd4, imd5] = splitEachLabel(imds,0.20,0.20,0.20,0.20,0.20,'randomize');
partStores{1} = imd1.Files ;
partStores{2} = imd2.Files ;
partStores{3} = imd3.Files ;
partStores{4} = imd4.Files ;
partStores{5} = imd5.Files ;

%% K-fold
k = 5;
idx = crossvalind('Kfold', k, k);

%% inceptionv3 achitecture. Note: It needs to be installed from Add-on explorer
net = inceptionv3;

%% sample images from dataset
figure;
perm = randperm(2424,20); 
for i = 1:20
    subplot(4,5,i);
    imshow(imds.Files{perm(i)});
end

%% Replace Final Layers according to the database
numClasses = numel(categories(imds.Labels));
lgraph = layerGraph(net);

newFCLayer = fullyConnectedLayer(numClasses,'Name','new_fc','WeightLearnRateFactor',10,'BiasLearnRateFactor',10);
lgraph = replaceLayer(lgraph,'predictions',newFCLayer); % Change the last layer (e.g. 'fc1000' -> 'predictions')

newClassLayer = classificationLayer('Name','new_classoutput');
lgraph = replaceLayer(lgraph,'ClassificationLayer_predictions',newClassLayer);


for foldi = 1 :k
    test_idx = (idx == foldi);
    train_idx = ~test_idx;
    imdsValidation = imageDatastore(partStores{test_idx}, 'IncludeSubfolders', true,'LabelSource', 'foldernames');
    imdsTrain = imageDatastore(cat(1, partStores{train_idx}), 'IncludeSubfolders', true,'LabelSource', 'foldernames'); 
    
    %% Train Network
    inputSize = net.Layers(1).InputSize;
    augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain);
    augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdsValidation);
    
    %% selecting the options for training
    options = trainingOptions('sgdm', ...
    'MiniBatchSize',16, ...                         % 16
    'MaxEpochs',4, ...                              % 4 
    'InitialLearnRate',1e-3, ...                    % 1e-3
    'Shuffle','every-epoch', ...
    'ValidationData',augimdsValidation, ...
    'ValidationFrequency',5, ...
    'Verbose',false, ...
    'Plots','training-progress');

    trainedNet = trainNetwork(augimdsTrain,lgraph,options);
    
    %% Prediction for each fold and their accuricies
    YPred = classify(trainedNet,augimdsValidation);
    accuracy(foldi) = mean(YPred == imdsValidation.Labels)
end

%% Average of 5-fold
avg=sum(accuracy)/5;
fprintf("The System Accuracy is %.2f \n",avg*100)

%% Saving the trained network (uncommend following line)
% save trainedNet
