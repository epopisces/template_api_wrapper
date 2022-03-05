

$PlaceholderObj = Get-Content ".vscode/scripts/find-and-replace.json" | ConvertFrom-Json

#Write-Host $PlaceholderObj.toolNameLCase.files
Write-Host $PlaceholderObj

#requires -version 2
<#
.SYNOPSIS
  Initializes the API Wrapper template for use with a specific tool
.DESCRIPTION
  Performs find and replace operations based on user input to populate placeholder variables and perform 
  cleanup on the repository
    #? Why so complicated, with the JSON definition and all for a simple find-and-replace?
    #? Repeatability/reusability.  If well-defined, this script & corresponding task can be
    #? used with all templates
.PARAMETER <Parameter_Name>
    <Brief description of parameter input required. Repeat this attribute if required>
.INPUTS
    find-and-replace.json file with targets, as well as variables passed via params defined above
.OUTPUTS
    <Outputs if any, otherwise state None - example: Log file stored in C:\Windows\Temp\<name>.log>
.NOTES
    Version:        1.0
    Author:         epopisces (https://github.com/epopisces)
    Creation Date:  2022.03.05
    Purpose/Change: Repeatable Find and Replace ops over multiple, specific files
  
.EXAMPLE
  <Example goes here. Repeat this attribute for more than one example>
#>

#-----------------------------------------------[Initializations]----------------------------------------------

#Set Error Action to Silently Continue
$ErrorActionPreference = "SilentlyContinue"

#------------------------------------------------[Declarations]------------------------------------------------

#Script Version
$sScriptVersion = "0.1"

#Log File Info
$sLogPath = ".\.vscode\logs"
$sLogName = "Set-PlaceholderValues.log"
$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName

#-------------------------------------------------[Functions]--------------------------------------------------


Function Set-PlaceholderValues {
    Param(
        [Parameter()]
        [string] $ToolName
    )

    Begin {}

    Process {
        Write-Host $ToolName
    }

    End {
        If($?) {
            Return $ToolName
            Log-Write -LogPath $sLogFile -LineValue "Completed Successfully."
            Log-Write -LogPath $sLogFile -LineValue " "
        }
    }
}