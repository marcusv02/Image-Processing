% MATLAB script for Assessment Item-1
% Task 4: Robust Swan Recognition ----------------
clear; close all; clc;

% Step-1: Read image
I = imread("IMG_02.JPG");

figure, imshow(I)
title('Task-4-Step-1: Read Image')

% Step-2: Produce Greyscale Image
grayscale = rgb2gray(I);

figure, imshow(grayscale)
title('Task-4-Step-2: Produce Greyscale Image');

% Step-3: Resizing the grayscale image using bilinear interpolation
grayscaleHalf = imresize(grayscale,0.5,'bilinear');

figure;
imagesc(grayscaleHalf);
colorbar;
colormap gray;
title('Task-4-Step-3: Resizing the grayscale image using bilinear interpolation');

% Step-4: Invert the image
Inv = imcomplement(grayscaleHalf);

figure, imshow(Inv)
title('Task-4-Step-4: Invert the image')

% Step-5: Reduce the haze
InvRed = imreducehaze(Inv, 0.95, 'method', 'approxdcp');

figure, imshow(InvRed)
title('Task-4-Step-5: Reduce the haze')

% Step-6: Invert to obtain enhanced image
enhanced = imcomplement(InvRed);

figure, imshow(enhanced)
title('Task-4-Step-6: Invert to obtain enhanced image')

% Step-7: Binarise the image
T = graythresh(enhanced); % Use Otsu's thresholding
BW = imbinarize(enhanced,T+0.191); % Refine the threshold

figure, imshow(BW)
title('Task-4-Step-7: Binarise the image')

% Step-8: Perform image opening
se90 = strel('line',3,90);
se0 = strel('line',3,0);
erode = imerode(BW, [se90, se0]);
dilate = imdilate(erode, [se90, se0]);

figure, imshow(dilate)
title('Task-4-Step-8: Perform image opening')

% Step-9: Clear the border
BWclear = imclearborder(dilate);

figure, imshow(BWclear)
title('Task-4-Step-9: Clear the border')

% Step-10: Remove the smallest components, leave ten largest
CC = bwconncomp(BWclear);

while CC.NumObjects > 10
    numPixels = cellfun(@numel,CC.PixelIdxList);
    [smallest,idx] = min(numPixels);
    BWclear(CC.PixelIdxList{idx}) = 0;
    CC = bwconncomp(BWclear);
end

figure, imshow(BWclear)
title('Task-4-Step-10: Remove the smallest components, leave ten largest')

% Step-11: Read Swan image
swan = imread("IMG_01_GT.JPG");

figure, imshow(swan)
title('Task-4-Step-11: Read Swan image')

% Step-12: Detect feature points
swanPoints = detectSURFFeatures(swan);
scenePoints = detectSURFFeatures(BWclear);

figure, imshow(swan)
title('Task-4-Step-12: Detect 100 strongest feature swan points')
hold on;
plot(selectStrongest(swanPoints, 100));

figure, imshow(BWclear)
title('Task-4-Step-12: Detect 1000 strongest feature scene points')
hold on;
plot(selectStrongest(scenePoints, 1000));

% Step-13: Find putative point matches
[swanFeatures, swanpoints] = extractFeatures(swan, swanPoints); % Extract feature descriptors
[sceneFeatures, scenePoints] = extractFeatures(BWclear, scenePoints); % Extract feature descriptors

swanPairs = matchFeatures(swanFeatures, sceneFeatures);

matchedSwanPoints = swanPoints(swanPairs(:, 1), :);
matchedScenePoints = scenePoints(swanPairs(:, 2), :);

figure;
showMatchedFeatures(swan, BWclear, matchedSwanPoints, matchedScenePoints, 'montage');
title('Task-4-Step-13: Find putative point matches')

% Step-14: Locate the swan in the scene
[tform, inlierIdx] = estgeotform2d(matchedSwanPoints, matchedScenePoints, 'affine');
inlierSwanPoints   = matchedSwanPoints(inlierIdx, :);
inlierScenePoints = matchedScenePoints(inlierIdx, :);

figure;
showMatchedFeatures(swan, BWclear, inlierSwanPoints, inlierScenePoints, 'montage');
title('Task-4-Step-14: Locate the swan in the scene')


% Task 5: Performance Evaluation ----------------- 
% Step 1: Load ground truth data
% GT = imread("IMG_01_GT.png");

% To visualise the ground truth image, you can
% use the following code.
% figure, imshow(GT)
