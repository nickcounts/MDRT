function ret_ax = cla(varargin)
% cla() is overloaded by MDRT to prevent inadvertant, unrecoverable data
% loss.
%
% This function is a wrapper that interjects a modal dialog before clearing
% axes. It looks for the existance of appdata.isMDRTplot and for the value
% to be true. If those conditions are met, the dialog is presented.
% Otherwise, the cla() call falls through to the builtin.
%
% Counts 2017, VCSFA - based on a suggestion from Greg at Matlab Answers

%CLA Clear current axis.
%   CLA deletes all children of the current axes with visible handles and resets
%   the current axes ColorOrder and LineStyleOrder..
%
%   CLA RESET deletes all objects (including ones with hidden handles)
%   and also resets all axes properties, except Position and Units, to
%   their default values.
%
%   CLA(AX) or CLA(AX,'RESET') clears the single axes with handle AX.
%
%   See also CLF, RESET, HOLD.

%   CLA(..., HSAVE) deletes all children except those specified in
%   HSAVE.

%   Copyright 1984-2002 The MathWorks, Inc. 

if nargin>0 && length(varargin{1})==1 && ishghandle(varargin{1}) && strcmpi((get(varargin{1},'Type')),'axes')
    % If first argument is a single axes handle, apply CLA to these axes
    ax = varargin{1};
    extra = varargin(2:end);
else
    % Default target is current axes
    ax = gca;
    extra = varargin;
end

%% Ask user "Are you sure?" if this is an MDRTplot (from appdata)

% axappdata = getappdata(ax);
cbo = gcbo;

% if ~isempty(axappdata) && isfield(axappdata,'isMDRTplot') && axappdata.isMDRTplot && ~isempty(cbo) && strcmpi(cbo.Label, 'Clear Axes')
if ~isempty(cbo) && isprop(cbo, 'Label') && strcmpi(cbo.Label, 'Clear Axes')

    debugout('User selected Clear Axes from context menu');
    
    yesButton = 'Clear Axes';
    noButton = 'Cancel';
    defaultButton = noButton;
    
    ButtonName = questdlg('You are about to clear all the data on this axes. This action can not be undone. Do you want to clear the axes?', ...
                         'Are you sure?', ...
                         yesButton, noButton, defaultButton);
    switch ButtonName
        case yesButton
        otherwise
            return
    end % switch
else
    debugout('Not an MDRT protected axes')
end

%% Return to TMW's cla() function



realcla = getappdata(groot, 'realcla');

feval(realcla,varargin{:})


if (nargout ~= 0)
    ret_ax = ax;
end
