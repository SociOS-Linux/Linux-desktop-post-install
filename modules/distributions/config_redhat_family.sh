# Add Flathub
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# Autoselect RPM packages instead of Flatpaks in GNOME Software
gsettings set org.gnome.software packaging-format-preference "['RPM', 'flatpak']"


# Add the Appstream metadata
sudo dnf groupupdate -y core
# Install the multimedia packages needed by gstreamer enabled applications
sudo dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
# Install the sound-and-video complement packages needed by some applications
sudo dnf groupupdate -y sound-and-video
# Install tainted repo
sudo dnf install -y rpmfusion-free-release-tainted
# Install DVD support
sudo dnf install -y libdvdcss
# Install tainted-nonfree repo
sudo dnf install -y rpmfusion-nonfree-release-tainted
# Install missing firmwares
sudo dnf install -y \*-firmware

## Additional software ##
# Firewall GUI
sudo dnf install -y firewall-config
# iOS devices filesystem support
sudo dnf install -y ifuse
# Install WEBP images support for desktop environments which lack it by default
case $(printf "%s" "${XDG_SESSION_DESKTOP}") in
  gnome)
    sudo dnf install -y webp-pixbuf-loader
    xdg-mime default org.gnome.eog.desktop image/webp
    ;;
  cinnamon)
    sudo dnf install -y webp-pixbuf-loader
    ;;
  xfce)
    sudo dnf install -y webp-pixbuf-loader
    xdg-mime default org.xfce.ristretto.desktop image/webp
    ;;
esac
# Install .rar archive support for desktop environments which lack it by default
case $(printf "%s" "${XDG_SESSION_DESKTOP}") in
  xfce) sudo dnf install -y unrar ;;
esac
# Install GNOME Extension manager for GNOME
if [[ $(printf "%s" "${XDG_SESSION_DESKTOP}") == 'gnome' ]] ; then
  flatpak install -y com.mattjakeman.ExtensionManager
  #sudo dnf install -y file-roller file-roller-nautilus
fi

## Nvidia ##
if [[ $(lspci | grep -ci NVIDIA) -gt 0 ]] ; then
  sudo dnf install -y akmod-nvidia
fi

## Updates ##
sudo dnf upgrade -y
sudo dnf autoremove -y
flatpak update -y
flatpak remove -y --unused
