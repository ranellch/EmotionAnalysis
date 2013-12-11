function [ feature_vector, Face] = get_featvec_LGBP( img_path )
%Get feature vector of concatenated LGBP histograms for multiple gabor transforms of 
%segmented eye and mouth regions 

colorI = imread(img_path);
%Segment face

[Face, Gabor_Faces] = detect_face(colorI); %gives face

Gabor_Faces_resized=zeros(1024,1024,18);
% Resizing images to create a square that can be divided easily 
for i=1:18
    Gabor_Faces_resized(:,:,i) = imresize(Gabor_Faces(:,:,i),[1024 1024]);
end 

% run LBP on every gabor transform image for each segment
% concatentate histograms
hists_Face = zeros(1,256*16*18);

square_dim = 1024/4;

index=1;
for i=1:18
    Face_transform = Gabor_Faces_resized(:,:,i);

    for j= 1:4
        for k= 1:4

              block_face = Face_transform((j-1)*square_dim+1:j*square_dim,(k-1)*square_dim+1:k*square_dim);

            hists_Face(((index-1)*256+1):index*256)=lbp(block_face,10,8,0,'nh');
            index=index+1;
        end
    end
end

%concatenate all feature vectors for eyes and mouth
feature_vector = hists_Face;
% figure, stem(feature_vector)

end

