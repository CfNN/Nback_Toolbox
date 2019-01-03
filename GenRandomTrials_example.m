% A script that demonstrates how to use the GenRandomTrials function (which
% is found in the code_backend/GenRandomTrials folder). Modify this as
% needed to set up your experiment.

% Add the GenRandomTrials function folder to the MATLAB path
addpath('./code_backend/GenRandomTrials');

% blockOutline: Each row outlines one "run" of data collection that
% consists of one or more "blocks" of trials. In each row, the first entry
% (a single integer) defines the number of cycles, i.e. the number of times
% the blocks in that run should be repeated in order. All subsequent
% entries in the row define blocks of trials (there can be any number of
% blocks, meaning rows can have any length). 
% Each block entry is an array of three integers. The first integer
% specifies the "N" in "Nback" - e.g. if this number is 2, a 2-back block
% will be created. The second integer specifies the total number of
% trials/stimulus presentations in that block. The third integer specifies
% how many of these trials should have "yes" as the correct answer - i.e.
% how many of the trials have another trial with the same stimulus N trials
% previously.

blockOutline = {
                3, [0, 9, 3], [2, 15, 5]; 
                3, [2, 15, 5], [0, 9, 3]
               };
           
           
% stimulusList: A cell array of stimulus names where each distinct stimulus
% has its own row, and stimuli in the same row are aliases/variants of each
% other. That is, if 'a', 'A'; forms a row, then 'a' and 'A' are treated as
% equivalent to each other in the N-back task. In the GenRandomTrials
% function, a row is randomly chosen from this array for each stimulus
% presentation.
           
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

           
% zeroBackYesStimuli: A cell array of stimulus names, like stimulusList,
% with a single row. This defines the stimulus names for which the correct
% answer should be "yes" in a zero-back block.
zeroBackYesStimuli = {'h', 'H'};

% The function below and its helper functions are found in the
% code_backend/GenRandomTrials folder
GenRandomTrials(blockOutline, stimulusList, zeroBackYesStimuli);