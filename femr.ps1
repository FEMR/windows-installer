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
Set-Location $PSScriptRoot

Write-Host "Current working directory: $(Get-Location)"
Write-Host "Script directory: $PSScriptRoot"

# starting  Docker Desktop 
# check if Docker Desktop is running
$dockerProcess = docker version --format '{{.Server.Version}}' 2>$null 
if (-not $dockerProcess) { #if not
    # find docker desktop via Windows Registry
    $regPath = (Get-ItemProperty -Path "HKLM:\Software\Docker Inc.\Docker" -Name "InstallationDir" -ErrorAction SilentlyContinue).InstallationDir
    $dockerExe = if ($regPath) { "$regPath\Docker Desktop.exe" } else { "C:\Program Files\Docker\Docker\Docker Desktop.exe" }

    Write-Host "Starting Docker Desktop..."
    Start-Process $dockerExe

    # polling on Docker Desktop with 60 tries
    $attempt = 0
    while ($attempt -lt 60) { #check if docker is ready
        if (docker ps 2>$null) { Write-Host "Docker Desktop up and running."; break }
        $attempt++
        Start-Sleep -Seconds 1
    }

    # needs a fix; docker ps is blocking wait
    # timeout not triggered if docker daemon is hanging or unresponsive
    # currently, aborting script is perfectly fine

    Write-Host "Docker Desktop took too long; please try again after Docker Desktop opens: Press Enter to exit..."
    Read-Host
    exit
} else {
    Write-Host "Docker Desktop is already running."
}

# docker compose up doesn't fetch latest version on remote DockerHub
# if internet connection exists, pull latest versions of images
# load offline cache into Docker 

try {
    # check for internet connection, break if air-gapped
    Write-Host "Checking internet connection"
    Invoke-WebRequest -Uri "https://hub.docker.com/v2/repositories/library/" -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop | Select-Object StatusCode, StatusDescription
    # above method for checking internet connection fails

    # fetch latest images on DockerHub
    Write-Host "Internet connection detected, fetching latest images on DockerHub..."
    docker compose pull

    # modify offline cache of femr docker images
    Write-Host "Updating offline cache of Docker images..."
    docker save -o femr-images-temp.tar $(docker compose config --images)
    Remove-Item -Path "./femr-images.tar"
    Rename-Item -Path "./femr-images-temp.tar" -NewName "./femr-images.tar"
    Write-Host "Updated offline cache."
} catch {
    Write-Host "No internet connection detected. Loading offline image cache..."
    docker load -i .\femr-images.tar
}

Write-Host "============================="
Write-Host "Starting fEMR..."
Write-Host "Ctrl+C in this window to shutdown the fEMR server"
Write-Host "============================="

docker-compose up

Write-Host "Successfully closed femr. Press Enter to exit..."
Read-Host

# To-do:
    # script based backup for latest N backups etc 
    # compression on backup volumes