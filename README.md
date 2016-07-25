# MDRT

### How to work on the project

This project uses the following branch structure and workflow convention:

* **Master** - Contains the latest version for release. Never directly edit this branch.
* **develop** - Incremental development occurs on this branch. It is merged into releaseBranch to finalize a new master release version.
* **releaseBranch** - final release tweaking occurs on this branch. It is merged back into Master to greate a new release version. The develop branch pulls from the final release branch to continue incremental development.
* **featureBranch** - major feature additions/overhauls are done on feature branches. These branches are pulled from the develop branch. They roll into final releases by merging back to the develop branch.
* **hotFix** - reserved for a major bug that was missed in an update to the Master branch. This branch pulls directly from the last Master, addresses the issue, and is merged back into master with an incremental version. The develop branch pulls from the final hotfix branch to ensure the fix is incorporated in future development.

A visual representation of the project workflow can be found [here](http://nvie.com/posts/a-successful-git-branching-model/)
