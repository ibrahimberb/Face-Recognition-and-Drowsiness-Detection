I_1 = imread('template_open.png');
I_1 = rgb2gray(I_1);
I_2 = imread('template_closed.png');
I_2 = rgb2gray(I_2);

I_2 = imresize(I_2, size(I_1)); 

R = corr2(I_1,I_2)