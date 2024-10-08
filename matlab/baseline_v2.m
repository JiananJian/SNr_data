path = '../data'; 

files = [...
    "GPe-PV spike times - spiketimes_20Hz", "D1 spike times - 20Hz", ...
%     "GPe-PV spike times - spiketimes_10Hz", "D1 spike times - 10Hz", ...
 %    "GPe-PV spike times - spiketimes_5Hz", "D1 spike times - 5Hz", ...
    ];    
freq = 20; 
isi = cell(size(files)); fspk = cell(size(files)); lspk = cell(size(files));  
for i = 1 : length(files)
    file = files(i);
    T = readtable(fullfile(path, file));
    A = table2array(T(2 : end, :)); A(A >= 2) = nan;
    a = A(2 : end, :) - A(1 : end - 1, :);
    isi{i} = a(:);

    B = floor(A * freq); %  to sample first spikes
    C = B(1 : end, :) - B([1, 1 : end - 1], :); C(1, :) = 1;
    fspk{i} = mod(A(~isnan(A) & C ~= 0), 1 / freq);

    A(isnan(A)) = -1; 
    B = floor(A * freq); %  to sample last spikes
    C = B(1 : end, :) - [B(2 : end, :); -freq * ones(1, size(A, 2))]; 
    lspk{i} = mod(A(C ~= 0), 1 / freq) - 1 / freq;
end
isi = vertcat(isi{:}); isi(isnan(isi)) = [];
bnsz = 0.001; edges = 0 : bnsz : 0.2; 
r = histcounts(isi, edges) / length(isi) / bnsz; 

figure(1); clf; hold on;
h = bar(edges(1 : end - 1), r, 'histc'); h.EdgeColor = 'none'; h.FaceColor = "#0072BD";
xlabel('isi (sec)'); ylabel('pdf (1/sec)');

% calculate first spike rate
fspk = vertcat(fspk{:}); 
bnsz = 0.001; edges = 0 : bnsz : 0.2; 
r = histcounts(fspk, edges) / sum(~isnan(fspk)) / bnsz; 

% plot first spike rate
figure(2); clf; hold on; xlim(edges([1, end])); 
% h = stairs(edges, [r, 0], 'k', 'LineWidth', 1);
h = bar(edges(1 : end - 1), r, 'histc'); h.EdgeColor = 'none'; h.FaceColor = "#0072BD";
xlabel('t_{spk}^1 (sec)', 'FontSize', 15); ylabel('pdf (1/sec)', 'FontSize', 15);

% theoretical plot
isi = sort(isi); 
pdf = cumsum(1 ./ isi, 'reverse') / length(isi);
% stairs([0; isi], [pdf; 0], 'k'); % untrancated trace

i = find(isi > 1 / freq, 1); isi(i) = 1 / freq;
s = pdf(1 : i)' * (isi(1 : i) - [0; isi(1 : i - 1)]);
% stairs([0; isi(1 : i)], [pdf(1 : i); 0] / s, 'k', 'LineWidth', 2); % trancated trace

% calculate last spike rate
lspk = vertcat(lspk{:}); 
bnsz = 0.001; edges = -0.2 : bnsz : 0; 
r = histcounts(lspk, edges) / sum(~isnan(lspk)) / bnsz; 

% plot last spike rate
xlim(-edges(1) * [-1, 1] / 2); 
% h = stairs(edges, [r, 0], 'k', 'LineWidth', 1);
h = bar(edges(1 : end - 1), r, 'histc'); h.EdgeColor = 'none'; h.FaceColor = "#0072BD";
xlabel('t_{spk}^{\pm 1} (sec)', 'FontSize', 15); ylabel('pdf (1/sec)', 'FontSize', 15);

% theoretical plot
% stairs(-[0; isi(1 : i)], [pdf(1 : i); 0] / s, 'k', 'LineWidth', 2); % trancated trace




 
isi = cell(size(files)); fspk = cell(size(files)); lspk = cell(size(files));  
for i = 1 : length(files)
    file = files(i);
    T = readtable(fullfile(path, file));
    A = table2array(T(2 : end, :)); A(A < 2 | A >= 12) = nan;
    a = A(2 : end, :) - A(1 : end - 1, :);
    isi{i} = a(:);

    B = floor(A * freq); %  to sample first spikes
    C = B(1 : end, :) - B([1, 1 : end - 1], :); C(1, :) = 1;
    fspk{i} = mod(A(~isnan(A) & C ~= 0), 1 / freq);

    A(isnan(A)) = -1; 
    B = floor(A * freq); %  to sample last spikes
    C = B(1 : end, :) - [B(2 : end, :); -freq * ones(1, size(A, 2))]; 
    lspk{i} = mod(A(C ~= 0), 1 / freq) - 1 / freq;
end
isi = vertcat(isi{:}); isi(isnan(isi)) = [];
bnsz = 0.001; edges = 0 : bnsz : 0.2; 
r = histcounts(isi, edges) / length(isi) / bnsz; 

