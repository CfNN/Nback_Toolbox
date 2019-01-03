% Install.m checks that PsychToolbox is installed and creates directories 
% needed for data analysis

% Set the current MATLAB folder to the folder where this script is stored
disp('Setting the current MATLAB folder to the location of this script');
cd(fileparts(which(mfilename)));

try
    disp(['Psychtoolbox install directory: ' PsychtoolboxRoot]);
catch
    warning('Psychtoolbox not installed. Install it using instructions on this page: http://psychtoolbox.org/download');
end

if ~exist('data_analysis/session_files', 'dir')
    mkdir data_analysis/session_files
    disp('Created directory data_analysis/session_files');
else
    warning('data_analysis/session_files directory already exists');
end
