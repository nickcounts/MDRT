function Original_KPF_CB(~,event,edit_h,parent_h,slider_h,fig_h,list,func)
% a key press callback function for an edit box
% 
% Description
%     KPF_CB() is a key press callback function for an edit box. This
%     callback creates a dynamically changing listbox under or above the
%     edit box (depending on space available).  The contents of the listbox
%     change depending on the keys pressed.  This callback may be useful
%     where very large lists are encountered and are difficult to sort
%     through.
% 
% Syntax
%     set(edit_h,'KeyPressFcn', ...
%         {@KPF_CB,edit_h,parent_h,slider_h,fig_h,list,func})
% 
% Arguments
%     edit_h   - handle of the edit box to which KPF_CB is applied
%     parent_h - handle of the parent of the edit box
%     slider_h - handle of the slider, if none, leave empty []
%     fig_h    - handle of the figure of the edit box
%     list     - list of selectable items (only 1 at a time)
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
%     list   = reshape(list,numel(list),1);
%     scrnsz = get(0,'ScreenSize');
%     fig_h  = figure('Position',[scrnsz(3)/2-100 scrnsz(4)/2-100 200 200]);
%     edit_h = uicontrol('Style','edit','Position',[6 170 190 25]);
%     set(edit_h,'KeyPressFcn',{@KPF_CB,edit_h,fig_h,[],fig_h,list,@my_fun})
%     function my_fun
%         get(edit_h,'String')
%     end
% 
% Notes
%     - Mouse clicks do not work with this function.  If a user types
%     something in and then clicks in the middle of the word, this function
%     will mess up. It can usually reset itself though if backspace or
%     delete is hit enough times.
%     - Selecting text and then editing it also does not work.
%     - In order to close the listbox an item must be selected, by either
%     pressing either the 'escape' or 'return' keys or 'opening' an item in
%     the listbox
%     - This function makes use of the edit box user data variable

% Version : 1.0 (09/21/2011)
% Author  : Nate Jensen
% Created : 09/21/2011
% History :
%  - v1.0 (09/21/2011) : initial release

persistent old_word old_key old_h lbox_h insert_key

temp = get(edit_h,'UserData');
if ~isempty(old_key) && old_h == edit_h
    if ~isempty(temp)
        word   = temp{1};
        cursor = temp{2};
    else
        word   = '';
        cursor = 1;
    end
else
    word   = get(edit_h,'String');
    cursor = length(word)+1;
end
edit_pos = get(edit_h,'Position');
edit_bgc = get(edit_h,'BackgroundColor');

setup_pos = get(parent_h,'Position');
if isempty(lbox_h) || length(temp) == 3
    if ~isempty(slider_h)
        slider_val = get(slider_h,'value');
        if edit_pos(2)-slider_val >= ...
                setup_pos(4)-edit_pos(2)-edit_pos(4)+28+slider_val
            lbox_h = uicontrol(parent_h,'Style','listbox','Fontsize',10, ...
                'String',list,'Position',[edit_pos(1),5,edit_pos(3), ...
                edit_pos(2)-4-slider_val],'BackgroundColor',edit_bgc);
        else
            lbox_h = uicontrol(parent_h,'Style','listbox', ...
                'BackgroundColor',edit_bgc,'String',list,'Fontsize',10, ...
                'Position',[edit_pos(1), ...
                edit_pos(2)+edit_pos(4)-1-slider_val,edit_pos(3), ...
                setup_pos(4)-edit_pos(2)-edit_pos(4)-5+slider_val]);
        end
    else
        if edit_pos(2) >= setup_pos(4)-edit_pos(2)-edit_pos(4)+28
            lbox_h = uicontrol(parent_h,'Style','listbox', ...
                'Position',[edit_pos(1),5,edit_pos(3),edit_pos(2)-4], ...
                'String',list,'BackgroundColor',edit_bgc,'Fontsize',10);
        else
            lbox_h = uicontrol(parent_h,'Style','listbox', ...
                'BackgroundColor',edit_bgc,'String',list,'Position', ...
                [edit_pos(1),edit_pos(2)+edit_pos(4)-1,edit_pos(3), ...
                setup_pos(4)-edit_pos(2)-edit_pos(4)-5],'Fontsize',10);
        end
    end
    if nargin == 8
        set(lbox_h,'Callback',{@KPF_lbox_CB,lbox_h,edit_h,fig_h,func}, ...
            'KeyPressFcn',{@KPF_lbox_KPF_CB,fig_h,lbox_h,edit_h,func})
    else
        set(lbox_h,'Callback',{@KPF_lbox_CB,lbox_h,edit_h,fig_h}, ...
            'KeyPressFcn',{@KPF_lbox_KPF_CB,fig_h,lbox_h,edit_h})
    end
    insert_key = 'off';
end
value  = get(lbox_h,'Value');
string = get(lbox_h,'String');

