# $Toolname Tools

> Tools for interacting with $Toolname, including a Python API wrapper

**NOTE:** For Python tool repo names, stick with underscores (eg 'tools_app'.  Hyphens can cause issues during imports.

One Paragraph of project description goes here

## Table of Contents
1. [$Toolname Python API Wrapper](#$Toolname-Python-API-Wrapper)
2. [Metadata](#Metadata)

![](plalceholder.png)

## Getting Started

### Prerequisites

- Python 3
- packages listed in the [requirements.txt](requirements.txt) file

### Installation

There is no formal installation process at this time, but using [git subtrees](https://www.atlassian.com/git/tutorials/git-subtree) is strongly recommended.  Unfortunately there is no 'helper' integration for git subtrees in VS Code, so using the actual git commands are necessary:

```bash
git subtree add --prefix tools/$toolname https://github.com/epopisces/tools_$toolname master --squash
git fetch https://github.com/epopisces/tools_$toolname master

# Breaking the above down, the following command creates the subtree and the connection to the remote repo
'''
git subtree add --prefix <dest-path> <source-repo> <branch> --squash
    --prefix <path>         specify the destination folder (relative to current working directory).
    <source-repo>           the repository that is being pulled from
    <branch>                branch to be pulled (usually 'master', may be 'main' if more recently created in GitHub)
    --squash                optional but recommended command to discard the commit history of the source repo
'''
#The following command fetches the content of that repo so it will be available for use
'''
git fetch <source-repo> <branch>
    <source-repo>           the repository that is being pulled from
    <branch>                branch to be pulled (usually 'master', may be 'main' if more recently created in GitHub)
'''
```

But what if the remote tool repo gets updated?  Pulling the latest changes is super easy, barely an inconvenience: just use the same command above with 'git subtree pull' instead of 'git subtree add':
```
git subtree pull --prefix tools/$toolname https://github.com/epopisces/tools_$toolname master --squash
```

Alternately git submodules can also be used; however, git submodules are not as easy to maintain and keep updated.  The recommendation is only to use git submodules if the tools repo is also going to be developed as part of the project, instead of just used as a static library by the main project.

The differences between git subtrees and git submodules are described in depth [in this article](https://martowen.com/2016/05/01/git-submodules-vs-git-subtrees/#:~:text=The%20simplest%20way%20to%20think,specific%20commit%20in%20another%20repository.&text=Subtrees%20are%20easier%20to%20pull,copies%20of%20the%20original%20repository).

# $Toolname Python API Wrapper

## $toolname_api.py

### Capabilities
* Authentication against API
* can do thing 1
* can do thing 2

### Usage
The below assumes you are using the repo as a subtree as described above.  Note this will require creating a empty `__init__.py` file in the 'tools' folder if there is not one present already so Python's import function can traverse the directories to get to the tool.
```python
import os
from tools.$toolname import $toolname_api as bbk

acct_email = os.getenv('$toolname_email')        # Use environment variable by this name to store a username for the API user
acct_pass = os.getenv('$toolname_pass')       # Use environment variable by this name to store a password for the API user
bb = bbk.BaseBrick(acct_email, acct_pass)

abbrev.{function-name}({parameters})
```
- Required Arguments

    Variable Name | Type | Required? | Description
    ------------- | ---- | --------- | ------------
    thing1        | dict | Required  | Dictionary containing things
    
- Optional Argument

    Variable Name | Type | Required? | Default | Description
    ------------- | ---- | --------- | --------| -----------
    thing2        | bool | Optional  | False   | Determines if a thing happens

### Running the Tests

Explain how to run the automated tests

## Release History

* 0.1.0
    * The first proper release, signified by upload to FL Github
* 0.0.1
    * Work in progress, local dev

## Metadata

### Authors

* [**epopisces**](https://github.com/epopisces) - Created the $toolname_api

See also the list of [contributors](https://github.com/<projname>/contributors) who participated in this project.

### License

This project is licensed under an MIT standard license - see the [LICENSE.md](LICENSE.md) file for details

### Acknowledgments

* [epopisces](https://github.com/epopisces) created the project template and boilerplate code used for this project
* Thanks to [PurpleBooth](https://gist.github.com/PurpleBooth/) & [dbader](https://github.com/dbader/readme-template) for the README Template
