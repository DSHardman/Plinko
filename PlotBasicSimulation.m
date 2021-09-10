% SimulatedPaths1(273,1) = Pathtaken();
% 
% for i = 1:273
%     load(sprintf('1rad/Path%d.txt',i));
%     eval(sprintf('path = [Path%d(:,2) -Path%d(:,1)];',i,i));
%     SimulatedPaths1(i,1) = Pathtaken(path);
%     eval(sprintf('clear Path%d;',i));
% end

%%

subplot = @(m,n,p)subtightplot(m,n,p,[0.001 0.005], [0.005 0.1], [0.01 0.01]);

load('SimulatedDiskRadii.mat');
figure();
subplot(1,4,1);
for i = 1:273
    SimulatedPaths8(i).plotpath()
    hold on
end
title('Radius = 8mm');

subplot(1,4,2);
for i = 1:273
    SimulatedPaths4(i).plotpath()
    hold on
end
title('Radius = 4mm');

subplot(1,4,3);
for i = 1:273
    SimulatedPaths2(i).plotpath()
    hold on
end
title('Radius = 2mm');

subplot(1,4,4);
for i = 1:273
    SimulatedPaths1(i).plotpath()
    hold on
end
title('Radius = 1mm');

set(gcf, 'Position', 10^3*[0.0026    0.5074    1.5152    0.3516]);