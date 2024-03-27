New-Item $PROFILE -Force
Copy-Item 'profile.ps1' $PROFILE
Copy-Item '.gitconfig' $HOME
