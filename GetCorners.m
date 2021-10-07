v = VideoReader('PMMATests/Videos/PMMA_L1_YB.wmv');
im = read(v,1000);
imshow(im);
hold on
ginput(4)
close();