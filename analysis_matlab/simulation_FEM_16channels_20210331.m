%% simulation_FEM_16channels_20210331
% Trying to compare the FEM predicted changes in impedance to those that were
% actually observed in vitro. 
% Trying to match impedance better to in vitro values

close all 
clearvars 

% Sets relative filepaths from this script
currentFile = mfilename( 'fullpath' );
cd(fileparts(currentFile));
addpath(genpath('../matlab'));
addpath(genpath('../rawData'));
addpath(genpath('../output'));
parts = strsplit(currentFile, {'\', '\'});
outputDir = ['../output/' parts{end}];
[~, ~] = mkdir(outputDir);

%% Extract impedance data
[customStructure_floating] = ...
    extractFEMData('..\rawData\FEM\raw-data\20210401_Sweep_floating_40mV_large_16sm');
[customStructure_gnded] = ...
    extractFEMData('..\rawData\FEM\raw-data\20210401_Sweep_gnded_40mV_large_16sm');
[customStructure_1PBS_inVitro] = ...
    extractCustomPstatData('..\rawData\CustomPot\20201201_TDT22_InVitro_1xPBS');
Zest_VCModel = load('..\rawData\Volume-Conductor\20210323_irMonopole_VC_calculation_1xPBS.mat');

%% Floating
numPoints = length(customStructure_floating.f);
Ref_V_mag_floating = abs(customStructure_floating.Ref_V);
Gnd_I_mag_floating = abs(customStructure_floating.Gnd_I(:,5));
Zmag_floating = Ref_V_mag_floating./Gnd_I_mag_floating;
figure(1)
semilogx(customStructure_floating.f(:,1), Zmag_floating(:,1))
hold on
xlabel('Frequency (Hz)')
ylabel('mag(Impedance) (Ohms)')

%% Gnded
numPoints = length(customStructure_gnded.f);
Ref_V_mag_gnded = abs(customStructure_gnded.Ref_V);
Gnd_I_mag_gnded = abs(customStructure_gnded.Gnd_I(:,5));
Zmag_gnd = Ref_V_mag_gnded./Gnd_I_mag_gnded;
figure(1)
semilogx(customStructure_gnded.f(:,1), Zmag_gnd(:,1))
xlabel('Frequency (Hz)')
ylabel('mag(Impedance) (Ohms)')
legend('Floating', 'Grounded')
title('FEM; 1 channel (floating) vs 16 parallel (grounded)')
%%
% Interesting.... Look like the lower frequencies have a big effect on
% impedance that drops off at higher frequencies. 

%% Plot measured vs predicted impedance for all simulations/measurements
figure
colorArray = lines( 2 );
% Plot initial values
% FEM
semilogx(customStructure_floating.f(:,1), ...
         Zmag_floating(:,1), '*', ...
         'Color', colorArray( 1, : ), 'LineWidth', 1.5)
hold on
% VC
semilogx(customStructure_1PBS_inVitro(2).f(:,5), ...
     customStructure_1PBS_inVitro(2).Zmag(:,5), 'o', ...
     'Color', colorArray( 1, : ), 'LineWidth', 1.5)
hold on
% Actual; Note VC is same as actual since VC only estimated changes in imp
semilogx(customStructure_1PBS_inVitro(2).f(:,5), ...
         customStructure_1PBS_inVitro(2).Zmag(:,5), ...
         'Color', colorArray( 1, : ), 'LineWidth', 1.5)
     
% Plot 16e values
% FEM
semilogx(customStructure_gnded.f(:,1), ...
         Zmag_gnd(:,1), '*', ...
         'Color', colorArray( 2, : ), 'LineWidth', 1.5)
hold on
% VC
semilogx(customStructure_1PBS_inVitro(2).f(:,5), ...
     Zest_VCModel(1).Zest_array(:,4), 'o', ...
     'Color', colorArray( 2, : ), 'LineWidth', 1.5)
hold on
% Actual
semilogx(customStructure_1PBS_inVitro(6).f(:,5), ...
         customStructure_1PBS_inVitro(6).Zmag(:,5), ...
         'Color', colorArray( 2, : ), 'LineWidth', 1.5)

xlim([70 10300])
grid on
xlabel('Frequency Markers')
ylabel('Impedance Magnitude')
title('1xPBS')
legend('FEM', 'VC', 'Measured')
title('Impedance for 1 vs 16 channels for all methods')
%% %Change by freq/model

% Calculate % Change
p_Change_FEM = (( Zmag_gnd - Zmag_floating )./ Zmag_floating )*100;
p_Change_VC =  (( Zest_VCModel(1).Zest_array(:,4) - ...
                  customStructure_1PBS_inVitro(2).Zmag(:,5) )./ customStructure_1PBS_inVitro(2).Zmag(:,5) ) * 100;
p_Change_measured = (( customStructure_1PBS_inVitro(6).Zmag(:,5) - ...
                       customStructure_1PBS_inVitro(2).Zmag(:,5) )./ customStructure_1PBS_inVitro(2).Zmag(:,5)) * 100;

figure
% FEM
semilogx(customStructure_gnded.f(:,1), ...
         p_Change_FEM, '*', ...
         'LineWidth', 1.5)
hold on
% VC
semilogx(customStructure_1PBS_inVitro(2).f(:,5), ...
         p_Change_VC, 'o', ...
         'LineWidth', 1.5)
% Actual
semilogx(customStructure_1PBS_inVitro(6).f(:,5), ...
         p_Change_measured, ...
         'LineWidth', 1.5)
xlabel('Frequency (Hz)')
ylabel('% Impedance change')
legend('FEM', 'VC', 'Measured')

%%
% FEM model matches the shape of the % change for the measured, but it is
% shifted down by about 200%... ish...

%% Plotting currents to visualize changes for each method
figure
colorArray = lines( 2 );
% FEM
semilogx(customStructure_gnded.f(:,1), ...
         Gnd_I_mag_floating, '*', ...
         'Color', colorArray( 1, : ), 'LineWidth', 1.5)
hold on
semilogx(customStructure_gnded.f(:,1), ...
         Gnd_I_mag_gnded, '*', ...
         'Color', colorArray( 2, : ), 'LineWidth', 1.5)
% % VC
% semilogx(customStructure_1PBS_inVitro(2).f(:,5), ...
%          p_Change_VC, 'o', ...
%          'Color', colorArray( 1, : ), 'LineWidth', 1.5)

% Actual
semilogx(customStructure_1PBS_inVitro(6).f(:,5), ...
         customStructure_1PBS_inVitro(2).Vpp_sig_rec(:,5)./4.7e3, ...
         'Color', colorArray( 1, : ), 'LineWidth', 1.5)
semilogx(customStructure_1PBS_inVitro(6).f(:,5), ...
         customStructure_1PBS_inVitro(6).Vpp_sig_rec(:,5)./4.7e3, ...
         'Color', colorArray( 2, : ), 'LineWidth', 1.5)
xlabel('Frequency (Hz)')
ylabel('Current (A)')
legend('FEM-1', 'FEM-16', 'Measured-1', 'Measured-16')
title('Current Changes; 1 channel vs 16 parallel')
%% Looking at estimates for surface voltage changes for measured vs simulated
% Estimate deltaV for measured values
I_measured_single = customStructure_1PBS_inVitro(2).Vpp_sig_rec(:,5)./4.7e3;
Ztot_single       = customStructure_1PBS_inVitro(2).Vpp_ref_rec(:,5)./ ...
                    I_measured_single;
Vsurface_single   = I_measured_single .* Ztot_single;
I_measured_16e    = customStructure_1PBS_inVitro(6).Vpp_sig_rec(:,5)./4.7e3;
Vsurface_16e      = I_measured_16e .* Ztot_single;

figure
% Actual
semilogx( customStructure_1PBS_inVitro(6).f(:,5), ...
          Vsurface_single, ...
          'Color', colorArray( 1, : ), 'LineWidth', 1.5)
hold on
semilogx( customStructure_1PBS_inVitro(6).f(:,5), ...
          Vsurface_16e, ...
          'Color', colorArray( 2, : ), 'LineWidth', 1.5)

%FEM 
semilogx(customStructure_gnded.f(:,1), ...
         abs(customStructure_floating.WEOffset_V(:,5)), '*', ...
         'Color', colorArray( 1, : ), 'LineWidth', 1.5)
semilogx(customStructure_gnded.f(:,1), ...
         abs(customStructure_gnded.WEOffset_V(:,5)), '*', ...
         'Color', colorArray( 2, : ), 'LineWidth', 1.5)
     
% REF VOltage for 16e - measured
semilogx( customStructure_1PBS_inVitro(6).f(:,5), ...
          customStructure_1PBS_inVitro(6).Vpp_ref_rec(:,5),'--', ...
          'LineWidth', 1.5)
xlabel('Frequency (Hz)')
ylabel('Voltage (V)')
title('Changes in Surface Voltage')   
%% Estimated impedance change for FEM based on change in V at surface
% Calculate estimated delta_Imp
WE_V_mag_floating = abs(customStructure_floating.WEOffset_V(:,5));
I_est_floating = WE_V_mag_floating./Zmag_floating; % Calculate change in I
Zmag_floating_WEEst = Ref_V_mag_floating./I_est_floating; % Calculate change in Z
%
WE_V_mag_gnded = abs(customStructure_gnded.WEOffset_V(:,5));
I_est_gnded = WE_V_mag_gnded./Zmag_floating; % Calculate change in I
Zmag_gnded_WEEst = Ref_V_mag_gnded./I_est_gnded; % Calculate change in Z
%
delta_Z_est = Zmag_gnded_WEEst - Zmag_floating_WEEst;

% Plot
figure
semilogx(customStructure_gnded.f(:,1), ...
         delta_Z_est)
hold on
semilogx(customStructure_gnded.f(:,1), ...
         (Zmag_gnd - Zmag_floating))
xlabel('Frequency (Hz)')
ylabel('Change in Impedance')
legend('Estimated-FEM', 'Actual-FEM')
title('Impedance Change Estimated from Change in Surface Voltage (FEM)')

% Estimated vs actual current
figure
semilogx(customStructure_gnded.f(:,1), ...
         Gnd_I_mag_gnded, ...
         'Color', colorArray( 1, : ), 'LineWidth', 1.5)
     hold on
semilogx(customStructure_gnded.f(:,1), ...
         I_est_gnded, ...
         'Color', colorArray( 2, : ), 'LineWidth', 1.5)
%% Current heat maps 
% NOTE: This is using the currents through the WE surface instead of the
% Gnd currents used in the calculations above. This is because most gnd
% currents in the floating case are NaN
freq = 9; % index of the frequency to be tested. Change as desired
figure
str = sprintf('Currents at %d Hz', customStructure_gnded.f(freq,1));

subplot(2,1,1)
data_11 = abs(customStructure_floating.WE_I(freq,1:8));
data_22 = abs(customStructure_floating.WE_I(freq,9:16));
h1 = heatmap([data_11;data_22]);
title(str)
subplot(2,1,2)
data_1 = abs(customStructure_gnded.WE_I(freq,1:8));
data_2 = abs(customStructure_gnded.WE_I(freq,9:16));
h2 = heatmap([data_1;data_2]);

%%
% Plot spectral currents for all electrodes
figure
colorArray = lines( 16 );
for ii = 1:16
    semilogx(customStructure_floating.f(:,1), ...
             abs(customStructure_floating.WE_I(:,ii)), 'o', ...
             'Color', colorArray( ii, : ))
    hold on
    semilogx(customStructure_gnded.f(:,1), ...
             abs(customStructure_gnded.WE_I(:,ii)), '-', ...
             'Color', colorArray( ii, : ))
end
xlabel('Frequency (Hz)')
ylabel('Current (A)')
title('Currents for all 16 electrodes; o = 1e, - = 16e')

figure
% Plot impedance for other electrodes for fun
for ii = 1:16
    semilogx(customStructure_gnded.f(:,1), ...
             Ref_V_mag_gnded./abs(customStructure_gnded.Gnd_I(:,ii)), '-', ...
             'Color', colorArray( ii, : ))
    hold on
end
xlabel('Frequency (Hz)')
ylabel('mag(Impedance) (Ohm)')
title('Impedance of all 16 channels (FEM)')