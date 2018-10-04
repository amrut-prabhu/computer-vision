diary on;
close all;
videoFilename = 'traffic.mp4';
videoObj = VideoReader(videoFilename);
numberOfFrames = videoObj.NumberOfFrames;

% Positions (indices) of rectangular window [y1 y2 x1 x2] (row, col)
wp = [
    430 480 1 90; % Lane 2
    430 480 160 280; % Lane 3
    430 480 380 580 % Lane 4
];

global isVehiclePresent;
isVehiclePresent = [
    false;
    false;
    false
];

global vehicleCounts;
vehicleCounts = [0; 0; 0];

% Load/generate background of video
backgroundFile = 'background.png';
if ~exist(backgroundFile, 'file')
    videoBackground = getBackgroundImage(videoObj, numberOfFrames);
	imwrite(videoBackground, backgroundFile, 'png');
else
    videoBackground = imread(backgroundFile); 
end

figureDiff = figure;
% set(gcf, 'units','normalized','outerposition',[0 0 1 1]); % Enlarge figure to full screen

for frameNum = 1 : numberOfFrames
    % Read video frame and convert to image
    vidFrame = read(videoObj, frameNum);
    image(vidFrame);
    
    % Get difference of images to get moving objects
    movingObjects = vidFrame - videoBackground;

	% Convert to binary image
    grayImg = rgb2gray(movingObjects);
	movingObjectsBinary = imbinarize(grayImg, 0.08); % size 480 x 640

    for j = 1 : 3 % since only 3 lanes reach the bottom of image (last row)
        window = movingObjectsBinary(wp(j,1):wp(j,2), wp(j,3):wp(j,4));
        updateVehicleCount(window, j);
        
        if frameNum == 1 
            RGB = insertShape(single(movingObjectsBinary),'Rectangle',[wp(j,3) wp(j,1) wp(j,4)-wp(j,3) wp(j,2)-wp(j,1)],'LineWidth',3);
            subplot(1, 2, 2), imshow(RGB);
            drawnow;
            saveImageFilename = sprintf('counting_vehicles_window_%d.png', j);
            imwrite(RGB, saveImageFilename, 'png'); 
        end
    end
    
    % Display moving objects
    subplot(1, 2, 1), imshow(movingObjects);
    titleStr = sprintf('Frame-wise difference %d', frameNum);
    title(titleStr);
    
    subplot(1, 2, 2), imshow(movingObjectsBinary);
    title('Frame-wise difference in Binary');
    drawnow; % Refresh figure

end

% Display results
fprintf('\nNumber of vehicles in each of the 3 lanes is: %i %i %i\n', vehicleCounts)
result = sprintf('\nNumber of VEHICLES that PARTIALLY crossed the last row of the video is %d', sum(vehicleCounts(:)));
disp(result);

diary off;

% TODO
% Expected answer: 13 vehicles
% Implement a wide window (since cars' windshields aren't detected) which
% counts the number of white pixels in it (using the original binary
% image). If > threshold number of pixels, count as a vehicle.
% Make multiple window positions (for each lane). If all pixels in window
% are black, then set it back to isVehiclePresent = false
% When they pass, increment count

% Function to update the vehicle count of windowNum if there is a new
% vehicle in window
function updateVehicleCount(window, windowNum)
global isVehiclePresent;
global vehicleCounts;

avgPixelValue = mean(window, 'all');
threshold = 0.13;

if avgPixelValue > threshold % if not all pixels are black
    if ~isVehiclePresent(windowNum)
        % Change to vehicle present in window and update count
        isVehiclePresent(windowNum) = true;
        vehicleCounts(windowNum) = vehicleCounts(windowNum) + 1;
        
        % First (leftmost) lane in video isn't considered in calculation
        fprintf('Vehicle crossed in lane %d\n',windowNum+1);
    end
elseif avgPixelValue == 0 
    % If no vehicle at all (completely black), reset back to no vehicles
    % present in window
    isVehiclePresent(windowNum) = false;
end
end

% Function to extract the background from the video using averaging
% technique
function background = getBackgroundImage(videoObj, numberOfFrames)
for frameNum = 1 : numberOfFrames
    vidFrame = read(videoObj, frameNum);
    image(vidFrame);
    
    if frameNum == 1
        background = vidFrame;
    else
        background = (frameNum - 1) / frameNum * background + 1 / frameNum * vidFrame;
    end
end
end