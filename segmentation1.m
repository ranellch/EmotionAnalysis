function [Face, Eyes, Mouth] = segmentation1(I)

% Crop face
FDetect = vision.CascadeObjectDetector;
BB = step(FDetect,I);
Face = imcrop(I,BB); 

figure, imshow(Face);

level = graythresh(Face);
BW = im2bw(Face,0.9*level);
figure, imshow(BW);

I_out = zeros(size(Face));

CC = bwconncomp(BW);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);

I_out(CC.PixelIdxList{idx}) = 1;
 
figure, imshow(I_out);

[height, width] = size(I_out);
[r,c] = find(I_out);

% cropping 
minRow = min(r);
maxRow = max(r);
minCol = min(c);
maxCol = max(c);
topCrop = [minCol minRow maxCol - minCol maxRow - minRow];
cropped = imcrop(Face, topCrop);


figure, imshow(cropped);
colormap(gray);