function [GaborTransforms, wavelet] = apply_gabor_wavelet(I, debug)

    %Convert image to double image
    I = im2double(I);

    npeaks = 1;
    theta = [0 30 60 90 120 150];
    lambda = [2 8 16];

    %Get the size of the input image
    [m,n] = size(I);
    
    %Layer all the transformations 
    GaborTransforms = zeros(m, n, length(lambda) * length(theta));
    piece_count = 1;
    gamma = 0.5;
    %Iterate over all gabor wavelets
    for i=1:length(lambda)
        p = 2*2.5*lambda(i)/gamma;
        q = p;
        pad_height = 2^nextpow2(p + m - 1);
        pad_width = 2^nextpow2(q +  n - 1);
        I(pad_height, pad_width) = 0;
        G = fft2(I);
        for j=1:length(theta)

            %Build the gabor wavelet
            [wavelet, ~] = morlet(lambda(i), theta(j), npeaks);
           
            %Convolve the img with the gabor wavelet
            padded_wavelet=wavelet;
            padded_wavelet(pad_height, pad_width) = 0;
            C = ifft2(G.*fft2(padded_wavelet));
            C = real(C(p:p+m-1,q:q+n-1)); %ask about this
            GaborTransforms(:,:,piece_count) = C;
          
            
            if(debug == 1)
                figure(1)
                subplot(length(theta), length(lambda), piece_count)
                imshow(real(wavelet), [])
            
                figure(2)
                subplot(length(theta), length(lambda), piece_count)
                imshow(GaborTransforms(:,:,piece_count))

            end
            
            piece_count = piece_count + 1;
        end
    end
     
    if debug==1
        figure(3)
        imshow(mat2gray(sum(GaborTransforms,3)));
    end
    
end
