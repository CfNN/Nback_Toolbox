function DrawFixationCross(obj)
% DRAWFIXATIONCROSS draws a fixation cross WITHOUT flipping the screen.
% Called by the ShowFixation function of @UserInterface. 
%   Usage: obj.DrawFixationCross();
% See also SHOWFIXATION

Screen('TextSize', obj.window, 80);
Screen('TextFont', obj.window, 'Courier New');
Screen('TextSTyle', obj.window, 0); % 0 is regular (not bold, italicized, etc)

DrawFormattedText(obj.window,'+','center','center',obj.c_white);

end