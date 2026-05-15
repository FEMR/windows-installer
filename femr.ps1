Write-Host "

 .d888 8888888888 888b     d888 8888888b.  
d88P""  888        8888b   d8888 888   Y88b 
888    888        88888b.d88888 888    888 
888888 8888888    888Y88888P888 888   d88P 
888    888        888 Y888P 888 8888888P""  
888    888        888  Y8P  888 888 T88b   
888    888        888   ""   888 888  T88b  
888    8888888888 888       888 888   T88b 
"


#To-do 5/13/2026:
# need to adjust .aip to include docker compose overrides
# check if working directory is set properly in .aip for github workflow
Write-Host "Current working directory: $(Get-Location)"
Write-Host "Script directory: $PSScriptRoot"

# start Docker Desktop
$dockerProcess = docker version --format '{{.Server.Version}}' 2>$null #check if running
if (-not $dockerProcess) {
    #find docker desktop via windows registries
    $regPath = (Get-ItemProperty -Path "HKLM:\Software\Docker Inc.\Docker" -Name "InstallationDir" -ErrorAction SilentlyContinue).InstallationDir
    $dockerExe = if ($regPath) { "$regPath\Docker Desktop.exe" } else { "C:\Program Files\Docker\Docker\Docker Desktop.exe" }

    Write-Host "Starting Docker Desktop..."
    Start-Process $dockerExe

    $attempt = 0
    while ($attempt -lt 60) { #check if docker is ready
        if (docker ps 2>$null) { Write-Host "Docker Desktop up and running."; break }
        $attempt++
        Start-Sleep -Seconds 1
    }
    Write-Host "Docker Desktop took too long; please try again after Docker Desktop opens..."
    break
} else {
    Write-Host "Docker Desktop is already running."
}

# check for existing femr-db-data volume (used to store volumes across containers for compatibility with app deployed 
# from femr/femr as well as femr/windows-installer)
# - required external volumes

if (docker volume ls -q -f name=femr-ext-volume ) {
    Write-Host "Volume 'femr-ext-volume' already exists."
} else {
    docker volume create femr-ext-volume
    Write-Host "Created new volume 'femr-ext-volume'."
}

Write-Host "============================="
Write-Host "Starting fEMR..."
Write-Host "Ctrl+C in this window to shutdown the fEMR server"
Write-Host "============================="

# load bundled docker images if there is no internet connection
# docker will default to fetch images from dockerhub;

# todo: GOING TO MAKE FEMR/femr BUNDLE IMAGES
# installer to only use bundled images


docker-compose up

Write-Host "Successfully closed femr. Press Enter to exit..."
Read-Host