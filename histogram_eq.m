FNames = {'meteora_gray_cropped.jpg';
'penang_hill_gray_cropped.jpg';
'foggy_carpark_gray_cropped.jpg'};

for p = 1 : size(FNames)
    figH = figure;
    
    % Read image file
    pic = imread(FNames{p});
    
    % =======================Form original histogram=======================
    h_before = zeros(1,256);
    
    no_of_rows = size(pic,1);
    no_of_columns = size(pic,2);
    
    for i = 1:no_of_rows
        for j = 1:no_of_columns
            curr_pixel_value = pic(i,j);
            h_before(curr_pixel_value + 1) = h_before(curr_pixel_value + 1) + 1;
        end
    end

    % =====Calculate cumulative frequency and Probability Distribution=====
    c_before = zeros(1,256);
    prob_dist = zeros(1, 256);
    
    no_of_pixels = no_of_rows * no_of_columns;
    
    c_before(1) = h_before(1);
    prob_dist(1) = h_before(1) / no_of_pixels;
    
    for i = 2:256 % Array has 1-based indices
        c_before(i) = c_before(i-1) + h_before(i);
        
        % Also, calculate probability distribution
        prob_dist(i) = h_before(i) / no_of_pixels;
    end
    
    % ==================Calculate cumulative probability===================
    c_prob_dist = zeros(1,256);
    
    c_prob_dist(1) = prob_dist(1);
    for i = 2:256
        c_prob_dist(i) = c_prob_dist(i-1) + prob_dist(i);
    end
    
    % ==================Scaled intensity===================
    c_after = zeros(1,256);
    
    for i = 1:256
        c_after(i) = round(c_prob_dist(i) * 255);
    end
    
    % ============================Display plots============================
    h_after = zeros(1,256);
    hPic = zeros(no_of_rows, no_of_columns);

    for i = 1:no_of_rows
        for j = 1:no_of_columns
            pic(i,j);
            new_pixel_value = c_after(pic(i,j)+1);
            hPic(i,j) = new_pixel_value;
            h_after(new_pixel_value + 1) = h_after(new_pixel_value + 1) + 1;
        end
    end
    
    % ============================Display plots============================
    subplot(3,2,1), imshow(pic, [0 255]);
    title('original image');
    subplot(3,2,2), imshow(hPic, [0 255]);
    title('hist equalized image');
    subplot(3,2,3), plot(h_before);
    title('original histogram');
    subplot(3,2,4), plot(h_after);
    title('equalized hist');
    subplot(3,2,5), plot(c_before);
    title('original cumu hist');
    subplot(3,2,6), plot(c_after);
    title('equalized cumu hist');
    
    baseName = FNames{p}(1:find(FNames{p}=='.')-1);
    figName = strcat(baseName, '_histogram_eq_results.jpg');
    
    print(figH, '-djpeg', figName);
end