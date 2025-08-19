%% Simply x and y 
%try
load('C:\Users\EricY\Desktop\Lumerical_Simulation\Proj_Facet_Lens_Couple_0704\Output\Run_3_FDTD_Facet_1064\FDTD_Verify_SD2um.mat')

x = T_ida.Width*1e6;
y = squeeze(T_ida.T_ida);

fs = 28;
x_name = 'Width(um)';%Var Name
y_name = 'Facet Coupling |s21|^2';
y_x_legend = 'SD=2um';
p_title = '@1064nm, Vary Width, h=2um, 2% Air Clad';
fit_deg = 0;

x_fit = linspace(min(x), max(x), 200);
if fit_deg <1
    y_fit = interp1(x, y, x_fit, 'spline');  % cubic spline
    fit_name = 'Cubic Interp';
else
    p = polyfit(x, y, fit_deg);           
    y_fit = polyval(p, x_fit);
    fit_name = sprintf("Poly Fit(%d)",fit_deg);
end


figure;hold on; 

plot(x, y, 'd', ...
    'LineWidth', 3.5, ...
    'MarkerSize', ms, ...
    'MarkerFaceColor', 'b', ...
    'DisplayName', [y_x_legend,'-',fit_name]);
plot(x_fit, y_fit, '--',  'LineWidth', 2,'Color', 'b', 'HandleVisibility','off');

if 1
    load('C:\Users\EricY\Desktop\Lumerical_Simulation\Proj_Facet_Lens_Couple_0704\Output\Run_3_FDTD_Facet_1064\FDTD_Verify_SD5um.mat')
    x = T_ida.Width*1e6;
    y = squeeze(T_ida.T_ida);
    cb = 'r';
    y_x_legend = 'SD=5um';
        x_fit = linspace(min(x), max(x), 200);
        if fit_deg <1
            y_fit = interp1(x, y, x_fit, 'spline');  % cubic spline
            fit_name = 'Cubic Interp';
        else
            p = polyfit(x, y, fit_deg);           
            y_fit = polyval(p, x_fit);
            fit_name = sprintf("Poly Fit(%d)",fit_deg);
        end
        plot(x, y, 'd', ...
        'LineWidth', 3.5, ...
        'MarkerSize', ms, ...
        'MarkerFaceColor', cb, ...
        'DisplayName', [y_x_legend,'-',fit_name]);
        plot(x_fit, y_fit, '--',  ...
            'LineWidth', 2, ...
            'Color', cb, ...
            'HandleVisibility','off');
end




legend('Location','best', 'FontSize', fs);
xlabel(x_name,        'FontSize', fs);
ylabel(y_name,     'FontSize', fs);
title(p_title, 'FontSize', fs+2);
set(gca,'FontSize',fs);
ylim([0 1]);
%end
%%
val = T_spectrum.T_spectrum;
wl = lambda.lambda(:,:,:,1);
wl = wl(:);

% Spectrum Plot
tag = (T_spectrum.var_1D*1e6);
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
max_vals = max(arrays, [], 2);  
[tag_sorted, idx] = sort(tag);
max_sorted = max_vals(idx);

x = tag_sorted *2;
y = max_sorted;

%%% Edit Here For T_ida v.s var
x_name = 'Spot Diameter(um)';%Var Name
y_name = 'Facet Coupling |s21|^2';
y_x_legend = '@1064nm';
p_title = '2um x 5.5um, Air Clad, 2%';
fit_deg = 6;



p = polyfit(x, y, fit_deg);           
tag_fine = linspace(min(x), max(x), 200);
fit_vals = polyval(p, tag_fine);

% Plot
figure; hold on;

% Diamond markers for raw data
plot(x, y, 'd', ...
    'LineWidth', 3.5, ...
    'MarkerSize', ms, ...
    'MarkerFaceColor', 'b', ...
    'DisplayName', y_x_legend);

% Fitted curve
plot(tag_fine, fit_vals, '--',  'LineWidth', 2,'Color', 'b', 'DisplayName', 'Poly Fit');
% Find max of fitted curve
[fit_y_max, idx_max] = max(fit_vals);
x_max = tag_fine(idx_max);

% Print result
%titlett = sprintf('Maximum fitted transmission = %.4f at x = %.3fnm', fit_y_max, x_max);

% Format
grid on;
xlabel(x_name,        'FontSize', fs);
ylabel(y_name,     'FontSize', fs);
title(p_title, 'FontSize', fs+2);
legend('Location','best', 'FontSize', fs);
set(gca, 'FontSize', fs);
ylim([0 1]);


