function [ feature_vector] = get_featvec_LGBP( img_path )
%Get feature vector of concatenated LGBP histograms for multiple gabor transforms of 
%segmented eye and mouth regions 

colorI = imread(img_path);
%Segment face
[~,Eyes,Mouth] = segmentation(colorI); %gives two 600 x 1600 pixel images
% Face = segmentation(I);

%Run Gabor filters on each segment (get 18 different scale/orientation
%images)
Gabor_Eyes = apply_gabor_wavelet(Eyes,0);
Gabor_Mouth = apply_gabor_wavelet(Mouth,0);
% Gabor_Face = apply_gabor_wavelet(Face,0);

% run LBP on every gabor transform image for each segment
% concatentate histograms
hists_Eyes = zeros(1,256*8*18);
hists_Mouth = zeros(1,256*8*18);
dim_x = 1600/4;
dim_y = 600/2;
index=1;
for i=1:18
    Eyes_transform = Gabor_Eyes(:,:,i);
    Mouth_transform = Gabor_Mouth(:,:,i);
    for j= 1:2
        for k= 1:4
            block_eyes= Eyes_transform((j-1)*dim_y+1:j*dim_y,(k-1)*dim_x+1:k*dim_x);
            block_mouth = Mouth_transform((j-1)*dim_y+1:j*dim_y,(k-1)*dim_x+1:k*dim_x);
            hists_Eyes(((index-1)*256+1):index*256)=lbp(block_eyes,10,8,0,'nh');
            hists_Mouth(((index-1)*256+1):index*256)=lbp(block_mouth,10,8,0,'nh');
            index=index+1;
        end
    end
end

%concatenate all feature vectors for eyes and mouth
feature_vector = [hists_Eyes, hists_Mouth];
% figure, stem(feature_vector)

end

