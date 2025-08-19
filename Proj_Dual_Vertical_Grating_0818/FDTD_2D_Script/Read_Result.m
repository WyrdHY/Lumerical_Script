val = T_spectrum.T_spectrum;
wl = lambda.lambda(:,:,:,1);
wl = wl(:);

% Spectrum Plot
tag = (T_spectrum.var_1D);
[~,~,N,M] = size(val);
flat = val(:);  
arrays = reshape(flat, [N, M]).';   

fs = 25;
ms = 6;
colors = lines(M);

figure; hold on;
for k = 1:M
    plot(wl*1e9, arrays(k,:)*100, '-o', ...
        'LineWidth',   1.5, ...
        'MarkerSize',  ms, ...
        'Color',       colors(k,:), ...
        'DisplayName', sprintf('F = %.2f',tag(k)));    % <-- your legend labels here
end

grid on;
xlabel('Wavelength (nm)',      'FontSize', fs);
ylabel('Transmission(%)', 'FontSize', fs);
%xlim([1450 1650]);
title('Silicon Grating, Mesh Acc Test, 1550nm', 'FontSize', fs+2);
legend('Location','best', 'FontSize', fs);
set(gca,'FontSize',fs);

%% I would like to plot another one that uses the tag(k) as the x-axis, and the corresponding max(arrays(k,:)) as the y-axis
% Calculate max transmission per curve
max_vals = max(arrays, [], 2);  % [M x 1]

% Sort by tag for nicer plotting (optional but recommended)
[tag_sorted, idx] = sort(tag);
max_sorted = max_vals(idx);

tag_sorted = tag_sorted(2:6);
max_sorted = max_sorted(2:6);
% Fit polynomial (e.g., degree 2)
p = polyfit(tag_sorted, max_sorted, 2);           % quadratic fit
tag_fine = linspace(min(tag_sorted), max(tag_sorted), 200);
fit_vals = polyval(p, tag_fine);

% Plot
figure; hold on;

% Diamond markers for raw data
plot(tag_sorted, max_sorted, 'd', ...
    'LineWidth', 3.5, ...
    'MarkerSize', ms, ...
    'MarkerFaceColor', 'b', ...
    'DisplayName', 'Simulation Data');

% Fitted curve
plot(tag_fine, fit_vals, '--',  'LineWidth', 2,'Color', 'b', 'DisplayName', 'Poly Fit (deg 6)');
% Find max of fitted curve
[fit_y_max, idx_max] = max(fit_vals);
x_max = tag_fine(idx_max);

% Print result
titlett = sprintf('Maximum fitted transmission = %.4f at x = %.3fnm', fit_y_max, x_max);

% Format
grid on;
xlabel('Fiber Position(nm)',        'FontSize', fs);
ylabel('Max Transmission',     'FontSize', fs);
title(titlett, 'FontSize', fs+2);
legend('Location','best', 'FontSize', fs);
set(gca, 'FontSize', fs);


