#!/usr/bin/env python

# ---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
#
#                                   C I K U R
#
#                           [ Digital Phantom Blade ]
#
# Nama Script        : switch-on.py
# Bahasa Pemrograman : Python
# Lokasi Script      : /usr/local/scripts/
# Scripts Pendukung  : -
# Nama Programmer    : Danny Ismarianto Ruhiyat (danito)
# Deskripsi Script   : Script untuk 'menyalakan' / meng-ON-kan GPIO17 atau pin 11
#                      pada Raspberry Pi Model B Rev 2.0 (mengisi atau mengubah
#                      nilai /sys/class/gpio/gpio17/value menjadi: '1' (true).
#                      Kabel data relay module terpasang pada GPIO17 ini, yang
#                      akan menyalakan 
# Terakhir di-Edit   : 2016-08-27 12:43
#
# ---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8

import RPi.GPIO as GPIO
 
GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
GPIO.setup(17, GPIO.OUT)
GPIO.output(17, True)
