%% combinePalmData
% Eventually turn this into a function if were going to use this more.
% Right now, just wanted a record of what was done. 

relPath = '..\rawData\PalmSens\20200629_TDT22_InVitro_OldPBS\Round3\matlab';

% Sets relative filepaths
currentFile = mfilename( 'fullpath' );  % Gets path for THIS script
currentFolder = pwd;    % For resetting cd at end of function
cd(fileparts(currentFile));
cd(relPath);

% Grabs all filenames in current directory
listFiles = dir;
fnames = {listFiles.name}';


for ii = 3:length(fnames)
    load( fnames{ii} )
    % Grab electrode number
    currentNameStr = (char(fnames(ii)));
    elecIndex = strfind(currentNameStr,'E') + 1;
    elecNum = str2num(currentNameStr(elecIndex:elecIndex+1));

    palmSensStructure( ii - 2 ).Electrode = elecNum;
    palmSensStructure( ii - 2 ).Frequency = eis0_Fixedat41freqs(:,1);
    palmSensStructure( ii - 2 ).Phase = eis0_Fixedat41freqs(:,2);
    palmSensStructure( ii - 2 ).Idc = eis0_Fixedat41freqs(:,3);
    palmSensStructure( ii - 2 ).Z = eis0_Fixedat41freqs(:,4);
    palmSensStructure( ii - 2 ).Zreal = eis0_Fixedat41freqs(:,5);
    palmSensStructure( ii - 2 ).ZIm = eis0_Fixedat41freqs(:,6);
    palmSensStructure( ii - 2 ).Cs = eis0_Fixedat41freqs(:,7);
end

cd(currentFolder)