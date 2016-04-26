#requires -version 4

<#
.SYNOPSIS
  Sync two folder with RoboCopy.

.DESCRIPTION
  Syncs two folders with the help of RoboCopy and logs errors to the "Application Log".

.NOTES
  Version:        1.0
  Author:         Velocet [GitHub]
  Creation Date:  20.04.2016
  Purpose/Change: Initial version
#>

# ------ [Initialisations] & [Declarations] ------

$sourcePath = "\\Station-1\TurboMed"
$destPath = "C:\TurboMed"

# ------ [Script] ------

try {
    $result = robocopy $sourcePath $destPath /ZB /E /W:5
    if($lastExitCode -ge 8) {
        Write-EventLog -logname Application -source FolderSync -eventID $lastExitCode -entrytype Warning -message "$result"
    }
    else {
        Write-EventLog -logname Application -source FolderSync -eventID 0 -entrytype Warning -message "Sync successful!"
    }
}
        
catch {
    $ErrorMessage = $_.Exception.Message
    Write-EventLog -logname Application -source RoboCopy -eventID 666 -entrytype Error -message "Sync failed: $ErrorMessage"
    Break
}