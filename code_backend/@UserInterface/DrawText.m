function DrawText(obj, text, textSize)
% DRAWTEXT draws a character or other string in the center of the
% screen according to the string passed by the "text" parameter
%   Usage: obj.DrawFixationCross(stimulus, textSize);
%   Example: obj.DrawFixationCross('A', 80); % draws a capital A in the center of
%   the screen with font size 80

Screen('TextSize', obj.window, textSize);
Screen('TextFont', obj.window, 'Courier New');
Screen('TextSTyle', obj.window, 0); % 0 is regular (not bold, italicized, etc)

DrawFormattedText(obj.window,text,'center','center',obj.c_white);

end