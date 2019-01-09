% A script that tests the genRandomBlock function by running it many times
% and exploring the properties of the resulting distribution(s).
% genRandomBlock is the key function of GenRandomTrials, which generates a
% sequence of randomized trial blocks for the Nback task. 

% Set the current MATLAB folder to the folder where this script is stored
cd(fileparts(which(mfilename)));

addpath("./cellhist");
addpath("./rotateticklabel");

% Set the current MATLAB folder to the folder where this script is stored
cd(fileparts(which(mfilename)));

% Add the GenRandomTrials function folder to the MATLAB path
addpath('./../code_backend/GenRandomTrials');
           
stimulusList = {
                'a', 'A';
                'b', 'B';
                'c', 'C';
                'd', 'D';
                'e', 'E';
                'f', 'F';
                'g', 'G';
                'h', 'H';
                'i', 'I';
                'j', 'J';
                'k', 'K';
                'l', 'L';
                'm', 'M';
                'n', 'N';
                'o', 'O';
                'p', 'P';
                'q', 'Q';
                'r', 'R'; 
                's', 'S';
                't', 'T';
                'u', 'U';
                'v', 'V'; 
                'w', 'W';
                'x', 'X';
                'y', 'Y';
                'z', 'Z';
               };

zeroBackYesStimuli = {'h', 'H'};

%% 112,000 samples (1,008,000 letters)
N = 112000;

% 0-back with 9 trials, 33% "yes" trials in each block
[nOccurences_0_9_3, ~] = make_letter_hist([0 9 3], N, stimulusList, zeroBackYesStimuli, true);

%% 70,000 samples (1,050,000 letters)
N = 70000;

% 2-back with 15 trials, 33% "yes" trials in each block
[nOccurences_2_15_5, ~] = make_letter_hist([2 15 5], N, stimulusList, zeroBackYesStimuli, true);

%% 10,000 samples (1,000,000 letters)
N = 10000; 

% 0-back with 100 trials, 33% "yes" trials in each block
[nOccurences_0_100_33, ~] = make_letter_hist([0 100 33], N, stimulusList, zeroBackYesStimuli, true);

% 2-back with 100 trials, 33% "yes" trials in each block
[nOccurences_2_100_33, ~] = make_letter_hist([2 100 33], N, stimulusList, zeroBackYesStimuli, true);

% 5-back with 100 trials, 50% "yes" trials in each block
[nOccurences_5_100_50, letterChars] = make_letter_hist([5 100 50], N, stimulusList, zeroBackYesStimuli, true);

clear N;

save('genRandomBlock_tests_data')

%% Function that runs genRandomBlock N times and generates a letter histogram
function [nOccurences, letterChars] = make_letter_hist(blockDef, N, stimulusList, zeroBackYesStimuli, save)

stimuli = {};
for i = 1:N
    stimuli = vertcat(stimuli, genRandomBlock(blockDef, stimulusList, zeroBackYesStimuli)); %#ok<AGROW>
end

    figure('Renderer', 'painters', 'Position', [10 10 800 400])
    [nOccurences, letterChars] = cellhist(stimuli);
    title({[num2str(blockDef(1)) '-back letter frequency histogram'], [num2str(blockDef(2)) ' trials per block with ' num2str(blockDef(3)) ' "yes" trials'], [num2str(N) ' samples (' num2str(N*blockDef(2)) ' total letters)']});
    
    if save
        saveas(gcf,['letterHistogram_' num2str(blockDef(1)) '_' num2str(blockDef(2)) '_' num2str(blockDef(3)) '_' num2str(N) 'samples.jpg'])
        saveas(gcf,['letterHistogram_' num2str(blockDef(1)) '_' num2str(blockDef(2)) '_' num2str(blockDef(3)) '_' num2str(N) 'samples.fig'])
    end
    
end