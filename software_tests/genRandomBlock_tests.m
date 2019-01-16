% A script that tests the genRandomBlock function by running it many times
% and exploring the properties of the resulting distribution(s).
% genRandomBlock is the key function of GenRandomTrials, which generates a
% sequence of randomized trial blocks for the Nback task. 

clear;
close all;

% To perform a full test (with many iterations), set this to 1 (or higher).
% Set it to a lower value to perform a quick test with fewer iterations.
% E.g. setting this to 0.1 will generate histograms with 1/10th the number
% of iterations that would be used in a full test.
FRACTION_OF_FULL_TEST = 0.01;

% Set the current MATLAB folder to the folder where this script is stored
cd(fileparts(which(mfilename)));

% Add the GenRandomTrials function folder to the MATLAB path
addpath('./../code_backend/GenRandomTrials');
% Add helper functions to the MATLAB path
addpath("./cellhist");
addpath("./rotateticklabel");
           
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
N = round(112000*FRACTION_OF_FULL_TEST);

% 0-back with 9 trials, 33% "yes" trials in each block
[nOccurences_0_9_3, ~] = make_letter_hist([0 9 3], N, stimulusList, zeroBackYesStimuli, true);

%% 67,000 samples (1,005,000 letters)
N = round(67000*FRACTION_OF_FULL_TEST);

% 2-back with 15 trials, 33% "yes" trials in each block
[nOccurences_2_15_5, ~] = make_letter_hist([2 15 5], N, stimulusList, zeroBackYesStimuli, true);

%% 10,000 samples (1,000,000 letters)
N = round(10000*FRACTION_OF_FULL_TEST);

% 0-back with 100 trials, 33% "yes" trials in each block
[nOccurences_0_100_33, ~] = make_letter_hist([0 100 33], N, stimulusList, zeroBackYesStimuli, true);

% 2-back with 100 trials, 33% "yes" trials in each block
[nOccurences_2_100_33, ~] = make_letter_hist([2 100 33], N, stimulusList, zeroBackYesStimuli, true);

% 5-back with 100 trials, 50% "yes" trials in each block
[nOccurences_5_100_50, letterChars] = make_letter_hist([5 100 50], N, stimulusList, zeroBackYesStimuli, true);

clear N;

save(['genRandomBlock_testx' num2str(FRACTION_OF_FULL_TEST) '_data.mat'])

%% Function that runs genRandomBlock N times and generates a letter histogram
function [nOccurences, letterChars] = make_letter_hist(blockDef, N, stimulusList, zeroBackYesStimuli, save)

% positionYesCounts has one entry for each position in the trial block
% being generated - it counts up how many times a "yes" trial was observed
% in that position.
positionYesCounts = zeros(blockDef(2), 1);
stimuli = cell(N*blockDef(2), 1);
for i = 1:N
    newStim = genRandomBlock(blockDef, stimulusList, zeroBackYesStimuli);
    stimuli(((i-1)*blockDef(2)+1):i*blockDef(2)) = newStim;
    
    yesInds = cell2mat(getCorrectYesNo(newStim, blockDef, stimulusList, zeroBackYesStimuli));
    newPositionYesCounts = zeros(blockDef(2), 1);
    newPositionYesCounts(yesInds) = 1;
    positionYesCounts = positionYesCounts + newPositionYesCounts;
end

    figure('Renderer', 'painters', 'Position', [10 10 800 400])
    [nOccurences, letterChars] = cellhist(stimuli, true);
    ylabel('Probability of presentation per trial');
    title({[num2str(blockDef(1)) '-back letter frequency histogram'], [num2str(blockDef(2)) ' trials per block with ' num2str(blockDef(3)) ' "yes" trials'], [num2str(N) ' samples (' num2str(N*blockDef(2)) ' total letters)']});
    
    if save
        saveas(gcf,['letterHistogram_' num2str(blockDef(1)) '_' num2str(blockDef(2)) '_' num2str(blockDef(3)) '_' num2str(N) 'samples.jpg'])
        saveas(gcf,['letterHistogram_' num2str(blockDef(1)) '_' num2str(blockDef(2)) '_' num2str(blockDef(3)) '_' num2str(N) 'samples.fig'])
    end
    
    figure('Renderer', 'painters', 'Position', [10 10 800 400])
    bar(positionYesCounts/numel(stimuli));
    xlabel('Trial index in block');
    ylabel('Probability of "yes" trial');
    title({[num2str(blockDef(1)) '-back "yes" position histogram'], [num2str(blockDef(2)) ' trials per block with ' num2str(blockDef(3)) ' "yes" trials'], [num2str(N) ' samples (' num2str(N*blockDef(2)) ' total letters)']});
    
    if save
        saveas(gcf,['yesPositionHistogram_' num2str(blockDef(1)) '_' num2str(blockDef(2)) '_' num2str(blockDef(3)) '_' num2str(N) 'samples.jpg'])
        saveas(gcf,['yesPositionHistogram_' num2str(blockDef(1)) '_' num2str(blockDef(2)) '_' num2str(blockDef(3)) '_' num2str(N) 'samples.fig'])
    end
    
end