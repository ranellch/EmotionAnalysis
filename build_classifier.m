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
function [nb] = build_classifier(filePath)

    hist_vectors = [];
    emotions = cell(0);
    [~,txt]=xlsread(filePath);
    numfiles = size(txt,1);
    for i = 1:numfiles
      title = txt{i,1};
      emotion = txt{i,2};
     % pause
      I = rgb2gray(imread(title));
      hist_vectors = [hist_vectors; get_featvec(I, 9)];
      emotions = [emotions; emotion];
      % pause
    end


nb = NaiveBayes.fit(hist_vectors, emotions);

end