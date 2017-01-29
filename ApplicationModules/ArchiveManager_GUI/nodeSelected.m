function [ output_args ] = nodeSelected( hobj, event, varargin )
%nodeSelected 
%   

    n = event.getCurrentNode;
%     n.setIcon(java.awt.Toolkit.getDefaultToolkit.createImage('folder-warning-16x16.png'))
%     drawnow
    
    
    
    
    path = arrayfun(@(nd) char(nd.getName), n.getPath, 'Uniform',false);
    
    npath = '';
    for i = 1:length(path)
        npath = fullfile(npath, path{i});
    end
    
    
    
    htext = findobj(hobj.Parent.Children, 'Style', 'text');
    htext.String = npath;

end


