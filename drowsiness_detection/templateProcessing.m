I = imread('closed.png');

figure, imshow(I)

EyeDetect = vision.CascadeObjectDetector('EyePairBig','MergeThreshold',16);
BB=step(EyeDetect,I);

ey=imcrop(I,BB);

figure, imshow(ey)

croppedImage = rgb2gray(ey);
figure, imshow(croppedImage)

croppedImage = histeq(croppedImage);
figure, imshow(croppedImage)

bluredImage = imgaussfilt(croppedImage,2);
figure, imshow(croppedImage)

BW = imbinarize(bluredImage,'adaptive','ForegroundPolarity','dark','Sensitivity',0.1);
figure, imshow(BW)