#!/bin/bash

# Monitor Variables
MONITOR_CENTER='HDMI-0'
MONITOR_RIGHT='DVI-0'
MONITOR_LEFT='DisplayPort-0'

# Installation CD location For Windows and VIRTIO Drivers
INSTALLCD='/home/nabler/Documents/3_KVM/ISO/Win10_1607_English_x64.iso'
DRIVERCD='/home/nabler/Documents/3_KVM/ISO/virtio-win-0.1.141.iso'
WINDOWSIMG='/home/nabler/WINDOWS-VM/win10_BIOS.qcow2'

# if you use a hardware CD-ROM drive, check for the device. In most cases it's /dev/sr0
INSTALLCD=/dev/sr0

# PCI address of the passthrough devices
NVIDIA_GPU='04:00.0' `# Nvidia GTX 1060`
NVIDIA_GPU_AUDIO='04:00.1' `# Nvidia GTX 1060 Audio Controller`
USB0="02:00.0" `# VIA PCIE USB 3.0 Controller`
USB1="07:00.0" `# Intel Motherboard USB 3.0 Controller`

# AMD Motherboard PCI Stubs of USB controllers
USB2="00:16.0"
USB3="00:16.2"

# Physical Boot Drive Directory
SATA0="/dev/sdb"

# Checking for root access
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root"
	exit 1
fi

splashScreen()
{
	clear
	printf "    ____  ______ __  __ _    _    ___  ____      ____  __    \n"
	printf "   / __ \|  ____|  \/  | |  | |  / / |/ /\ \    / /  \/  |   \n"
	printf "  | |  | | |__  | \  / | |  | | / /| ' /  \ \  / /| \  / |   \n"
	printf "  | |  | |  __| | |\/| | |  | |/ / |  <    \ \/ / | |\/| |   \n"
	printf "  | |__| | |____| |  | | |__| / /  | . \    \  /  | |  | |   \n"
	printf "   \___\_\______|_|  |_|\____/_/   |_|\_\    \/   |_|  |_|   \n"
	printf "\n=============================================================\n"
}

usbBind()
{
	if [[ $1 == 'bindNow' ]]; then
		printf "\n               Binding PCIE USB HUB to VFIO                  "
		printf "\n=============================================================\n"

		for dev in "0000:$2"
		do
			vendor=$(cat /sys/bus/pci/devices/${dev}/vendor)
			device=$(cat /sys/bus/pci/devices/${dev}/device)
			if [[ -e /sys/bus/pci/devices/${dev}/driver ]]
			then
				echo "${dev}" | tee /sys/bus/pci/devices/${dev}/driver/unbind > /dev/null
				while [[ -e /sys/bus/pci/devices/${dev}/driver ]]
				do
					sleep 0.1
				done
			fi
			echo "${vendor} ${device}" | tee /sys/bus/pci/drivers/vfio-pci/new_id > /dev/null
		done
	elif [[ $1 == 'unbindNow' ]]; then
		printf "\n               Binding PCIE USB HUB to xhci_hcd              "
		printf "\n=============================================================\n"
		for dev in "0000:$2"
		do
			if [[ -e /sys/bus/pci/devices/${dev}/driver ]]
			then
				vendor=$(cat /sys/bus/pci/devices/${dev}/vendor)
				device=$(cat /sys/bus/pci/devices/${dev}/device)
				echo "${vendor} ${device}" | tee /sys/bus/pci/drivers/vfio-pci/remove_id > /dev/null
				echo "${dev}" | tee /sys/bus/pci/devices/${dev}/driver/unbind > /dev/null
				while [[ -e /sys/bus/pci/devices/${dev}/driver ]]
				do
					sleep 0.1
				done
			fi
			echo "${dev}" | tee /sys/bus/pci/drivers/xhci_hcd/bind > /dev/null
		done
	else
		exit 1
	fi
}

