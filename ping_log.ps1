# PowerShell script to continuously ping Google.com, log the observations, and rotate logs hourly

$hostToPing = "google.com"

# Function to log messages to a file
function Log-Message {
    param(
        [string]$message,
        [string]$logFilePath
    )

    $logMessage = "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") - $message"
    Add-Content -Path $logFilePath -Value $logMessage
}

# Function to generate the log file path with hourly rotation
function Get-LogFilePath {
    $timestamp = Get-Date -Format "yyyyMMdd_HH"
    $logFileName = "PingLog_$timestamp.txt"
    $logFilePath = Join-Path -Path $PSScriptRoot -ChildPath $logFileName
    return $logFilePath
}

# Infinite loop for continuous pinging
while ($true) {
    $logFilePath = Get-LogFilePath
    Log-Message "Starting continuous ping test to $hostToPing..." -logFilePath $logFilePath

    $pingResult = Test-Connection -ComputerName $hostToPing -Count 1

    if ($pingResult.ResponseTime -eq $null) {
        $logMessage = "Destination unreachable"
    } else {
        $logMessage = "Response time = $($pingResult.ResponseTime) ms"
    }

    Log-Message $logMessage -logFilePath $logFilePath
    Start-Sleep -Seconds 1  # Add a short delay between ping attempts
}
