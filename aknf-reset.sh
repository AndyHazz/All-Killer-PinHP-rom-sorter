#!/bin/bash

# Run this script from PinHP menu to undo folders created by the rom sorter script

##############################################################################################
# WARNING - this will remove any and all custom folders !!!
##############################################################################################

SCRIPT_TITLE="Rom sorter - reset"

#Enable Jamma controls, if system is running on Pi2Jamma
pikeyd165_start() {
  if [ "$1" != "$pikeyd_current" ] && [ "$pi2scart_mode" != "Y" ]; then
    pikeyd165_stop
    pikeyd_current=$1
    if [ ! -f "/etc/pikeyd165.conf" ]; then
      cp /root/pikeyd165_default.conf /tmp/pikeyd165.conf
      ln -sf /tmp/pikeyd165.conf /etc/pikeyd165.conf
    fi

    case $1 in
    anykey)
      cp /root/pikeyd165_anykey.conf /tmp/pikeyd165.conf
      ;;
    default)
      cp /root/pikeyd165_default.conf /tmp/pikeyd165.conf
      ;;
    enterkey)
      cp /root/pikeyd165_enterkey.conf /tmp/pikeyd165.conf
      ;;
    updown)
      cp /root/pikeyd165_updown.conf /tmp/pikeyd165.conf
      ;;
    updowntabenter)
      cp /root/pikeyd165_updowntabenter.conf /tmp/pikeyd165.conf
      ;;
    yesno)
      cp /root/pikeyd165_yesno.conf /tmp/pikeyd165.conf
      ;;
    *)
      cp /root/pikeyd165_default.conf /tmp/pikeyd165.conf
      ;;
    esac

    /usr/bin/taskset -c 2 /root/pikeyd165 -ndb -d &>/dev/null
    if [ -n "$2" ]; then
      sleep "$2"
    fi
  fi
}

# Disable Jamma keyboard daemon
pikeyd165_stop() {
  /root/pikeyd165 -k &>/dev/null
  killall pikeyd165 &>/dev/null
}

# Enable gamepad controls, required for dialog boxes
joy2key_start() {
  case $1 in
  anykey)
    joy2key -config anykey &>/dev/null &
    ;;
  enterkey)
    joy2key -config enterkey &>/dev/null &
    ;;
  yesno)
    joy2key -config yesno &>/dev/null &
    ;;
  noaxis)
    joy2key -config noaxis &>/dev/null &
    ;;
  escape)
    joy2key -config escape &>/dev/null &
    ;;
  updown)
    joy2key -config updown &>/dev/null &
    ;;
  updowntabenter)
    joy2key -config updowntabenter &>/dev/null &
    ;;
  esac
}

# Disable gamepad controls
joy2key_stop() {
  pkill joy2key &>/dev/null
}


#Get current rom path from pinhp variables output - if it exists
VARFILE="/tmp/pinhp_variables"
if [ -e "$VARFILE" ]; then # variables file exists
  RPI2JAMMA=$(grep " RPI2JAMMA=" "$VARFILE" | awk -F'"' '{print $2}')
  ROMS_ADVM=$(grep " ROMS_ADVM=" "$VARFILE" | awk -F'"' '{print $2}')
  CONFIGFILE=$(grep " CONFIGFILE=" "$VARFILE" | awk -F'"' '{print $2}')
  pi2scart_mode=$(grep " pi2scart_mode=" "$VARFILE" | awk -F'"' '{print $2}')
  cd "$RPI2JAMMA" || exit
  auto-update
  cd "$ROMS_ADVM" || exit
else
  auto-update
fi

#File to check for in the rom path
FILE="_games.template"

if [ -f $FILE ]; then
  dialog --title "$SCRIPT_TITLE" \
    --infobox "Confirmed script is acting on PinHP roms folder" 7 30
else
  echo "$FILE does not exist - failed check for PinHP rom folder."
  echo "Aborting script to avoid disaster"
  echo "Run the script from PinHP menu"
  sleep 2
  exit 1
fi

pikeyd165_start "yesno" "0.5"

joy2key_start "yesno"
dialog --title "$SCRIPT_TITLE" \
  --yesno "Are you ready?\n\nThis script will flatten any existing folder structure in the roms directory." 15 30
response=$?
joy2key_stop
case $response in
0) echo "Yes" ;;
1)
  clear
  [[ "$0" = "${BASH_SOURCE[0]}" ]] && exit 1 || return 1
  ;; # handle exits from shell or function but don't exit interactive shell
255)
  clear
  [[ "$0" = "${BASH_SOURCE[0]}" ]] && exit 1 || return 1
  ;;
esac

#get full path to rom list
ROMLIST="$RPI2JAMMA/$REPO/$ROMLIST_FILENAME"

# Move everything back into the root roms dir so we can start from scratch
find . -mindepth 2 -type f -print -exec mv {} . \; |
  dialog --title "$SCRIPT_TITLE" \
    --progressbox "Moving everything back to main dir from any existing folders." 20 30
# Remove the now empty directories
find . -type d -empty -delete


rm .title                                   # Delete unwanted .title file from root of roms dir
echo "custom_folders=N" >/tmp/external_vars #Turn PinHP custom folders option
sed -i -e 's/custom_folders=./custom_folders=N/' "$CONFIGFILE"
echo "pikeyd_current=" >>/tmp/external_vars #Clear variable to not confuse parent script

joy2key_start "yesno"
dialog --title "$SCRIPT_TITLE" \
  --msgbox "\nAll done!" 7 30
joy2key_stop
clear
