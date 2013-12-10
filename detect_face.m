function [ face, face_gabors, S] = detect_face( I )
%FACE = DETECT_FACE(I) finds single face in color image I based on (1) skin
%detection using k-means clustering of feature vectors built from CbCr
%values and Gabor transform values in resized image and (2) eye detection by finding
%holes in skin mask.  FACE is a cropped version of image I

%Generate Gabor filtered images from fullsize image
Igray=rgb2gray(I);
H = fspecial('gaussian',[9 9], 3);
Igray = imfilter(Igray,H, 'same');
Igabors = apply_gabor_wavelet(Igray,0);

%Apply Grayworld Algorithm for illumination compensation/color balancing
Ibalanced = grayworld(I);
%Convert image from RGB to YCbCr 
Iycbcr = rgb2ycbcr(Ibalanced);
Cb = Iycbcr(:,:,2);
Cr = Iycbcr(:,:,3);

blk_size = 10;

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
%figure, imshow(Iseg)
colormap(jet)

%get largest skin region
Iskin = logical(Iskin);
skinmap = zeros(size(Iskin));

CC = bwconncomp(Iskin);
numPixels = cellfun(@numel,CC.PixelIdxList);
[~,idx] = max(numPixels);

skinmap(CC.PixelIdxList{idx}) = 1;
%figure, imshow(skinmap)

%**********Find Eyes*****************************
 %get holes in skinmap
   eyemap = imclearborder(~skinmap);
%    %figure, imshow(eyemap)

   CC = bwconncomp(eyemap);
   S = regionprops(CC,'all');

%   Checking all blobs in image and returning array of eccentricity values 
%   Filtering by range of eye eccentricity and returning index values 
     inEccRange = [S.Eccentricity] > 0.75 & [S.Eccentricity] < 0.9;
     indexarr =find(inEccRange);
     
     flag=0;
     if isempty(indexarr) || length(indexarr) ==1
         flag = 1;
     end
     
     if ~flag
    %    Creating four dimensional array with each column representing :
    %    xcoord of center | ycoord of center  | eccentricity | area  
         potEyes = [cat(1,S(indexarr).Centroid) [S(indexarr).Eccentricity]' [S(indexarr).Area]' indexarr'];

    %    Sorting based on area to eliminate small blobs 
         potEyesSort = sortrows(potEyes,-4);

         filteredEyes = potEyesSort;
    %    Get five biggest elements 
         if size(potEyesSort,1) >= 5
             filteredEyes = potEyesSort(1:5,:);
         end

         X = filteredEyes(:,1);
         Y = filteredEyes(:,2);
         eye1 = 1;
         eye2 = 2;
         
       if size(filteredEyes,1) >=3
        %   Get elements that contain the most variance in grayscale image
           maxVar1 = 0;
           for i = 1:size(filteredEyes,1)
               grayscale_object = Igray(S(filteredEyes(i,5)).PixelIdxList);
               currentVar = var(double(grayscale_object(:)));
               if currentVar > maxVar1
                   maxVar1 = currentVar;
                   eye1 = i;
               end
           end
           maxVar2 = 0;
           for j = 1:size(filteredEyes,1)
               if j == eye1;
                   continue
               end
               grayscale_object = Igray(S(filteredEyes(j,5)).PixelIdxList);
               currentVar = var(double(grayscale_object(:)));
               if currentVar > maxVar2
                   maxVar2 = currentVar;
                   eye2 = j;
               end
           end   
        end
       
         %Check to make sure they are actually a pair of eyes.  Look for
         %significant variance along with horizontal alignment
         if abs(atand((Y(eye1)-Y(eye2))/(X(eye1)-X(eye2)))) <20 
           %figure;
           imshow(eyemap);
           hold on
           plot(X(eye1),Y(eye1), 'or')
           plot(X(eye2),Y(eye2), 'or')
           hold off
         else 
             flag=1;
         end
     end

     if ~flag %Crop face based on position and separation of eyes. Place eyes in the top third of the face window
        eyes = sortrows([X(eye1) Y(eye1); X(eye2) Y(eye2)], 1);
        eyedist = pdist(eyes);
        centerpoint = [eyes(1,1)+(eyes(2,1)-eyes(1,1))/2,eyes(1,2)+(eyes(2,2)-eyes(1,2))/2];
        [r,~] = find(skinmap);
        minRow = min(r);
        top = minRow+round(0.5*(centerpoint(2)-minRow));
        height = 2*round((centerpoint(2)-minRow));
        head_top = centerpoint(1)-2*eyedist;
        if head_top <1
            head_top=1;
        end
        head_bot = centerpoint(1)+2*eyedist;
        if head_bot > M
            head_bot=M;
        end
        head_left = centerpoint(1)-2*eyedist;
        if head_left <1
            head_left=1;
        end
        head_right = centerpoint(1)+2*eyedist;
        if head_right >N
            head_right=N;
        end
        head = skinmap(head_top:head_bot,head_left:head_right);
        [~,c] = find(head);
        minCol = min(c);
        maxCol = max(c);
        width = maxCol - minCol;
        faceCrop = [minCol, top, width, height];
        face = imcrop(I, faceCrop);
     
     else
         %do dumb cropping 
        [r,c] = find(skinmap);
        minRow = min(r);
        minCol = min(c);
        maxCol = max(c);
        top = round(minRow+0.3*(maxCol-minCol));
        height = round(1.1*(maxCol - minCol));
        bot = top+height;
        if top <1
            top=1;
        end
        if bot > M
            height=M-top;
        end
        width = maxCol - minCol;
        faceCrop = [minCol, top, width, bot-top];
        face = imcrop(I, faceCrop);
     end

%show face
 %%figure, imshow(face)

face_gabors = Igabors(top:top+height,minCol:minCol+width,:);
end

