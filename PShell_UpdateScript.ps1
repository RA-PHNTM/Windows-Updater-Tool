# NuGet package provider install check
if (-not (Get-PackageProvider -Name NuGet -ListAvailable)) {
    Write-Output "NuGet provider not found. Installing..."
    Install-PackageProvider -Name NuGet -Force -Scope CurrentUser
}

# PSWindowsUpdate install check
if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Write-Output "PSWindowsUpdate module not found. Installing..."
    Install-Module -Name PSWindowsUpdate -Force -SkipPublisherCheck
}

Import-Module PSWindowsUpdate

# list available updates/drivers
function List-CurrentUpdatesAndDrivers {
    Write-Output "Checking current installed updates and drivers..."

    # List installed updates/drivers
    Write-Output "Installed Windows Updates:"
    Get-HotFix | Select-Object -Property Description, HotFixID, InstalledOn

    
    Write-Output "Installed Drivers:"
    Get-WmiObject Win32_PnPSignedDriver | Select-Object -Property DeviceName, DriverVersion, DriverDate
}

# Function to check for available updates and drivers
function Check-ForUpdatesAndDrivers {
    Write-Output "Checking for available Windows updates and drivers..."

    # Check for Windows updates
    $updates = Get-WindowsUpdate -AcceptAll -IgnoreReboot
    Write-Output "Available Windows Updates:"
    $updates | Select-Object -Property KBArticle, Title, Size, MsrcSeverity

    # Note: Checking for driver updates programmatically is complex and may require third-party tools or additional scripting.
    Write-Output "Driver updates are managed by Windows Update or third-party tools."
}

# Download updates and drivers
function Download-UpdatesAndDrivers {
    Write-Output "Downloading available Windows updates and drivers..."

    # Download Windows updates
    Write-Output "Downloading Windows Updates:"
    Get-WindowsUpdate -Download -AcceptAll

    Write-Output "Windows updates will be downloaded to the default Windows Update download directory."

    # Note: Downloading driver updates programmatically is more complex and typically managed by Windows Update itself or third-party tools.
    Write-Output "Driver updates will be managed by Windows Update or need to be handled manually."
}


List-CurrentUpdatesAndDrivers
Check-ForUpdatesAndDrivers

#downloading updates
$downloadChoice = Read-Host "Do you want to download the available updates and drivers? (Y/N)"
if ($downloadChoice -eq 'Y') {
    Download-UpdatesAndDrivers
} else {
    Write-Output "Download skipped."
}
