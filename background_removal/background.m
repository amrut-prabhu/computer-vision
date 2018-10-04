filename = 'traffic.mp4';
videoObj = VideoReader(filename);

width = videoObj.Width;
height = videoObj.Height;
numberOfFrames = videoObj.NumberOfFrames;

disp('Total length of video file (in seconds):');
disp(videoObj.Duration);

disp('Height of the video frame in pixels:');
disp(height);

disp('Width of the video frame in pixels:');
disp(width);

disp('Bits per pixel of the video data:');
disp(videoObj.BitsPerPixel);

disp('Video format as it is represented in Matlab:');
disp(videoObj.VideoFormat);

disp('Frame rate of the video in frames per second:');
disp(videoObj.FrameRate);

for frameNum = 1 : numberOfFrames
    vidFrame = read(videoObj, frameNum);
    image(vidFrame);
    
    if frameNum == 1
        videoBackground = vidFrame;
    else
        videoBackground = (frameNum - 1) / frameNum * videoBackground + 1 / frameNum * vidFrame;
    end

    if mod(frameNum,25) == 0
        disp(frameNum);
    end
end

imshow(videoBackground);
title('Video Background');
imwrite(videoBackground, 'background.png', 'png');