character = get(fig_h,'CurrentKey');
if sum(strcmp(character,{'downarrow','uparrow'})) == 1 && ...
        old_key == 2 && old_h == edit_h
    word = old_word;
end
if     strcmp(character,'backspace')
    if ~isempty(word) && (cursor > 1)
        word = word(1:length(word) ~= cursor-1);
        cursor = cursor-1;
    end
    old_key = 1;
elseif strcmp(character,'delete')
    if ~isempty(word)
        if old_key == 2
            word = get(edit_h,'String');
        end
        word = word(1:length(word) ~= cursor);
    end
    old_key = 1;
elseif strcmp(character,'insert')
    if strcmp(insert_key,'off')
        insert_key = 'on';
    else
        insert_key = 'off';
    end
elseif strcmp(character,'end')
    cursor = length(word)+1;
elseif strcmp(character,'shift')
    return
elseif any(strcmp(character,{'return','escape'})) || isempty(event)
    if     old_key == 2
        value = get(lbox_h,'Value');
        list = list(strncmpi(word,list,length(word)));
        set(edit_h,'String',list(value))
        word = list{value};
    elseif any(strcmpi(word,list))
        set(edit_h,'String',list(strcmpi(word,list)))
        word = list{strcmpi(word,list)};
    else
        temp = list(strncmpi(word,list,length(word)));
        if isempty(temp)
            set(edit_h,'String',list(1))
            word = list{1};
        else
            list = temp;
            set(edit_h,'String',list(1))
            word = list{1};
        end
    end
    delete(lbox_h)
    clear lbox_h
    old_key = 2;
    cursor = length(word)+1;
    if nargin == 8 && ~isempty(func)
        feval(func)
    end
elseif strcmp(character,'leftarrow')
    if cursor > 1
        cursor = cursor-1;
    end
    if old_key == 2
        return
    else
        old_key = 1;
    end
elseif strcmp(character,'downarrow')
    list = list(strncmpi(word,list,length(word)));
    if value < length(list)
        value = value+1;
    end
    set(lbox_h,'Value',value)
    set(edit_h,'String',string{value})
    old_word = word;
    old_key = 2;
    cursor = 1;
    set(edit_h,'UserData',{word,cursor})
    return
elseif strcmp(character,'rightarrow')
    if cursor <= length(word)
        cursor = cursor+1;
    end
    if old_key == 2
        return
    else
        old_key = 1;
    end
elseif strcmp(character,'uparrow')
    if value > 1
        value = value-1;
    end
    set(lbox_h,'Value',value)
    set(edit_h,'String',string{value})
    old_word = word;
    old_key = 2;
    cursor = 1;
    set(edit_h,'UserData',{word,cursor})
    return
elseif strcmp(character,'space')
    if strcmp(insert_key,'off') && cursor-1 ~= length(word)
        word(length(word)+1) = ' ';
        temp = word(cursor:end-1);
        word(cursor+1:end) = temp;
        clear temp
    end
    word(cursor) = ' ';
    cursor = cursor+1;
    if strcmp(insert_key,'on')
        set(edit_box,'String',word)
        cursor = 1;
    end
    old_key = 1;
elseif (any(isletter(character)) && length(character) == 1) || ...
        (isnumeric(str2double(character)) && length(character) == 1)
    if strcmp(insert_key,'off') && cursor-1 ~= length(word)
        word(length(word)+1) = ' ';
        temp = word(cursor:end-1);
        word(cursor+1:end) = temp;
        clear temp
    end
    word(cursor) = character;
    cursor = cursor+1;
    if strcmp(insert_key,'on')
        set(edit_box,'String',word)
        cursor = 1;
    end
    old_key = 1;
end
if old_key == 1
    if ~isempty(word)
        list = list(strncmpi(word,list,length(word)));
    end
    set(lbox_h,'String',list,'Value',1)
end
set(edit_h,'UserData',{word,cursor})
old_h = edit_h;
end

function KPF_lbox_CB(~,~,lbox_h,edit_h,fig_h,func)
value  = get(lbox_h,'Value');
string = get(lbox_h,'String');

set(edit_h,'String',string{value})
word = string{value};
cursor = length(word)+1;

if strcmp(get(fig_h,'SelectionType'),'open')
    delete(lbox_h)
    clear lbox_h
    set(edit_h,'UserData',{word,cursor,1})
    if nargin == 6 && ~isempty(func)
        feval(func)
    end
else
    set(edit_h,'UserData',{word,cursor})
end
end

function KPF_lbox_KPF_CB(~,~,fig_h,lbox_h,edit_h,func)
character = get(fig_h,'CurrentKey');
value  = get(lbox_h,'Value');
string = get(lbox_h,'String');

set(edit_h,'String',string{value})
word = string{value};
cursor = length(word)+1;

if strcmp(character,'return')
    delete(lbox_h)
    clear lbox_h
    set(edit_h,'UserData',{word,cursor,1})
    if nargin == 6 && ~isempty(func)
        feval(func)
    end
end
end
