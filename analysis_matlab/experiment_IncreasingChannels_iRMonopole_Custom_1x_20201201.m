%% experiment_IncreasingChannels_iRMonopole_Custom_20201201
% This was a modified repeat of the 20200915 experiments with the Gamry,
% using the Custom potentiostat here. A single electrode's impedance was
% measured with an increasing number of channels connected in parallel for
% 3 different PBS concentrations (0p1x, 1x and 2x). 
% Here, I'm specifically trying to figure out how the additional electrodes
% are causing the error using the monopole equation to estimate the deltaV

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
[customStructure_0p1] = ...
    extractCustomPstatData('..\rawData\CustomPot\20201201_TDT22_InVitro_0p1xPBS');
[customStructure_1] = ...
    extractCustomPstatData('..\rawData\CustomPot\20201201_TDT22_InVitro_1xPBS');
[customStructure_2] = ...
    extractCustomPstatData('..\rawData\CustomPot\20201201_TDT22_InVitro_2xPBS');

%% Block 1: Calculate r-r0
% Electrode layout
% __ __ 16 15 14 13 12 11 10 09
% RE __ 08 07 06 05 04 03 02 01

% Spacings; Assuming electrodes have radius of 0
row_spacing = 250e-6; % (m) spacing between electrodes in the same row
col_spacing = 500e-6; % (m) spacing between electrodes in column
ref_spacing = 2 * row_spacing; % distance from E08 to reference

% Distances relative to E05
xaxis_dimensions = [ (4 * row_spacing) ...    %E01
                     (3 * row_spacing) ...    %E02
                     (2 * row_spacing) ...    %E03
                     (1 * row_spacing) ...    %E04
                     (0 * row_spacing) ...    %E05
                     (1 * row_spacing) ...    %E06
                     (2 * row_spacing) ...    %E07
                     (3 * row_spacing) ...    %E08
                     (4 * row_spacing) ...    %E09
                     (3 * row_spacing) ...    %E10
                     (2 * row_spacing) ...    %E11
                     (1 * row_spacing) ...    %E12
                     (0 * row_spacing) ...    %E13
                     (1 * row_spacing) ...    %E14
                     (2 * row_spacing) ...    %E15
                     (3 * row_spacing) ];     %E16                     
yaxis_dimensions = [ 0 ...    %E01
                     0 ...    %E02
                     0 ...    %E03
                     0 ...    %E04
                     0 ...    %E05
                     0 ...    %E06
                     0 ...    %E07
                     0 ...    %E08
                     1 * col_spacing ...  %E09
                     1 * col_spacing ...  %E10
                     1 * col_spacing ...  %E11
                     1 * col_spacing ...  %E12
                     1 * col_spacing ...  %E13
                     1 * col_spacing ...  %E14
                     1 * col_spacing ...  %E15
                     1 * col_spacing ];   %E16
                 
for ii = 1:16
    hypot_dimensions(ii) = sqrt(xaxis_dimensions(ii)^2 + ...
                                yaxis_dimensions(ii)^2 ); % distance to E05 for each electrode
end

