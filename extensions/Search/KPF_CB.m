function KPF_CB(obj,event,jedit_h,slider_h,fig_h,list,func)
% a key press callback function for an edit box
% 
% Description
%     KPF_CB() is a key press callback function for an edit box. This
%     callback creates a dynamically changing listbox under or above the
%     edit box (depending on space available).  The contents of the listbox
%     change depending on the keys pressed.  This callback may be useful
%     where very large lists are encountered and are difficult to sort
%     through, or may act as a search box.
% 
% Syntax
%     set(edit_h,'KeyPressFcn', ...
%         {@KPF_CB,jedit_h,slider_h,fig_h,list,func})
% 
% Arguments
%     edit_h   - handle of the edit box to which KPF_CB is applied
%     jedit_h  - handle of the java component of the edit box
%     slider_h - handle of the slider, if none, leave empty []
%     fig_h    - handle of the figure of the edit box
%     list     - list of selectable items
%     func     - function to evaluate after 'return', or 'escape' key is
%         pressed or item in listbox is 'opened', if this is not needed,
%         leave empty [] or do not include in edit box 'KeyPressFcn'
%         callback
% 
% Other Functionality
%     - KPF_CB incorporates the functionality of many special keys
%     including, backspace, delete, escape, insert, end, shift, return,
%     arrow keys, and space.
%     - Arrow keys allow the user to cycle left to right across the edit
%     box and continue typing with a dynamically changing listbox.  They
%     also allow the user to scroll through the list box up and down.
%     - The 'return' key will either select the closest match to the
%     contents of the listbox from the contents of the edit box, or if
%     the arrow keys were previously used to cycle through the listbox,
%     then whichever item is currently highlighted will be selected.  This
%     selected word will then appear in the edit box, and the listbox will
%     be deleted.
%     - Other keys behave as expected
%     - If an item in the listbox is clicked, the edit box will display
%     the item clicked on, but the contents of the listbox will remain the
%     same.  If an item in the listbox is opened (i.e. double-clicked),
%     this will have the same effect as the 'return' key, but for the item
%     clicked on.
%     - A slider can be used with this function.  For example, if multiple
%     edit boxes were placed on a panel with a slider, the listbox would
%     change size depending on the position of the edit box and slider.
%     - The optional function to evaluate after 'return', or 'escape' key
%     is pressed or item in listbox is 'opened' allows for immediate
%     function evaluation without needing a 'push button'
% 
% Example
%     list = cell(26,26,26);
%     for i1 = 1:26
%        for i2 = 1:26
%            for i3 = 1:26
%             list{i1,i2,i3} = [char(64+i1) char(64+i2) char(64+i3)];
%            end
%        end
%     end
%     list    = reshape(list,numel(list),1);
%     scrnsz  = get(0,'ScreenSize');
%     fig_h   = figure('MenuBar','none','Resize','off', ...
%         'Position',[scrnsz(3)/2-100 scrnsz(4)/2-100 200 200]);
%     edit_h  = uicontrol('Style','edit','Position',[6 170 190 25]);
%     jedit   = java(findjobj(edit_h));
%     jedit_h = handle(jedit,'CallbackProperties');
% 
%     set(edit_h,'KeyPressFcn',{@KPF_CB,jedit_h,[],fig_h,list,@my_fun})
%     set(jedit_h,'MouseReleasedCallback',{@KPF_MR_CB,edit_h}, ...
%         'MousePressedCallback',{@KPF_MP_CB,edit_h})
% 
%     function my_fun
%         get(edit_h,'String')
%     end
% 
% Notes
%     - In order to close the listbox an item must be selected, by either
%     pressing either the 'escape' or 'return' keys or 'opening' an item in
%     the listbox
%     - This function makes use of the edit box user data variable
%     - Java is used extensively
%     - This function is not bug free yet, but usually hitting 'backspace'
%     or 'delete' enough times will clear whatever my function thinks is in
%     there

