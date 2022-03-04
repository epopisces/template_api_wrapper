# TEMPLATE USAGE
> This template has been designed to provide a springboard or starting point for creating an API wrapper written in Python

## Getting Started

To use this template, navigate to the repository in GitHub and select `Use this template`.  For templates that have been used before, they will appear in the `Repository template` dropdown in the new repository process in GitHub.

Name the repository using the naming convention that makes sense for the use case.  For example, when building an API wrapper for a tool named 'Sprocket', use the name `sprocket_api_wrapper`

## Use the Included Task to Initialize the Template for Use (recommended)

This template includes a vscode task to automate the replacement of placeholder variables and other cleanup actions for convenience

It makes the following assumptions:
* the user returned by `git config user.name` is the author
* the repo returned by `git remote get-url origin` is where this code will live longterm

If these assumptions are incorrect, [manual adjustments will be needed](#Manually-Modify-the-Template-for-Use) (the task can still be run first)

> is a mermaid diagram really necessary?  Of course not.  But mermaid is awesome, so let's use one anyway

```mermaid
%% tricky getting subgraphs not to re-order themselves.  Used invisible Container subgraph to force ordering
flowchart LR
    subgraph Container [_]
        direction LR
        A([Run Task])-->B[Prompt for User Input]
        subgraph task [Task Process Flow]
        B-->C[Find & Replace placeholders]-->D[Delete TEMPLATE.md]
        end
        subgraph user [Manual Actions]
        E[Update the README]
        end
    end
    style Container fill:none,stroke:none
```

The one thing the task can't automate for you is populating the README--don't neglect that step!  Documentation is important even for one-off personal projects

## Manually Modify the Template for Use

For more control, the steps that the Task would perform can be performed manually if preferred, and are enumerated below

### 1. Find & Replace (VSCode: `Ctrl+Shift+h`) Targets
| Variable | Usage | Example | Notes |
|--|--|--|--|
| TOOLNAME | toolname_api.py| SPROCKET ||
| toolname | toolname_api.py| sprocket ||
| Toolname |  |  ||
| shortname | toolname_api.py| skt ||
| ObjectClass | toolname_api.py| SprocketWidget ||
| authorname | toolname_api.py| spock ||
| repo_name | maintain.ps1 | tools_sprocket_api | only if tools are intended to be used via subtrees |

### 2. Delete this file (TEMPLATE.md)
Once the repository is ready for use, this file can be removed to keep the repository clean.

### 3. Update the README
Don't neglect this step!  Update the documentation to reflect the usage and nature of the API wrapper.