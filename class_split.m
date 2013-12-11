
function class_split(featvecfile)
 
    [num, imageInfo]=xlsread('imageInfo.xls');
    
    images = []; positions = []; emotions = [];
    testInfo = []; testPositions = [];
    happy_ct = 0; sad_ct = 0; sur_ct = 0; angry_ct = 0; neut_ct = 0;

    % first round has pictures startBound to endBound as being predicted
    startBound = 0;
    endBound = 6;

    for i=1:4
        emotion = imageInfo{imagePosition,2};
        pic = imageInfo{imagePosition,1};

        for imagePostion=1:num
            %happy emotions for classifier
            if strcmp('happy',emotion)
            	update(happy_ct);
            elseif strcmp('sad',emotion)
            	update(sad_ct);
            elseif strcmp('surprised',emotion)
            	update(sur_ct);
            elseif strcmp('angry',emotion)
            	update(angry_ct);
            elseif strcmp('neutral',emotion)
             	update(neut_ct);
            end
        end   

        % call the build_classifier and predict
        nb = build_classifier(images, emotions, positions);
        predictions = predict(nb, testInfo);
        
        for i=1:length(testPositions)
           row = testPositions(i);
           prediction = predictions(i);
           C = strcat('C',i,':C',i);
           xlswrite('imageInfo.xls', prediction, C);
        end
         
        %  call to accuracy function
        accuracy_of_happy = get_acc('happy', 'imageInfo.xls') %call happy
        accuracy_of_neut = get_acc('neutral', 'imageInfo.xls') %call neutral
        accuracy_of_sad = get_acc('sad', 'imageInfo.xls') %call sad
        accuracy_of_supr = get_acc('suprised', 'imageInfo.xls') %call suprised
        accuracy_of_angry = get_acc('angry', 'imageInfo.xls') %call angry
        accuracy_total = (accuracy_of_happy + accuracy_of_neut + accuracy_of_sad + accuracy_of_supr + accuracy_of_angry)/5
        
        pause; 

        % shift the bounds to run a different set of testers
        startBound = startBound + 5;
        endBound = endBound + 5;
    end



function update(count)
	count = count + 1;
    if (count > startBound) && (count < endBound)   
        % ADD IMAGE TO TESTING
        temp = csvread(featvecfile, position,:);
        testInfo = [testInfo; temp];
        testPositions = [testPositions; imagePosition];
    else
        % ADD IMAGE TO CLASSIFER
        % add to each array
        images = [images; pic];
        emotions = [emotions; emotion];
        positions = [positions; imagePosition];
    end
end

end