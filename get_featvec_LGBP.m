function [ feature_vector] = get_featvec_LGBP( img_path )
%Get feature vector of concatenated LGBP histograms for multiple gabor transforms of 
%segmented eye and mouth regions 

colorI = imread(img_path);
%Segment face
[~,Eyes,Mouth] = segmentation(colorI);
% Face = segmentation(I);

%Run Gabor filters on each segment (get 18 different scale/orientation
%images)
Gabor_Eyes = apply_gabor_wavelet(Eyes,1);
Gabor_Mouth = apply_gabor_wavelet(Mouth,1);
% Gabor_Face = apply_gabor_wavelet(Face,0);

% run LBP on every gabor transform image for each segment
% concatentate histograms
hists_Eyes = zeros(1,256*18);
hists_Mouth = zeros(1,256*18);
for i=1:18
    hists_Eyes(((i-1)*256+1):i*256)=lbp(Gabor_Eyes(:,:,i),10,8,0,'nh');
    hists_Mouth(((i-1)*256+1):i*256)=lbp(Gabor_Mouth(:,:,i),10,8,0,'nh');
end
% feature_vector = zeros(1,256*18);
% for i = 1:18
%     feature_vector(((i-1)*256+1):i*256)=lbp(Gabor_Face(:,:,i),1,8,0,'nh');
% end

%concatenate all feature vectors for eyes and mouth
feature_vector = [hists_Eyes, hists_Mouth];
figure, stem(feature_vector)

end

