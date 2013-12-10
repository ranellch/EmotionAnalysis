function get_all_featvec(filePath)

[~,images]=xlsread(filePath);


numImages = length(images);


all_featvec = zeros(numImages,256*18*16);

for i = 1:numImages
       [all_featvec(i,:), faceImage] = get_featvec_LGBP(images{i});
       imwrite(faceImage,int2str(i));
end
% insert featvec into excel sheet
 csvwrite('featvec.csv', all_featvec);

end

