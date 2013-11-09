function [ feature_vector] = get_featvec( I, numboxes)
%Get feature vector of concatenated LBP histograms for image divided into
%(numboxes) blocks 
sizeI = size(I);

%determine dimensions of boxes
dim_x = floor(sizeI(2)/sqrt(numboxes));
dim_y = floor(sizeI(1)/sqrt(numboxes));

%run LBP on dim x dim blocks
allHists = zeros(1,256*numboxes);
index=1;
for i= 1:sqrt(numboxes)
    for j= 1:sqrt(numboxes)
        block= I((i-1)*dim_y+1:i*dim_y,(j-1)*dim_x+1:j*dim_x);
        hist=lbp(block,1,8,0,'nh');
        allHists((index-1)*256+1:index*256) = hist;
        index=index+1;
    end
end

feature_vector = allHists;

end

