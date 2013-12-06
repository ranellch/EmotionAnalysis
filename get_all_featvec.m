function get_all_featvec()

dirpath = '451ProjectPictures/Labeled Pics/';
imageFiles = dir(dirpath);
names = setdiff({imageFiles.name},{'.','..'});

namePath = strcat(dirpath,names);

numImages = length(names);

all_featvec = zeros(numImages,256*18*2);

for i = 1:numImages
    all_featvec(i,:) = get_featvec_LGBP(namePath{i});
end

 xlwrite(all_featvc.xls, all_featvec);

end

