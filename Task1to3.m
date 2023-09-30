% MATLAB script for Assessment 1
% Task 1: Preprocessing ---------------------------
clear; close all; clc;

% Step-1: Load input image
I = imread('IMG_01.jpg');
figure;
imshow(I);
title('Task-1-Step-1: Load input image');

% Step-2: Conversion of input image to grey-scale image
Igray = rgb2gray(I);
figure;
imshow(Igray);
title('Task-1-Step-2: Conversion of input image to greyscale');

% Step-3: Resizing the grayscale image using bilinear interpolation
IgrayHalf = imresize(Igray,0.5,'bilinear');
figure;
imagesc(IgrayHalf);
colorbar;
colormap gray;
title('Task-1-Step-3: Resizing the grayscale image using bilinear interpolation');

% Step-4: Generating histogram for the resized image
figure;
imhist(IgrayHalf)
title('Task-1-Step-4: Generating histogram for the resized image');

% Step-5: Producing binarised image
Ibinary = imbinarize(IgrayHalf,0.8671); % 222/256 to calculate threshold
figure;
imshow(Ibinary);
title('Task-1-Step-5: Producing binarised image')

%---------------------------------------------------------------
% Task 2: Edge Detection -----------------------

% -------------------- SOBEL --------------------
edgeS = edge(IgrayHalf,'sobel');

figure;
imshow(edgeS);
title('Task-2: Edge Detection (Sobel)')

% -------------------- CANNY --------------------
edgeC = edge(IgrayHalf,'canny');

figure;
imshow(edgeC);
title('Task-2: Edge Detection (Canny)');

%---------------------------------------------------------------
% Task-3: Simple Segmentation -----------------------

% ------------------ Binary Image ------------------
% Step-1: Dilate Image
se90 = strel('line',3,90);
se0 = strel('line',3,0);
BDilate = imdilate(Ibinary,[se90,se0]);

figure;
imshow(BDilate)
title('Task-3-Step-1: Dilate Image (Binary Image)')

% Step-2: Fill Image
BFill = imfill(BDilate,'holes');

figure;
imshow(BFill)
title('Task-3-Step-2: Fill Image (Binary Image)')

% Step-3: Erode Image
BErode = imerode(BFill,[se90,se0]);

figure;
imshow(BErode)
title('Task-3-Step-3: Erode Image (Binary Image)')

% Step-4: Remove Connected Objects On Border
Bnobord = imclearborder(BErode,4);

figure;
imshow(Bnobord);
title('Task-3-Step-4: Remove Connected Objects On Border (Binary Image)')

% Step-5: Finalizing the Swan
BCC = bwconncomp(Bnobord);

while BCC.NumObjects > 2
    numPixels = cellfun(@numel,BCC.PixelIdxList);
    [smallest,idx] = min(numPixels);
    Bnobord(BCC.PixelIdxList{idx}) = 0;
    BCC = bwconncomp(Bnobord);
end

figure;
imshow(Bnobord)
title('Task-3-Step-5: Finalizing the Swan (Binary Image)')

% ------------------ Sobel Edge ------------------
% Step-1: Dilate Image
se90 = strel('line',3,90);
se0 = strel('line',3,0);
SDilate = imdilate(edgeS,[se90,se0]);

figure;
imshow(SDilate)
title('Task-3-Step-1: Dilate Image (Sobel Edge)')

% Step-2: Fill Image
SFill = imfill(SDilate,'holes');

figure;
imshow(SFill)
title('Task-3-Step-2: Fill Image (Sobel Edge)')

% Step-3: Erode Image
SErode = imerode(SFill,[se90,se0]);
SErode = imerode(SErode,[se90,se0]);

figure;
imshow(SErode)
title('Task-3-Step-3: Erode Image (Sobel Edge)')

% Step-4: Remove Connected Objects On Border
Snobord = imclearborder(SErode,4);

figure;
imshow(Snobord);
title('Task-3-Step-4: Remove Connected Objects On Border (Sobel Edge)')

% Step-5: Finalizing the Swan
SCC = bwconncomp(Snobord);

while SCC.NumObjects > 2
    numPixels = cellfun(@numel,SCC.PixelIdxList);
    [smallest,idx] = min(numPixels);
    Snobord(SCC.PixelIdxList{idx}) = 0;
    SCC = bwconncomp(Snobord);
end

figure;
imshow(Snobord)
title('Task-3-Step-5: Finalizing the Swan (Sobel Edge)')




