%a test excel list
%third column in excel is what program identifies picture as

%output of classification code
%look for file names and see what string was
%compare to string we outputted

function accuracy = get_accuracy(emotion, picture, xlfile)
    [NUM,file]=xlsread(xlfile);
    total_correct = 0;
    total = 0;
    blank = '';
    for i = 1:4
        emotionInFile = file{i,2};
        emotionDeclared = file{i,3};
        if (strcmp(emotion, emotionInFile))   
            if (~(strcmp(emotionDeclared,blank)))
                if (strcmp(emotionInFile,emotionDeclared))
                     total_correct = total_correct+1;
                end
                total = total+1;
            end
        end
   end
%number we got/total number in excel *100
    accuracy = total_correct/total *100;

end