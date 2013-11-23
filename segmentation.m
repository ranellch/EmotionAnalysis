function [Face, Eyes, Mouth] = segmentation(I)

%DETECTING FACE
FDetect = vision.CascadeObjectDetector;
BB = step(FDetect,I);

%Crops image to just the face
figure,Face = imcrop(I,BB); 
imshow(Face); 
title('Face');

%% 

% DETECTING EYES
EyeDetect = vision.CascadeObjectDetector('EyePairBig');
BB = step(EyeDetect,I);

% Adjust to include eyebrows
BB(1:4) = [BB(1) BB(2)-(0.8*BB(4)) BB(3) 1.8*BB(4)];

% Crop image to just eyes and eyebrows
Eyes = imcrop(I, BB);
figure, imshow(Eyes);
title('Eyes');

%% 

%DETECTING MOUTH
MouthDetect = vision.CascadeObjectDetector('Mouth','MergeThreshold',16);
BB=step(MouthDetect,I);
[a, b] = size(BB);

%prints everything it thinks is a mouth
for i = 1:a
    figure, imshow(imcrop(I, BB(i,1:4)));
    title(['Mouth possibility #',num2str(i)]);
end


