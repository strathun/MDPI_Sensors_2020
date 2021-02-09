%% troubleshooting_Custom_impedanceCalc
% Basic tests to see if were calculating impedance correctly with Tye's
% original scripts. 

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
[customStructure] = ...
    extractCustomPstatData('..\rawData\CustomPot\20200316_MUX_cellTest');

%% 
Vm = customStructure.Vpp_sig_rec(:,1);
Im = Vm/4.7e3;
Vstim = customStructure.Vpp_ref_rec(:,1);
Ztot = (Vstim)./(Im);
Zcomponent = Ztot.*cos(customStructure.Phase_rad(:,1)) + 1i*Ztot.*sin(customStructure.Phase_rad(:,1));
Zest = abs(Zcomponent - 4.7e3);
figure
plot(Zest)
hold on
plot(Ztot - 4.7e3, '--')
legend('Zest','Ztot - Rm')



%%
Vm = customStructure.Vpp_sig_rec(:,1);
Im = Vm/4.7e3;
Vstim = customStructure.Vpp_ref_rec(:,1);
Ztot = (Vstim-Vm)./(Im);
Zcomponent = Ztot.*cos(customStructure.Phase_rad(:,1)) + 1i*Ztot.*sin(customStructure.Phase_rad(:,1));
Zest = abs(Zcomponent);
plot(Zest, '*')
legend('Zest','Ztot - Rm','Zest-Ross')

% Ross and my method are the same as subtracting Rm directly from Tye's
% Ztot, which should be the impedance magnitude. 

%% Not sure what I'm testing here...
% Vm = customStructure.Vpp_sig_rec(:,1);
% Im = Vm/4.7e3;
% Vstim = customStructure.Vpp_ref_rec(:,1);
% Ztot = (Vstim)./(Im);
% Zcomponent = Ztot.*cos(customStructure.Phase_rad(:,1)) + 1i*Ztot.*sin(customStructure.Phase_rad(:,1));
% Zest = abs(Zcomponent - 4.7e3*cos(customStructure.Phase_rad(:,1)));
% figure
% plot(Zest, '--')
% hold on

%% Comparing proper voltage subtraction methods to Tye's original method
% Tye's Original Method
Vm = customStructure.Vpp_sig_rec(:,1);
Im = Vm/4.7e3;
Vstim = customStructure.Vpp_ref_rec(:,1);
Ztot = (Vstim)./(Im);
Zcomponent = Ztot.*cos(customStructure.Phase_rad(:,1)) + 1i*Ztot.*sin(customStructure.Phase_rad(:,1));
Zest = abs(Zcomponent - 4.7e3);
figure
plot(Zest)
hold on

% PROPER subtraction of Vref - Vm
Vm = customStructure.Vpp_sig_rec(:,1);
Im = Vm/4.7e3;
Vstim = customStructure.Vpp_ref_rec(:,1);
Vm_rectangular = Vm.*cosd(-1*customStructure.Phase(:,1)) + ...
                 1i*Vm.*sind(-1*customStructure.Phase(:,1));
V_diff = abs(Vstim - Vm_rectangular);
Im_rectangular = Im.*cosd(-1*customStructure.Phase(:,1)) + ...
                 1i*Im.*sind(-1*customStructure.Phase(:,1));
Ztot = (V_diff)./(Im);
% Ztot_test = abs((V_diff)./(Im_rectangular)); % Get same value if convert Im to rectangular form as well
% Zcomponent = Ztot.*cos(customStructure.Phase_rad(:,1)) + 1i*Ztot.*sin(customStructure.Phase_rad(:,1));
% Zest = abs(Zcomponent - 4.7e3);
plot(Ztot, '--')
% plot(Ztot_test)

% Cool! This method predicts Tye's original estimates for impedance. The
% issue with the way that I was implementing Ross' method was that I was
% subtracting Vstim and Vm directly when I needed to convert them both to
% rectangular form before doing the subtraction because they were out of
% phase. I'm guessing something similar is going on with the voltage
% divider method: likely it is the EXACT same problem actually. 

% Triple checking method with the voltage divider method

Vm = customStructure.Vpp_sig_rec(:,1);
Im = Vm/4.7e3;
Vstim = customStructure.Vpp_ref_rec(:,1);
Vm_rectangular = Vm.*cosd(-1*customStructure.Phase(:,1)) + ...
                 1i*Vm.*sind(-1*customStructure.Phase(:,1));
% V_diff = abs(Vstim - Vm_rectangular);
Ztot = abs(Vstim - Vm_rectangular).*(4.7e3)./abs(Vm_rectangular);
plot(Ztot, '*')
legend('Tye', 'Drop across Vm', 'Voltage Divider')
ylabel('Impedance Magnitude (Ohm)')
% All 3 methods AGREE!
