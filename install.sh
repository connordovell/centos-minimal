#!/bin/bash

echo "Choose environment: (work/home):"
read environment

if [[ $environment != "work" && $environment != "home" ]]
then
  echo "Incorrect environment, should be work/home."
  exit 2
fi

# Environment independent:
## Purge
yum remove adwaita-qt5 brasero brasero-libs brasero-nautilus cheese cheese-libs control-center empathy eog evince evince-libs evince-nautilus evolution-data-server file-roller file-roller-nautilus gedit gnome-abrt gnome-bluetooth gnome-bluetooth-libs gnome-boxes gnome-calculator gnome-classic-session gnome-clocks gnome-color-manager gnome-contacts gnome-destkop3 gnome-dictionary gnome-citionary-libs gnome-disk-utility gnome-documents gnome-documents-libs gnome-font-viewer gnome-initial-setup gnome-keyring gnome-keyring-pam gnome-online-accounts gnome-online-miners gnome-packagekit gnome-packagekit-common gnome-packagekit-installer gnome-packagekit-updater gnome-screenshot gnome-session gnome-session-xsession gnome-settings-daemon gnome-shell gnome-shell-extension-alternate-tab gnome-shell-extensions-apps-menu gnome-shell-extension-common gnome-shell-extension-launch-new-instance gnome-shell-extension-places-menu gnome-shell-extensions-top-icons gnome-shell-extension-user-theme gnome-shell-extension-window-list gnome-software gnome-system-log gnome-system-monitor gnome-terminal gnome-terminal-nautilus gnome-tweak-tool gnome-weather nautilus nautilus-extensions shotwell totem totem-nautilus

## Package installation
yum install -y openbox lightdm vim geany tint2 libreoffice-writer libreoffice-calc firefox terminator levien-inconsolata-fonts Thunar i3lock

## Local package installation
yum localinstall --nogpgcheck -y rpms/nitrogen.rpm rpms/virtualbox.rpm

## Set display manager
systemctl disable gdm
systemctl enable lighdm

## Copy custom configs
cp -r home/rose/config/terminator/* /home/rose/.config/terminator/
cp -r home/rose/config/openbox/* /home/rose/.config/openbox/
cp -r home/rose/config/nitrogen/* /home/rose/.config/nitrogen/

# Copy over wallpaper
cp home/rose/Pictures/centos-server-room.jpg /home/rose/Pictures/centos-server-room.jpg

# Environment specific
if [ $environment == "home" ]
then
  # Set up repositories
  yum install -y epel-release
  yum localinstall --nogpgcheck -y rpms/nux-dextop.rpm
  yum localinstall --nogpgcheck -y rpms/rpmfusion-free.rpm
  # Package setup
  yum install -y zsnes
else
  yum install -y virt-viewer
fi

# Install packages needed to run /sbin/vboxconfig
yum install make gcc kernel-devel

# Set lightdm as the default display manager
systemctl disable gdm
systemctl enable lightdm

# Reboot
reboot