figure(1); clf; hold on;
h = bar(edges(1 : end - 1), r, 'histc');
h.EdgeColor = 'none'; h.FaceColor = "#0072BD";
xlabel('isi (sec)'); ylabel('pdf (1/sec)');

% calculate first spike rate
fspk = vertcat(fspk{:}); 
bnsz = 0.001; edges = 0 : bnsz : 0.2; 
r = histcounts(fspk, edges) / sum(~isnan(fspk)) / bnsz; 

% plot first spike rate
figure(2); % clf; hold on; xlim(edges([1, end])); 
% h = bar(edges(1 : end - 1), r, 'histc'); h.EdgeColor = 'none'; h.FaceColor = "#0072BD";
h = stairs(edges, [r, 0], 'k', 'LineWidth', 2);
xlabel('t_{spk}^1 (sec)', 'FontSize', 15); ylabel('pdf (1/sec)', 'FontSize', 15);

% theoretical plot
isi = sort(isi); 
pdf = cumsum(1 ./ isi, 'reverse') / length(isi);
% stairs([0; isi], [pdf; 0], 'k'); % untrancated trace

i = find(isi > 1 / freq, 1); isi(i) = 1 / freq;
s = pdf(1 : i)' * (isi(1 : i) - [0; isi(1 : i - 1)]);
% stairs([0; isi(1 : i)], [pdf(1 : i); 0] / s, 'k', 'LineWidth', 2); % trancated trace

% calculate last spike rate
lspk = vertcat(lspk{:}); 
bnsz = 0.001; edges = -0.2 : bnsz : 0; 
r = histcounts(lspk, edges) / sum(~isnan(lspk)) / bnsz; 

% plot last spike rate
% xlim(-edges(1) * [-1, 1]); 
% h = bar(edges(1 : end - 1), r, 'histc'); h.EdgeColor = 'none'; h.FaceColor = "#0072BD";
h = stairs(edges, [r, 0], 'k', 'LineWidth', 2);
xlabel('t_{spk}^{\pm 1} (sec)', 'FontSize', 15); ylabel('pdf (1/sec)', 'FontSize', 15);

% theoretical plot
% stairs(-[0; isi(1 : i)], [pdf(1 : i); 0] / s, 'k', 'LineWidth', 2); % trancated trace

 
legend('baseline', '', 'stimulated');

%%
isi = isis;
isi(isnan(isi)) = []; isi = sort(isi); r = 1 ./ isi;

figure;stairs(isi,cumsum(r,'reverse') / length(isi)); xlim([0, 0.2]);
xlabel('time (sec)'); ylabel('rate (Hz)')

%% 15sec
figure(2); clf;
freq = [20, 10, 5]; n = length(freq);
edges = 0 : 0.02 : 2; bnsz = edges(2) - edges(1);
N = histcounts(A, edges); r = N / size(A, 2) / bnsz;
for i = 1 : n
    subplot(n, 1, i); hold on;
    h = bar(edges(1 : end - 1), r, 'histc');
    h.EdgeColor = 'none'; h.FaceColor = "#0072BD";
    xticks([0, 2, 12, 15]); ylabel('rate (Hz)');
    title("baseline - " + num2str(freq(i)) + "Hz"); 
end
xlabel('time (sec)');

%% .2sec
A(A >= 2 & A < 12) = nan;
figure(3); clf;
edges = (0 : 0.01 : 1) / freq(3); bnsz = edges(2) - edges(1);
for i = 1 : n
    v = mod(A, 1 / freq(i)); % freq is interpreted as sampling rate of each subplot
    N = histcounts(v, edges); r = N / size(A, 2) / bnsz;
    r = r  / (10 * freq(i));
    subplot(n, 1, i); hold on;
    h = bar(edges(1 : end - 1), r, 'histc');
    h.EdgeColor = 'none'; h.FaceColor = "#0072BD";
    ylabel('rate (Hz)');
    title("baseline - " + num2str(freq(i)) + "Hz");
end
xlabel('time (sec)');

%% 1st spike
figure(4); clf;
edges = (0 : 0.005 : 1) / freq(3); bnsz = edges(2) - edges(1);
for i = 1 : n
    v = mod(A, 1 / freq(i)); B = A - v; 
    C = B(1 : end, :) - B([end, 1 : end - 1], :); v(C == 0) = nan;
    N = histcounts(v, edges); r = N / size(A, 2) / bnsz;
    r = r  / (10 * freq(i));
    subplot(n, 1, i); hold on;
    h = bar(edges(1 : end - 1), r, 'histc');
    h.EdgeColor = 'none'; h.FaceColor = "#0072BD";
    ylabel('rate (Hz)'); ylim([0, 40]);
    title("baseline - " + num2str(freq(i)) + "Hz");
%     for k = 1 : size(A, 2)
%         N = histcounts(v(:, k), edges); r = N / bnsz;
%         r = r  / (10 * freq(i));
%         l = plot(edges(1 : end - 1), r, 'k-'); pause; delete(l);
%     end
end
xlabel('time (sec)');