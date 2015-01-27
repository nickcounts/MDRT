function example
close all
clear all



% Hard lines - MARS communicationduring Launch Ops


% Read in file to search

tic;
fid = fopen('allFDs.txt');
disp(sprintf('Opening file took: %f seconds',toc));
        
Q = textscan(fid, '%s','delimiter','\n');
fclose(fid);
FDlist = Q{1};



scrnsz  = get(0,'ScreenSize');
fig_h   = figure('Menubar','none','Resize','off', ...
    'Position',[scrnsz(3)/2-100 scrnsz(4)/2-100 200 200]);
edit_h  = uicontrol('Style','edit','Position',[6 170 190 25],'backgroundcolor','w');


jedit   = java(findjobj(edit_h));
jedit_h = handle(jedit,'CallbackProperties');

set(edit_h,'KeyPressFcn',{@myKeyPress})
% set(jedit_h,'MouseReleasedCallback',{@KPF_MR_CB,edit_h}, ...
%     'MousePressedCallback',{@KPF_MP_CB,edit_h})

function get_current_string
    get(edit_h,'String')
end


function find_matching_cells(list, searchString)
    disp('Inside find_matching_cells');
end

function myKeyPress(varargin)
    disp('Inside myKeyPress');
    keyboard

end

end
