function [ Iseg ] = gabor_cluster( I,k )
%GABOR_CLUSTER(I, k) Turns N-dimensional Gabor wavelet filtered image into
%standard 2D image with values normalized from 0 to k where 
%k clusters are determined using k-Means and recolored image Iseg is
%provided as output

%run gabor on image
J = apply_gabor_wavelet(I,0);
num_rows = size(I,1);
num_cols = size(I,2);
numVecs= num_rows*num_cols;
allVecs =zeros(numVecs,27);
Iseg = zeros(size(I));
for i= 1:num_rows
    for j= 1:num_cols
        index= (i-1)*num_cols+j;
        allVecs(index,:)=J(i,j,:);
    end
end
[idx, c]= kmeans(allVecs,k,'EmptyAction','singleton');
for i = 1:num_rows
    for j = 1:num_cols
        index = (i-1)*num_cols+j;
        Iseg(i,j) = idx(index)-1; 
    end
end

Iseg=uint8((Iseg./k)*255); %get grayscale image
figure, imshow(Iseg)
end

