
%% Get .delim file to import

[a b c] = uigetfile('*.delim')

filename = fullfile(b, a)

startMetaData = newMetaDataStructure;

%% Meta Data Input

prompt = {'Enter operation name:','Enter procedure name:'};
dlg_title = 'Meta Data Input';
num_lines = 1;
defaultans = {'',''};

answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

if isempty(answer)
    % User cancelled
    return
end

opname      = strtrim(answer{1});
marsname    = strtrim(answer{2});

if ~isempty( opname),   startMetaData.isOperation      = true; end;
if ~isempty( marsname), startMetaData.isMARSprocedure  = true; end;

startMetaData.operationName      = opname;
startMetaData.MARSprocedureName  = marsname;

%% Begin automated import script

StartNewImportProject(filename, startMetaData)