function [ Iseg, centers ] = LGBP_cluster( I,r, dim, k )
%LGBP_cluster(I, r, dim, k) Runs Gabor filter on input image I and then runs LBP on all transform images.
%r specifies radius of LBPs.  dim specifies the square side length of blocks used to get LBP histograms to use in k-means.
%Recolored image 'Iseg' is provided as output, along with cluster centroids in 'centers'

%gaussian filter image
h=fspecial('gaussian',[10 10], 5);
I = imfilter(I,h);

%run gabor on image
J = apply_gabor_wavelet(I,0);
%run LBP on gabor images
J_lbp=cell(18,1);
for i = 1:18
    J_lbp{i} = lbp(J(:,:,i),r,8,0,'i');
end
%Mirror pad lbp images so they are divisible by dim 
[M, N] = size(J_lbp{1});
Q1 = ceil(M/dim)*dim;
Q2 = ceil(N/dim)*dim;
paddedJ=zeros(Q1,Q2,18);
for i = 1:18
    paddedJ(:,:,i) = padarray(J_lbp{i}, [Q1-M, Q2-N], 'symmetric', 'post');
end

Hist_rows = size(paddedJ,1)/dim;
Hist_cols = size(paddedJ,2)/dim;
numHists= Hist_rows*Hist_cols;
allHists = zeros(numHists,256*18);  
for i= 1:Hist_rows
    for j= 1:Hist_cols
        for l = 1:18 
            index= (i-1)*Hist_cols+j;
            block= paddedJ((i-1)*dim+1:i*dim,(j-1)*dim+1:j*dim,l);
            allHists(index,(l-1)*256+1:l*256)=hist(block(:),256);
        end
    end
end
Iseg = zeros(size(I));
[idx, centers]= kmeans(allHists,k,'EmptyAction','singleton');
for i = 1:Hist_rows
    for j = 1:Hist_cols
        index = (i-1)*Hist_cols+j;
        Iseg((i-1)*dim+1:i*dim,(j-1)*dim+1:j*dim) = idx(index); 
    end
end

%show colored image
Iseg = Iseg(1:size(I,1),1:size(I,2));
Iseg=double(Iseg)./k; %get colors
figure, imshow(Iseg)
colormap(jet)
end

