%reads in a excel file with two columns; 1 column for the image file names
%and second column for the type of emotions they are
%
%
%Written by Samantha Eaton & Chris Ranella
%for EECS 451 (F13) group project
%
%

%Inputs: filePath is the location of the excel document and images
%Outputs: Naive Bayes classifier object
%Purpose: reads in a excel file with two columns; 1 column for the image file name
%               and second column for the type of emotion it is
function [nb] = build_classifier(featurevectors, emotions)
%NOTE: images is the array of images
%           emotions is the array of emotions
%           position is the array of the positions of images in the
%           original array we used in the classifier
    
    %[~,txt]=xlsread(filePath);
    %numfiles = size(txt,1);
%    hist_vectors = zeros(numfiles,1);
    %emotions = cell(numfiles,1);

    for i = 1:numfiles
      title = txt{i,1};
      emotion = txt{i,2};
     % pause
      I = rgb2gray(imread(title));
%       hist_vectors(i) = get_featvec_LGBP(I);
      hist_vectors(i) = xlsread('all_featvc.xls');
      emotions{i} = emotion;
      % pause
    end


nb = NaiveBayes.fit(hist_vectors, emotions,'uniform');

end