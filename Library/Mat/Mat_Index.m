% File paths
file1 = 'C:\Users\EricY\Desktop\Lumerical_Simulation\Library\Mat\2%_Long_Anneal_Fit_Tol_1e-4_Max_Coeff_10_Rang_1000nm_1600nm.txt';
file2 = 'C:\Users\EricY\Desktop\Comsol_Simulation\Ge-SiO2 (2% doping long annealing) (Shijia-UCSB 2024a n 0.491-1.688 µm).txt';

% --- Load File 1 (skip header lines) ---
numHeaderLines = 10;  % change this to match the actual number of header lines
data1 = readmatrix(file1, 'NumHeaderLines', numHeaderLines);
lambda1 = data1(:, 1);  % wavelength [µm]
n1 = data1(:, 2);       % real refractive index

% --- Load File 2 ---
data2 = load(file2);  % assumes no header
lambda2 = data2(:, 1) * 1e6;  % convert from [m] to [µm]
n2 = data2(:, 2);             % real refractive index

% --- Plot ---
figure;
plot(lambda1, n1, 'b-', 'LineWidth', 2); hold on;
plot(lambda2, n2, 'r--', 'LineWidth', 2);
xlabel('Wavelength [\mum]');
ylabel('Real Refractive Index n');
legend('File 1 (Lumerical)', 'File 2 (COMSOL)');
title('Comparison of Real Refractive Index vs. Wavelength');
grid on;

