circles = [0 0 15; 3 3 5; 0 15 10; 0 -10 4];
inclinationProbes = [1, 1, 1; 0.6, 0.6, 0.6; 0.2, 0.2, 0.2];
thetaProbes = [1, 1, 1; 0.6, 0.6, 0.6; 0.2, 0.2, 0.2];
densityProbes = [1, 1, 1; 0.6, 0.6, 0.6; 0.2, 0.2, 0.2];

% Write matrices to text files which are accessed by IceSL
writematrix(circles, 'circles.txt');
[Xq,Yq] = meshgrid((0:63),(0:63));
[X, Y] = meshgrid((0:31.5:63),(0:31.5:63));
writematrix(interp2(X,Y,inclinationProbes,Xq,Yq), 'inclination.txt');
writematrix(interp2(X,Y,thetaProbes,Xq,Yq), 'theta.txt');
writematrix(interp2(X,Y,densityProbes,Xq,Yq), 'density.txt');