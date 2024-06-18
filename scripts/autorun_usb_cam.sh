#!/bin/bash

# Perintah untuk menjalankan ketika /dev/usb_cam ditemukan
COMMAND="ros2 run usb_cam usb_cam_node_exe &"

# Variabel untuk menyimpan status sebelumnya
previous_status=""
previous_pid=""

while true; do
    # Periksa apakah /dev/usb_cam ada
    if [ -e /dev/usb_cam ]; then
        current_status="found"
    else
        current_status="not_found"
    fi

    # Bandingkan status saat ini dengan status sebelumnya
    if [ "$current_status" != "$previous_status" ]; then
        if [ "$current_status" = "found" ]; then
            echo "/dev/usb_cam ditemukan"
            # Jalankan perintah jika /dev/usb_cam ditemukan
            eval $COMMAND
            # Simpan PID dari proses yang berjalan
            process_pid=$!
            echo "Process started with PID: $process_pid"
        else
            echo "/dev/usb_cam tidak ditemukan"
            # Jalankan perintah jika /dev/usb_cam tidak ditemukan
            # Hentikan proses jika /dev/usb_cam tidak ditemukan
            if [ -n "$process_pid" ]; then
                kill $process_pid
                echo "Process with PID: $process_pid stopped"
                process_pid=""
            fi
        fi
    fi

    # Perbarui status sebelumnya
    previous_status="$current_status"
	echo "Checking camera connection"
    # Tunggu 1 detik sebelum pengecekan berikutnya
    sleep 1
done
