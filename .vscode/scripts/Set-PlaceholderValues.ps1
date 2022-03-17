#! NOTE: This has been integrated into the Initialize-ToolTemplate.ps1 module.  If justified it can be split out later
#requires -version 2
<#
.SYNOPSIS
    Performs Find & Replace operations based on input + JSON definition
.DESCRIPTION
    Performs find and replace operations based on user input to populate placeholder variables
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

. "$PSScriptRoot\Initialize-ToolTemplate.ps1"

#------------------------------------------------[Declarations]------------------------------------------------

#Script Version
$sScriptVersion = "0.1"

#Log File Info
$sLogPath = ".\.vscode\logs"
$sLogName = "Set-PlaceholderValues.log"
$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName

#-------------------------------------------------[Functions]--------------------------------------------------

Function Set-AllPlaceholderValues {
    Param(
        [Parameter()]
        [string] $ToolName
    )

    Begin {}

    Process {
        $ToolNameObj = Format-ToolName -ToolName $ToolName
        $PlaceholderObj = Get-Content -Path ".vscode/scripts/find-and-replace-test.json" | ConvertFrom-Json
        $PlaceholderObj.PSObject.Properties | ForEach-Object {
            Try {
                $Placeholder = $_.Value.placeholder
                $Key = $_.Name
                $_.Value.files | ForEach-Object {
                    Set-PlaceholderValue -Placeholder $Placeholder -Value $ToolNameObj[$Key] -Location $_
                    Write-Host "Writing "$Key" done for "$_.Name
                    #Write-Host $_.Value
                }
            }
            Catch {
                Write-Host "Well that didn't work"
                Write-Host $Error[0]
            }
            #Write-Host $_.Name
            #Write-Host $_.Value.placeholder
            
        }
        #Write-Host $PlaceholderObj.toolNameLCase.files
        #Write-Host $PlaceholderObj

    }

    End {
        If($?) {
            Log-Write -LogPath $sLogFile -LineValue "Completed Successfully."
            Log-Write -LogPath $sLogFile -LineValue " "
        }
    }
}

Function Set-PlaceholderValue {
    Param(
        [Parameter()]
        [string] $Placeholder,
        [Parameter()]
        [string] $Value,
        [Parameter()]
        [string] $Location
    )

    Begin {}

    Process {
        ((Get-Content -Path $Location -Raw) -Replace $Placeholder, $Value) | Set-Content -Path $Location
        #Write-Host $PlaceholderObj.toolNameLCase.files
        #Write-Host $PlaceholderObj

    }

    End {
        If($?) {
            Return $ToolName
            Log-Write -LogPath $sLogFile -LineValue "Completed Successfully."
            Log-Write -LogPath $sLogFile -LineValue " "
        }
    }
}


#--------------------------------------------------[Execution]--------------------------------------------------

# TODO Remove after testing
Set-AllPlaceholderValues('Microsoft Excel')