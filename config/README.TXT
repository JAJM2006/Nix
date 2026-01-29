Quick reference for your setup:
Add system packages: Edit system/hosts/EliteDesk/configuration.nix
Add user packages: Edit home/juso.nix in home.packages
Configure programs: Edit home/juso.nix in programs.*
Rebuild from anywhere: Just run rebuild
When you're ready to deploy to other machines, you can:

Copy the Settings folder to the new machine
Create a new host config in system/hosts/NewMachine/
Add it to flake.nix as a new nixosConfigurations
Share the same home/juso.nix across all machines!
