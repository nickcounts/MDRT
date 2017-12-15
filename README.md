# MDRT : MARS Data Review Tool

## Description: 

MDRT imports UGFCS .delim files, processes them, and creates a data repository of indexed FDs for plotting, comparison, and analysis. Tools are available for data filtering, numerical methods, trend analysis, and operation comparison.

## Table of Contents: 

1. [Installation](#Installation)
2. [Usage](#Usage)
3. [Contributing-to-MDRT](#Contributing-to-MDRT)

## Installation: 

**NOTE:** MDRT was developed on OS X and relies on some Linux/Unix system commands during the data import process. Windows users can still access processed data and use the plotting and analysis tools.

Installation just requires copying the MDRT files to your machine. We recommend you clone the git repository. Once you have the files, navigate to the root MDRT folder. 

Check the included `startup.m` file, which sets the required paths for the tool. You can add this code to your existing `startup.m` script if you wish, but MDRT will run it if required upon application launch.

### Third Party Tools

MDRT is developed entirely in MATLAB (with a little Java in the Matlab code). There are a few additional tools that are required for best performance.

#### Grep

MDRT uses the `grep` utility during data import. On OSX it is recommended to install GNU grep, which is significantly faster than BSD grep. 

```shell
brew install grep --with-default-names
```

Additional details can be found in the [MDRT Wiki](https://github.com/nickcounts/MDRT/wiki/Dependencies)

## Usage: 

The entry point to MDRT is the `review.m` function. Execute `review` to launch a GUI that allows access to all the MDRT tools. Most common tasks are available from MDRT's GUI.

There are many small helper functions in the "helpers" subdirectory. The
most commonly used are:

*	`boundaryMath([lowerLimit upperLimit], dataVector)`
*	`trendMath(dataBrushVariable)`
*	`ntegrateTotalFlow(dataBrushVariable, 'gpm')`
*	`deltat(figureNumber)` 

## Contributing to MDRT

This project uses the following branch structure and workflow convention:

* **Master** - Contains the latest version for release. Never directly edit this branch.
* **develop** - Incremental development occurs on this branch. It is merged into releaseBranch to finalize a new master release version.
* **releaseBranch** - final release tweaking occurs on this branch. It is merged back into Master to greate a new release version. The develop branch pulls from the final release branch to continue incremental development.
* **featureBranch** - major feature additions/overhauls are done on feature branches. These branches are pulled from the develop branch. They roll into final releases by merging back to the develop branch.
* **hotFix** - reserved for a major bug that was missed in an update to the Master branch. This branch pulls directly from the last Master, addresses the issue, and is merged back into master with an incremental version. The develop branch pulls from the final hotfix branch to ensure the fix is incorporated in future development.

A visual representation of the project workflow can be found [here](http://nvie.com/posts/a-successful-git-branching-model/)

**IMPORTANT NOTE:** Please do not modify `VERSION` or `CHANGES`. These files are 
generated in the versioning process and changes made outside of the release
process can cause issues with version control.


## Credits

MDRT was initially developed by [Nick Counts](https://github.com/nickcounts) at Spaceport Support Services in 2012. Additional development and contributions have been provided by Paige Pruce, [Staten Longo](https://github.com/StatenLongo), [Trisha Patel](https://github.com/tpatel823), and [Jake Singh](https://github.com/jtsingh7).
