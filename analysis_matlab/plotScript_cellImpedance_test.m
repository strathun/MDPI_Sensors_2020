%% Create impedances for in vitro test cells
% Just a test of the gamry headstage. Impedance measurements were performed
% or 4 cells (colors) and then plotted with actual (theoretical?) values
% for the cells provided by Tye.

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

%%
[gamryStructure] = ...
    extractImpedanceDataGlobal('..\rawData\Gamry\20200323_DummyCell');
%%
% Generate arrays from actual resistor/capacitor values in the dummy cells

fnm = gamryStructure(1).f;
Rm = 4.7e3;
Rp = 237e3;
Cp1 = 21e-9; ZCp1 = 1./(j*2*pi*fnm*Cp1);
Cp2 = 55e-9; ZCp2 = 1./(j*2*pi*fnm*Cp2);
Crs = 10e-12;ZCrs = 1./(j*2*pi*fnm*Crs);

Rs1 = [1.62e3, 3.16e3, 5.62e3, 7.5e3];
Rs2 = [8.25e3, 10e3, 12.1e3, 14.7e3];
Rs3 = [1.21e3, 2.15e3, 4.22e3, 6.19e3];
Rs4 = [9.09e3, 11e3, 13.3e3, 16.2e3];
Rss = [Rs1 Rs2 Rs3 Rs4];
order = [5 13 6 14 7 15 8 16 4 12 3 11 2 10 1 9];

RR = [Rs1, Rs2, Rs3, Rs4];
Zp1 = (Rp.*ZCp1)./(Rp+ZCp1);
Zp2 = (Rp.*ZCp2)./(Rp+ZCp2);
for ii = 1:length(Zp1)
    Z1(ii,:) = Rs1+Zp1(ii);
    Z2(ii,:) = Rs2+Zp1(ii);
    Z3(ii,:) = Rs3+Zp2(ii);
    Z4(ii,:) = Rs4+Zp2(ii);
end
[a,b] = sort(Rss);
Zarr = [Z1, Z2, Z3, Z4];
Ecellarray = Zarr(b);
for kk = 1:16
    Zarr_ordered(:,kk) = Zarr(:, order(kk))';
end

semilogx(fnm, abs(Zarr_ordered)/1e3,'k-.'); hold on

%% Plot Gamry data on top of cell values
[~, numMeas] = size(gamryStructure);
for ii = 1:numMeas
    semilogx(gamryStructure(ii).f, gamryStructure(ii).Zmag./1e3);
    hold on
end

%% 
% Shows Gamry headstage (dress) is probably not broken. We still can't
% definitively say anything about the gamry itself, when measurement real
% electrodes.