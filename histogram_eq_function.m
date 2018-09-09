FNames = {'meteora_gray.jpg';
'penang_hill_gray.jpg';
'foggy_carpark_gray.jpg'};

histogram_equilise(FNames{1});
histogram_equilise(FNames{2});
histogram_equilise(FNames{3});


function f = histogram_equilise(filename)
    figH = figure;
    
    I = imread(filename);
    J = histeq(I);
    subplot(2,2,1);
    imshow( I );
    subplot(2,2,2);
    imhist(I)
    subplot(2,2,3);
    imshow( J );
    subplot(2,2,4);
    imhist(J)
    
    baseName = filename(1:find(filename=='.')-1);
    figName = strcat(baseName, '_histeq_function.jpg');
    print(figH, '-djpeg', figName);
end