monitorSwitch()
{
	if [ $1 == 'switch' ]
	then
		printf "\n               Switching Monitor Inputs                      "
		printf "\n=============================================================\n"
		xrandr --output $MONITOR_CENTER --off --output $MONITOR_RIGHT --off --output $MONITOR_LEFT --auto --primary
	elif [ $1 == 'switchBack' ]
	then
		printf "\n               Switching Monitor Inputs                      "
		printf "\n=============================================================\n"
		xrandr --output $MONITOR_CENTER --auto --primary --output $MONITOR_LEFT --auto --left-of $MONITOR_CENTER --output $MONITOR_RIGHT --auto --right-of $MONITOR_CENTER
	else
		exit 1
	fi
}

networkBridge()
{
	if [[ $1 == 'start' ]]; then
		echo "Network Adapter Settings"
		ip link add name bridge0 type bridge
		ip link set bridge0 up
		ip link set eno1 up
		ip link set eno1 master bridge0
		bridge link
	elif [[ $1 == 'stop' ]]; then
		echo "Network Adapter Settings"
		ip link set eno1 nomaster
		ip link delete bridge0 type bridge
		bridge link
	else
		exit 1
	fi
}

qemuStart()
{
	if [[ ! -e  /home/nabler/.config/qemu/OVMF_CODE.fd ]]; then
	    mkdir -p /home/nabler/.config/qemu/
		cp /usr/share/ovmf/x64/OVMF_CODE.fd /home/nabler/.config/qemu/OVMF_CODE.fd
	fi

	printf "\n               Windows VM is starting                        "
	printf "\n=============================================================\n"
	#export QEMU_AUDIO_DRV="pa"
	sudo qemu-system-x86_64 \
		-nodefaults \
		-nodefconfig \
		-no-user-config \
		-serial none \
		-parallel none \
		-name WIN10_VM \
		-m 14128 \
		-enable-kvm \
		-cpu host,kvm=off,hv_vapic,hv_time,hv_relaxed,hv_spinlocks=0x1fff,hv_vendor_id=sugoidesu \
		-smp 8,sockets=1,cores=4,threads=2 \
		-machine pc-i440fx-2.8,accel=kvm,kernel_irqchip=on,mem-merge=off \
		-device vfio-pci,host=$NVIDIA_GPU,addr=0x8.0x0,multifunction=on,x-vga=on \
		-device vfio-pci,host=$NVIDIA_GPU_AUDIO,addr=0x8.0x1 \
		-device vfio-pci,host=$USB0 \
		-netdev user,id=user.0 \
		-device qxl `# ,vgamem_mb=32` \
		-device virtio-net-pci,netdev=user.0,mac=52:54:78:a0:66:b3 \
		-rtc base=localtime,driftfix=slew \
		-device virtio-scsi-pci,id=scsi \
		-drive if=pflash,format=raw,readonly,file=/home/nabler/.config/qemu/OVMF_CODE.fd \
		-drive file=$SATA0,id=disk0,format=raw,if=none -device scsi-hd,drive=disk0 `# Physical Hard Drive` \
		#-vga none \
		#-boot menu=on \
		#-drive file=$INSTALLCD,id=isocd,format=raw,if=none -device scsi-cd,drive=isocd \
		#-drive file=$DRIVERCD,id=virtiocd,format=raw,if=none -device ide-cd,bus=ide.1,drive=virtiocd \
		#-usb -usbdevice host:0a12:0001 `# Bluetooth Adapter` \
	    #-usb -usbdevice host:0d8c:0102 `# CM106 USB Sound Card` \
		#-usb -usbdevice host:045e:028e `# Xbox 360 Controller` \
		#-soundhw hda \
		#-drive if=pflash,format=raw,readonly,file=/usr/share/ovmf/x64/ovmf_code_x64.bin \
		#-drive if=pflash,format=raw,file=/usr/share/ovmf/x64/ovmf_vars_x64.bin \
		#-soundhw hda \
		#-drive file=$SATA1,id=disk1,format=raw,if=none -device scsi-hd,drive=disk1
		#-drive file=$WINDOWSIMG,id=disk,format=qcow2,if=none -device scsi-hd,drive=disk \
		#-mem-path /dev/hugepages \
		#-mem-prealloc \
	printf "\n               Windows VM Has Been Closed                    "
	printf "\n=============================================================\n"
}

