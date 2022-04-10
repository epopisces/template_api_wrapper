Write-Host "This task removes the README.md file describing the template, then renames"
Write-Host "the PROJ_README.md file to README.md for a project built from this template"
Remove-Item -Path './README.md'
Rename-Item -Path './PROJ_README.md' -NewName 'README.md'
Write-Host "Operation successful: update the README.md as appropriate for the project"
