function [dataStructure] = extractCustomPstatData(relPath)
%[f, Zreal, Zim, Phase] = extractCustomPstatData(relPath)
%   This will be a generic function to extract the impedance data from a 
% folder containing mat files recorded with the custom pstat. 
%   Inputs: 
%       relPath: String of relative path of the directory to be analyzed
%                ex. '../rawData/CustomPot/2018-01-30_TDT3_PreSurge'
%   Outputs:
%   dataStructure.
%       fnames      : cell containing filenames. Same order as other outputs.
%       f           :
%       Zmag        : 
%       Phase       :
%       Vpp_ref_rec : I assume this is the voltage on the reference E?
%       Vpp_sig_rec : Voltage on the working E?
%       I_rec       : Ignore this. THis is a legacy variable that's
%                     unfinished


% Sets relative filepaths
currentFile = mfilename( 'fullpath' );  % Gets path for THIS script
currentFolder = pwd;    % For resetting cd at end of function
cd(fileparts(currentFile));
cd(relPath);

% Grabs all filenames in current directory
listFiles = dir;
fnames = {listFiles.name}';

%% Pull Impedance data into structure
for kk = 3:length( fnames )
    fname = fnames( kk );
    load(fname{1});
    dataStructure(kk-2).fname = fname;
    dataStructure(kk-2).f = f_rec;
    dataStructure(kk-2).Zmag = Zest;
    dataStructure(kk-2).Phase_rad = phases_rec;
    dataStructure(kk-2).Phase = (-1)*( rad2deg( phases_rec ) ) ; % Phase comes in as radians
    dataStructure(kk-2).Vpp_ref_rec = Vpp_ref_rec./37.8723; %Gain
    dataStructure(kk-2).Vpp_sig_rec = Vpp_sig_rec./Av;
    dataStructure(kk-2).I_rec = I_rec./Av; % Gain
    % Calculate and store Zreal. From ...RapidMux_2stage.m script
        Vm = Vpp_sig_rec./Av;
        Im = Vm/(4.7e3);
        Vstim = Vpp_ref_rec/37.8723;
        Ztot = Vstim./Im;
    dataStructure(kk-2).Zreal = Ztot.*cosd(-1*dataStructure(kk-2).Phase); % note, both Zreal and Zimag contain the pd resistor
    dataStructure(kk-2).Zimag = 1i*Ztot.*sind(-1*dataStructure(kk-2).Phase);
    dataStructure(kk-2).Ztest = (Vstim - Vm).*(4.7e3)./Vm;
end

cd(currentFolder)
end

