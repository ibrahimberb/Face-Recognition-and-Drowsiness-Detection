%% Detecting and tracking the eye-pair
% Automatically detects and tracks eye-apir in a webcam

clear classes;

%% Instantiate video device, face detector, and KLT object tracker
vidObj = webcam;

eyeDetector = vision.CascadeObjectDetector('EyePairBig'); % Finds faces by default
tracker = MultiObjectTrackerKLT;

%% Get a frame for frame-size information
frame = snapshot(vidObj);
frameSize = size(frame);

%% Create a video player instance
videoPlayer  = vision.VideoPlayer('Position',[200 100 fliplr(frameSize(1:2)+30)]);

%% Iterate until we have successfully detected a face
bboxes = [];
while isempty(bboxes)
    framergb = snapshot(vidObj);
    frame = rgb2gray(framergb);
    bboxes = eyeDetector.step(frame);
end
tracker.addDetections(frame, bboxes);

%% tamplate acquire
template = imread('t1_1.png'); % t1 = ibrahim
template = rgb2gray(template);
%%

%% audio
[y, Fs] = audioread('a.wav');
player = audioplayer(y, Fs);
%%

%% And loop until the player is closed
frameNumber = 0;
keepRunning = true;
disp('Press Ctrl-C to exit...');
temp = 0;
templateRegistered = 0;
numOfSleepCaptures = 0;
while keepRunning
    
    framergb = snapshot(vidObj);
    frame = rgb2gray(framergb);
    
    if mod(frameNumber, 2) == 0
        % (Re)detect faces.
        %
        % NOTE: face detection is more expensive than imresize; we can
        % speed up the implementation by reacquiring faces using a
        % downsampled frame:
        % bboxes = eyeDetector.step(frame);
        bboxes = 2 * eyeDetector.step(imresize(frame, 0.5));
        if ~isempty(bboxes)
            tracker.addDetections(frame, bboxes);
        end
    else
        % Track faces
        tracker.track(frame);
    end
    
    % Display bounding boxes and tracked points.
    displayFrame = insertObjectAnnotation(framergb, 'rectangle',...
        tracker.Bboxes, tracker.BoxIds);
    % displayFrame = insertMarker(displayFrame, tracker.Points); %%%%%%%%%
    videoPlayer.step(displayFrame);
    
 
    
    if mod(frameNumber, 5) == 0
        croppedImage = imcrop(framergb,tracker.Bboxes);
        croppedImageGrayed = rgb2gray(croppedImage);
        imageHist = histeq(croppedImageGrayed);
        imageBlured = imgaussfilt(imageHist,2);
        BW = imbinarize(imageBlured,'adaptive','ForegroundPolarity','dark','Sensitivity',0.4);
        
        % figure, imshow(BW)
       
        corners = detectHarrisFeatures(BW);
        imshow(BW); hold on;
        plot(corners.selectStrongest(10));
        J = imresize(BW, size(template)); 
        R = corr2(template,J)
        % ssimval = ssim(template,J)
        
        % first time registry
        if templateRegistered == 0
            % update template if similarity is high, so that closed eye will
            % not be our template
            if R > 0.10 %%% TODO :: change it to 0.50 BUT MAYBE NO NEED
                template = BW;
                templateRegistered = 1;
                disp 'registered..'
            end
        end
        
        if templateRegistered == 1
            
            %% optional
            if R > 0.50 %%% TODO :: change it to 0.50 BUT MAYBE NO NEED
                template = BW;
                disp 'template updated..'
            end
            %%
            
            
            th = 0.30;
            
            if R < th 
                lastSleeped = 1;
                numOfSleepCaptures = numOfSleepCaptures + 1
            end
            
            if R > th
                numOfSleepCaptures = 0;
                lastSleeped = 0;
            end
            
            if numOfSleepCaptures > 3 && lastSleeped == 1
                play(player);
            end
            
            if numOfSleepCaptures > 0
                numOfSleepCaptures
            end
                
        end
      
       
    end
    
    
    
    temp = tracker.Points;
    frameNumber = frameNumber + 1;
end

%% Clean up
release(videoPlayer);