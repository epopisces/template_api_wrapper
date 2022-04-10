#requires -version 2
<#
.SYNOPSIS
  Initializes the API Wrapper template for use with a specific tool
.DESCRIPTION
  Performs find and replace operations based on user input to populate placeholder variables and perform 
  cleanup on the repository
.PARAMETER <Parameter_Name>
    <Brief description of parameter input required. Repeat this attribute if required>
.INPUTS
  <Inputs if any, otherwise state None>
.OUTPUTS
  <Outputs if any, otherwise state None - example: Log file stored in C:\Windows\Temp\<name>.log>
.NOTES
  Version:        1.0
  Author:         epopisces (https://github.com/epopisces)
  Creation Date:  2022.03.04
  Purpose/Change: Initial script development
  
.EXAMPLE
  <Example goes here. Repeat this attribute for more than one example>
#>

#-----------------------------------------------[Initializations]----------------------------------------------

#Set Error Action to Silently Continue
$ErrorActionPreference = "SilentlyContinue"

#Dot Source required Function Libraries
. Set-PlaceholderValues.ps1

#------------------------------------------------[Declarations]------------------------------------------------

#Script Version
$sScriptVersion = "0.1"

#Log File Info
$sLogPath = ".\.vscode\logs"
$sLogName = "Initialize-ToolTemplate.log"
$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName

#-------------------------------------------------[Functions]--------------------------------------------------


Function Get-ToolName {
    Param(
        [Parameter()]
        [string] $ToolName
    )

    Begin {}

    Process {
        Write-Host "The name passed as an argument is "$ToolName
        If ( $ToolName -eq "" ) {
            Try {
                $ToolName = Read-Host -Prompt "What is the tool this API wrapper is for (eg 'National Parks')?"
            }
            
            Catch {
                Log-Error -LogPath $sLogFile -ErrorDesc $_.Exception -ExitGracefully $True
            Break
            }
        }
    }

    End {
        If($?) {
            Log-Write -LogPath $sLogFile -LineValue "Completed Successfully."
            Log-Write -LogPath $sLogFile -LineValue " "
            Return $ToolName
        }
    }
}

Function Format-ToolName {
    Param(
        [Parameter(Mandatory)]
        [string] $ToolName
    )

    Begin {}

    Process {
        Try {
            $RepoName = Split-Path -Leaf (git remote get-url origin | Split-Path -leaf).split('.')[0]
            $ToolNameSpaceless = $ToolName -replace '\s', ''
            $ToolNameLCase = $ToolNameSpaceless.ToLower()
            $ToolNamePCase = (Get-Culture).TextInfo.ToTitleCase($($ToolName -Replace '[^0-9,A-Z]', ' ')) -Replace ' '
            $ToolName.Split(' ') | ForEach-Object {$ToolNameShort += $_[0]}
            If ($ToolNameShort.Length -lt 3) {
                
                If ($ToolNameShort.Length -lt 2) {
                    #? From https://www.reddit.com/r/PowerShell/comments/9olsg8/selecting_first_letter_of_a_string_then_the_first/
                    $Vowels = "AEIOU"
                    $Consonants = $null
                    $Second = $ToolName.Substring(1)
                    $Second = $Second.ToCharArray()

                    ForEach ($Letter In $Second){ If ($Vowels -NotMatch $Letter){ $Consonants = $Consonants + $Letter } }

                    $SecondConsonant = $Consonants.substring(0,1)
                    $ToolNameShort += $SecondConsonant
                }
                $LastChar = $ToolName.Substring($ToolName.Length - 1)
                $ToolNameShort += $LastChar
            } ElseIf ( $ToolNameShort.Length -gt 3 ) {
                $ToolNameShort = $ToolNameShort.Substring(0,3)
            }
            $ToolNameShort = $ToolNameShort.ToLower()
            $AuthorName = git config --global user.name
            $AuthorProfile = git remote get-url origin | Split-Path
            # find and replace tools_toolname first: repo-name dependent, not user input
            # f&r camelcase ToolName
            # f&r lcase toolname
            # f&r shortname tnm #? permit user override?
            # authorname, #authorprofile
            Write-Host 'repon = '$RepoName
            Write-Host 'lcase = '$ToolNameLCase
            Write-Host 'pcase = '$ToolNamePCase
            Write-Host 'short = '$ToolNameShort
            Write-Host 'authn = '$AuthorName
            Write-Host 'authp = '$AuthorProfile
            
            $ToolNameObj = @{
                "toolNameLCase" = $RepoName;
                "toolNamePCase" = $ToolNameLCase;
                "toolNameShort" = $ToolNamePCase;
                "repoName" = $ToolNameShort;
                "authorName" = $AuthorName;
                "authorProfile" = $AuthorProfile
            }
            
            $ToolNameObj
        }
        Catch {}
        
        # Catch {
        #     Write-Host $_.Exception
        #     Log-Error -LogPath $sLogFile -ErrorDesc $_.Exception -ExitGracefully $True
        # Break
        # }
    }

    End {
        If($?) {
            Log-Write -LogPath $sLogFile -LineValue "Completed Successfully."
            Log-Write -LogPath $sLogFile -LineValue " "
        }
    }
}

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
#Log-Start -LogPath $sLogPath -LogName $sLogName -ScriptVersion $ScriptVersion
# Write-Host "oh hey there!"
# $InLoop = $true
# While ($InLoop) {
#     $ToolName = Get-ToolName("")
#     Format-ToolName($ToolName)
#     Rename-Item -Path './README.md' -NewName 'TEMPLATE_README.md'
#     Rename-Item -Path './PROJ_README.md' -NewName 'README.md'
#     break
# }
Write-Host "Operation successful: update the README.md as appropriate for the project"


#Log-Finish -LogPath $sLogFile