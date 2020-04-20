%% experiment_inVitro_OCP_Gamry
% The primary goals of this analysis are to get an idea of the range of 
% [electrode offsets or OCP] in vitro within a single array and between 
% arrays of the same type, as well as the time it takes to establish 
% equilibrium potentials and the approximate [shape] of this change with 
% respect to time. 
% All data taken from 20203010 and 20200317?

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
[ocp_preEIS] = ...
    extractEarlyOCPData('..\rawData\Gamry\20200311_TDT21_InVitro_1xPBSNew\Impedance');

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
title( 'Timecourse of OCP for one TDT electrode' )

% Plot OCP of additional electrode 
% meant to be a simple stability test proxy for the rest of the array
figure
timeUpdated = ( ocp_equilibrium( ii ).t + timeLast );
plot( ( ocp_equilibrium( 5 ).t ), ...
        ocp_equilibrium( 5 ).OCP * ( 1e3 ) )
hold on
xlabel( 'Time (s)' )
ylabel( 'OCP (mV)' )
title( 'Timecourse of OCP for one TDT electrode' )

%%
% Looks like the longer measurement balances out around 60 minutes. The
% second measurement taken immediately after (although only measured for 2
% minutes) looks pretty stable changing only about 0.85 mV. 

%% OCP Distributions
numTrodes = length( ocp_preEIS );
% Convert to array for histogram because I'm bad at coding
for ii = 1:numTrodes
    ocpArray(ii) = ocp_preEIS(ii).VvRef(end);
end
figure
h = histogram(ocpArray*(1e3), 16);
% Figure out a better distribution probably...
