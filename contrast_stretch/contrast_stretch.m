FNames = {
    'Lab3_pictures_set1/meteora_gray_cropped.jpg';
    'Lab3_pictures_set1/penang_hill_gray_cropped.jpg';
    'Lab3_pictures_set1/foggy_carpark_gray_cropped.jpg'
};

mins = {
    23; 
    9; 
    48
};

maxs = {
  225;
  210;
  240
};

cropMins = {
    5; 
    8; 
    36
};

cropMaxs = {
  230;
  212;
  150
};

for p = 1 : size(FNames)
    figH = figure;

    % Read image file
    pic = imread(FNames{p});
    newPic = contrastStretch(FNames{p}, cropMins{p}, cropMaxs{p});

    h_before = histogram(pic);
    h_after = histogram(newPic);
    
    subplot(2,2,1), bar(h_before);
    title('original histogram');
    subplot(2,2,2), bar(h_after);
    title('contrast stretched histogram');
    subplot(2,2,3), imshow(pic, [0 255]);
    title('original image');
    subplot(2,2,4), imshow(newPic, [0 255]);
    title('contrast stretched image');
     
    baseName = FNames{p}(1:find(FNames{p}=='.')-1);
    figName = strcat(baseName, '_contrast_stretch_comparison.jpg');
    print(figH, '-djpeg', figName);
end

% ===================================================================
% ===========================Functions===============================
% ===================================================================

% Function to return histogram of an image
function [hist] = histogram(pic)
height = size(pic,1);
width = size(pic,2);
    
hist = zeros(1,256);

for i = 1:height
    for j = 1:width
        curr_pixel_value = pic(i,j);
        hist(curr_pixel_value + 1) = hist(curr_pixel_value + 1) + 1;
    end
end
end

% Function to get image from filepath contrast stretched from {minI, maxI}
% to {0, 255}
function [newPic] = contrastStretch(filePath, minI, maxI)
pic = imread(filePath);
newPic = pic(:,:,1);

normalisationScale = 255 / (maxI - minI);

% height = size(pic,1);
% width = size(pic,2);
% for i = 1:height
%     for j = 1:width
%         newPic(i, j) = (pic(i,j) - minI) * normalisationScale;
%     end
% end 

newPic = round((pic - minI) * normalisationScale);
end