#!/run/current-system/sw/bin/bash

# Stop display manager
systemctl stop display-manager.service
killall gdm-x-session
killall gdm-wayland-session
killall gdm-session

# Unbind VTconsoles
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

# Unbind EFI Framebuffer
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

# Avoid race condition
sleep 5

# Unload NVIDIA kernel modules
modprobe -r nvidia_drm
modprobe -r nvidia_modeset
modprobe -r nvidia_uvm
modprobe -r nvidia

# Detach GPU devices from host
virsh nodedev-detach pci_0000_01_00_0
virsh nodedev-detach pci_0000_01_00_1
virsh nodedev-detach pci_0000_01_00_2
virsh nodedev-detach pci_0000_01_00_3

# Load VFIO Kernel Module
modprobe vfio-pci
modprobe vfio_iommu_type1
modprobe vfio
