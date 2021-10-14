figure();

subplot(3,2,1);
s2xa.plotpaths('k', 140);
s2xb.plotpaths('r', 120);
title('5mm Small Centre');

subplot(3,2,2);
l2xa.plotpaths('k', 140);
l2xb.plotpaths('r', 120);
l2xc.plotpaths('b', 100);
title('5mm Large Centre');

subplot(3,2,4);
l1xa.plotpaths('k', 140);
l1xb.plotpaths('r', 120);
l1xc.plotpaths('b', 100);
title('5mm Large Offset');

subplot(3,2,5);
l2ya.plotpaths('k', 140);
l2yb.plotpaths('r', 120);
title('3mm Large Centre');

subplot(3,2,6);
l1ya.plotpaths('k', 140);
l1yb.plotpaths('r', 120);
title('3mm Large Offset');

subplot(3,2,3);
imshow(imread('PMMATests/Positions.png'))

set(gcf, 'Position', 1000*[0.1458    0.0714    1.1704    0.7968]);