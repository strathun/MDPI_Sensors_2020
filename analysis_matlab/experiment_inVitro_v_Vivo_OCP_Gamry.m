%% experiment_inVitro_OCP_Gamry
% This script builds on experiment_inVitro_OCP_Gamry to perform comparisons
% of OCP distributions in vivo and in vitro. 

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

%% Extract OCP Data
[ocp_equilibrium] = ...
    extractOCPData('..\rawData\Gamry\20200311_TDT21_InVitro_1xPBSNew\OCP');
[ocp_equilibrium_inVivo] = ...
    extractOCPData('..\rawData\Gamry\20200316_TDT21_Day03\OCP');
[ocp_preEIS] = ...
    extractEarlyOCPData('..\rawData\Gamry\20200311_TDT21_InVitro_1xPBSNew\Impedance');
[ocp_preEIS_TDT22] = ...
    extractEarlyOCPData('..\rawData\Gamry\20200323_TDT22_InVitro_OldPBS');
[ocp_preEIS_inVivo] = ...
    extractEarlyOCPData('..\rawData\Gamry\20200316_TDT21_Day03\Impedance\Round1');

%% Plot Equilibrium OCP
figure
timeLast = 0; % place holder so OCPs can be plotted chronologically
for ii = 1:4
    timeUpdated = ( ocp_equilibrium( ii ).t + timeLast );
    plot( ( timeUpdated )./60, ...
            ocp_equilibrium( ii ).OCP * ( 1e3 ) )
    hold on
    timeLast = timeUpdated(end);
end
xlabel( 'Time (minutes)' )
ylabel( 'OCP (mV)' )
title( 'Timecourse of OCP for one TDT electrode (In Vitro)' )

% Plot OCP of additional electrode 
% meant to be a simple stability test proxy for the rest of the array
figure
plot( ( ocp_equilibrium( 5 ).t ), ...
        ocp_equilibrium( 5 ).OCP * ( 1e3 ) )
hold on
xlabel( 'Time (s)' )
ylabel( 'OCP (mV)' )
title( 'Timecourse of OCP for one TDT electrode (In Vitro)' )

% Plot of OCP of an in vivo electrode
figure
plot( ( ocp_equilibrium_inVivo.t ), ...
        ocp_equilibrium_inVivo.OCP * ( 1e3 ) )
hold on
xlabel( 'Time (s)' )
ylabel( 'OCP (mV)' )
title( 'Timecourse of OCP for one TDT electrode (In Vivo)' )
%%
% Looks like the longer measurement balances out around 60 minutes. The
% second measurement taken immediately after (although only measured for 2
% minutes) looks pretty stable changing only about 0.85 mV. 

%% OCP Distributions Gamry (in vitro) (TDT21)
numTrodes = length( ocp_preEIS );
% Convert to array for histogram because I'm bad at coding
for ii = 1:numTrodes
    ocpArray(ii) = ocp_preEIS(ii).VvRef(end);
end
figure
h = histogram(ocpArray*(1e3));
h.BinWidth = 5;
xlabel( 'Open Circuit Potential (mV)' )
ylabel( 'Counts' )
title( 'In Vitro OCP Distribution for TDT21; Gamry' )

%% OCP Distributions Gamry (in vitro) (TDT22)
numTrodes = length( ocp_preEIS_TDT22 );
% Convert to array for histogram because I'm bad at coding
for ii = 1:numTrodes
    ocpArray_TDT22(ii) = ocp_preEIS_TDT22(ii).VvRef(end);
end
figure
h = histogram(ocpArray_TDT22*(1e3));
h.BinWidth = 5;
xlabel( 'Open Circuit Potential (mV)' )
ylabel( 'Counts' )
title( 'In Vitro OCP Distribution for TDT22; Gamry' )

%% OCP Distributions Gamry (in vitro) (TDT21 vs TDT22)
numTrodes = length( ocp_preEIS_TDT22 );
% Convert to array for histogram because I'm bad at coding
for ii = 1:numTrodes
    ocpArray_TDT22(ii) = ocp_preEIS_TDT22(ii).VvRef(end);
end
figure
h1 = histogram(ocpArray*(1e3));
h1.BinWidth = 5;
hold on
h2 = histogram(ocpArray_TDT22*(1e3));
h2.BinWidth = 5;
xlabel( 'Open Circuit Potential (mV)' )
ylabel( 'Counts' )
title( 'In Vitro OCP Distribution for Two Arrays; Gamry' )
legend( 'TDT21', 'TDT22' )

%% OCP Distributions Gamry (in vivo vs in vitro) (TDT21)
% Replot histogram from above
numTrodes = length( ocp_preEIS );
% Convert to array for histogram because I'm bad at coding
for ii = 1:numTrodes
    ocpArray(ii) = ocp_preEIS(ii).VvRef(end);
end
figure
h1 = histogram(ocpArray*(1e3));
hold on
h1.BinWidth = 5;

% Plot in vivo data
numTrodes = length( ocp_preEIS_inVivo );
% Convert to array for histogram because I'm bad at coding
for ii = 1:numTrodes
    ocpArray_inVivo(ii) = ocp_preEIS_inVivo(ii).VvRef(end);
end
h2 = histogram(ocpArray_inVivo*(1e3));
h2.BinWidth = 5;
xlabel( 'Open Circuit Potential (mV)' )
ylabel( 'Counts' )
title( 'In Vitro vs In Vivo OCP Distribution for TDT21; Gamry' )
legend( 'In Vitro', 'In Vivo' )

