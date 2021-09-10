load('AllManualPaths.mat');

figure();
set(gcf,'Position', 1000*[0.0386    0.4882    1.4816    0.3708]);
subplot(1,3,1);
Apaths(1).plotpath();
hold on;
for i = 2:100
    Apaths(i).plotpath();
end
%title('A');

subplot(1,3,2);
Bpaths(1).plotpath();
hold on;
for i = 2:100
    Bpaths(i).plotpath();
end
%title('B');

subplot(1,3,3);
Fpaths(1).plotpath();
hold on;
for i = 2:100
    Fpaths(i).plotpath();
end
%title('F');

%{
figure();
Cpaths(1).plotpath();
hold on;
for i = 2:100
    Cpaths(i).plotpath();
end
title('C');

figure();
Dpaths(1).plotpath();
hold on;
for i = 2:100
    Dpaths(i).plotpath();
end
title('D');

figure();
Epaths(1).plotpath();
hold on;
for i = 2:100
    Epaths(i).plotpath();
end
title('E');
%}

%% cycle paths
%{
for i = 1:100
    Fpaths(i).plotpath();
    title(sprintf('%d',i));
    xlim([-800 0]);
    ylim([0 1200]);
    pause();
end
%}