% Version : 1.1 (10/06/2011)
% Author  : Nate Jensen
% Created : 09/21/2011
% History :
%  - v1.0 (09/21/2011) : initial release
%  - v1.1 (10/06/2011) : added java component to enable mouse clicks



%%% Initialization

% A java robot is used to press 'Ctrl+c' to copy text highlighted by the
% user. When this happens, this key press function is called.  To avoid
% calling this function, a 'return' is used to exit.
if ~isempty(event.Modifier)
    if strcmp(event.Modifier{1},'control') && any(strcmp(event.Key,{'control','c'}))
        return
    end
end

persistent old_key old_h lbox_h

% this function is called before the caret has a chance to move
pause(1e-4)
crsr = jedit_h.getCaretPosition();

% set up defaults and get 'UserData' if it exists
UserData = get(obj,'UserData');
flag  = 0;
jflag = 0;
jprsd = 0;
jrlsd = 0;
jtext = '';
ocrsr = 0;
if old_h == obj
    word   = '';
    if ~isempty(UserData)
        click = UserData.click;
        word  = UserData.word;
        flag  = UserData.flag;
        jflag = UserData.jflag;
        jprsd = UserData.jprsd;
        jrlsd = UserData.jrlsd;
        jtext = UserData.jtext;
        ocrsr = UserData.ocrsr;
    end
else
    word   = get(obj,'String');
end

%%% Build the Listbox
if isempty(lbox_h) || flag
    % get various items to build listbox
    edit_pos = get(obj,'Position');
    edit_bgc = get(obj,'BackgroundColor');
    parent_h = get(obj,'Parent');
    stup_pos = get(parent_h,'Position');
    
    % if the position of the edit box is determined by a slider
    if ~isempty(slider_h)
        slider_val = get(slider_h,'value');
        % if there is more room on the bottom, put the listbox there
        if edit_pos(2)-slider_val >= ...
                stup_pos(4)-edit_pos(2)-edit_pos(4)+28+slider_val
            lbox_h = uicontrol(parent_h,'Style','listbox','Fontsize',10, ...
                'String',list,'Position',[edit_pos(1),5,edit_pos(3), ...
                edit_pos(2)-4-slider_val],'BackgroundColor',edit_bgc);
        % if there is more room on the top, put the listbox there
        else
            lbox_h = uicontrol(parent_h,'Style','listbox', ...
                'BackgroundColor',edit_bgc,'String',list,'Fontsize',10, ...
                'Position',[edit_pos(1), ...
                edit_pos(2)+edit_pos(4)-1-slider_val,edit_pos(3), ...
                stup_pos(4)-edit_pos(2)-edit_pos(4)-5+slider_val]);
        end
        
    % if the position of the edit box is static
    else
        % if there is more room on the bottom, put the listbox there
        if edit_pos(2) >= stup_pos(4)-edit_pos(2)-edit_pos(4)+28
            lbox_h = uicontrol(parent_h,'Style','listbox', ...
                'Position',[edit_pos(1),5,edit_pos(3),edit_pos(2)-4], ...
                'String',list,'BackgroundColor',edit_bgc,'Fontsize',10);
        % if there is more room on the top, put the listbox there
        else
            lbox_h = uicontrol(parent_h,'Style','listbox', ...
                'BackgroundColor',edit_bgc,'String',list,'Position', ...
                [edit_pos(1),edit_pos(2)+edit_pos(4)-1,edit_pos(3), ...
                stup_pos(4)-edit_pos(2)-edit_pos(4)-5],'Fontsize',10);
        end
    end
    
    % set Callback and KeyPressFcn for the listbox
    % if a function to evaluate is specified, set it
    if nargin == 7
        set(lbox_h,'Callback',{@KPF_lbox_CB,obj,fig_h,func}, ...
            'KeyPressFcn',{@KPF_lbox_KPF_CB,fig_h,obj,func})
    % if a function to evaluate is not specified, do not set it
    else
        set(lbox_h,'Callback',{@KPF_lbox_CB,obj,fig_h}, ...
            'KeyPressFcn',{@KPF_lbox_KPF_CB,fig_h,obj})
    end
    flag = 0;
