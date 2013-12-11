
function [featureCat,emotions,nb,testInfo,testPositions] = class_split(featvecfile)
 
    [~, imageInfo]=xlsread('imageInfo.xlsx');
    
    flag = [3 4 7 9 19 48 55 56 57 59 65 66 67 68 74 75 76 77 78 79 80 81 84 85 86 89 94 95 96 98 100 101];
%     images = []; positions = []; 
    emotions = [];
    testInfo = []; testPositions = []; featureCat = [];
    happy_ct = 0; sad_ct = 0; sur_ct = 0; angry_ct = 0; neut_ct = 0;

    % first round has pictures startBound to endBound as being predicted
    startBound = 0;
    endBound = 10;

%         emotion = imageInfo{imagePosition,2};
%         pic = imageInfo{imagePosition,1};

        for imagePosition=1:length(imageInfo)
            %happy emotions for classifier
            if not(ismember(imagePosition,flag(:)))
                if strcmp('happy', imageInfo{imagePosition,2})
                	update(happy_ct,imagePosition);
                    happy_ct = happy_ct + 1; 
                elseif strcmp('sad',imageInfo{imagePosition,2})
                    update(sad_ct,imagePosition);
                    sad_ct = sad_ct +1;
                elseif strcmp('surprised', imageInfo{imagePosition,2})
                	update(sur_ct,imagePosition);
                    sur_ct = sur_ct + 1;
                elseif strcmp('angry', imageInfo{imagePosition,2})
                    update(angry_ct,imagePosition);
                    angry_ct = angry_ct + 1;
                elseif strcmp('neutral', imageInfo{imagePosition,2})
                	update(neut_ct,imagePosition);
                    neut_ct = neut_ct + 1; 
                end
            end
            happy_ct
            sad_ct
            sur_ct
            angry_ct
            neut_ct 
            
        end   
        
        size(featureCat)
  
        % call the build_classifier and predict
        nb = NaiveBayes.fit(featureCat, emotions,'Prior','uniform','Distribution', 'mvmn');
        
 


function update(count,imagePosition)
    if (count > startBound) && (count <= endBound)   
        % ADD IMAGE TO CLASSIFIER
        temp = csvread(featvecfile, imagePosition-1,0,[imagePosition-1,0,imagePosition-1,73669]);
        featureCat= [featureCat; temp];
        emotions  = [emotions ; cellstr(imageInfo{imagePosition,2})]
    else
        % ADD IMAGE TO TESTING
        % add to each array
        temp = csvread(featvecfile, imagePosition-1,0,[imagePosition-1,0,imagePosition-1,73669]);
        testInfo = [testInfo; temp];
        testPositions = [testPositions; imagePosition]
    end
end

end