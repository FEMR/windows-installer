# FEMR - Fast Electronic Medical Records

<img src="https://github.com/user-attachments/assets/dbad0bc5-3f97-4bfe-903b-90a47c045f91" width="60%"/>

This is the windows-installer for https://github.com/FEMR/femr. Installer releases are intended to be consumer facing.

## For End Users
To install fEMR on Windows, go to the [Latest Installer Release](https://github.com/FEMR/windows-installer/releases/latest) page and download the `femr-xxx-setup.exe` file listed under **Assets**.

Need an older version? Visit the [GitHub Releases](https://github.com/FEMR/windows-installer/releases) page.
> An older version of the installer does not mean an older version of the fEMR app due to technicals.

<p>&nbsp;</p>

**Initially, the setup process requires internet connection to ensure dependencies (i.e. Docker Desktop) are installed.**

The default installation path is `C:/Program Files/Team FEMR/femr`.
After the setup, running the application is designed to be entirely offline. The application can be run through the Start Menu, Start Menu search bar, and desktop shortcuts. To update the app, simply run the app in an online environment. 


New installer releases **DO NOT** need to be installed to get the latest fEMR app updates. 

<p>&nbsp;</p>



___

## For Developers

As of 5/27/2026, installer releases are created through a manually triggered workflow that takes in \<version\> as input. It can be run under Actions section. The workflow pulls necessary files for creating an installer from the current repository (FEMR/windows-installer) OR FEMR/femr repository OR builds them directly in the Github Runner. 


The following files are from the windows-installer repository.

- **femr.ps1**: the entry script to startup the fEMR application

- **femrInstaller.aip**: Advanced Installer file to build the installer

- **docker-compose.override.yml**: Since we pull docker-compose.yml directly from FEMR/femr into staging, we override the directive that builds the docker image and replace it with a DockerHub image.

- **Misc. files**: miscellaneous files

	> README.md, FEMR_EULA.rtf, femr.ico

	> Note: The docker-compose.yml in FEMR/windows-installer is only for installer development purposes.

### Other Files

- **docker-compose.yml**: the compose stack

	> Installer production uses docker-compose.yml directly from FEMR/femr. <br> IMPORTANT: docker-compose.yml in current repository is for quick testing purposes.

- **femr-images.tar**: an offline cache of docker images used by the application
	> Docker Desktop does cache images on its own, but the offline cache handles the case when Docker never had an image pulled locally from DockerHub.
	Also serves as emergency backup for remote fixes

<p>&nbsp;</p>

## Installed Files And Folders

All Advanced Installer does is take in a bunch of files and folders and produces an installer that restores those files and folders. It also provides additional functionality better referred on their official site.



  
  

### [EULA and Privacy Policy](https://github.com/FEMR/femr/blob/master/LICENSE)

  
