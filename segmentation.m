function [Face, Eyes, Mouth] = segmentation(I)

% Errors at Jai_A.jpg, Jai_Su.jpg
% Can't detect eyes in Jay_A2.jpg
%    


%% 

%DETECTING FACE
FDetect = vision.CascadeObjectDetector;
BB = step(FDetect,I);

%Crops image to just the face, resize
Face = imcrop(I,BB); 
size(Face)
Face = imresize(Face,[2000 2000], 'bilinear');
figure
imshow(Face); 
title('Face');

%Split into portions 
Eyes = imcrop(Face, [1 1 size(Face,2) round(size(Face,1)/2)]);
figure, imshow(Eyes)
Mouth = imcrop(Face, [1 round(size(Face,1)/2) size(Face,2) size(Face,1)-round(size(Face,1)/2)]);
figure, imshow(Mouth)
end

%% 
% 
% % DETECTING EYES
% EyeDetect = vision.CascadeObjectDetector('EyePairBig');
% BB = step(EyeDetect,I);
% 
% % Adjust to include eyebrows
% BB(1:4) = [BB(1) BB(2)-(0.8*BB(4)) BB(3) 1.8*BB(4)];
% 
% % Crop image to just eyes and eyebrows
% Eyes = imcrop(I, BB);
% figure, imshow(Eyes);
% title('Eyes');
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


