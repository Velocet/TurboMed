#requires -version 4

<#
.SYNOPSIS
  SYNOPSIS.

.DESCRIPTION
  DESCRIPTION.

.NOTES
  Version:        1.0
  Author:         Velocet [GitHub]
  Creation Date:  20.04.2016
  Purpose/Change: Initial version

.LINK
  LINK
#>

# ------ [Initialisations] & [Declarations] ------

$tm ="C:\TurboMed\Programm"
$tmGlobalini = "C:\TurboMed\Programm\global.ini"
$tmProgramm = "C:\TurboMed\Programm\TurboMed.exe"
$tmProgrammFake = = "C:\TurboMed\Programm\TM.exe"
$tmIfIndex = "16" # Get-NetAdapter | select ifIndex,Name,InterfaceDescription
$tmServerName = "Station-1"
$tmNetwork = "Praxis"

# ------ [Functions] ------

function TMSetMode
{
    begin {
        # cancel the execution if an error occurs
        $ErrorActionPreference = "Stop"
    }

    process {
        try {
            #if((Get-NetConnectionProfile -InterfaceIndex $ifIndex).Name -eq $tmNetwork){ }
            if((Get-NetAdapter -InterfaceIndex $tmIfIndex).MediaConnectionState -eq "Connected") {
                if(Test-Connection -ComputerName $tmServerName -Count 1) {
                    $tmContent = [System.IO.File]::ReadAllText($tmGlobalIni).Replace("Mehrplatzbetrieb={nein}","Mehrplatzbetrieb={ja}")
                } # check if in the right network: ping server
                else {
                    $tmContent = [System.IO.File]::ReadAllText($tmGlobalIni).Replace("Mehrplatzbetrieb={ja}","Mehrplatzbetrieb={nein}")
                } # start local TurboMed version if in the wrong network
            } # check if network connection is available
            
            else {
                $tmContent = [System.IO.File]::ReadAllText($tmGlobalIni).Replace("Mehrplatzbetrieb={ja}","Mehrplatzbetrieb={nein}")
            } # start local TurboMed version if no network connection is available
            
            [System.IO.File]::WriteAllText($tmGlobalIni, $tmContent)            
        }

        catch {
            [System.Windows.Forms.MessageBox]::Show("TurboMed Modus konnte nicht gesetzt werden!","Fehler")
            Break
        }
    }

    end {
        #nothing to do
    }
}

function TMCheckVersion
{
    begin {
        # cancel the execution if an error occurs
        $ErrorActionPreference = "Stop"
    }

    process {
        try {
            if((Get-Item $tmProgramm).VersionInfo.ProductVersion -ne (Get-Item $tmProgrammFake).VersionInfo.ProductVersion) {
                Copy-Item $tmProgramm $tmProgrammFake -Force
            } # if the two versions differ copy the original TurboMed.exe and rename it to TM.exe
        }
        catch {
            [System.Windows.Forms.MessageBox]::Show("TurboMed Version konnte nicht ersetzt werden!","Fehler")
            Break
        }
    }

    end {
        #nothing to do
    }
}


# ------ [Script] ------
TMSetMode
TMCheckVersion
C:\TurboMed\Programm\TM.exe
