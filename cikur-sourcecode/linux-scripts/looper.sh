#!/usr/bin/env bash

# ---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
#
#                                   C I K U R
#
#                           [ Digital Phantom Blade ]
#
# Nama Script        : looper.sh
# Bahasa Pemrograman : Bash
# Lokasi Script      : /usr/local/scripts/
# Scripts Pendukung  : -
# Nama Programmer    : Danny Ismarianto Ruhiyat (danito)
# Deskripsi Script   : Script untuk melakukan proses looping (pseudo-daemon)
# Terakhir di-Edit   : 2016-08-27 02:51
#
# ---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8

#if [ "$(whoami)" != "root" ]; then
#   echo "ERROR[1]: Script harus dijalankan dengan 'root rule'!"
#   exit 1
#fi


tahun=""
tahun=$(date +%Y)
## echo tahun=\"$tahun\" 

bulan=""
bulan=$(date +%m)
## echo bulan=\"$bulan\"

tanggal=""
tanggal=$(date +%d)
## echo tanggal=\"$tanggal\"

jam=""
jam=$(date +%H)
## echo jam=\"$jam\"

menit=""
menit=$(date +%M)
## echo menit=\"$menit\"

detik=""
detik=$(date +%S)
## echo detik=\"$detik\"

script_exit()
  {
    exit_code=""
    exit_code=$1
    shift
    exit_message=""
    exit_message="$@"
    if ! [ "$tmp01" == "" ]; then rm -Rf $tmp01 &>/dev/null; fi
    if ! [ "$tmp02" == "" ]; then rm -Rf $tmp02 &>/dev/null; fi
    if ! [ "$tmp03" == "" ]; then rm -Rf $tmp03 &>/dev/null; fi
    if ! [ "$lock_dir" == "" ]; then rm -Rf $lock_dir &>/dev/null; fi
    if ! [ "$exit_code" == "" ]; then
       echo -n "[ ERROR:$exit_code ] "
       if ! [ "$exit_message" == "" ]; then
          echo "$exit_message"
       else
          echo " "
       fi
       exit $exit_code
    else
       exit 0
    fi
  }

script_user=""
script_user=$(whoami)
## echo script_user=\"$script_user\"

# if ! [ "$script_user" == "root" ]; then
#    script_exit 00010 Script hanya bisa dijalankan oleh user 'root'!
# fi

v_which=""

if [ -x /bin/which ]; then
    v_which="/bin/which"
elif [ -x /usr/bin/which ]; then
    v_which="/usr/bin/which"
elif [ -x /bin/which ]; then
    v_which="/sbin/which"
elif [ -x /usr/bin/which ]; then
    v_which="/usr/sbin/which"
