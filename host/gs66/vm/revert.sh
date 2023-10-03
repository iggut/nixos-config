#!/run/current-system/sw/bin/bash

# Unload vfio module
modprobe -r vfio
modprobe -r vfio_iommu_type1
modprobe -r vfio-pci

# Attach GPU devices from host
virsh nodedev-reattach pci_0000_01_00_0
virsh nodedev-reattach pci_0000_01_00_1
virsh nodedev-reattach pci_0000_01_00_2
virsh nodedev-reattach pci_0000_01_00_3

# Load NVIDIA kernel modules
modprobe nvidia
modprobe nvidia_uvm
modprobe nvidia_modeset
modprobe nvidia_drm

# Avoid race condition
sleep 5

# Bind EFI Framebuffer
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/bind

# Bind VTconsoles
echo 1 > /sys/class/vtconsole/vtcon0/bind
echo 1 > /sys/class/vtconsole/vtcon1/bind

# Start display manager
systemctl start display-manager.service

nvidia-smi -pm 1
