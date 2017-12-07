function reportMDRTbug (varargin)
%% reportMDRTbug launches a web browser for bug reporting
%
%   reportMDRTbug() - discards any arguments passed
%
%   MDRT uses the "issue" system on GitHub for bugs and feature requests.
%
% Counts, 2017 VCSFA


url = 'https://github.com/nickcounts/MDRT/issues'
web(url)


