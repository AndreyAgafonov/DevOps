#!/bin/bash

#===============Varibels=================
DIR=/datadrive
SWNAME=swapfile
SWSIZE=16384  # In MB
SF=2 #safety factor


#===============Functions=================
CREATE_SWAP_FILE() {
echo "create swapfile"
dd if=/dev/zero of=$DIR/$SWNAME bs=1MiB count=$SWSIZE
echo "Новый swapfile  $DIR/$SWNAME создан"
#change pemissions
chmod 600 $DIR/$SWNAME
echo "create filesystem"
mkswap $DIR/$SWNAME
}

SWAP_ON() {
#active SWAP
swapon $DIR/$SWNAME
}

ADD_SWAP_TO_FSTAB() {
echo "add swap fs to fstab"
if (( CHK_SW == 1  ))
    then
         sed -i 's/$SWPATH/$DIR\/$SWNAME|g' /etc/fstab
    else
         echo "$DIR/$SWNAME none swap sw 0 0"    >> /etc/fstab
fi
}

CHECK_FREE_SPACE(){
FREESPACE=$(df -m  $DIR |tail -n1 |awk '{print $4}')
NEEDSPACE=$(( $SF * $SWSIZE ))
CHECK_SPACE=$(( $FREESPACE - $NEEDSPACE ))
if (( $CHECK_SPACE < 0 ))
then
    echo "В рабочей папке $DIR Недостаточно места"
    exit 1
else
    echo "В рабочей папке $DIR свободного места достаточно"
fi
}

CHECK_SWAP_FILE() {
CHECK_SW=$(swapon -s|wc -l)
if (( $CHECK_SW > 1 ))
then
    echo "SWAP файл уже существует"
    # Метка существования файла SWAP
    CHK_SW=1
    # путь к существующему файлу
    SWPATH=$(swapon -s|grep swapfile |awk '{print $1}')
else
    echo "SWAP файл не существует"
    CHK_SW=0
fi
}

#Проверка что приложение запущено
CHECK_DAEMON_RUNNING() {
echo "test"
}
#================Scripts body=================
CHECK_FREE_SPACE
CHECK_SWAP_FILE
CREATE_SWAP_FILE
SWAP_ON
ADD_SWAP_TO_FSTAB
if (( $CHK_SW == 1  ))
    then
        echo "Отключаю старый свап файл"
        swapoff $SWPATH
        if (( $? == 0  ))
            then
            echo "Замена swap произведена успешно"
        fi
fi
swapon -s
