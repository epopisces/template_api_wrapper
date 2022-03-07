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
        Write-Host $ToolName
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
            $ToolName.Split(' ') | ForEach {$ToolNameShort += $_[0]}
            If ($ToolNameShort.Length -lt 3) {
                
                If ($ToolNameShort.Length -lt 2) {
                    $vowel = "AEIOU"
                    $cons = $null
                    $second = $ToolName.Substring(1) 
                    $second = $second.ToCharArray()

                    ForEach ($letter in $second){ If ($vowel -notmatch $letter){ $cons = $cons + $letter } }

                    $SecondConsonant = $cons.substring(0,1)
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

        }
        
        Catch {
            Write-Host $_.Exception
            Log-Error -LogPath $sLogFile -ErrorDesc $_.Exception -ExitGracefully $True
        Break
        }
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

#Log-Start -LogPath $sLogPath -LogName $sLogName -ScriptVersion $ScriptVersion
Write-Host "oh hey there!"
$InLoop = $true
While ($InLoop) {
    $ToolName = Get-ToolName("")
    Format-ToolName($ToolName)
    break
}


#Log-Finish -LogPath $sLogFile