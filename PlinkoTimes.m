tic
times = zeros(100,2);

for i = 1:100
    waitforbuttonpress;
    ts = toc;
    fprintf("Iteration %d Started\n", i);
    waitforbuttonpress;
    tf = toc;
    fprintf("Iteration %d Finished\n", i);
    times(i,:) = [ts tf];
end