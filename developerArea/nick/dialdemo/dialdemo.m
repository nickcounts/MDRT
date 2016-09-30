function  dialdemo
% Dialemo alá JFreeGraph-Demo
%
% The code behind is just a demo of what is possible with JFreeChart using it in Matlab. I played a little
% with codesnippets I found on the web and the API-Documentation.
% (http://www.jfree.org/jfreechart/api/javadoc/index.html). When  you want to explore the whole functionality,
% I think it is better to buy the JFreeChart Developer Guide (http://www.jfree.org/jfreechart/devguide.html). 
%
% This function shows a multiple TimeSeries as an example of JFreeChart (http://www.jfree.org/). The Idea
% to this code is based on the UndocumentedMatlab-Blog of Yair Altman, who shows a sample Code of JFreeChart
% for creating a PieChart (http://undocumentedmatlab.com/blog/jfreechart-graphs-and-gauges/#comments)
%
% Within the plot you can modify the values for the time by using the sliders.
%
% Before this demo works, you need to download JFreeChart and make matlab get to know with it. There are 2
% ways you can do this:
%
% 1. Add the jcommon and jfreechart jar to the dynamic matlab JavaClassPath (uncommented lines in the first
%    cell an change path to your local installation path)
% 2. Add the jcommon and jfreechart jar to the static matlab JavaClassPath (see Matlab Help, modify
%    classpath.txt on matlabroot\toolbox\local) 
%
% Finally you must donwload jcontrol from Malcom Lidierth
% (http://www.mathworks.com/matlabcentral/fileexchange/15580-using-java-swing-components-in-matlab).
% 
%
% Bugs and suggestions:
%    Please send to Sven Koerner: koerner(underline)sven(add)gmx.de
% 
% You need to download and install first:
%    http://sourceforge.net/projects/jfreechart/files/1.%20JFreeChart/1.0.13/ 
%    http://sourceforge.net/projects/jfreechart/files/1.%20JFreeChart/1.0.9/
%    http://www.mathworks.com/matlabcentral/fileexchange/15580-using-java-swing-components-in-matlab 
%
%
% Programmed by Sven Koerner: koerner(underline)sven(add)gmx.de
% Date: 2011/02/14 



%% Dialdemo
import java.awt.BasicStroke;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.GradientPaint;
import java.awt.Point;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JSlider;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

import org.jfree.chart.*;
import org.jfree.chart.JFreeChart;
import org.jfree.data.general.DefaultValueDataset;
import org.jfree.chart.plot.dial.DialBackground;
import org.jfree.chart.plot.dial.DialPlot;
import org.jfree.chart.plot.dial.DialCap;
import org.jfree.chart.plot.dial.DialPointer;
import org.jfree.chart.plot.dial.StandardDialFrame;
import org.jfree.chart.plot.dial.StandardDialScale;
import org.jfree.ui.GradientPaintTransformType;
import org.jfree.ui.StandardGradientPaintTransformer;


%%  JFreeChart to matlab
%  Add the JavaPackages to the static javaclasspath (see Matlab Help, modify classpath.txt on
%  matlabroot\toolbox\local) or alternativ turn it to the dynamic path (uncomment the next and change path to jFreeeChart) 

% javaaddpath C:/Users/sk/Documents/MATLAB/jfreechart-1.0.13/lib/jcommon-1.0.16.jar
% javaaddpath C:/Users/sk/Documents/MATLAB/jfreechart-1.0.13/lib/jfreechart-1.0.13.jar

%% Start

% get actual Time
t = clock;
hour   = t(4);
if hour>12
    hour = 23-hour;
end;
minute = t(5);

% Create Dataset for the DialPlot 
this.hoursDataset = DefaultValueDataset(hour);
this.dataset2     = DefaultValueDataset(minute);


plot = DialPlot(this.hoursDataset);    % Create the Plot with hour-dataset
plot.setView(0.0, 0.0, 1.0, 1.0);      % set the View of the plot
plot.setDataset(1, this.dataset2);     % add the minute-Dataset

dialFrame = StandardDialFrame();       % create the Dialframe  
% make the dial "pretty"
dialFrame.setBackgroundPaint(Color.lightGray);
dialFrame.setForegroundPaint(Color.darkGray);
plot.setDialFrame(dialFrame);
        
db = DialBackground(Color.white);
db.setGradientPaintTransformer(StandardGradientPaintTransformer(GradientPaintTransformType.VERTICAL));
plot.setBackground(db);

% Modify the Scales of hour and minute and add it to the plot
hourScale = StandardDialScale; %(0, 12, 90, -360);
hourScale.setLowerBound(0);
hourScale.setUpperBound(12);
hourScale.setStartAngle(90);
hourScale.setExtent(-360);
hourScale.setFirstTickLabelVisible(false);
hourScale.setMajorTickIncrement(1.0);
hourScale.setTickRadius(0.88);
hourScale.setTickLabelOffset(0.15);
hourScale.setTickLabelFont(java.awt.Font('Dialog', 0, 14));

plot.addScale(0, hourScale);

scale2 = StandardDialScale; %(0, 60, 90, -360);
scale2.setLowerBound(0);
scale2.setUpperBound(60);
scale2.setStartAngle(90);
scale2.setExtent(-360);
scale2.setVisible(false);
scale2.setMajorTickIncrement(5.0);
scale2.setTickRadius(0.68);
scale2.setTickLabelOffset(0.15);
scale2.setTickLabelFont(java.awt.Font('Dialog', 0, 14));

plot.addScale(1, scale2);

% Generate the pointer of the dials 
% hour - pointer
needle2 = javaObjectEDT('org.jfree.chart.plot.dial.DialPointer$Pointer',0);  % Special thx to Yair Altmann
needle2.setRadius(0.55); % set the radius if the hour-pointer (a little bit shorter)
plot.addLayer(needle2);  % add needle to the plot

plot.mapDatasetToScale(1, 1);  % Maps the minute dataset to the minute-scale

% minute - pointer
needle = javaObjectEDT('org.jfree.chart.plot.dial.DialPointer$Pointer',1);
needle.setRadius(0.78);
plot.addLayer(needle);


cap = DialCap();       % Creates a new cap of the dial (inner circle)
cap.setRadius(0.10);
plot.setCap(cap);

% Create Chart Area with Panel
chart1 = JFreeChart(plot);
chart1.setTitle('Dial Demo');
cp1 =  ChartPanel(chart1);

% New figure
fh = figure('Units','normalized','position',[0.1,0.1,  0.2,  0.4]);

% ChartPanel with JControl
jp = jcontrol(fh, cp1,'Position',[0.01 0.07 0.98 0.88]);


% Matlab-Slider for hours
sh = uicontrol(fh,'Style','slider',...
                'Max',12,'Min',0,'Value',hour,...
                'SliderStep',[0.01 0.01],...
                'Units','normalized', ...
                'Position',[0.01 0.01 0.90/2  0.03], ...
                'UserData', {plot}, ...                       % save the handle of the plot-object to Userdata to change values
                'Callback',@sh_callback_hour);
            

            
% Matlab-Slider for minutes
sh2 = uicontrol(fh,'Style','slider',...
                'Max',60,'Min',0,'Value',minute,...
                'SliderStep',[0.01 0.01],...
                'Units','normalized', ...
                'Position',[0.95/2 0.01 0.98/2 0.03], ...
                'UserData', {plot}, ...                       % save the handle of the plot-object to Userdata to change values
                'Callback',@sh_callback_minutes);
            
            
% Matlab-Text for Sliders
uicontrol(fh,'Style','Text',...
                'Units','normalized', ...
                'Position',[0.01 0.04 0.90/2  0.03], ...                
                'String', 'Hours:');
            
uicontrol(fh,'Style','Text',...
                'Units','normalized', ...
                'Position',[0.95/2 0.04 0.98/2  0.03], ...                
                'String', 'Minutes:');

            
            

% Slider Callback for Changing Hour-Needle
function sh_callback_hour(varargin)
hObject = varargin{1,1};  
% disp(['Slider moved to ' num2str(get(hObject,'Value'))]);   % diplay stuff in Matlab Command Window

% Get Handle from java plot object
plot_cell = get(hObject,'Userdata' );
plot_h    = plot_cell{1,1};    % handle of plot_object

% Update DialPlot
plot_h.setDataset(org.jfree.data.general.DefaultValueDataset(get(hObject,'Value')));   % change Values of the thermometer


% Slider Callback for Changing Minutes-Needle
function sh_callback_minutes(varargin)
hObject = varargin{1,1};  
%disp(['Slider moved to ' num2str(get(hObject,'Value'))]);   % diplay stuff in Matlab Command Window

% Get Handle from java plot object
plot_cell = get(hObject,'Userdata' );
plot_h    = plot_cell{1,1};    % handle of plot_object

% Update DialPlot
plot_h.setDataset(1, org.jfree.data.general.DefaultValueDataset(get(hObject,'Value')));   % change Values of the thermometer







            
            











