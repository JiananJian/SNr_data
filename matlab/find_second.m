path = '.';
edges = (0 : 0.005 : 1) / 5;
bnsz = edges(2) - edges(1);
freq = [20, 10, 5]; n = length(freq);
file = ["D1 spike times - ", "GPe-PV spike times - spiketimes_"];
stim = ["D1", "GPe"];
for j = 1 : length(file)
    figure(j); clf; 
    for i = 1 : n
        T = readtable(fullfile(path, file(j) + num2str(freq(i)) + "Hz"));
        A = table2array(T(2 : end, :)) - 2; A(A < 0 | A >= 10) = nan;
        v = [];
        for k = 1 : 200
            [row, col] = find(A >= (k-1)/freq(i) & A < k/freq(i));
            [~, ia] = unique(col);
            for l = 1 : length(ia)
                A(row(ia(l)), col(ia(l))) = nan;
            end

            [row, col] = find(A >= (k-1)/freq(i) & A < k/freq(i));
            [~, ia] = unique(col);
            w = ia * 0;
            for l = 1 : length(ia)
                w(l) = A(row(ia(l)), col(ia(l))) - (k-1) / freq(i);
            end
            v = [v; w];
        end
        N = histcounts(v, edges) / size(A, 2) / bnsz;
        subplot(n, 1, i); hold on;
        h = bar(edges(1 : end - 1), N / (10 * freq(i)), 'histc');
        h.EdgeColor = 'none'; h.FaceColor = "#0072BD";
        title(stim(j) + "-nZD-" + num2str(freq(i)) + "Hz"); 
    end
    xlabel('time (sec)');
end