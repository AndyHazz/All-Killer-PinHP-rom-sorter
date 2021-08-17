#!/bin/bash

# Run this script from PinHP menu and it will organise games into folders,
# based on work by members of the arcadecontrols.com forum here:
# http://forum.arcadecontrols.com/index.php/topic,149708.0.html
# Best games from each genre will be moved into their own subfolders
# Everything else will be put in a hidden '[Leftovers]' folder

##############################################################################################
# WARNING - this will remove any custom folders you had set up before running this script!!!
##############################################################################################

ORIGIN="https://github.com/AndyHazz/"
REPO="All-Killer-PinHP-rom-sorter"
GOOGLE_SHEET="https://docs.google.com/spreadsheets/d/e/2PACX-1vQAZx0Wz2EqlxtN5CIBJMZm0bhofF7o-bJWep1oufGW4kxuCwsq2JADA2h1xWryyRpDfNj3zI9ysyiL/pub?gid=1837762843&single=true&output=tsv"
ROMLIST_FILENAME="rom-list.sh"
BRANCH="main"
SCRIPT="aknf-rom-sorter.sh"
UPDATESTRING="v2.0" # This will show in the first dialog title for update confirmation
SCRIPT_TITLE="Rom sorter - $UPDATESTRING"

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

auto-update() {
  if ping -q -c 1 -W 1 github.com >/dev/null; then # we're online
    ONLINE=true
    if [ -a "/tmp/aknf-gitcheck" ]; then # update has just taken place, get on with the script
      rm "/tmp/aknf-gitcheck"
    else                           # check for any git updates
      if [ -a "$REPO/.git" ]; then # git repo already exists
        cd $REPO || exit
        git pull
        sleep 5
        cd ..
      else # clone git repo
        git clone --single-branch --branch $BRANCH "$ORIGIN$REPO"
        sleep 5
      fi
      cp $REPO/$SCRIPT $SCRIPT
      touch "/tmp/aknf-gitcheck"
      bash $SCRIPT
      exit 0
    fi
  else # couldn't reach github.com
    ONLINE=false
  fi
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
  --yesno "Are you ready?\n\nThis script will use all killer no filler lists to select best games for each genre and move them into folders for PinHP.\nAny existing rom folders will be replaced/updated." 15 30
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

joy2key_start "yesno"
dialog --title "$SCRIPT_TITLE" \
  --yesno "\nHide games known to run slow on Pi 3b+?" 11 30
response=$?
joy2key_stop
case $response in
0) EXCLUDE="\[Slow\]" ;;
1) EXCLUDE="\[nothing\]" ;;
255)
  clear
  [[ "$0" = "${BASH_SOURCE[0]}" ]] && exit 1 || return 1
  ;;
esac

joy2key_start "yesno"
dialog --title "$SCRIPT_TITLE" \
  --yesno "\nUse rom list already downloaded from github? This is updated less frequently but will be stable. Choose 'No' to use the google sheet directly https://bit.ly/3k3dh9U (active internet connection required)." 15 30
response=$?
joy2key_stop
case $response in
0) SOURCE="Git" ;;
1) SOURCE="Google" ;;
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
    --progressbox "Getting ready ... moving everything back to main dir from any existing folders." 20 30
# Remove the now empty directories
find . -type d -empty -delete

moveroms() {
  mkdir "$1"
  if [[ "$ONLINE" = true && "$SOURCE" = "Google" ]]; then # Download latest from Google sheet
    joy2key_start "yesno"
    dialog --title "$ONLINE - $SOURCE" \
      --msgbox "\nUsing google sheet" 7 30
    joy2key_stop
    exit 1
    # bash <(curl -s -L "$GOOGLE_SHEET" | grep -v "$EXCLUDE" | grep "'$1'")
  else # Use rom list from git repo
    joy2key_start "yesno"
    dialog --title "$ONLINE - $SOURCE" \
      --msgbox "\nUsing git list" 7 30
    joy2key_stop
    exit 1
    # bash <(grep -v "$EXCLUDE" "$ROMLIST" | grep "'$1'")
  fi
}

#=========== BIOS files ==============================================================

# First, move all the bios files to a hidden folder

dialog --title "$SCRIPT_TITLE" \
  --infobox "\nMoving BIOS files aside ..." 7 30

moveroms ".BIOS"

#=========== Beat em ups ==============================================================

dialog --title "$SCRIPT_TITLE" \
  --infobox "\nFinding the best beat em ups ..." 7 30

moveroms "Beat em ups"

#=========== Classics ==============================================================

dialog --title "$SCRIPT_TITLE" \
  --infobox "\nFinding the classics ..." 7 30

moveroms "Classics"

#=========== Platformers ==============================================================

dialog --title "$SCRIPT_TITLE" \
  --infobox "\nFinding the best platformers ..." 7 30

moveroms "Platformers"

#=========== Puzzle ==============================================================

dialog --title "$SCRIPT_TITLE" \
  --infobox "\nFinding the best puzzle games ..." 7 30

moveroms "Puzzle"

#=========== Run and gun ==============================================================

dialog --title "$SCRIPT_TITLE" \
  --infobox "\nFinding the best Run and gun games ..." 7 30

moveroms "Run and gun"

#=========== Shoot em ups ==============================================================

dialog --title "$SCRIPT_TITLE" \
  --infobox "\nFinding the best shoot em ups ..." 7 30

moveroms "Shoot em ups"

#=========== Sports ==============================================================

dialog --title "$SCRIPT_TITLE" \
  --infobox "\nFinding the best sports games ..." 7 30

moveroms "Sports"

#=========== Vs Fighting ==============================================================

dialog --title "$SCRIPT_TITLE" \
  --infobox "\nFinding the best Vs fighting games ..." 7 30

moveroms "Vs Fighting"

#===========Everything else==============================================================

dialog --title "$SCRIPT_TITLE" \
  --infobox "\nMoving everything else to a hidden [Leftovers] folder ..." 7 30

mkdir "[Leftovers]"
echo "#Hidden-folder" >\[Leftovers\]/.title #Write a hidden file to the lefotvers dir, which will make it appear invisible but still accessible in the menu
#cp .BIOS/*.zip	"[Leftovers]"
mv ./*.zip "[Leftovers]"
rm .title                                   # Delete unwanted .title file from root of roms dir
echo "custom_folders=Y" >/tmp/external_vars #Turn PinHP custom folders option
sed -i -e 's/custom_folders=./custom_folders=Y/' "$CONFIGFILE"
echo "pikeyd_current=" >>/tmp/external_vars #Clear variable to not confuse parent script

joy2key_start "yesno"
dialog --title "$SCRIPT_TITLE" \
  --msgbox "\nAll done!" 7 30
joy2key_stop
clear
