%% experiment_IncreasingChannels_iRDrops_Custom_20201201
% This was a modified repeat of the 20200915 experiments with the Gamry,
% using the Custom potentiostat here. A single electrode's impedance was
% measured with an increasing number of channels connected in parallel for
% 3 different PBS concentrations (0p1x, 1x and 2x). 
% Here, I'm specifically trying to figure out how the additional electrodes
% are causing the error
% Go back through this one. I think I messed up the estimates for the 1x
% because the order of the measurements is different. 

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

%% Block 1: Estimate Voltage AT each electrode
% Assuming that each additional parallel electrode will have the same
% voltage. 
% 1st added electrode is directly in the path between working and ref so we
% can assume all of its voltage contributed to the error. 
V_parallelE = customStructure_1(2).Vpp_sig_rec(:,5) - ...
              customStructure_1(3).Vpp_sig_rec(:,5);


%% Block 2: Calc each electrodes contribution to the WE-Ref dV
% While each electrode is assumed to have the same voltage, the geometric
% arrangement will mean not all additional electrodes contribute the same
% amount to the WE-Ref voltage drop. 
% Electrode layout
% __ __ 16 15 14 13 12 11 10 09
% RE __ 08 07 06 05 04 03 02 01

% Spacings; Assuming electrodes have radius of 0
row_spacing = 250; % (um) spacing between electrodes in the same row
col_spacing = 500; % (um) spacing between electrodes in column
ref_spacing = 2 * row_spacing; % distance from E08 to reference

xaxis_dimensions = [ (7 * row_spacing) + ref_spacing ...    %E01
                     (6 * row_spacing) + ref_spacing ...    %E02
                     (5 * row_spacing) + ref_spacing ...    %E03
                     (4 * row_spacing) + ref_spacing ...    %E04
                     (3 * row_spacing) + ref_spacing ...    %E05
                     (2 * row_spacing) + ref_spacing ...    %E06
                     (1 * row_spacing) + ref_spacing ...    %E07
                     (0 * row_spacing) + ref_spacing ...    %E08
                     (7 * row_spacing) + ref_spacing ...    %E09
                     (6 * row_spacing) + ref_spacing ...    %E10
                     (5 * row_spacing) + ref_spacing ...    %E11
                     (4 * row_spacing) + ref_spacing ...    %E12
                     (3 * row_spacing) + ref_spacing ...    %E13
                     (2 * row_spacing) + ref_spacing ...    %E14
                     (1 * row_spacing) + ref_spacing ...    %E15
                     (0 * row_spacing) + ref_spacing ];     %E16                     
yaxis_dimensions = [ 0 ...    %E01
                     0 ...    %E02
                     0 ...    %E03
                     0 ...    %E04
                     0 ...    %E05
                     0 ...    %E06
                     0 ...    %E07
                     0 ...    %E08
                     500 ...  %E09
                     500 ...  %E10
                     500 ...  %E11
                     500 ...  %E12
                     500 ...  %E13
                     500 ...  %E14
                     500 ...  %E15
                     500 ];   %E16
                 
for ii = 1:16
    hypot_dimensions(ii) = sqrt(xaxis_dimensions(ii)^2 + ...
                                yaxis_dimensions(ii)^2 ); % hypotenuses for each electrode
    rel_contributions(ii) = (xaxis_dimensions(ii)/hypot_dimensions(ii)) * ... 
                            (xaxis_dimensions(05)/xaxis_dimensions(ii)); % based of E05 which was measured electrode
    if rel_contributions(ii) > 1
        rel_contributions(ii) = xaxis_dimensions(ii)/hypot_dimensions(ii);
    end
end

%% Block 3: Simulation
% Use the values from Block 2 and the groupings in which they were added to
% estimate predicted impedances for each group. 
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
        V_contribution = V_parallelE.*rel_contributions( electrode_n );
        V_contribution_total(:,ii) = V_contribution_total(:,ii) + V_contribution; 
    end
    V_predicted(:,ii) = customStructure_1(2).Vpp_sig_rec(:,5) - ...
                        V_contribution_total(:,ii);
end

% Plot voltage estimates vs actual
figure
colorArray = lines( 4 );
for ii = 1:4
    plot(V_predicted(:,ii), 'o', ...
    'Color', colorArray( ii, : ))
    hold on
    plot(customStructure_1(ii+2).Vpp_sig_rec(:,5), ...
    'Color', colorArray( ii, : ))
end
xlabel('Frequency Markers')
ylabel('WE Voltage (V)')
title('1xPBS')
%% Plot of expected deltaV from the geometric prediction, vs what is
% % actually seen with increasing channel count. 
% % Experimental Values
% measOrder = [2 3 4 5 6]; % selects 0, 1, 3, 7, and 15 parallel electrodes
% freqSelector = [1 10 18]; % selects freqs 100 1k and 7k
% for ii = 1:5
%     jj = measOrder(ii);
%     for kk = 1:3
%         ll = freqSelector(kk);
%         deltaVArray(kk, ii) = customStructure_1(jj).Vpp_ref_rec(ll,5) - ...
%                               customStructure_1(jj).Vpp_sig_rec(ll,5);
%     end
% end
% deltaVArrayNorm = deltaVArray - deltaVArray(:,1); % Remove the initial deltaV with no parallel channels
% 
% % Predicted Values
% 
% 
% % Plot everything
% figure
% additionalChannels = [0 1 3 7 15];
% for ii = 1:3
%     plot(additionalChannels, deltaVArrayNorm(ii, :), '-o')
%     hold on
% end
% legend('100 Hz', '1 kHz', '7 kHz')
% ylabel('DeltaV; Ref vs WE (V)')
% xlabel('Parallel Electrodes')
% 
% % Finish this guy up. use notes above and in notebook for help. Need to
% % incorporate geometric predictions as well. 


