% sends prediction to excel

function [out]=update_xl(picture, fileName)
   [NUM,file]=xlsread(fileName); 
   for i=i:48
        emotionDeclared = predict(NB, picture);
        file{i,3} = emotionDeclared;
        
        %write back the file
        var1 = file{i,1};
        var2 = file{i,2};
        var3 = file{i,3};
        num_var = num2str(i);
        A = strcat('A',num_var,':A',num_var);
        B = strcat('B',num_var, ':B', num_var);
        C = strcat('C',num_var, ':C', num_var);
       xlswrite(fileName, var1, A);
       xlswrite(fileName, var2, B);
       xlswrite(fileName, var3, C);
       
    out = 1;
   end
   end