else
    flag = 1;
end

%%% Evaluate the Event
% if an alphanumeric, or select special keys, or the space bar was pressed
if length(event.Key) == 1 || strcmp(event.Key,'space')
    if jflag    % jflag is thrown if text was highlighted by the user
        if jrlsd == jprsd               % user double or triple clicked
            if     ~rem(click,3)        % user triple clicked
                word = event.Key;
            elseif ~rem(click,2)        % user double clicked
                % if the position where the user double clicked subtract
                % the length of the highlighted word is less than 1
                if     jprsd-length(jtext)+1 < 1
                    word(jprsd:jprsd+length(jtext)-1)       = event.Key;
                    word(jprsd:jprsd+length(jtext)-2)       = [];
                % if the position where the user double clicked subtract
                % the length of the highlighted word is greater than the
                % length of the highlighted word
                elseif jprsd+length(jtext)-1 > length(word)
                    word(jprsd-length(jtext)+1:jprsd)       = event.Key;
                    word(jprsd-length(jtext)+1:jprsd-1)     = [];
                else
                    % if the position where the user double clicked through
                    % the length of the highlighted word is the same as the
                    % highlighted word
                    if all(word(jprsd:jprsd+length(jtext)-1)*1 == jtext*1)
                        word(jprsd:jprsd+length(jtext)-1)   = event.Key;
                        word(jprsd:jprsd+length(jtext)-2)   = [];
                    else
                        word(jprsd-length(jtext)+1:jprsd)   = event.Key;
                        word(jprsd-length(jtext)+1:jprsd-1) = [];
                    end
                end
            end
        else
            % get indexes of highlighted text
            if jrlsd > jprsd            % the user dragged left to right
                indx = jprsd+1:jrlsd;
            else                        % the user dragged right to left
                indx = jprsd:-1:jrlsd+1;
            end
            % set the indexes of the word to the key pressed
            if length(event.Key) == 1   % alphanumeric or select special key
                word(indx) = event.Key;
            else                        % space bar
                word(indx) = ' ';
            end
            % remove excess indexes that were deleted
            if jrlsd > jprsd            % the user dragged left to right
                word(jprsd+2:jrlsd) = [];
            else                        % the user dragged right to left
                word(jprsd:-1:jrlsd+2) = [];
            end
        end
    else        % no flag
        % the index is wherever the cursor is
        indx = crsr;
        % if the cursor is not at the end of word there will be jtext
        if ~isempty(jtext)
            temp_var1 = zeros(1,length(jtext)+1);   % preallocate new word
            temp_var1(indx) = 1;                    % set index to 1
            word(~temp_var1) = jtext;               % set 0's to old word
        end
        % set the index of the word to the key pressed
        if length(event.Key) == 1   % alphanumeric or select special key
            word(indx) = event.Key;
        else                        % space bar
            word(indx) = ' ';
        end
    end
    % set jtext
    if crsr == length(word)         % if the cursor is at the end
        UserData.jtext = '';
    else                            % if the cursor is in the middle
        UserData.jtext = word;
    end
    old_key = 1;
    
