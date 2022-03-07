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
$ScriptVersion = "0.1"

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

Function Confirm-ToolName {
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
            $ToolNameShort = ""
            $AuthorName = ""
            $AuthorProfile = ""
            # find and replace tools_toolname first: repo-name dependent, not user input
            # f&r camelcase ToolName
            # f&r lcase toolname
            # f&r shortname tnm #? permit user override?
            # authorname, #authorprofile

        }
        
        Catch {
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


<#
Function Set-PlaceholderVariables{
  Param(

  )
  
  Begin{
    Log-Write -LogPath $sLogFile -LineValue "<description of what is going on>..."
  }
  
  Process{
    Try{
      <code goes here>
    }
    
    Catch{
      Log-Error -LogPath $sLogFile -ErrorDesc $_.Exception -ExitGracefully $True
      Break
    }
  }
  
  End{
    If($?){
      Log-Write -LogPath $sLogFile -LineValue "Completed Successfully."
      Log-Write -LogPath $sLogFile -LineValue " "
    }
  }
}
#>

#--------------------------------------------------[Execution]--------------------------------------------------

#Log-Start -LogPath $sLogPath -LogName $sLogName -ScriptVersion $sScriptVersion
Write-Host "oh hey there!"
$InLoop = $true
While ($InLoop) {
    $ToolName = Get-ToolName("")
    Confirm-ToolName($ToolName)
}


#Log-Finish -LogPath $sLogFile