%% Block 2: Calculate deltaV at WE surface
% Need to do per group since current will change
% current = amps??
conductivity_val = 2.5;    % S/m From Cogan et al. 2007
conductivity_array = linspace(0.25,2.5,18);
conductivity_array = linspace(0.2,1.5,18);
order_array = [ 3 4 5 6]; 
deltaV_numerator = 1/( 4*pi*conductivity_val );
for ii = 1:4
    kk = order_array(ii);
    for jj = 1:16
        I_temp = customStructure_1(kk).Vpp_sig_rec(:,5)./4.7e3; 
        deltaV_numerator = 1./( 4*pi.*conductivity_val' );
%         deltaV_numerator = 1./( 4*pi.*conductivity_array' );
        deltaV_contribution{ii}(:,jj) = ( deltaV_numerator ) .* ...
                                    ( I_temp./ hypot_dimensions(jj) );
    end
end
%% Block 3: Calculate deltaCurrent
% Use predicted deltaV values to try to predict the change to the current
% at the electrode 
group_add{1} = [06];
group_add{2} = [06 04 13];
group_add{3} = [06 04 13 03 07 12 14];
group_add{4} = [01 02 03 04 06 07 08 09 10 11 12 13 14 15 16];
V_contribution_total = zeros(18,4); % Adds up the contributions to dV WE-Ref for each additional electrode
% Calcualte Voltage drops
for ii = 1:4
    num_electrodes = length(group_add{ii});
    for jj = 1:num_electrodes
        electrode_n = group_add{ii}(jj);
        V_contribution = deltaV_contribution{ii}( :,electrode_n );
        V_contribution_total(:,ii) = V_contribution_total(:,ii) + V_contribution; 
    end
    I_change(:,ii) = V_contribution_total(:,ii)./( customStructure_1(2).Zmag(:,5) + 4.7e3);
    I_change_test(:,ii) = V_contribution_total(:,ii)./( customStructure_1(2).Zreal(:,5) + customStructure_1(2).Zimag(:,5));
    % Comparing a few different ways of calculating current
    I_predicted(:,ii) = (customStructure_1(2).Vpp_sig_rec(:,5)./(4.7e3) - ...
                        I_change(:,ii)); % be sure to change to correct index for each concentration
    I_predicted_test(:,ii) = abs(customStructure_1(2).Vpp_sig_rec(:,5)./(4.7e3) - ...
                        I_change_test(:,ii)); % be sure to change to correct index for each concentration
    Vm = customStructure_1(2).Vpp_sig_rec(:,5);
    Vm_rectangular = Vm.*cosd(-1*customStructure_1(2).Phase(:,5)) + ...
                 1i*Vm.*sind(-1*customStructure_1(2).Phase(:,5));
    I_predicted_test_test(:,ii) = abs(Vm_rectangular./(4.7e3) - ...
                        I_change_test(:,ii));
end
    % Storing the original for comparisons
    I_measured = customStructure_1(2).Vpp_sig_rec(:,5)./(4.7e3);

% Plot current estimates vs actual
figure
colorArray = lines( 4 );
for ii = 1:4
    plot(I_predicted(:,ii), 'o', ...
    'Color', colorArray( ii, : ))
    hold on
    plot(customStructure_1(ii+2).Vpp_sig_rec(:,5)./4.7e3, ...
    'Color', colorArray( ii, : ))
    plot(I_predicted_test(:,ii), '*', ...
    'Color', colorArray( ii, : ))
    plot(I_predicted_test_test(:,ii), '--', ...
    'Color', colorArray( ii, : ))
end
% plot(customStructure_1(2).Vpp_sig_rec(:,5)./4.7e3, ...
%     'Color', colorArray( ii, : ))
xlabel('Frequency Markers')
ylabel('Current')
title('1xPBS')
legend('Predicted', 'Measured')

%% Plot measured vs predicted impedance
figure
colorArray = lines( 4 );
for ii = 1:4
    Vstim = customStructure_1(ii+2).Vpp_ref_rec(:,5);
    Ztot = Vstim./I_predicted(:,ii);
    phases_rec = customStructure_1(ii+2).Phase_rad(:,5);
    Zcomponent = Ztot.*cos(phases_rec) + 1i*Ztot.*sin(phases_rec);
    Zest = abs(Zcomponent - 4.7e3);
    Zest_array(:,ii) = Zest;
    semilogx(customStructure_1(ii+2).f(:,5), ...
         Zest, 'o', ...
    'Color', colorArray( ii, : ), 'LineWidth', 1.5)
    hold on
    semilogx(customStructure_1(ii+2).f(:,5), ...
             customStructure_1(ii+2).Zmag(:,5), ...
    'Color', colorArray( ii, : ), 'LineWidth', 1.5)
end
xlim([70 10000])
ylim([300 20000])
grid on
xlabel('Frequency Markers')
ylabel('Impedance Magnitude')
title('1xPBS')
legend('Predicted', 'Measured')

% % Plot voltage change estimates vs actual %%Fix not comparing the correct voltages%%
% figure
% colorArray = lines( 4 );
% for ii = 1:4
%     plot((-1)*V_contribution_total(:,ii), 'o', ...
%     'Color', colorArray( ii, : ))
%     hold on
%     plot(customStructure_1(ii+2).Vpp_sig_rec(:,5) - customStructure_1(2).Vpp_sig_rec(:,5), ...
%     'Color', colorArray( ii, : ))
% end
% xlabel('Frequency Markers')
% ylabel('Change in Voltage (V)')
% title('1xPBS')
% legend('Predicted', 'Measured')
