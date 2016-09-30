Unzip these functions to a folder named '@jcontrol' somewhere on your MATLAB 
path.

To run jcontroldemo, cut the jcontrolDemo.m file from the @jcontrol folder
and paste it into a higher folder- it's a standard m-file not a class method.


You can then construct a jcontrol object in MATLAB e.g.:

>> myObject=jcontrol(gcf,'javax.swing.JPanel')

myObject = 

	jcontrol object: 1-by-1

>> get(myObject)

ans = 

    	hgcontainer: [1x1 hgjavacomponent]
      	hgcontrol: [1x1 javahandle_withcallbacks.javax.swing.JPanel]
      	 hghandle: 2.0012
	  uipanel: 22.120

>>

********************************************************************************
Note that jcontrol objects now always have a uipanel as an ancestor. This is for 
compatability with R2008b onwards. The jcontrol constructor will add the uipanel 
automatically and the jcontrol's subsasgn and set methods will update the 
uipanel and hgcontainer automatically. In most instances, the rpesence of the 
uipanel will be transparent.
********************************************************************************


You can then access the MATLAB graphics container and its java object using GET 
and SET in the usual way,
either by accessing the individual components or by accessing the jcontrol.

You can also use MATLAB '.' syntax. This also provides access to the java 
object's methods:

myObject.set......
myObject.get......
myObject.is........

Type helpwin jcontrol at the MATLAB prompt for more information.


Malcolm Lidierth
07/07


Revisions
21.08.07 Fixes in subsref and setappdata. Ancestor method added.
--.09.07 Various speed improvements in subsref.
	 close method added.
20.10.08 Add uipanel for R2008b compatability
21.09.10 Cumulative update. Support for transparency.