else
    script_exit 00101 Tidak ditemukan tools pendukung primer script \(\'which\'\)!
fi

## echo v_which=\"$v_which\"

tools_locator() {

    tools_name=""
    tools_name=$1
    ## echo tools_name=\"$tools_name\"

    tools_fullpath=""
    tools_fullpath=$($v_which $tools_name)
    ## echo tools_fullpath=\"$tools_fullpath\"

    if [ "$tools_fullpath" == "" ]; then
       if [ -x /bin/$tools_name ]; then
          $tools_fullpath="/bin/$tools_name"
       elif [ -x /usr/bin/$tools_name ]; then
          $tools_fullpath="/usr/bin/$tools_name"
       elif [ -x /sbin/$tools_name ]; then
          $tools_fullpath="/sbin/$tools_name"
       elif [ -x /usr/sbin/$tools_name ]; then
          $tools_fullpath="/usr/sbin/$tools_name"
       else
          $tools_fullpath="$tools_name"
       fi
    fi

    eval v_${1}=$tools_fullpath
    ## echo v_$tools_name=\"$tools_fullpath\"

}

tools_locator date
tools_locator pwd
tools_locator basename
tools_locator dirname
tools_locator ps
tools_locator grep
tools_locator awk
tools_locator head
tools_locator tail
tools_locator tr
tools_locator cat

active_dir=""
active_dir=$($v_dirname $0)
## echo active_dir=\"$active_dir\"

script_dir=""

if [ "$active_dir" == "." ]; then
    script_dir=$($v_pwd)
else
    script_dir=$active_dir
fi

## echo script_dir=\"$script_dir\"

script_name=""
script_name=$($v_basename $0)
## echo script_name=\"$script_name\"

script=""
script=$script_dir/$script_name
## echo script=\"$script\"

script_pid=""
script_pid=$$
## echo script_pid=\"$script_pid\"

lock_dir=""
lock_dir=$script_dir/${script_name%.*}.lock
## echo lock_dir=\"$lock_dir\"

if mkdir $lock_dir &>/dev/null; then

   echo $script_pid > $lock_dir/$script_pid

else

   other_pid=""
   other_pid=$(ls -l $lock_dir | $v_tail -n +2 | $v_awk '{print $9}' | $v_grep -v $script_pid | $v_head -1)
   ## echo other_pid=\"$other_pid\"

   if ! kill -0 $other_pid &>/dev/null; then
      rm -Rf $lock_dir &>/dev/null
      mkdir $lock_dir &>/dev/null
      echo $script_pid > $lock_dir/$script_pid
      echo -n "[ WARNING:00001 ] "
      echo "Script $script_name ($other_pid) sudah tidak ada proses. Re-locking ..."
   else
      echo 00021 Sudah ada script $script_name \($other_pid\) yang sedang berjalan!
      script_exit 00021 Sudah ada script $script_name \($other_pid\) yang sedang berjalan!
   fi
fi

mkdir_chrono()
  {
    chrono_dir=""
    chrono_dir="$1"
    chrono_dir=$script_dir/$chrono_dir
    if [ ! -d $chrono_dir ]; then mkdir $chrono_dir; fi
    chrono_dir=$chrono_dir/$tahun
    if [ ! -d $chrono_dir ]; then mkdir $chrono_dir; fi
    chrono_dir=$chrono_dir/$bulan
    if [ ! -d $chrono_dir ]; then mkdir $chrono_dir; fi
    chrono_dir=$chrono_dir/$tanggal
    if [ ! -d $chrono_dir ]; then mkdir $chrono_dir; fi
    eval chrono_${1}=$chrono_dir
    ## echo chrono_${1}=\"$chrono_dir\"
  }

mkdir_chrono temp
tmp01=$chrono_temp/$($v_cat /dev/urandom | $v_tr -cd "a-zA-Z0-9" | $v_head -c 10).tmp

mkdir_chrono logs
echo -n "# ----[ $script_name ]----[ " >> $chrono_logs/logs.txt
echo "$tahun-$bulan-$tanggal $jam:$menit:$detik ]" >> $chrono_logs/logs.txt

# &> $tmp01

looping() {

    tahun=""
    tahun=$(date +%Y)
    ## echo tahun=\"$tahun\"

    bulan=""
    bulan=$(date +%m)
    ## echo bulan=\"$bulan\"

    tanggal=""
    tanggal=$(date +%d)
    ## echo tanggal=\"$tanggal\"

    jam=""
    jam=$(date +%H)
    ## echo jam=\"$jam\"

    menit=""
    menit=$(date +%M)
    ## echo menit=\"$menit\"

    detik=""
    detik=$(date +%S)
    ## echo detik=\"$detik\"

#    echo "[ $tahun-$bulan-$tanggal $jam:$menit:$detik ]" >> $chrono_logs/logs.txt

# http://agnosthings.com/b3034576-6c39-11e6-8001-005056805279/field/last/feed/690/Lamp
# http://agnosthings.com/b3034576-6c39-11e6-8001-005056805279/feed?push=Lamp=1_ON_0_0_lightBulb.png
# http://agnosthings.com/b3034576-6c39-11e6-8001-005056805279/feed?push=Lamp=1_OFF_0_0_darkBulb.png

status=$(lynx -dump http://agnosthings.com/b3034576-6c39-11e6-8001-005056805279/field/last/feed/690/Lamp | awk -F_ '{print $2}')

echo "status='$status'"

if [ x"$status" == "xON" ]; then
   /usr/local/scripts/switch-on.py
else
   if [ x"$status" == "x" ]; then
      echo "ERROR: agnosthings.com tidak dapat diakses!"
   else
      /usr/local/scripts/switch-off.py
   fi
fi

sleep 7

    looping

}

looping

script_exit

# [d!] - danito!
# www.danito.net | info@danito.net | +62 8522-141-1234 | +62 8572-151-1234
