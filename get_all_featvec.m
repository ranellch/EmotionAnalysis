function get_all_featvec(filePath)

[images,~]=xlsread(filePath);


numImages = length(images);

all_featvec = zeros(numImages,256*18*2);

for i = 1:numImages
    all_featvec(i,:) = get_featvec_LGBP(images{i});
end

 xlwrite(all_featvc.xls, all_featvec);

end

