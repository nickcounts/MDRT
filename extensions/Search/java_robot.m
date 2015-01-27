function java_robot(varargin)
% emulates the human input via mouse and keyboard
% 
% JAVA_ROBOT Java-Based Mouse/Keyboard Emulator
%   JAVA_ROBOT(ACTION,PARAM) emulates the human input via mouse and
%   keyboard. This utility uses Java java.awt.Robot class.
% 
%   JAVA_ROBOT(MOUSE_ACTION,
% 
%   JAVA_ROBOT(KEYBOARD_ACTION,
% 
% Examples
%             function input                             equivalent
%   java_robot('key_normal','Hello World!')         Hello World!
%   java_robot('key_win',{'key_normal','d'})        [Windows Key]+d
%   java_robot('key_alt',{'key_special','\F4'})     Alt+F4
%   java_robot('key_ctrl',{'key_normal','n'})       Ctrl+n
%   java_robot('key_special','\PRINTSCREEN')        [Print Screen Key]
% 
%   java_robot('mouse','button1')                   click button 1
%   java_robot('mouse',[400 400])                   move mouse to 400,400
%   java_robot('mouse',{'button1', ...             drag button 1 from
%       {'mouse',[30 30],{'pause',1e-6}}})           current pos to 30,30
%   java_robot('drag3',[30 30]                      drag method 2
% 
%   java_robot('wheel',5)                 rotate mouse wheel 5 notches down
%   java_robot('wheel',-5)                rotate mouse wheel 5 notches up
% 
%   java_robot('pause',2)                           pause 2 seconds
% 
%   java_robot('key_normal',{'x',{'mouse', ...      x+move mouse to 30,30
%       [30 30],{'mouse','button2'}}})               +click button 2
%   java_robot('key_shift',{'mouse','button3'})     Shift+click button 3
%   java_robot('key_normal','How are you?', ...     How are you?
%       'mouse',[123 981], ...                      move mouse to 123,981
%       'wheel',7, ...                              rotate wheel 7 notches
%       'key_alt',{'mouse','button1'})              Alt+click button 1

% Version : 1.0 (06/28/2011)
% Author  : Nate Jensen
% Created : 06/28/2011
% History :
%  - v1.0 (06/28/2011) : initial release

% Acknowledgements:
% Takeshi Ikuma and his inputemu

%% Initialization
import java.awt.event.MouseEvent
import java.awt.event.KeyEvent
robot = java.awt.Robot;

last_var   = varargin;
key_type   = {'key_normal','key_shift','key_ctrl','key_alt','key_win', ...
    'key_special','mouse','drag1','drag2','drag3','wheel','pause'};
mouse_type = {'button1','button2','button3','open'};

% Seperate key modifiers
key_input = zeros(nargin,1);
mod2 = cell(1,nargin/2);
for idx   = 2:2:nargin
    flag  = true;
    idx1  = 0;
    while iscell(last_var{idx})
        idx1       = idx1+1;
        mod2{idx/2}(idx1) = {last_var{idx}(1:end-1)};
        old_temp   = last_var;
        last_var{idx}  = last_var{idx}{end};
        flag       = any(strcmpi(old_temp{idx}(1),key_type(1:5)));
    end
    key_input(idx) = any(strcmpi(last_var(idx-1),key_type(1:5))) & flag;
end

special_char1 = [33:38,40:43,58,60,62:64,94,95,123:126];
special_char2 = [special_char1,65:90];
lower_spcl    = [49,39,51:53,55,57,48,56,61,59,44,46,47,50,54,45,91:93,96];
mouse_char    = [16,8,4];

special_key = [{ ...
		'\BACKSPACE'     [8];	'\TAB'           [9];	'\ENTER'        [10];
		'\SHIFT'        [16];   '\CTRL'         [17];	'\ALT'          [18];
		'\PAUSE'        [19];	'\CAPSLOCK'     [20];	'\ESC'          [27];
		'\PAGEUP'       [33];	'\PAGEDOWN'     [34];	'\END'          [35];
		'\HOME'         [36];	'\LEFT'         [37];	'\UP'           [38];
		'\RIGHT'        [39];	'\DOWN'         [40];   '\PRINTSCREEN' [154];
		'\INSERT'      [155];	'\DELETE'      [127];	'\WINDOWS'     [524];
		'\NUMLOCK'     [144];	'\SCROLLLOCK'  [145];   '\F1'          [112];
        '\F2'          [113];   '\F3'          [114];   '\F4'          [115];
        '\F5'          [116];   '\F6'          [117];   '\F7'          [118];
        '\F8'          [119];   '\F9'          [120];   '\F10'         [121];
        '\F11'         [122];   '\F12'         [123];   '\F13'       [61440];
        '\F14'       [61441];   '\F15'       [61442];   '\F16'       [61443];
        '\F17'       [61444];   '\F18'       [61445];   '\F19'       [61446];
        '\F20'       [61447];   '\F21'       [61448];   '\F22'       [61449];
        '\F23'       [61450];   '\F24'       [61451]    }]; %#ok<NBRAK>

%% Parse Input
% Preallocation
empty_cel = cell(1,nargin/2);
shift_num = empty_cel;
ascii_num = empty_cel;
release   = empty_cel;
mod_valu1 = empty_cel;
mod_valu2 = empty_cel;
mouse_num = empty_cel;
pause_num = empty_cel;

mouse_input = zeros(1,nargin/2);
pause_input = zeros(1,nargin/2);

for i1    = 1:nargin/2 % loop through each set of commands
    %% Key Modifications
    
    % mod type 1
    mod_type1 = strcmpi(last_var{2*i1-1},key_type);
    switch find(mod_type1,1)
        case 1 %'key_normal'
            if ~isempty(mod2{i1})
                mod2{i1}{1} = [last_var{2*i1-1} mod2{i1}{1}];
            end
        case 2 %'key_shift'
            mod_valu1{i1} = 16;
        case 3 %'key_ctrl'
            mod_valu1{i1} = 17;
        case 4 %'key_alt'
            mod_valu1{i1} = 18;
        case 5 %'key_win'
            mod_valu1{i1} = 524;
        case 6 %'key_special'
            if isempty(mod2{i1})
                mod_valu1{i1} = special_key(strcmpi(last_var{2*i1}, ...
                    special_key(:,1)),2);
                mod_valu1{i1} = mod_valu1{i1}{1};
            end
        case {7,8,9,10,11} %'mouse' 'drag1' 'drag2' 'drag3' 'wheel'
            if isempty(mod2{i1})
                mouse_input(i1) = 1;
            else
                mod2{i1}{1} = [last_var{2*i1-1} mod2{i1}{1}];
            end
        case 12 %'pause'
            if isempty(mod2{i1})
                pause_input(i1) = 1;
            else
                mod2{i1}{1} = [last_var{2*i1-1} mod2{i1}{1}];
            end
        otherwise
            warning('MATLAB:paramAmbiguous', ...
                ['Arg unknown: ' cell2mat(last_var{2*i1-1})])
    end
    
    % mod type 2
    if ~isempty(mod2{i1})
        mod_type2 = cell(length(mod2{i1}),1);
        for i2 = 1:length(mod2{i1})
            if length(mod2{i1}{i2}) > 1
                temp = mod2{i1}{i2};
                mod_type2{i2} = strcmpi(temp{1},key_type);
                mod_type2{i2,2} = temp{2};
                if length(mod2{i1}{i2}) == 3
                    temp = mod2{i1}{i2};
                    if i2 < length(mod2{i1})
                        mod2{i1}{i2+1} = [temp{end} mod2{i1}{i2+1}];
                    else
                        mod2{i1}{i2+1} = temp{end};
                    end
                end
            else
                mod_type2{i2} = strcmpi(mod2{i1}{i2},key_type);
            end
        end
        
        mod_valu2{i1} = cell(length(mod_type2),1);
        for i2 = 1:length(mod_type2)
            switch find(mod_type2{i2},1)
                case 1 %'key_normal'
                    if length(mod_type2(i2)) ~= length(mod_type2)
                        mod_valu2{i1}{i2} = abs(mod_type2{i2,2});
                    else
                        break
                    end
                case 2 %'key_shift'
                    mod_valu2{i1}{i2} = 16;
                case 3 %'key_ctrl'
                    mod_valu2{i1}{i2} = 17;
                case 4 %'key_alt'
                    mod_valu2{i1}{i2} = 18;
                case 5 %'key_win'
                    mod_valu2{i1}{i2} = 524;
                case 6 %'key_special'
                    if size(mod_type2,2) == 2
                        if isempty(mod_type2{i2,2})
                            mod_valu2{i1}(i2) = special_key( ...
                                strcmpi(last_var{2*i1},special_key(:,1)),2);
                        else
                            mod_valu2{i1}(i2) = special_key( ...
                                strcmpi(mod_type2{idx2,2},special_key(:,1)),2);
                        end
                    else
                        mod_valu2{i1}(i2) = special_key( ...
                        	strcmpi(last_var{2*i1},special_key(:,1)),2);
                    end
                case 7 %'mouse'
                    if i2 ~= length(mod_type2)
                        temp = mod2{i1}{i2};
                        if isnumeric(temp{2})
                            mod_valu2{i1}{i2} = {'mouse',temp{2}};
                        else
                            mod_valu2{i1}{i2} = {'mouse', ...
                                mouse_char(strcmpi(temp{2},mouse_type))};
                        end
                    else
                        if isnumeric(last_var{2*i1})
                            mod_valu2{i1}{i2} = {'mouse',last_var{2*i1}};
                        else
                            mod_valu2{i1}{i2} = {'mouse', ...
                                mouse_char(strcmpi(last_var{2*i1},mouse_type))};
                        end
                    end
                case 8 %'drag1'
                    
                case 11 %'wheel'
                    temp = mod2{i1}{i2};
                    mod_valu2{i1}{i2} = {'wheel',temp{2}};
                case 12 %'pause'
                    temp = mod2{i1}{i2};
                    if length(temp) == 1
                        mod_valu2{i1}{i2} = {'pause',last_var{2*i1}};
                    else
                        mod_valu2{i1}{i2} = {'pause',temp{2}};
                    end
            end
        end
    else
        mod_valu2{i1}{1} = [];
    end
    
    %% Keyboard Input
    if key_input(2*i1)
        text     = last_var{2*i1};
        char_num = abs(text);
        
        loc = zeros(size(char_num));
        for i = 1:size(char_num,2)
            temp = find(special_char1 == char_num(1,i),1);
            if ~isempty(temp)
                loc(i) = find(special_char1 == char_num(1,i));
            end
        end
        trufal = loc ~= 0;
        text(trufal) = lower_spcl(loc(trufal));
        
        shifts = zeros(size(char_num));
        for i = 1:size(special_char2,2)
            shifts = shifts+(char_num == special_char2(1,i));
        end
        shifts = [shifts(1),diff(shifts)];
        
        char_num = abs(upper(text));
        
        shift_num{i1} = shifts;
        ascii_num{i1} = char_num;
        release{i1}   = sum(shifts) > 0;
    end
    
    %% Mouse Input
    if mouse_input(i1)
        if     strcmpi(last_var{2*i1-1},key_type(8))
            mouse_input(i1) = 0;
            mod_valu2{i1} = {{'mouse' [16]}
                             {'mouse' last_var{2*i1}}
                             {'pause' [1e-6]}}; %#ok<NBRAK>
        elseif strcmpi(last_var{2*i1-1},key_type(9))
            mouse_input(i1) = 0;
            mod_valu2{i1} = {{'mouse' [8]}
                             {'mouse' last_var{2*i1}}
                             {'pause' [1e-6]}}; %#ok<NBRAK>
        elseif strcmpi(last_var{2*i1-1},key_type(10))
            mouse_input(i1) = 0;
            mod_valu2{i1} = {{'mouse' [4]}
                             {'mouse' last_var{2*i1}}
                             {'pause' [1e-6]}}; %#ok<NBRAK>
        else
            if isnumeric(last_var{2*i1})
                mouse_num{i1} = last_var{2*i1};
            else
                mouse_num{i1} = mouse_char(strcmpi(last_var{2*i1},mouse_type));
            end
        end
    end
    
    %% Pause Input
    if pause_input(i1)
        pause_num{i1} = last_var{2*i1};
    end
end

%% Execution
for i1 = 1:nargin/2 % loop through each set of commands
    %% Pre Key Modifications
    if ~isempty(mod_valu1{i1})
        robot.keyPress  (mod_valu1{i1})
    end
    if ~isempty(mod_valu2{i1}{1})
        for i2 = 1:length(mod_valu2{i1})
            if ~iscell(mod_valu2{i1}{i2})
                robot.keyPress  (mod_valu2{i1}{i2})
            else
                temp = mod_valu2{i1}{i2};
                if     strcmp(temp{1},'mouse')
                    if length(temp{2}) == 2
                        robot.mouseMove   (temp{2}(1),temp{2}(2))
                    else
                        robot.mousePress  (temp{2})
                    end
                elseif strcmp(temp{1},'wheel')
                    robot.mouseWheel  (temp{2});
                else
                    pause(temp{2})
                end
            end
        end
    end
    
    %% Keyboard Input
    if ~isempty(ascii_num{i1})
        for i2 = 1:length(text)
            if shift_num{i1}(i2) == 1
                robot.keyPress  (16)
            end
            if shift_num{i1}(i2) == -1
                robot.keyRelease(16)
            end
            robot.keyPress  (ascii_num{i1}(i2))
            robot.keyRelease(ascii_num{i1}(i2))
        end
        if release{i1}
            robot.keyRelease(16)
        end
    end
    
    %% Mouse Input
    if mouse_input(i1)
        if length(mouse_num{i1}) == 2
            robot.mouseMove   (mouse_num{i1}(1),mouse_num{i1}(2))
        else
            if strcmpi(last_var{2*i1-1},'mouse')
                robot.mousePress  (mouse_num{i1})
                robot.mouseRelease(mouse_num{i1})
            else
                robot.mouseWheel  (mouse_num{i1});
            end
        end
    end
    
    %% Pause Input
    if pause_input(i1)
        pause(pause_num{i1})
    end
    
    %% Post Key Modificaations
    if ~isempty(mod_valu2{i1}{1})
        for i2 = length(mod_valu2{i1}):-1:1
            if ~iscell(mod_valu2{i1}{i2})
                robot.keyRelease(mod_valu2{i1}{i2})
            else
                temp = mod_valu2{i1}{i2};
                if strcmp(temp{1},'mouse')
                    if length(temp{2}) ~= 2
                        robot.mouseRelease(temp{2})
                    end
                end
            end
        end
    end
    if ~isempty(mod_valu1{i1})
        robot.keyRelease(mod_valu1{i1})
    end
    
end

robot.waitForIdle();
end
