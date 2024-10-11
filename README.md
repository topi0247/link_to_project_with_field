# Link to Project with Field
This GitHubActions automatically adds issues and pull requests to your GitHubProject.\
GitHubProject does not need to be connected to the repository.\
It also sets the fields and values for you when you connect. This can have multiple settings.
Currently only Single Select is supported.

# Usage
First, obtain a Personal Access Token (PAT).\
Access privileges should include repo, admin:org, and project.\
Set the Actions environment variable in the repository to the PAT you obtained with the name GH_TOKEN.


Here is a sample writing style
```yml
name: Link Projects
on:
  issues:
    types:
      - opened
jobs:
  link_projects:
    runs-on: ubuntu-latest
    name: test
    steps:
      - uses: topi0247/link_to_projects_with_field@v1.0
        with:
          GH_TOKEN: ${{ secrets.GH_TOKEN }}
          ProjectsNumber: 1
          FiledKeyValues: '[{ "key": "Status", "value": "Todo" }]'
```
Only when an issue is opened or a pull request is created is it supported.\
Please change here to select pull requests or issues.
```yml
on:
  issues:
    types:
      - opened
```
For pull requests, do this.
```yml
on:
  pull_request:
    types:
      - opened
```
If it is both, then this is what you should do.
```yml
name: Link Projects
on:
  issues:
    types:
      - opened
  pull_request:
    types:
      - opened
```

## with variable

| Name | data type | description |
| :-- | :-- | :-- |
| GH_TOKEN | | PAT Settings |
| ProjectsNumber | integer | Project Number. The number listed in the URL of the project you wish to set up. Example: 1 if https://github.com/users/{username}/projects/1 |
| FiledKeyValues | string | The name of the Field you want to set and its value. Currently, only Single Select is supported, so the name of the Field and the name of the Option will be entered. Multiple values can be set here. |
| IsOrganization | boolean | (option)Whether or not the organization.`default: false` |

### Multiple Field settings
For example, suppose you want to set the following Field and Option

| Field name | Options you want to set |
| :-- | :-- |
| Status | Todo |
| Project | SampleProject |

In this case FiledKeyValues will be as follows.
```yml
FiledKeyValues: '[{ "key": "Status", "value": "Todo" },{ "key": "Project", "value": "SampleProject" }]'
```
Put the associative array into an array and set it as a string.

# Hot to use
For example, you may want to use the following.
- You want to automatically set up multiple fields when setting up an issue or pull request for a project.
- You have a project that contains issues and pull requests from multiple repositories and you want to separate the fields for each repository along with their statuses, such as Todo.

# Notes
I believe that the repository and the project must be in the same account to work.\
For organizations, the repository and project must also be in the same organization.

# In the future
We would like to support Field types other than Single Select, but the implementation date has not yet been determined.
