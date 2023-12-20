#!/data/data/com.termux/files/usr/bin/bash
folder=backbox-fs
if [ -d "$folder" ]; then
	first=1
	echo "skipping downloading"
fi
tarball="backbox-rootfs.tar.xz"
if [ "$first" != 1 ];then
	if [ ! -f $tarball ]; then
		echo -e "\033[1;32mDownload Rootfs, this may take a while base on your internet speed."
		case `dpkg --print-architecture` in
		aarch64)
			archurl="arm64" ;;
		arm)
			archurl="armhf" ;;
		amd64)
			archurl="amd64" ;;
		x86_64)
			archurl="amd64" ;;	
		i*86)
			archurl="i386" ;;
		x86)
			archurl="i386" ;;
		*)
			echo "\033[1;31munknown architecture"; exit 1 ;;
		esac
		wget "https://raw.githubusercontent.com/EXALAB/AnLinux-Resources/master/Rootfs/BackBox/${archurl}/backbox-rootfs-${archurl}.tar.xz" -O $tarball
	fi
	cur=`pwd`
	mkdir -p "$folder"
	cd "$folder"
	echo "Decompressing Rootfs, please be patient."
	proot --link2symlink tar -xJf ${cur}/${tarball}||:
	cd "$cur"
fi
mkdir -p backbox-binds
bin=backbox
echo "writing launch script"
cat > $bin <<- EOM
#!/bin/bash
cd \$(dirname \$0)
pulseaudio --start
## For rooted user: pulseaudio --start --system
## unset LD_PRELOAD in case termux-exec is installed
unset LD_PRELOAD
command="proot"
command+=" --link2symlink"
command+=" -0"
command+=" -r $folder"
if [ -n "\$(ls -A backbox-binds)" ]; then
    for f in backbox-binds/* ;do
      . \$f
    done
fi
command+=" -b /dev"
command+=" -b /proc"
command+=" -b backbox-fs/root:/dev/shm"
## uncomment the following line to have access to the home directory of termux
#command+=" -b /data/data/com.termux/files/home:/root"
## uncomment the following line to mount /sdcard directly to / 
command+=" -b /sdcard"
command+=" -w /root"
command+=" /usr/bin/env -i"
command+=" HOME=/root"
command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"
command+=" TERM=\$TERM"
command+=" LANG=C.UTF-8"
command+=" /bin/bash --login"
com="\$@"
if [ -z "\$1" ];then
    exec \$command
else
    \$command -c "\$com"
fi
EOM

echo -e "\033[1;32mSetting up pulseaudio so you can have music in backbox."

pkg install pulseaudio -y

if grep -q "anonymous" ~/../usr/etc/pulse/default.pa;then
    echo "module already present"
else
    echo  "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" >> ~/../usr/etc/pulse/default.pa
fi

echo "exit-idle-time = -1" >> ~/../usr/etc/pulse/daemon.conf
echo "Modified pulseaudio timeout to infinite"
echo "autospawn = no" >> ~/../usr/etc/pulse/client.conf
echo "Disabled pulseaudio autospawn"
echo "export PULSE_SERVER=127.0.0.1" >> backbox-fs/etc/profile
echo -e "\033[1;32mSetting Pulseaudio server to 127.0.0.1"

echo -e "\033[0;32mfixing shebang of $bin"
termux-fix-shebang $bin
echo "making $bin executable"
chmod +x $bin
rm $tarball
touch $PATH/Backbox
chmod +x $PATH/Backbox
echo "./${bin}" > $PATH/Backbox
mkdir -p BackBox
mv $bin $folder backbox-binds BackBox
W="\033[1;37m"
echo -e "\033[1;32mYou can now launch Backbox with the ${G}${bin} \033[1;32mCommand"
