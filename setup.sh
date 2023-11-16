#!/bin/bash
# Colour
R="\033[1;31m"
G="\033[1;32m"
Y="\033[1;33m"
PU="\033[1;34m"
PI="\033[1;35m"
B="\033[1;36m"
W="\033[1;37m"
Teal="\e[38;5;37m"
# files PATH
LOG_DIR=$PWD/logs
ILOG=$LOG_DIR/install.logs

# status_check installed or Failed
status_check() {
    if [ $? -eq 0 ]
    then
        echo -e "$1 - ${G}Installed"
    else
        echo -e "$1 - ${R}Failed!"
    fi
}
mkdir -p $LOG_DIR
# Logs File
termux_install() {
    echo -e '=====================\nINSTALLING\n=====================\n' > "$ILOG"
    echo -e "\n--------------------\n" >> "$ILOG"
    echo -ne 'proot-distro\r'
    apt install proot-distro -y &>> "$ILOG"
    status_check proot-distro 
    echo -e '\n--------------------\n' >> "$ILOG"
    echo -ne 'pv\r'
    pkg install pv -y &>> "$ILOG"
    status_check pv
    echo -e '\n--------------------\n' >> "$ILOG"
}

banner() {
echo -e "\033[1;31m"
echo -e "\t _|        _|_|_|  _|      _|  _|    _|  _|      _|  "
echo -e "\t _|          _|    _|_|    _|  _|    _|    _|  _|    "
echo -e "\t _|          _|    _|  _|  _|  _|    _|      _|      "
echo -e "\t _|          _|    _|    _|_|  _|    _|    _|  _|    "
echo -e "\t _|_|_|_|  _|_|_|  _|      _|    _|_|    _|      _|  "
for ((i=1; i<=4; i++))
do
echo
done
echo -e "\t _|_|_|    _|_|_|    _|_|_|  _|_|_|_|_|  _|_|_|      _|_|    "
echo -e "\t _|    _|    _|    _|            _|      _|    _|  _|    _|  "
echo -e "\t _|    _|    _|      _|_|        _|      _|_|_|    _|    _| "
echo -e "\t _|    _|    _|          _|      _|      _|    _|  _|    _|"
echo -e "\t _|_|_|    _|_|_|  _|_|_|        _|      _|    _|    _|_| "
echo
}
banner
echo -e "\t\t\t\t\t\t\t${Teal}Version 3.O"
echo -e "\033[1;32m"
echo -e "\t\t${W}Code ${PI}By ${B}Manjuanth\n\n"
termux_install
echo -e '\n--------------------\n' >> "$ILOG"

echo -e '\n=========\nCOMPLETED\n=========\n' >> "$ILOG"

sleep 1
chmod +x linux-distro
chmod +x Linux-distro
mv linux-distro /data/data/com.termux/files/usr/bin
mv remove-distro .remove-distro
echo
echo -e "\t${G}Successfully Installed\n\n"
rm -rf setup.sh
sleep 1
bash Linux-distro
# Script Ended
