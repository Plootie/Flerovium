$HD2AppID = 553850
$ErrorTitle = "Fatal Error!"
$GGMainName = "GameGuard.des"
$GGMonitorName = "GameMon.des"


while ($true) {
    Write-Output "Starting Helldivers..."
    Start-Process "steam://launch/$HD2AppID"
    while($HD2Proc -eq $null)
    {
        Start-Sleep -Milliseconds 100
        $HD2Proc = Get-Process "helldivers2" -ErrorAction SilentlyContinue
    }
    Write-Output "Helldivers started."
    Write-Output "Waiting for GameGuard..."

    while($true)
    {
        Start-Sleep -Milliseconds 100
        $GGMainProc = Get-Process $GGMainName -ErrorAction SilentlyContinue
        $GGMonitorProc = Get-Process $GGMonitorName -ErrorAction SilentlyContinue
        if($GGMainProc -eq $null -And $GGMonitorProc -ne $null)
        {
            Write-Output "GameGuard startup complete. Checking game status..."
            break
        }
        else
        {
            if($GGMainProc -eq $null -And $GGMonitorProc -eq $null -And $HD2Proc -ne $null -And $HD2Proc.HasExited -eq $false)
            {
                Write-Output "GameGuard looks to have failed to start. Checking game status..."
                break
            }
        }
    }

    $HD2Proc = Get-Process "helldivers2" -ErrorAction SilentlyContinue
    if($HD2Proc -eq $null)
    {
        Write-Output "Helldivers closed unexpetedly. Restarting..."
        continue;
    }

    Write-Output "Checking for error window..."
    if($HD2Proc.MainWindowTitle -eq $ErrorTitle)
    {
        Write-Output "Error window detected. Restarting..."
        Stop-Process -Name "helldivers2"
        continue;
    }
    else
    {
        Write-Output "No error window detected. Assuming successful start."
        Write-Output "Exiting..."
        Exit
    }
}