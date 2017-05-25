function testAxesDelete
% testAxesDelete
% 
% testAxesDelete is a testing function for methods to prevent the
% accidental deletion of axes by selecting and pressing delete. The desire
% is to present a modal dialog. So far, this is fairly challenging.
%
% There seem to be timing issues with the 'being deleted' actions, and
% intercepting these events has proven unsuccesful.


    hs = struct('fig', figure);
    hs.fig.MenuBar = 'none';
    hs.fig.ToolBar = 'figure';
    
%     hs.fig.KeyPressFcn = @myKeyCallback;
    
    hs.ax = axes;
    hs.line = plot([0 0], [-1 1]);

%     hs.ax.DeleteFcn = @myDeleteCallback;
%     hs.ax.ButtonDownFcn = @myButtonCallback;
    
    addlistener(hs.ax, 'ObjectBeingDestroyed', @obdCallback);
    
    keyboard
    
end

function myKeyCallback(hobj, event, varargin)
    
    disp('Pressed a key on figure!');
    disp('Axes still is deleted if you press delete with the axis selected');
    disp('Axis is deleted prior to executing this function')
    keyboard
    
end


function myDeleteCallback(hobj, event, varargin)
    
    disp('Deleting axes!');
    disp('Axis is deleted prior to executing this function')
    keyboard

end

function myButtonCallback(hobj, event, varargin)
    
    disp('Does not intercept delete key');
    keyboard

end

function obdCallback(hobj, event, varargin)

    disp('Object being destroyed callback');
    disp('this happens *after* the axes have been deleted ');
    keyboard

end