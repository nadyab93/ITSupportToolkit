# IT Support Automation Toolkit
# Developed by Nadya

Clear-Host
Write-Host "--- IT Support Toolkit ---" -ForegroundColor Cyan
Write-Host "1. System Health Check"
Write-Host "2. Network Information"
Write-Host "3. Disk Usage"
Write-Host "4. Top Processes"
Write-Host "5. Export System Report"
Write-Host "6. Exit"

$choice = Read-Host "`nEnter your choice (1-6)"

# This is where we will add the logic for each choice next
Write-Host "You selected option: $choice"
if ($choice -eq "1") {
    Write-Host "`n--- System Health ---" -ForegroundColor Yellow
    # This command pulls your RAM information
    Get-ComputerInfo | Select-Object CsTotalPhysicalMemory
    # This command shows your disk space usage
    Get-PSDrive -PSProvider FileSystem | Select-Object Name, Used, Free
}
# Logic for Option 2: Network Information
if ($choice -eq "2") {
    Write-Host "`n--- Network Information ---" -ForegroundColor Green
    # Shows only IPv4 addresses
    Get-NetIPAddress | Where-Object {$_.AddressFamily -eq "IPv4"} | Select-Object IPAddress, InterfaceAlias
    # Lists network adapters and their current status (Up/Down)
    Get-NetAdapter | Select-Object Name, Status, LinkSpeed
}
# Logic for Option 3: Disk Usage
if ($choice -eq "3") {
    Write-Host "`n--- Disk Usage ---" -ForegroundColor Blue
    Get-PSDrive -PSProvider FileSystem | Select-Object Name, Used, Free | Format-Table
}

# Logic for Option 4: Top Processes
if ($choice -eq "4") {
    Write-Host "`n--- Top Processes (CPU) ---" -ForegroundColor Red
    # Sorts processes by CPU usage and takes the top 5
    Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 | Format-Table Name, CPU, WorkingSet
}
# Logic for Option 5: Export System Report
if ($choice -eq "5") {
    Write-Host "`nGenerating report... please wait." -ForegroundColor Cyan
    $reportPath = "$PSScriptRoot\system_report.txt"
    
    $report = @()
    $report += "================================"
    $report += "IT SUPPORT SYSTEM REPORT"
    $report += "Generated on: $(Get-Date)"
    $report += "================================"
    $report += "`n[CPU INFO]"
    $report += Get-Process | Sort-Object CPU -Descending | Select-Object -First 1 | Out-String
    $report += "`n[RAM INFO]"
    $report += Get-ComputerInfo | Select-Object CsTotalPhysicalMemory | Out-String
    $report += "`n[DISK INFO]"
    $report += Get-PSDrive -PSProvider FileSystem | Select-Object Name, Used, Free | Out-String
    $report += "`n[NETWORK INFO]"
    $report += Get-NetIPAddress | Where-Object {$_.AddressFamily -eq 'IPv4'} | Select-Object IPAddress | Out-String
    
    # Saves the compiled data into a text file
    $report | Out-File $reportPath
    Write-Host "✅ Report successfully saved to: system_report.txt" -ForegroundColor Green
}
if ($choice -eq "6") {
    Write-Host "Exiting Toolkit. Have a great day!" -ForegroundColor Cyan
    exit
}