tic
n = 30;

times = zeros(n,2);

for i = 1:n
    waitforbuttonpress;
    ts = toc;
    fprintf("Iteration %d Started\n", i);
    waitforbuttonpress;
    tf = toc;
    fprintf("Iteration %d Finished\n", i);
    times(i,:) = [ts tf];
end