splashScreen
usbBind bindNow $USB0
monitorSwitch switch
qemuStart
usbBind unbindNow $USB0
monitorSwitch switchBack

#----------------------------------------System Services & monitor----------------------------------------
# load vfio-pci module
# modprobe vfio-pci
#
# for dev in "0000:$NVIDIA_GPU" "0000:$NVIDIA_GPU_AUDIO"; do
#         vendor=$(cat /sys/bus/pci/devices/$dev/vendor)
#         device=$(cat /sys/bus/pci/devices/$dev/device)
#         if [ -e /sys/bus/pci/devices/$dev/driver ]; then
#                echo $dev > /sys/bus/pci/devices/$dev/driver/unbind
#         fi
#         echo $vendor $device > /sys/bus/pci/drivers/vfio-pci/new_id
# done
#

#------------------------------------------Additional Modules---------------------------------------------
#export SDL_VIDEO_X11_DGAMOUSE=0
#QEMU_ALSA_DAC_BUFFER_SIZE=512 QEMU_ALSA_DAC_PERIOD_SIZE=170 QEMU_AUDIO_DRV=alsa

#-serial none \
#-parallel none \
#-nodefaults \
#-nodefconfig \
#-no-user-config \
#-mem-prealloc \
#-mem-path /dev/hugepages \
#-drive if=pflash,format=raw,readonly,file=/usr/share/ovmf/x64/ovmf_code_x64.bin \
#-drive if=pflash,format=raw,file=/usr/share/ovmf/x64/ovmf_vars_x64.bin \
#-cpu host,kvm=off,hv_vapic,hv_time,hv_relaxed,hv_spinlocks=0x1fff,hv_vendor_id=sugoidesu \
#-cpu Opteron_G4,kvm=off \
#-device vfio-pci,host=$USB1 \
#-device vfio-pci,host=$USB2 \
#-device vfio-pci,host=$NVIDIA_GPU,addr=0x8.0x0,multifunction=on,x-vga=on \
#-device vfio-pci,host=$NVIDIA_GPU_AUDIO,addr=0x8.0x1 \

# Networking
#-netdev user,id=network0 -device e1000,netdev=network0 \
#-net nic -net bridge,br=bridge0 \
#-device virtio-net-pci,netdev=user.0,mac=52:54:78:a0:66:b3 \
#-netdev user,id=user.0 \

# Hardware
#-soundhw hda \
#-device usb-tablet \
#-device usb-kbd \
#-device qxl \
#-device virtio-net-pci,netdev=user.0,mac=52:54:00:a0:66:43 \
#-netdev user,id=user.0 \
#-boot order=c

# Drive Options
#-drive file=$INSTALLCD,id=isocd,format=raw,if=none -device scsi-cd,drive=isocd \
#-drive file=$DRIVERCD,id=virtiocd,format=raw,if=none -device ide-cd,bus=ide.1,drive=virtiocd \
#-drive file=$SATA0,id=disk0,format=raw,if=none -device scsi-hd,drive=disk0 \
#-drive file=$INSTALLCD,id=isocd,if=none -device scsi-cd,drive=isocd \
#-drive file=$DRIVERCD,id=virtiocd,if=none -device ide-cd,bus=ide.1,drive=virtiocd \
#-drive file=$INSTALLIMG,id=disk,format=raw,if=none -device scsi-hd,drive=disk \
#-drive file=$INSTALLCD,id=isocd,if=none -device scsi-cd,drive=isocd \
#-drive file=$DRIVERCD,id=virtiocd,if=none -device ide-cd,bus=ide.1,drive=virtiocd \
#-drive file=$INSTALLCD,id=isocd,if=none -device scsi-cd,drive=isocd \
#-drive file=$DRIVERCD,id=virtiocd,if=none -device ide-cd,bus=ide.1,drive=virtiocd \
#-drive file=/dev/$SATA1,id=disk1,format=raw,if=none -device scsi-hd,drive=disk1 \

exit 0
