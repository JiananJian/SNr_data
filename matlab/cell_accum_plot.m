%% raster plots
path = '../data'; 
file = "GPe-PV spike times - spiketimes_20Hz"; freq = 20; titlename = 'GPe-nZD'; 
% file = "GPe-PV spike times - spiketimes_10Hz"; freq = 10; titlename = 'GPe-nZD-10Hz'; 
% file = "GPe-PV spike times - spiketimes_5Hz"; freq = 5; titlename = 'GPe-nZD-5Hz'; 
% file = "D1 spike times - 20Hz"; freq = 20; titlename = 'D1-nZD'; 
% file = "D1 spike times - 10Hz"; freq = 10; titlename = 'D1-nZD-10Hz'; 
% file = "D1 spike times - 5Hz"; freq = 5; titlename = 'D1-nZD-5Hz'; 
% file = "GPe-20Hz-withZD"; freq = 20; titlename = 'GPe-wZD'; 
% file = "D1-20Hz-wZD"; freq = 20; titlename = 'D1-wZD'; 

    T = readtable(fullfile(path, file) , 'NumHeaderLines', 1);
    A = table2array(T); 
    [~, i] = sort(sum(~isnan(A)));
    A = A(:, i);
    figure(1); clf; hold on; 
for i = 1 : size(A, 2)
    figure(1); clf; hold on; 
    
    spk0 = A(A(:, i) >= 0 & A(:, i) < 2, i);
    spk1 = A(A(:, i) >= 2 & A(:, i) < 4, i);
    makePlot(spk0 * 1e3, spk1 * 1e3, freq)
    r0 = length(spk0) / 2; r1 = length(spk1) / 2;
    legend("ctrl: " + num2str(r0) + "Hz", "stim: " + num2str(r1) + "Hz", 'Location', 'northwest');

    title("cell " + num2str(i)); ylim([0, inf]);
%     saveas(gcf, "figs\" + titlename + " " + num2str(i) + ".png");
    pause
end

function makePlot(spk0, spk1, freq)
    % spk0, spk1 in ms
    % freq in Hz
    isi = spk0(2 : end) - spk0(1 : end - 1); n = length(isi) - 1;
    plot((0 : n) / n, sort(isi), '-or', 'MarkerSize', 4, 'MarkerFaceColor', 'w')

    isi = spk1(2 : end) - spk1(1 : end - 1); n = length(isi) - 1;
    [~, r] = sort(isi);
    plot((0 : n) / n, isi(r), '-ob', 'MarkerSize', 4, 'MarkerFaceColor', 'w')

    M = floor(spk1 * freq * 1e-3); 
    j = M(1 : end - 1) ~= M(2 : end); % j(k) true if there is a GABA between spk k and spk k+1
    isi(r(~j(r))) = nan;
    plot((0 : n) / n, isi(r), 'ob', 'MarkerSize', 4, 'MarkerFaceColor', 'b')

    ylabel('isi (ms)'); xticks('');
end
