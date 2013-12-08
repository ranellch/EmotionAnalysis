function [ face, face_gabors] = detect_face( I )
%FACE = DETECT_FACE(I) finds single face in color image I based on (1) skin
%detection using k-means clustering of feature vectors built from mean CbCr
%values and mean Gabor transform values in grid boxes and (2) eye detection by finding
%holes in skin mask.  FACE is a cropped version of image I

%Generate Gabor filtered images
Igray=rgb2gray(I);
Igabors = apply_gabor_wavelet(Igray,0);

%Apply Grayworld Algorithm for illumination compensation/color balancing
Ibalanced = grayworld(I);
%Convert image from RGB to YCbCr
Iycbcr = rgb2ycbcr(Ibalanced);
Cb = Iycbcr(:,:,2);
Cr = Iycbcr(:,:,3);

blk_size = 20;

%Mirror pad matrices so they are divisible by blk_size
[M, N] = size(Igray);
Q1 = ceil(M/blk_size)*blk_size;
Q2 = ceil(N/blk_size)*blk_size;
Igabors = padarray(Igabors, [Q1-M, Q2-N], 'symmetric', 'post');
Cb = padarray(Cb, [Q1-M, Q2-N], 'symmetric', 'post');
Cr = padarray(Cr, [Q1-M, Q2-N], 'symmetric', 'post');

%Build feature vectors of mean CB, mean Cr, and LBP histogram (i.e. describe color and texture) for each block
%run LBP on dim x dim blocks
vec_rows = Q1/blk_size;
vec_cols = Q2/blk_size;
numvecs= vec_rows*vec_cols;
allvecs =zeros(numvecs,2);
for i= 1:vec_rows
    for j= 1:vec_cols
        index= (i-1)*vec_cols+j;
        Cb_block = Cb((i-1)*blk_size+1:i*blk_size,(j-1)*blk_size+1:j*blk_size);
        Cr_block = Cr((i-1)*blk_size+1:i*blk_size,(j-1)*blk_size+1:j*blk_size);
        allvecs(index,1) = mean2(Cb_block);
        allvecs(index,2) = mean2(Cr_block);
        for k = 1:18
            allvecs(index,2+k) = mean2(Igabors((i-1)*blk_size+1:i*blk_size,(j-1)*blk_size+1:j*blk_size,k));
        end
    end
end
Iseg = zeros(Q1,Q2);
Iskin = Iseg;
k=6;
%Run k-means on vectors and get clusters representing different objects
[idx, c]= kmeans(allvecs,k,'EmptyAction','singleton');
for i = 1:vec_rows
    for j = 1:vec_cols
        index = (i-1)*vec_cols+j;
        %look for skin tone, show binary image of object with Cb and Cr
        %centers in skin tone range
        Iseg((i-1)*blk_size+1:i*blk_size,(j-1)*blk_size+1:j*blk_size) = idx(index);
        if (c(idx(index),1) > 100 && c(idx(index),1) < 140) && (c(idx(index),2) > 135 && c(idx(index),2) < 170) 
            Iskin((i-1)*blk_size+1:i*blk_size,(j-1)*blk_size+1:j*blk_size) = 1; 
        end
    end
end
 
%show segmented clusters
Iseg = Iseg(1:M,1:N)./k;
figure, imshow(Iseg)
colormap(jet)

%get largest skin region
Iskin = logical(Iskin(1:M,1:N));
skinmap = zeros(size(Iskin));

CC = bwconncomp(Iskin);
numPixels = cellfun(@numel,CC.PixelIdxList);
[~,idx] = max(numPixels);

skinmap(CC.PixelIdxList{idx}) = 1;
figure, imshow(skinmap)

% %find eyes
% %get holes in skinmap
% eyemap = ~skinmap;
% CC = bwconncomp(eyemap);
% S = regionprops(CC,'Centroid');
% numholes = size(S,1);
% allcenters = zeros(numholes,2);
% for i = 1:numholes
%     allcenters(i,:) = S(i).Centroid;
% end
% %sort by vertical position 
% allcenters = sortrows(allcenters,-1);
% %find two holes horizontally across from each other within some margin of
% %error
% flag = 0;
% for i = 1:numholes
%     compare1 = allcenters(i,1);
%     for j = 1:numholes
%         if j ==i
%             continue
%         end
%         compare2 = allcenters(j,1);
%         if compare1 <= compare2 + 50 && compare1>= compare2 - 50
%             eyes = [allcenters(i,:); allcenters(j,:)];
%             flag = 1;
%             break
%         end
%     end
%     if flag == 1
%         break
%     end
% end
% 
% eyedist = pdist(eyes);
% eyes  = sortrows(eyes,2);
% lefteye = eyes(1,:);
% righteye = eyes(2,:);
% 
% %show eye region
% eyebox = I(lefteye(1)-.5*eyedist:lefteye(1)+.5*eyedist,lefteye(2)-.5*eyedist:righteye(2)+.5*eyedist,:);
% figure, imshow(eyebox)

%cropping 
[r,c] = find(skinmap);
minRow = min(r);
minCol = min(c);
maxCol = max(c);
top = round(minRow+0.3*(maxCol-minCol));
height = round(1.1*(maxCol - minCol));
width = maxCol - minCol;
faceCrop = [minCol, top, width, height];
face = imcrop(I, faceCrop);

%show face
figure, imshow(face)

face_gabors = Igabors(top:top+height,minCol:maxCol,:);
end

