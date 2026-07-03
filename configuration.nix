{ config, lib, pkgs, ... }:

{
	imports =
		[ # Include the results of the hardware scan.
			./hardware-configuration.nix
		];

	################
	# system stuff #
	################

	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	networking.hostName = "nixos";
	networking.networkmanager.enable = true; #nmtui goat
	nixpkgs.config.allowUnfree = true;

	###################
	# display & audio #
	###################

	programs.hyprland = {
		enable = true;
		xwayland.enable = true;
	};
	hardware.graphics.enable = true;
	services.xserver.videoDrivers = [ "nvidia" ];
	hardware.nvidia = {
		modesetting.enable = true;
		powerManagement.enable = false;
		open = false;
		nvidiaSettings = true;
		package = config.boot.kernelPackages.nvidiaPackages.stable;
	};

	environment.sessionVariables = {
		NIXOS_OZONE_WL = "1";
		GBM_BACKEND = "nvidia-drm";
		__GLX_VENDOR_LIBRARY_NAME = "nvidia";
	};
	programs.gamemode.enable = true;
	services.pipewire = {
		enable = true;
		pulse.enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		jack.enable = true;
	};

	#################	
	# user settings #
	#################
	
	users.users.slushy = {
		isNormalUser = true;
		extraGroups = [ "wheel" ];
		packages = with pkgs; [
			tree
			fastfetch
			alacritty
			thunar
			firefox
			neovim
			nix-search-cli
			prismlauncher
			vencord
			rofi
			lutris
			steam
			protonup-qt
			waybar
			hyprpaper
			bottles
		];
		initialPassword = "changeme";
	};

	environment.systemPackages = with pkgs; [
		nano
		wget
		curl
		git
		stdenv
		htop
		gnumake
		github-cli
	];

	fonts.packages = with pkgs; [
		nerd-fonts.jetbrains-mono
	];

	system.stateVersion = "26.05"; # dont change this probably

}
