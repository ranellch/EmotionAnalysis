function [ feature_vector] = get_featvec_LGBP( img_path )
%Get feature vector of concatenated LGBP histograms for multiple gabor transforms of 
%segmented eye and mouth regions 

colorI = imread(img_path);
%Segment face

[~, Gabor_Face] = detect_face(colorI); %gives two 600 x 1600 pixel images
% Face = segmentation(I);

% Resizing images to create a square that can be divided easily 
for i=1:18
    Gabor_Face(:,:,i) = imresize(Gabor_Face(:,:,i),[1024 1024]);
end 
%Run Gabor filters on each segment (get 18 different scale/orientation
%images)
% Gabor_Eyes = apply_gabor_wavelet(Eyes,0);
% Gabor_Mouth = apply_gabor_wavelet(Mouth,0);
% Gabor_Face = apply_gabor_wavelet(Face,0);

% run LBP on every gabor transform image for each segment
% concatentate histograms
hists_Face = zeros(1,256*16*18);
% hists_Eyes = zeros(1,256*8*18);
% hists_Mouth = zeros(1,256*8*18);
square_dim = 1024/4;

index=1;
for i=1:18
    Face_transform = Gabor_Face(:,:,i);
%     Eyes_transform = Gabor_Eyes(:,:,i);
%     Mouth_transform = Gabor_Mouth(:,:,i);
    for j= 1:4
        for k= 1:4
%             block_eyes= Eyes_transform((j-1)*dim_y+1:j*dim_y,(k-1)*dim_x+1:k*dim_x);
%             block_mouth = Mouth_transform((j-1)*dim_y+1:j*dim_y,(k-1)*dim_x+1:k*dim_x);
              block_face = Face_transform((j-1)*square_dim+1:j*square_dim,(k-1)*square_dim+1:k*square_dim);
%             hists_Eyes(((index-1)*256+1):index*256)=lbp(block_eyes,10,8,0,'nh');
%             hists_Mouth(((index-1)*256+1):index*256)=lbp(block_mouth,10,8,0,'nh');
            hists_Face(((index-1)*256+1):index*256)=lbp(block_face,10,8,0,'nh');
            index=index+1;
        end
    end
end

%concatenate all feature vectors for eyes and mouth
feature_vector = hists_Face;
% figure, stem(feature_vector)

end

