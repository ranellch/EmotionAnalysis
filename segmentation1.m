I = rgb2gray(imread('Jai_A.jpg'));

% Crop face
FDetect = vision.CascadeObjectDetector;
BB = step(FDetect,I);
I = imcrop(I,BB); 

figure, imshow(I);
% 
% level = graythresh(I);
% BW = im2bw(I,level);
% figure, imshow(BW);
% 
% I_out = zeros(size(I));
% 
% CC = bwconncomp(BW);
% numPixels = cellfun(@numel,CC.PixelIdxList);
% [biggest,idx] = max(numPixels);
% 
% I_out(CC.PixelIdxList{idx}) = 1;
%  
% figure, imshow(I_out);
% 
% [height, width] = size(I_out);
% [r,c] = find(I_out);
% 
% % cropping 
% minRow = min(r);
% maxRow = max(r);
% minCol = min(c);
% maxCol = max(c);
% topCrop = [minCol minRow maxCol - minCol maxRow - minRow];
% cropped = imcrop(I, topCrop);
% 
% 
% figure, imshow(cropped);
% colormap(gray);