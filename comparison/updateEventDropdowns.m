function [tlist1, tlist2] = updateEventDropdowns(hcontrol)


    filename = 'timeline.mat';


    el1 = findobj(hcontrol.Parent, 'Tag', 'eventList1');
    el2 = findobj(hcontrol.Parent, 'Tag', 'eventList2');

    ol1 = findobj(hcontrol.Parent, 'Tag', 'opList1');
    ol2 = findobj(hcontrol.Parent, 'Tag', 'opList2');

    dataIndex = getappdata(hcontrol.Parent, 'dataIndex');

    
    
%% Get metadata file for dataindex(list value)

    % Variable instantiation

    elist1 = {};
    tlist1 = [];

    elist2 = {};
    tlist2 = [];

    
    
%% Event List 1
    % Check that a timeline file exists!
    if exist(fullfile(dataIndex(ol1.Value).pathToData, filename),'file')
        load(fullfile(dataIndex(ol1.Value).pathToData, filename))

        % Load the t0 info if it exists and put at the top of the list
        if timeline.uset0
            elist1 = {timeline.t0.name};
            tlist1 = timeline.t0.time;
        end

        % Assemble list of event strings and event times
        elist1 = vertcat( elist1, {timeline.milestone(:).String}'   );
        tlist1 = vertcat( tlist1, [timeline.milestone(:).Time]'     );

        % populate dropdown
        el1.String = elist1;

    else
        % No timeline data found
        el1.String = {'No event data found'};
        el1.Value = 1;

    end


%% Event List 2        
    % Check that a timeline file exists!
    if exist(fullfile(dataIndex(ol2.Value).pathToData, filename))
        load(fullfile(dataIndex(ol2.Value).pathToData, filename))

        % Load the t0 info if it exists and put at the top of the list
        if timeline.uset0
            elist2 = {timeline.t0.name};
            tlist2 = timeline.t0.time;
        end

        % Assemble list of event strings and event times
        elist2 = vertcat( elist2, {timeline.milestone(:).String}'   );
        tlist2 = vertcat( tlist2, [timeline.milestone(:).Time]'     );

        % populate dropdown
        el2.String = elist2;

    else
        % No timeline data found
        el2.String = {'No event data found'};
        el2.Value = 1;

    end

%% Make the time lists available to the application    
    % update app data with the event times
    
    % This stubbornly refused to work. Changed function to return the time
    % values and the appdata is updated in the calling function




