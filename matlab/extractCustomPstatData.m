function [dataStructure] = extractCustomPstatData(relPath)
%[f, Zreal, Zim, Phase] = extractCustomPstatData(relPath)
%   This will be a generic function to extract the impedance data from a 
% folder containing mat files recorded with the custom pstat. 
%   Inputs: 
%       relPath: String of relative path of the directory to be analyzed
%                ex. '../rawData/CustomPot/2018-01-30_TDT3_PreSurge'
%   Outputs:
%   dataStructure.
%       fnames : cell containing filenames. Same order as other outputs.
%       f      :
%       Zmag   : 
%       Phase  :


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
    dataStructure(kk-2).Phase = (-1)*( rad2deg( phases_rec ) ) ; % Phase comes in as radians
end

cd(currentFolder)
end

