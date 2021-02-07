#!/bin/bash

source ./prints.sh

if (( $EUID != 0 )); then
	print_err "Run this script as root!" ,
	exit 1
fi

function main()
{
	KERNEL=$(uname -v)
	OS=-1
	if [[ $(cat /etc/*-release | grep Ubuntu) != "" ]]; then OS=1; fi
	if [[ $(cat /etc/*-release | grep Raspbian) != "" ]]; then OS=2; fi

	config_folder=""
	if [[ "$OS" -eq 1 ]]; then config_folder="/boot/firmware"; fi
	if [[ "$OS" -eq 2 ]]; then config_folder="/firmware"; fi

	print_menu "$KERNEL" "$OS"
}

function remove_lcd()
{
	clear
	print_title "Removing..."
	print_inf "Config folder: $config_folder"
	
	echo
	sudo sed -i 's/fbcon=map:10 fbcon=font:ProFont6x11//g' $config_folder/cmdline.txt
	sudo sed -i '/^dtoverlay=/d' $config_folder/usercfg.txt
	sudo sed -i '/^dtparam=spi=/d' $config_folder/usercfg.txt
	echo

	#sudo rm $config_folder/overlays/waveshare35a.dtbo
	echo 'Press any key to return.'
	read -n 1 c
	echo
	print_menu
}

function install_lcd()
{
	sel=$1
	if [[ "$sel" -eq 1 ]]; then overlay=waveshare35a; fi

	clear
	print_title "Installing..."

	if [[ ! -f ./overlays/$overlay-overlay.dtb ]]; then
		print_err 'Error: Required files are missing...' ,
		echo 'Press any key to return.'
		read -n 1 c
		echo
		print_menu
	fi

	print_inf "Enter rotation (0): "
	read rotation
	if [[ -z "$rotation" ]]; then rotation=0; fi

	sudo sed -i 's/fbcon=map:10 fbcon=font:ProFont6x11//g' $config_folder/cmdline.txt
	sudo sed -i 's/$/ fbcon=map:10 fbcon=font:ProFont6x11/g' $config_folder/cmdline.txt

	sudo sed -i '/^dtoverlay=/d' $config_folder/usercfg.txt
	sudo sed -i '/^dtparam=spi=/d' $config_folder/usercfg.txt

	echo "dtoverlay=$overlay:rotate=$rotation" | sudo tee -a $config_folder/usercfg.txt
	echo "dtparam=spi=on" | sudo tee -a $config_folder/usercfg.txt

	sudo cp ./overlays/$overlay-overlay.dtb $config_folder/overlays/$overlay.dtbo

	echo 'Press any key to return.'
	read -n 1 c
	echo
	print_menu
}

function print_lcdselection()
{
	clear
	print_inf "Select the installed LCD type" ,
	print_wrn "-----------------------------" ,
	print_ok "1) Waveshare 3.5'" ,
	print_err "2) Return" ,
	print_wrn "-----------------------------" ,
	print_inf "Select: "
	read -n 1 c
	echo

	if [[ "$c" -ne 2 ]]; then install_lcd $c; fi
	if [[ "$c" -eq 2 ]]; then print_menu; fi
}

function print_menu()
{
	clear
	print_title "RaspberryPi LCD Installer"
	print_wrn "-------------------------" ,
	print_ok "1) Install LCD Support" ,
	print_ok "2) Remove LCD Support" ,
	print_err "3) Exit" ,
	print_wrn "-------------------------" ,
	print_inf "Select: "
	read -n 1 c
	echo

	if [[ "$c" -eq "1" ]]; then print_lcdselection; fi
	if [[ "$c" -eq "2" ]]; then remove_lcd; fi
	if [[ "$c" -eq "3" ]]; then exit 0; fi
}


# ----------------------------------------------------
main
