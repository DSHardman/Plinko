for i = 1:5
    my_colors;
    addtoplot(i-1, colors(i,:));
    hold on
end

my_defaults([488.0000  438.0000  708.2000  420.0000]);
xlim([0 200]);
ylim([0 1.005]);
legend('orientation', 'horizontal', 'location','s');
legend boxoff
xlabel("Iterations");
ylabel("Repeatability");


function addtoplot(number, color)
    load("../Sim2Real/BOFiles/BOTest"+string(number)+".mat");
    plot(1 - BayesoptResults.ObjectiveMinimumTrace, 'LineWidth', 2, 'Color',...
        color, 'DisplayName', "Level " + string(number+1));
end