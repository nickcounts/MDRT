function example
close all
clear all
list = cell(26,26,26);
for i1 = 1:26
   for i2 = 1:26
       for i3 = 1:26
        list{i1,i2,i3} = [char(64+i1) char(64+i2) char(64+i3)];
       end
   end
end

list    = reshape(list,numel(list),1);


% Hard lines - MARS communicationduring Launch Ops


% Read in file to search

tic;
fid = fopen('allFDs.txt');
disp(sprintf('Opening file took: %f seconds',toc));
        
Q = textscan(fid, '%s','delimiter','\n');
fclose(fid);
FDlist = Q{1};

keyboard

scrnsz  = get(0,'ScreenSize');
fig_h   = figure('Menubar','none','Resize','off', ...
    'Position',[scrnsz(3)/2-100 scrnsz(4)/2-100 200 200]);
edit_h  = uicontrol('Style','edit','Position',[6 170 190 25],'backgroundcolor','w');
jedit   = java(findjobj(edit_h));
jedit_h = handle(jedit,'CallbackProperties');

set(edit_h,'KeyPressFcn',{@KPF_CB,jedit_h,[],fig_h,FDlist,@my_fun})
set(jedit_h,'MouseReleasedCallback',{@KPF_MR_CB,edit_h}, ...
    'MousePressedCallback',{@KPF_MP_CB,edit_h})

function my_fun
    get(edit_h,'String')
end
end
