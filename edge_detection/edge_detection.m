FNames = {
    'Lab3_pictures_set2/carmanBox.jpg';
    'Lab3_pictures_set2/checker.jpg';
    'Lab3_pictures_set2/letterBox.jpg';
    'Lab3_pictures_set2/pipe.jpg'
};

for p = 1 : size(FNames)
    figH = figure;
    pic = imread(FNames{p});
    subplot(1,2,1), imshow(pic);
    title('original image');
    
    edgePic = rgb2gray(pic);
    edgePic = double(edgePic); % Convert to double (so that we can use sqrt later)
    
    height = size(pic,1);
    width = size(pic,2);
    
    for i = 1:height-2 % since multiplying by 3x3 matrix
        for j = 1:width-2 % since multiplying by 3x3 matrix
            %{
            subMat = edgePic([i i+1 i+2],[j j+1 j+2]); % 3x3 submatrix
            hor_edge_strength = horizontalEdgeStrength(subMat);
            vert_edge_strength = verticalEdgeStrength(subMat);
            %}
            
            % More efficient than above (but less elegant :P)
            % since no submatrix, loops, multiplication with 0, etc.
            hor_edge_strength = 1*edgePic(i,j) + 2*edgePic(i,j+1) + 1*edgePic(i,j+2) - 1*edgePic(i+2,j) - 2*edgePic(i+2,j+1) - 1*edgePic(i+2,j+2);
            vert_edge_strength = -1*edgePic(i,j) - 2*edgePic(i+1,j) - 1*edgePic(i+2,j) + 1*edgePic(i,j+2) + 2*edgePic(i+1,j+2) + 1*edgePic(i+2,j+2);
            edgePic(i,j) = sqrt(hor_edge_strength.^2 + vert_edge_strength.^2);
        end
    end
    
    edgePic = uint8(edgePic); % Convert back to 8-bit (grayscale: 2^8 = 256)
    
    subplot(1,2,2), imshow(edgePic);
    title('Sobel edge');
    
    baseName = FNames{p}(1:find(FNames{p}=='.')-1);
    figName = strcat(baseName, '_sobel_edge_detection.jpg');
    print(figH, '-djpeg', figName);
end

% ===================================================================
% ===========================Functions===============================
% ===================================================================

% Returns the horizontal Sobel edge strength for a 3x3 matrix, whose first
% element (top left) is the pixel whose strength is to be detemined
function [hor_strength] = horizontalEdgeStrength(img)
kernel = [1,2,1; 0,0,0; -1,-2,-1];

hor_strength = 0;
for i=1:size(kernel,1)
    for j=1:size(kernel,2)
        hor_strength = hor_strength + (kernel(i,j) * img(i,j));
    end
end

end

% Returns the vertical Sobel edge strength for a 3x3 matrix, whose first
% element (top left) is the pixel whose strength is to be detemined
function [vert_strength] = verticalEdgeStrength(img)
kernel = [-1,0,1; -2,0,2; -1,0,1];

vert_strength = 0;
for i=1:size(kernel,1)
    for j=1:size(kernel,2)
        vert_strength = vert_strength + (kernel(i,j) * img(i,j));
    end
end

end
