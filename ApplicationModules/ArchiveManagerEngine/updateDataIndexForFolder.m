function updateDataIndexForFolder(dataSetFolderInArchive_path)

    higherLevels = dataSetFolderInArchive_path;

    % get path 2 directories 'up'
    for i = 1:DATA_FOLDERS_LEVELS_DEEP_IN_ARCHIVE
        [higherLevels, currentDirectory, ~] = fileparts(higherLevels);
    end

    archiveRootPath = higherLevels;

    dataIndexFullFile = fullfile(archiveRootPath, DATAINDEX_FILE_NAME_STR);

    if exist(dataIndexFullFile, 'file')

        % Try to find the relevant metadata entry
        d = load(dataIndexFullFile);

        if isfield(d, 'dataIndex')
            dataIndex = d.dataIndex;
        end

        matchingEntries = [];

        for i = 1:numel(dataIndex)
            if strcmp(dataIndex(i).pathToData, rootDir_path)
                % Found a dataIndex enry that points to this data set
                matchingEntries = vertcat(matchingEntries, i);
            end
        end

        bWriteToIndex = true;

        switch length(matchingEntries)
            case 0
                % No matches found
                indexIndex = numel(dataIndex) + 1;
            case 1
                % One match found
                indexIndex = matchingEntries;
            otherwise
                % Multiple matches found.
                % Throw error or launch another tool?
                bWriteToIndex = false;
                error('Multiple dataIndex entries found for data set.');

        end


        if bWriteToIndex

            dataIndex(indexIndex).metaData = metadata;
            dataIndex(indexIndex).FDList = metadata.fdList;
            dataIndex(indexIndex).pathToData = rootDir_path;

        end

        bWriteDataIndexFile = false;

        % Ask if you want to write new dataIndex
        qString = 'Commit updated dataIndex.mat to disk?';
        titleString = 'Save dataIndex.mat';
        choice = questdlg(  qString, ...
                            titleString, ...
                            'Yes', 'No', 'No');
        switch choice
            case 'Yes'
                bWriteDataIndexFile = true;
            otherwise            
        end

        if bWriteDataIndexFile

            backupFileName_str = sprintf('dataIndex-%s.bak', ...
                                         datestr(now, 'mmmddyyyy-HHMMSS') );

            backupFullFile = fullfile(archiveRootPath, backupFileName_str);

            copyfile(dataIndexFullFile, backupFullFile, 'f');

            save(dataIndexFullFile, 'dataIndex', '-mat');

        end



    else
        % Didn't find the data index

        % Prompt user to locate index


    end


end