% if the 'backspace' or 'delete' keys were pressed
elseif any(strcmp(event.Key,{'backspace','delete'}))
    if jflag    % jflag is thrown if text was highlighted by the user
        if jrlsd == jprsd               % user double or triple clicked
            if     ~rem(click,3)        % user triple clicked
                word = '';
            elseif ~rem(click,2)        % user double clicked
                % if the position where the user double clicked subtract
                % the length of the highlighted word is less than 1
                if     jprsd-length(jtext)+1 < 1
                    word(jprsd:jprsd+length(jtext)-1)       = '';
                % if the position where the user double clicked subtract
                % the length of the highlighted word is greater than the
                % length of the highlighted word
                elseif jprsd+length(jtext)-1 > length(word)
                    word(jprsd-length(jtext)+1:jprsd)       = '';
                else
                    % if the position where the user double clicked through
                    % the length of the highlighted word is the same as the
                    % highlighted word
                    if all(word(jprsd:jprsd+length(jtext)-1)*1 == jtext*1)
                        word(jprsd:jprsd+length(jtext)-1)   = '';
                    else
                        word(jprsd-length(jtext)+1:jprsd)   = '';
                    end
                end
            end
        else
            % get indexes of highlighted text
            if jrlsd > jprsd    % the user dragged left to right
                indx = jprsd+1:jrlsd;
            else                % the user dragged right to left
                indx = jprsd:-1:jrlsd+1;
            end
            word(indx) = [];    % delete those characters
        end
    else        % no flag
        % if 'backspace' or 'delete' was pressed, delete that character
        if strcmp(event.Key,'backspace') && (ocrsr ~= 0 || crsr > 0)
            word(crsr+1) = '';
        elseif strcmp(event.Key,'delete') && crsr+1 <= length(word)
            word(crsr+1) = '';
        end
        if ~isempty(jtext)
            UserData.jtext = word;
        end
    end
    old_key = 1;
    
% if the 'return/enter' or 'escape' keys were pressed
elseif any(strcmp(event.Key,{'return','escape'})) || isempty(event)
    if     ~old_key
        value = get(lbox_h,'Value');
        list  = get(lbox_h,'String');
    elseif any(strncmpi(word,list,length(word)))
        value = strncmpi(word,list,length(word));
    else
        value = 1;
    end
    set(obj,'String',list(value))
    word = list{value};
    delete(lbox_h)
    clear lbox_h
    UserData.jtext = word;
    old_key = 0;
    if nargin == 7 && ~isempty(func)
        feval(func)
    end
    
% if the 'downarrow' or' 'uparrow' keys were pressed
elseif any(strcmp(event.Key,{'downarrow','uparrow'}))
    value  = get(lbox_h,'Value');
    string = get(lbox_h,'String');
    % increment the highlighted value in the listbox
    if flag     % if this is not the first call after the listbox is built
        if strcmp(event.Key,'downarrow')
            list = list(strncmpi(word,list,length(word)));
            if value < length(list) % if the selected item is not the last
                value = value+1;    % increment down
            end
        else
            if value > 1            % if the selected item is not the first
                value = value-1;    % increment up
            end
        end
    end
    old_key = 0;
    set(lbox_h,'Value',value)
    set(obj,'String',string{value})
    UserData.jtext = '';
    
% if any other key was pressed
else
    UserData.jtext = word;
    old_key = 1;
end

if old_key
    if ~isempty(word)
        list = list(strncmpi(word,list,length(word)));
    end
    set(lbox_h,'String',list,'Value',1)
end

%%% Reset UserData
UserData.click = 0;
UserData.word  = word;
UserData.flag  = 0;
UserData.jflag = 0;
UserData.jprsd = 0;
UserData.jrlsd = 0;
UserData.ocrsr = crsr;
set(obj,'UserData',UserData)
old_h = obj;
end

function KPF_lbox_CB(obj,~,edit_h,fig_h,func)
value  = get(obj,'Value');
string = get(obj,'String');

set(edit_h,'String',string{value})
word = string{value};
UserData.word = word;
UserData.flag = 0;

if strcmp(get(fig_h,'SelectionType'),'open')
    UserData.flag = 1;
    delete(obj)
    clear obj
    set(edit_h,'UserData',UserData)
    if nargin == 5 && ~isempty(func)
        feval(func)
    end
else
    set(edit_h,'UserData',UserData)
end
end

function KPF_lbox_KPF_CB(obj,~,fig_h,edit_h,func)
character = get(fig_h,'CurrentKey');
value  = get(obj,'Value');
string = get(obj,'String');

set(edit_h,'String',string{value})
word = string{value};

if strcmp(character,'return')
    delete(obj)
    clear obj
    UserData.word = word;
    UserData.flag = 1;
    set(edit_h,'UserData',UserData)
    if nargin == 5 && ~isempty(func)
        feval(func)
    end
end
end
