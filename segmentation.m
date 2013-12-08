function [Face, Eyes, Mouth] = segmentation(colorI)

% Errors at Jai_A.jpg, Jai_Su.jpg
% Can't detect eyes in Jay_A2.jpg
%    


%% 

%DETECTING FACE
grayI = rgb2gray(colorI);
FDetect = vision.CascadeObjectDetector('FrontalFaceLBP');
BB = step(FDetect,grayI);

%Crops image to just the face
Face = imcrop(grayI,BB); 
% size(Face)
% figure
% imshow(Face); 
% title('Face');

%CROP OUT MOUTH USING SKIN DETECTION
[~,skinmap] = generate_skinmap(colorI);
skinmapFace = imcrop(skinmap, BB);
skinmapMouth = imcrop(skinmapFace,[1 round(2*size(Face,1)/3) size(Face,2) size(Face,1)-round(2*size(Face,1)/3)]);
[r,c] = find(skinmapMouth); 
minRow = min(r);
maxRow = max(r);
minCol = min(c);
maxCol = max(c);
CropBox = [minCol minRow maxCol - minCol maxRow - minRow];
Mouth = imcrop(Face, [1 round(2*size(Face,1)/3) size(Face,2) size(Face,1)-round(2*size(Face,1)/3)]);
Mouth = imcrop(Mouth, CropBox);
Mouth = imresize(Mouth,[600 1600]);
% figure, imshow(Mouth);
% title('Mouth');


% 

% DETECTING EYES
EyeDetect = vision.CascadeObjectDetector('EyePairBig');
BB = step(EyeDetect,grayI);

% Adjust to include eyebrows
BB(1:4) = [BB(1) BB(2)-(0.8*BB(4)) BB(3) 1.8*BB(4)];

% Crop image to just eyes and eyebrows
Eyes = imcrop(grayI, BB);
% size(Eyes)
Eyes = imresize(Eyes,[600 1600], 'bilinear');
% figure, imshow(Eyes);
% title('Eyes');

end
% 
% %% 
% 
% %DETECTING MOUTH
% MouthDetect = vision.CascadeObjectDetector('Mouth','MergeThreshold',16);
% 
% % crop the top 70% of face image
% [row, col] = size(I);
% halfrow = 0.7*row;
% croppedI = I(halfrow:row, 1:col);
% 
% BB=step(MouthDetect,croppedI);
% [a, b] = size(BB);
% 
% maxBB = 1;
% maxWidth = 0;
% %find biggest object identified as mouth
% for i = 1:a
%     if(BB(i,4) > maxWidth)
%         maxBB = i;
%         maxWidth = BB(i,4);
%     end
% end
% 
% figure, imshow(imcrop(croppedI, BB(maxBB,1:4)));
% %figure, imshow(imcrop(I, BB));
% title('Mouth');


