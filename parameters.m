
%excelFile.m
%reads in a excel file with two columns; 1 column for the image file name
%and second column for the type of emotion it is
%
%
%Written by Samantha Eaton
%for EECS 451 (F13) group project
%
%
hist_vector = cell(0);
emotions = cell(0);

for i = 1:4
    [NUM,file]=xlsread('testXL.xlsx');
    title = file{i}
    emotion = file{i,2}
   % pause
    I = rgb2gray(imread(title));
    hist_vector = [hist_vector; get_featvec(I, 9)]
    emotions = [emotions; emotion]
    % pause
end