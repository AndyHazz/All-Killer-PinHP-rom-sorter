#!/bin/bash

# Run this script from PinHP menu and it will organise games into folders,
# based on work by members of the arcadecontrols.com forum here: 
# http://forum.arcadecontrols.com/index.php/topic,149708.0.html
# Best games from each genre will be moved into their own subfolders
# Everything else will be put in a hidden '[Leftovers]' folder

##############################################################################################
# WARNING - this will remove any custom folders you had set up before running this script!!! 
##############################################################################################

#Change to use the google sheet if you want very latest updates
#TSVINPUT="https://docs.google.com/spreadsheets/d/e/2PACX-1vQAZx0Wz2EqlxtN5CIBJMZm0bhofF7o-bJWep1oufGW4kxuCwsq2JADA2h1xWryyRpDfNj3zI9ysyiL/pub?gid=210123609&single=true&output=tsv"
TSVINPUT="https://raw.githubusercontent.com/AndyHazz/All-Killer-PinHP-rom-sorter/main/rom-list.tsv"
ORIGIN="https://github.com/AndyHazz/"
REPO="All-Killer-PinHP-rom-sorter"
BRANCH="auto-update"
SCRIPT="rom-sorter.sh"
UPDATESTRING="27-06-2021 - 19:44" # This will show in the first dialog title for update confirmation

#Enable Jamma controls, if system is running on Pi2Jamma
pikeyd165_start ()
{
  if [ $1 != "$pikeyd_current" ] && [ "$pi2scart_mode" != "Y" ]; then
    pikeyd165_stop
    pikeyd_current=$1
    if [ ! -f "/etc/pikeyd165.conf" ]; then
      cp /root/pikeyd165_default.conf /tmp/pikeyd165.conf
      ln -sf /tmp/pikeyd165.conf /etc/pikeyd165.conf
    fi

    case $1 in
      anykey )
        cp /root/pikeyd165_anykey.conf /tmp/pikeyd165.conf
      ;;
      default )
        cp /root/pikeyd165_default.conf /tmp/pikeyd165.conf
      ;;
      enterkey )
        cp /root/pikeyd165_enterkey.conf /tmp/pikeyd165.conf
      ;; 
      updown )
        cp /root/pikeyd165_updown.conf /tmp/pikeyd165.conf
      ;;  
      updowntabenter )
        cp /root/pikeyd165_updowntabenter.conf /tmp/pikeyd165.conf
      ;;
      yesno )
        cp /root/pikeyd165_yesno.conf /tmp/pikeyd165.conf
      ;;
      * )
        cp /root/pikeyd165_default.conf /tmp/pikeyd165.conf
      ;;
    esac

    /usr/bin/taskset -c 2 /root/pikeyd165 -ndb -d &> /dev/null
    if [ ! -z $2 ]; then
      sleep $2
    fi
  fi
}

# Disable Jamma keyboard daemon
pikeyd165_stop ()
{
    /root/pikeyd165 -k &> /dev/null
    killall pikeyd165 &> /dev/null
}

# Enable gamepad controls, required for dialog boxes
joy2key_start ()
{
  case $1 in
    anykey )
      joy2key -config anykey &> /dev/null &
    ;;
    enterkey )
      joy2key -config enterkey &> /dev/null &
    ;;
    yesno )
      joy2key -config yesno &> /dev/null &
    ;;
    noaxis )
      joy2key -config noaxis &> /dev/null &
    ;;
    escape )
      joy2key -config escape &> /dev/null &
    ;;
    updown )
      joy2key -config updown &> /dev/null &
    ;;
    updowntabenter )
      joy2key -config updowntabenter &> /dev/null &
    ;;
  esac
}

# Disable gamepad controls
joy2key_stop ()
{
  pkill joy2key &> /dev/null
}

auto-update ()
{
	if ping -q -c 1 -W 1 github.com >/dev/null; then # we're online
		if [ -a "/tmp/aknf-gitcheck" ]; then # update has just taken place, get on with the script
			echo "We're good, update $UPDATESTRING has taken place"
			rm "/tmp/aknf-gitcheck"
		else
			if [ -a "$REPO/.git" ]; then
				echo "Git repo already exists in $(pwd)"
				cd $REPO
				git pull
				cd ..
			else
				echo "Cloning git repo in $(pwd)"
				git clone --single-branch --branch $BRANCH "$ORIGIN$REPO"
				sleep 5
			fi
			cp $REPO/$SCRIPT $SCRIPT
			touch "/tmp/aknf-gitcheck"
			bash $SCRIPT
			exit 0
		fi
	fi
}

#Get current rom path from pinhp variables output - if it exists
VARFILE="/tmp/pinhp_variables"
if [ -e "$VARFILE" ]; then
	RPI2JAMMA=$( grep " RPI2JAMMA=" "$VARFILE" | awk -F'"' '{print $2}' )
	ROMS_ADVM=$( grep " ROMS_ADVM=" "$VARFILE" | awk -F'"' '{print $2}' )
	CONFIGFILE=$( grep " CONFIGFILE=" "$VARFILE" | awk -F'"' '{print $2}' )
	pi2scart_mode=$( grep " pi2scart_mode=" "$VARFILE" | awk -F'"' '{print $2}' )
	echo $RPI2JAMMA "and" $ROMS_ADVM
	cd $RPI2JAMMA
	auto-update
	cd $ROMS_ADVM
else
	auto-update
fi

#File to check for in the rom path
FILE="_games.template"

if [ -f $FILE ]; then
    echo "Confirmed script is acting on PinHP roms folder"
else 
    echo "$FILE does not exist - failed check for PinHP rom folder."
	echo "Aborting script to avoid disaster"
	sleep 2
	exit 1
fi

pikeyd165_start "yesno" "0.5"

joy2key_start "yesno"
dialog --title "Rom sorter $UPDATESTRING" \
--yesno "Are you ready? 

This script will use all killer no filler lists to select best games for each genre and move them into folders for PinHP.

Any existing rom folders will be replaced/updated." 15 30
response=$?
joy2key_stop
case $response in
   0) echo "Yes";;
   1) clear; [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 ;; # handle exits from shell or function but don't exit interactive shell
   255) clear; [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 ;;
esac

joy2key_start "yesno"
dialog --title "Rom sorter" \
--yesno "Get latest and best game recommendations list from github?
Answer 'no' to use offline" 11 30
response=$?
joy2key_stop
case $response in
   0)
	if ping -q -c 1 -W 1 google.com >/dev/null; then
	  #echo "The network is up"
	  ONLINE=true
	else
	  clear; echo "The network is down"; [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
	fi ;;
   1) ONLINE=false ;;
   255) clear; [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 ;;
esac

# Move everything back into the root roms dir so we can start from scratch
find . -mindepth 2 -type f -print -exec mv {} . \; | \
dialog --title "Rom sorter" \
--progressbox "Getting ready - moving everything back to main dir from any existing folders ..." 20 30
# Remove the now empty directories
find . -type d -empty -delete


#=========== BIOS files ==============================================================

# First, move all the bios files to a hidden folder

dialog --title "Rom sorter" \
--infobox "Moving BIOS files aside ..." 7 30

mkdir ".BIOS"

if $ONLINE
then
	bash <(curl -s -L $TSVINPUT | cut -f1)
else
	mv acpsx.zip	".BIOS"	# Acclaim PSX
	mv ar_bios.zip	".BIOS"	# Arcadia System BIOS
	mv atluspsx.zip	".BIOS"	# Atlus PSX
	mv atpsx.zip	".BIOS"	# Atari PSX
	mv bctvidbs.zip	".BIOS"	# MPU4 Video Firmware
	mv cpzn1.zip	".BIOS"	# ZN1
	mv cpzn2.zip	".BIOS"	# ZN2
	mv crysbios.zip	".BIOS"	# Crystal System BIOS
	mv cvs.zip	".BIOS"	# CVS Bios
	mv decocass.zip	".BIOS"	# Cassette System
	mv hng64.zip	".BIOS"	# Hyper NeoGeo 64 Bios
	mv konamigv.zip	".BIOS"	# Baby Phoenix-GV System
	mv konamigx.zip	".BIOS"	# System GX
	mv macsbios.zip	".BIOS"	# Multi Amenity Cassette System BIOS
	mv maxaflex.zip	".BIOS"	# Max-A-Flex
	mv megaplay.zip	".BIOS"	# Mega Play BIOS
	mv megatech.zip	".BIOS"	# Mega-Tech BIOS
	mv neogeo.zip	".BIOS"	# Neo-Geo
	mv nss.zip	".BIOS"	# Nintendo Super System BIOS
	mv pgm.zip	".BIOS"	# PGM (Polygame Master) System BIOS
	mv playch10.zip	".BIOS"	# PlayChoice-10 BIOS
	mv psarc95.zip	".BIOS"	# PS Arcade 95
	mv skns.zip	".BIOS"	# Super Kaneko Nova System BIOS
	mv stvbios.zip	".BIOS"	# ST-V Bios
	mv taitofx1.zip	".BIOS"	# Taito FX1
	mv taitogn.zip	".BIOS"	# Taito GNET
	mv tps.zip	".BIOS"	# TPS
fi


#=========== Beat em ups ==============================================================

dialog --title "Rom sorter" \
--infobox "Finding the best beat em ups ..." 7 30

mkdir "Beat em ups"

if $ONLINE
then
	bash <(curl -s -L $TSVINPUT | cut -f2)
else
	mv 64street.zip	"Beat em ups"	# 64th. Street - A Detective Story (World)
	mv altbeast.zip	"Beat em ups"	# Altered Beast (set 7, 8751 317-0078)
	mv arabfgt.zip	"Beat em ups"	# Arabian Fight (World)
	mv armwar.zip	"Beat em ups"	# Armored Warriors (Euro 941024)
	mv astorm.zip	"Beat em ups"	# Alien Storm (set 4, 2 Players, FD1094 317-?)
	mv avengers.zip	"Beat em ups"	# Avengers (US set 1)
	mv avsp.zip	"Beat em ups"	# Alien vs. Predator (Euro 940520)
	mv baddudes.zip	"Beat em ups"	# Bad Dudes vs. Dragonninja (US)
	mv batcir.zip	"Beat em ups"	# Battle Circuit (Euro 970319)
	mv bmaster.zip	"Beat em ups"	# Blade Master (World)
	mv brapboys.zip	"Beat em ups"	# B.Rap Boys
	mv btoads.zip	"Beat em ups"	# Battle Toads
	mv burningf.zip	"Beat em ups"	# Burning Fight (set 1)
	mv captaven.zip	"Beat em ups"	# Captain America and The Avengers (Asia Rev 1.9)
	mv captcomm.zip	"Beat em ups"	# Captain Commando (World 911014)
	mv crimfght.zip	"Beat em ups"	# Crime Fighters (US 4 players)
	mv crysking.zip	"Beat em ups"	# The Crystal of Kings
	mv ctribe.zip	"Beat em ups"	# The Combatribes (US)
	mv ddragon.zip	"Beat em ups"	# Double Dragon (Japan)
	mv ddragon2.zip	"Beat em ups"	# Double Dragon II - The Revenge (World)
	mv ddsom.zip	"Beat em ups"	# Dungeons & Dragons: Shadow over Mystara (Euro 960619)
	mv ddtod.zip	"Beat em ups"	# Dungeons & Dragons: Tower of Doom (Euro 940412)
	mv denjinmk.zip	"Beat em ups"	# Denjin Makai
	mv dino.zip	"Beat em ups"	# Cadillacs and Dinosaurs (World 930201)
	mv dynwar.zip	"Beat em ups"	# Dynasty Wars (World)
	mv edrandy.zip	"Beat em ups"	# The Cliffhanger - Edward Randy (World revision 2)
	mv eightman.zip	"Beat em ups"	# Eight Man
	mv ffight.zip	"Beat em ups"	# Final Fight (World)
	mv ga2.zip	"Beat em ups"	# Golden Axe: The Revenge of Death Adder (World)
	mv gaia.zip	"Beat em ups"	# Gaia Crusaders
	mv gaiapols.zip	"Beat em ups"	# Gaiapolis (ver EAF)
	mv ganryu.zip	"Beat em ups"	# Ganryu / Musashi Ganryuki
	mv gauntdl.zip	"Beat em ups"	# Gauntlet Dark Legacy (version DL 2.52)
	mv gauntleg.zip	"Beat em ups"	# Gauntlet Legends (version 1.6)
	mv goldnaxe.zip	"Beat em ups"	# Golden Axe (set 6, US, 8751 317-123A)
	mv grdians.zip	"Beat em ups"	# Guardians / Denjin Makai II
	mv growl.zip	"Beat em ups"	# Growl (World)
	mv hook.zip	"Beat em ups"	# Hook (World)
	mv kbash.zip	"Beat em ups"	# Knuckle Bash
	mv knights.zip	"Beat em ups"	# Knights of the Round (World 911127)
	mv kod.zip	"Beat em ups"	# The King of Dragons (World 910711)
	mv kov.zip	"Beat em ups"	# Knights of Valour / Sangoku Senki (ver. 117)
	mv kov2.zip	"Beat em ups"	# Knights of Valour 2
	mv lightbr.zip	"Beat em ups"	# Light Bringer (Ver 2.1J 1994/02/18)
	mv metamrph.zip	"Beat em ups"	# Metamorphic Force (ver EAA)
	mv mp_sor2.zip	"Beat em ups"	# Streets of Rage II (Mega Play)
	mv mutnat.zip	"Beat em ups"	# Mutation Nation
	mv mwalk.zip	"Beat em ups"	# Michael Jackson's Moonwalker (set 3, World, FD1094/8751 317-0159)
	mv nbbatman.zip	"Beat em ups"	# Ninja Baseball Batman (US)
	mv ninjak.zip	"Beat em ups"	# The Ninja Kids (World)
	mv nslasher.zip	"Beat em ups"	# Night Slashers (Korea Rev 1.3)
	mv orlegend.zip	"Beat em ups"	# Oriental Legend / Xi Yo Gi Shi Re Zuang (ver. 126)
	mv pow.zip	"Beat em ups"	# P.O.W. - Prisoners of War (US)
	mv pulirula.zip	"Beat em ups"	# PuLiRuLa (World)
	mv punisher.zip	"Beat em ups"	# The Punisher (World 930422)
	mv riotcity.zip	"Beat em ups"	# Riot City (Japan)
	mv rmpgwt.zip	"Beat em ups"	# Rampage: World Tour (rev 1.3)
	mv roboarmy.zip	"Beat em ups"	# Robo Army (set 1)
	mv sailormn.zip	"Beat em ups"	# Pretty Soldier Sailor Moon (95/03/22B)
	mv sengoku.zip	"Beat em ups"	# Sengoku / Sengoku Denshou (set 1)
	mv sengoku3.zip	"Beat em ups"	# Sengoku 3
	mv shadfrce.zip	"Beat em ups"	# Shadow Force (US Version 2)
	mv silentd.zip	"Beat em ups"	# Silent Dragon (World)
	mv silkroad.zip	"Beat em ups"	# The Legend of Silkroad
	mv simpsn2p.zip	"Beat em ups"	# The Simpsons (2 Players)
	mv spidman.zip	"Beat em ups"	# Spider-Man: The Videogame (World)
	mv splatter.zip	"Beat em ups"	# Splatter House (World)
	mv tmht2p.zip	"Beat em ups"	# Teenage Mutant Hero Turtles (UK 2 Players)
	mv tmnt22p.zip	"Beat em ups"	# Teenage Mutant Ninja Turtles - Turtles in Time (2 Players ver UDA)
	mv uccops.zip	"Beat em ups"	# Undercover Cops (World)
	mv vamphalf.zip	"Beat em ups"	# Vamp 1/2 (Korea version)
	mv vendet2p.zip	"Beat em ups"	# Vendetta (World 2 Players ver. W)
	mv vigilant.zip	"Beat em ups"	# Vigilante (World)
	mv viostorm.zip	"Beat em ups"	# Violent Storm (ver EAB)
	mv warriorb.zip	"Beat em ups"	# Warrior Blade - Rastan Saga Episode III (Japan)
	mv wizdfire.zip	"Beat em ups"	# Wizard Fire (US v1.1)
	mv wof.zip	"Beat em ups"	# Warriors of Fate (World 921002)
	mv xmen2p.zip	"Beat em ups"	# X-Men (2 Players ver AAA)
fi

#=========== Classics ==============================================================

dialog --title "Rom sorter" \
--infobox "Finding the classics ..." 7 30

mkdir "Classics"

if $ONLINE
then
	bash <(curl -s -L $TSVINPUT | cut -f3)
else
	mv anteater.zip	"Classics"	# Anteater
	mv astdelux.zip	"Classics"	# Asteroids Deluxe (rev 2)
	mv astinvad.zip	"Classics"	# Astro Invader
	mv astrob.zip	"Classics"	# Astro Blaster (version 3)
	mv bagman.zip	"Classics"	# Bagman
	mv berzerk.zip	"Classics"	# Berzerk (set 1)
	mv bosco.zip	"Classics"	# Bosconian (new version)
	mv btime.zip	"Classics"	# Burger Time (Data East set 1)
	mv bubbles.zip	"Classics"	# Bubbles
	mv buckrog.zip	"Classics"	# Buck Rogers: Planet of Zoom
	mv carnival.zip	"Classics"	# Carnival (upright)
	mv centiped.zip	"Classics"	# Centipede (revision 3)
	mv circusc.zip	"Classics"	# Circus Charlie (Selectable level set 1)
	mv cloak.zip	"Classics"	# Cloak & Dagger (rev 5)
	mv congo.zip	"Classics"	# Congo Bongo
	mv defender.zip	"Classics"	# Defender (Red label)
	mv digdug.zip	"Classics"	# Dig Dug (rev 2)
	mv digdug2.zip	"Classics"	# Dig Dug II (New Ver.)
	mv dkong.zip	"Classics"	# Donkey Kong (US set 1)
	mv dkong3.zip	"Classics"	# Donkey Kong 3 (US)
	mv dkongjr.zip	"Classics"	# Donkey Kong Junior (US)
	mv docastle.zip	"Classics"	# Mr. Do's Castle (set 1)
	mv dommy.zip	"Classics"	# Dommy
	mv dowild.zip	"Classics"	# Mr. Do's Wild Ride
	mv drmicro.zip	"Classics"	# Dr. Micro
	mv elevator.zip	"Classics"	# Elevator Action
	mv eyes.zip	"Classics"	# Eyes (Digitrex Techstar)
	mv frogger.zip	"Classics"	# Frogger
	mv galaga.zip	"Classics"	# Galaga (Namco rev. B)
	mv galaxian.zip	"Classics"	# Galaxian (Namco set 1)
	mv gauntlet.zip	"Classics"	# Gauntlet (rev 14)
	mv gorf.zip	"Classics"	# Gorf
	mv gyruss.zip	"Classics"	# Gyruss (Konami)
	mv invaders.zip	"Classics"	# Space Invaders
	mv jjack.zip	"Classics"	# Jumping Jack
	mv journey.zip	"Classics"	# Journey
	mv joust.zip	"Classics"	# Joust (White/Green label)
	mv joust2.zip	"Classics"	# Joust 2 - Survival of the Fittest (set 1)
	mv jrpacman.zip	"Classics"	# Jr. Pac-Man
	mv junglek.zip	"Classics"	# Jungle King (Japan)
	mv kangaroo.zip	"Classics"	# Kangaroo
	mv krull.zip	"Classics"	# Krull
	mv ladybug.zip	"Classics"	# Lady Bug
	mv ldrun.zip	"Classics"	# Lode Runner (set 1)
	mv mappy.zip	"Classics"	# Mappy (US)
	mv milliped.zip	"Classics"	# Millipede
	mv mooncrst.zip	"Classics"	# Moon Cresta (Nichibutsu)
	mv mpatrol.zip	"Classics"	# Moon Patrol
	mv mrdo.zip	"Classics"	# Mr. Do!
	mv mspacman.zip	"Classics"	# Ms. Pac-Man
	mv mspacmnf.zip	"Classics"	# Ms. Pac-Man (with speedup hack)
	mv mtrap.zip	"Classics"	# Mouse Trap (version 5)
	mv nibbler.zip	"Classics"	# Nibbler (set 1)
	mv pacman.zip	"Classics"	# Pac-Man (Midway)
	mv pacmanf.zip	"Classics"	# Pac-Man (Midway, with speedup hack)
	mv pandoras.zip	"Classics"	# Pandora's Palace
	mv panic.zip	"Classics"	# Space Panic (version E)
	mv pengo.zip	"Classics"	# Pengo (set 1 rev c)
	mv pepper2.zip	"Classics"	# Pepper II
	mv phoenix.zip	"Classics"	# Phoenix (Amstar)
	mv pooyan.zip	"Classics"	# Pooyan
	mv popeye.zip	"Classics"	# Popeye (revision D)
	mv puckman.zip	"Classics"	# PuckMan (Japan set 1, Probably Bootleg)
	mv punchout.zip	"Classics"	# Punch-Out!!
	mv qbert.zip	"Classics"	# Q*bert (US set 1)
	mv rallyx.zip	"Classics"	# Rally X
	mv rampage.zip	"Classics"	# Rampage (revision 3)
	mv rbtapper.zip	"Classics"	# Tapper (Root Beer)
	mv robotron.zip	"Classics"	# Robotron (Solid Blue label)
	mv rocnrope.zip	"Classics"	# Roc'n Rope
	mv sbagman.zip	"Classics"	# Super Bagman
	mv scobra.zip	"Classics"	# Super Cobra
	mv scramble.zip	"Classics"	# Scramble
	mv scregg.zip	"Classics"	# Scrambled Egg
	mv sharrier.zip	"Classics"	# Space Harrier (Rev A, 8751 315-5163A)
	mv shollow.zip	"Classics"	# Satan's Hollow (set 1)
	mv skykid.zip	"Classics"	# Sky Kid (New Ver.)
	mv tapper.zip	"Classics"	# Tapper (Budweiser)
	mv timber.zip	"Classics"	# Timber
	mv tutankhm.zip	"Classics"	# Tutankham
	mv vanguard.zip	"Classics"	# Vanguard (SNK)
	mv wow.zip	"Classics"	# Wizard of Wor
	mv zaxxon.zip	"Classics"	# Zaxxon (set 1)
	mv zookeep.zip	"Classics"	# Zoo Keeper (set 1)
fi

#=========== Platformers ==============================================================

dialog --title "Rom sorter" \
--infobox "Finding the best platformers ..." 7 30

mkdir "Platformers"

if $ONLINE
then
	bash <(curl -s -L $TSVINPUT | cut -f4)
else
	mv alexkidd.zip	"Platformers"	# Alex Kidd: The Lost Stars (set 2, unprotected)
	mv arabian.zip	"Platformers"	# Arabian
	mv athena.zip	"Platformers"	# Athena
	mv bigkarnk.zip	"Platformers"	# Big Karnak
	mv bjourney.zip	"Platformers"	# Blue's Journey / Raguy
	mv blktiger.zip	"Platformers"	# Black Tiger
	mv bnzabros.zip	"Platformers"	# Bonanza Bros (US, Floppy DS3-5000-07d?)
	mv bombjack.zip	"Platformers"	# Bomb Jack (set 1)
	mv bonkadv.zip	"Platformers"	# B.C. Kid / Bonk's Adventure / Kyukyoku!! PC Genjin
	mv bubblem.zip	"Platformers"	# Bubble Memories: The Story Of Bubble Bobble III (Ver 2.4O 1996/02/15)
	mv bublbob2.zip	"Platformers"	# Bubble Bobble II (Ver 2.5O 1994/10/05)
	mv bublbobl.zip	"Platformers"	# Bubble Bobble
	mv cadash.zip	"Platformers"	# Cadash (World)
	mv cninja.zip	"Platformers"	# Caveman Ninja (World revision 3)
	mv dondokod.zip	"Platformers"	# Don Doko Don (World)
	mv drgnbstr.zip	"Platformers"	# Dragon Buster
	mv dynagear.zip	"Platformers"	# Dyna Gear
	mv ghouls.zip	"Platformers"	# Ghouls'n Ghosts (World)
	mv gng.zip	"Platformers"	# Ghosts'n Goblins (World? set 1)
	mv hcastle.zip	"Platformers"	# Haunted Castle (version M)
	mv hharry.zip	"Platformers"	# Hammerin' Harry (World)
	mv indytemp.zip	"Platformers"	# Indiana Jones and the Temple of Doom (set 1)
	mv jjsquawk.zip	"Platformers"	# J. J. Squawkers
	mv joemacr.zip	"Platformers"	# Joe & Mac Returns (World, Version 1.1, 1994.05.27)
	mv karnov.zip	"Platformers"	# Karnov (US)
	mv kicker.zip	"Platformers"	# Kicker
	mv kidniki.zip	"Platformers"	# Kid Niki - Radical Ninja (World)
	mv liquidk.zip	"Platformers"	# Liquid Kids (World)
	mv liquidku.zip	"Platformers"	# Liquid Kids (US)
	mv maglord.zip	"Platformers"	# Magician Lord (set 1)
	mv marvland.zip	"Platformers"	# Marvel Land (US)
	mv mcatadv.zip	"Platformers"	# Magical Cat Adventure
	mv momoko.zip	"Platformers"	# Momoko 120%
	mv mp_soni2.zip	"Platformers"	# Sonic The Hedgehog 2 (Mega Play)
	mv mp_sonic.zip	"Platformers"	# Sonic The Hedgehog (Mega Play)
	mv msword.zip	"Platformers"	# Magic Sword - Heroic Fantasy (World 900725)
	mv mtwins.zip	"Platformers"	# Mega Twins (World 900619)
	mv mystwarr.zip	"Platformers"	# Mystic Warriors (ver EAA)
	mv nemo.zip	"Platformers"	# Nemo (World 901130)
	mv nitd.zip	"Platformers"	# Nightmare in the Dark
	mv nspirit.zip	"Platformers"	# Ninja Spirit
	mv osman.zip	"Platformers"	# Osman (World)
	mv pacland.zip	"Platformers"	# Pac-Land (set 1)
	mv penbros.zip	"Platformers"	# Penguin Brothers (Japan)
	mv pigout.zip	"Platformers"	# Pigout
	mv rastan.zip	"Platformers"	# Rastan (World)
	mv recalh.zip	"Platformers"	# Recalhorn (Ver 1.42J 1994/5/11) (Prototype)
	mv rodland.zip	"Platformers"	# Rod-Land (World)
	mv sabotenb.zip	"Platformers"	# Saboten Bombers (set 1)
	mv shdancer.zip	"Platformers"	# Shadow Dancer (set 3, US)
	mv shinobi.zip	"Platformers"	# Shinobi (set 5, System 16A, unprotected)
	mv snowbro2.zip	"Platformers"	# Snow Bros. 2 - With New Elves / Otenki Paradise
	mv snowbros.zip	"Platformers"	# Snow Bros. - Nick & Tom (set 1)
	mv spelunkr.zip	"Platformers"	# Spelunker
	mv spinmast.zip	"Platformers"	# Spin Master / Miracle Adventure
	mv strider.zip	"Platformers"	# Strider (US set 1)
	mv suprmrio.zip	"Platformers"	# Vs. Super Mario Bros.
	mv teddybb.zip	"Platformers"	# TeddyBoy Blues (New Ver.)
	mv thoop.zip	"Platformers"	# Thunder Hoop (Ver. 1)
	mv tigeroad.zip	"Platformers"	# Tiger Road (US)
	mv tnzs.zip	"Platformers"	# The NewZealand Story (World, newer)
	mv toki.zip	"Platformers"	# Toki (World set 1)
	mv tophuntr.zip	"Platformers"	# Top Hunter - Roddy & Cathy (set 1)
	mv trojan.zip	"Platformers"	# Trojan (US)
	mv tumblep.zip	"Platformers"	# Tumble Pop (World)
	mv wardner.zip	"Platformers"	# Wardner (World)
	mv wb3.zip	"Platformers"	# Wonder Boy III - Monster Lair (set 5, World, System 16B, 8751 317-0098)
	mv wbml.zip	"Platformers"	# Wonder Boy in Monster Land (Japan New Ver.)
	mv wboy.zip	"Platformers"	# Wonder Boy (set 1, new encryption)
	mv willow.zip	"Platformers"	# Willow (US)
	mv wiz.zip	"Platformers"	# Wiz
fi

#=========== Puzzle ==============================================================

dialog --title "Rom sorter" \
--infobox "Finding the best puzzle games ..." 7 30

mkdir "Puzzle"

if $ONLINE
then
	bash <(curl -s -L $TSVINPUT | cut -f5)
else
	mv aquarush.zip	"Puzzle"	# Aqua Rush (AQ1/VER.A1)
	mv ar_spot.zip	"Puzzle"	# Spot (Arcadia)
	mv bakubaku.zip	"Puzzle"	# Baku Baku Animal (J 950407 V1.000)
	mv bangball.zip	"Puzzle"	# Bang Bang Ball (v1.05)
	mv blockhl.zip	"Puzzle"	# Block Hole
	mv blockout.zip	"Puzzle"	# Block Out (set 1)
	mv columns.zip	"Puzzle"	# Columns (World)
	mv crospang.zip	"Puzzle"	# Cross Pang
	mv cshift.zip	"Puzzle"	# Chicken Shift
	mv deroon.zip	"Puzzle"	# Deroon DeroDero
	mv dharma.zip	"Puzzle"	# Dharma Doujou
	mv drmario.zip	"Puzzle"	# Vs. Dr. Mario
	mv emeralda.zip	"Puzzle"	# Emeraldia (Japan Version B)
	mv ghostlop.zip	"Puzzle"	# Ghostlop (prototype)
	mv htchctch.zip	"Puzzle"	# Hatch Catch
	mv joyjoy.zip	"Puzzle"	# Puzzled / Joy Joy Kid
	mv klax.zip	"Puzzle"	# Klax (set 1)
	mv landmakr.zip	"Puzzle"	# Land Maker (Ver 2.01J 1998/06/01)
	mv locomotn.zip	"Puzzle"	# Loco-Motion
	mv magdrop3.zip	"Puzzle"	# Magical Drop III
	mv magerror.zip	"Puzzle"	# Search for the Magical Error
	mv miexchng.zip	"Puzzle"	# Money Puzzle Exchanger / Money Idol Exchanger
	mv mosaicf2.zip	"Puzzle"	# Mosaic (F2 System)
	mv motos.zip	"Puzzle"	# Motos
	mv mrdrillr.zip	"Puzzle"	# Mr Driller (DRI1/VER.A2)
	mv ohmygod.zip	"Puzzle"	# Oh My God! (Japan)
	mv pbobble2.zip	"Puzzle"	# Puzzle Bobble 2 (Ver 2.2O 1995/07/20)
	mv pbobble4.zip	"Puzzle"	# Puzzle Bobble 4 (Ver 2.04O 1997/12/19)
	mv plotting.zip	"Puzzle"	# Plotting (World set 1)
	mv pururun.zip	"Puzzle"	# Pururun
	mv puyopuy2.zip	"Puzzle"	# Puyo Puyo 2 (Japan)
	mv puzzledp.zip	"Puzzle"	# Puzzle De Pon!
	mv puzzli2.zip	"Puzzle"	# Puzzli 2 Super
	mv puzzloop.zip	"Puzzle"	# Puzz Loop (Europe)
	mv qix.zip	"Puzzle"	# Qix (set 1)
	mv riskchal.zip	"Puzzle"	# Risky Challenge
	mv senkyu.zip	"Puzzle"	# Senkyu (Japan)
	mv spang.zip	"Puzzle"	# Super Pang (World 900914)
	mv spf2t.zip	"Puzzle"	# Super Puzzle Fighter II Turbo (US 960620)
	mv tetrisp2.zip	"Puzzle"	# Tetris Plus 2 (World?)
	mv tokkae.zip	"Puzzle"	# Taisen Tokkae-dama (ver JAA)
	mv uopoko.zip	"Puzzle"	# Puzzle Uo Poko (International)
	mv watrball.zip	"Puzzle"	# Water Balls
fi

#=========== Run and gun ==============================================================

dialog --title "Rom sorter" \
--infobox "Finding the best Run and gun games ..." 7 30

mkdir "Run and gun"

if $ONLINE
then
	bash <(curl -s -L $TSVINPUT | cut -f6)
else
	mv aliens.zip	"Run and gun"	# Aliens (World set 1)
	mv aliensyn.zip	"Run and gun"	# Alien Syndrome (set 4, System 16B, unprotected)
	mv avspirit.zip	"Run and gun"	# Avenging Spirit
	mv battlera.zip	"Run and gun"	# Battle Rangers (World)
	mv bayroute.zip	"Run and gun"	# Bay Route (set 3, World, FD1094 317-0116)
	mv biomtoy.zip	"Run and gun"	# Biomechanical Toy (unprotected)
	mv bionicc.zip	"Run and gun"	# Bionic Commando (US set 1)
	mv bucky.zip	"Run and gun"	# Bucky O'Hare (ver EA)
	mv calibr50.zip	"Run and gun"	# Caliber 50
	mv commando.zip	"Run and gun"	# Commando (World)
	mv contra.zip	"Run and gun"	# Contra (US)
	mv crimec.zip	"Run and gun"	# Crime City (World)
	mv crkdown.zip	"Run and gun"	# Crack Down (US, FD1094 317-0058-04d)
	mv cyberlip.zip	"Run and gun"	# Cyber-Lip
	mv demonwld.zip	"Run and gun"	# Demon's World / Horror Story
	mv dmnfrnt.zip	"Run and gun"	# Demon Front (V102)
	mv elvactr.zip	"Run and gun"	# Elevator Action Returns (Ver 2.2O 1995/02/20)
	mv eprom.zip	"Run and gun"	# Escape from the Planet of the Robot Monsters (set 1)
	mv eswat.zip	"Run and gun"	# E-Swat - Cyber Police (set 3, World, FD1094 317-0130)
	mv flamegun.zip	"Run and gun"	# Flame Gunner
	mv gberet.zip	"Run and gun"	# Green Beret
	mv gbusters.zip	"Run and gun"	# Gang Busters
	mv ghostb.zip	"Run and gun"	# The Real Ghostbusters (US 2 Players)
	mv gundhara.zip	"Run and gun"	# Gundhara
	mv gunforc2.zip	"Run and gun"	# Gunforce 2 (US)
	mv gunforce.zip	"Run and gun"	# Gunforce - Battle Fire Engulfed Terror Island (World)
	mv gunsmoke.zip	"Run and gun"	# Gun.Smoke (World)
	mv gwar.zip	"Run and gun"	# Guerrilla War (US)
	mv hbarrel.zip	"Run and gun"	# Heavy Barrel (US)
	mv ikari.zip	"Run and gun"	# Ikari Warriors (US)
	mv ikari3.zip	"Run and gun"	# Ikari III - The Rescue (Rotary Joystick)
	mv mercs.zip	"Run and gun"	# Mercs (World 900302)
	mv midres.zip	"Run and gun"	# Midnight Resistance (World)
	mv mslug.zip	"Run and gun"	# Metal Slug - Super Vehicle-001
	mv mslug2.zip	"Run and gun"	# Metal Slug 2 - Super Vehicle-001/II
	mv mslug3.zip	"Run and gun"	# Metal Slug 3
	mv mslug4.zip	"Run and gun"	# Metal Slug 4
	mv mslug5.zip	"Run and gun"	# Metal Slug 5
	mv mslugx.zip	"Run and gun"	# Metal Slug X - Super Vehicle-001
	mv nam1975.zip	"Run and gun"	# NAM-1975
	mv narc.zip	"Run and gun"	# Narc (rev 7.00)
	mv ncommand.zip	"Run and gun"	# Ninja Commando
	mv oscar.zip	"Run and gun"	# Psycho-Nics Oscar (US)
	mv outzone.zip	"Run and gun"	# Out Zone (set 1)
	mv rambo3.zip	"Run and gun"	# Rambo III (Europe set 1)
	mv robocop.zip	"Run and gun"	# Robocop (World revision 4)
	mv robocop2.zip	"Run and gun"	# Robocop 2 (Euro/Asia v0.10)
	mv rthun2.zip	"Run and gun"	# Rolling Thunder 2
	mv rthunder.zip	"Run and gun"	# Rolling Thunder (new version)
	mv scontra.zip	"Run and gun"	# Super Contra
	mv searchar.zip	"Run and gun"	# SAR - Search And Rescue (World)
	mv secretag.zip	"Run and gun"	# Secret Agent (World)
	mv shocktr2.zip	"Run and gun"	# Shock Troopers - 2nd Squad
	mv shocktro.zip	"Run and gun"	# Shock Troopers (set 1)
	mv ssrdrubc.zip	"Run and gun"	# Sunset Riders (2 Players ver UBC)
	mv suratk.zip	"Run and gun"	# Surprise Attack (World ver. K)
	mv thndzone.zip	"Run and gun"	# Thunder Zone (World)
	mv timesold.zip	"Run and gun"	# Time Soldiers (US Rev 3)
	mv victroad.zip	"Run and gun"	# Victory Road
	mv xsleena.zip	"Run and gun"	# Xain'd Sleena
	mv xybots.zip	"Run and gun"	# Xybots (rev 2)
fi

#=========== Shoot em ups ==============================================================

dialog --title "Rom sorter" \
--infobox "Finding the best shoot em ups ..." 7 30

mkdir "Shoot em ups"

if $ONLINE
then
	bash <(curl -s -L $TSVINPUT | cut -f7)
else
	mv 1942.zip	"Shoot em ups"	# 1942 (set 1)
	mv 1943.zip	"Shoot em ups"	# 1943: The Battle of Midway (US)
	mv 19xx.zip	"Shoot em ups"	# 19XX: The War Against Destiny (US 951207)
	mv agallet.zip	"Shoot em ups"	# Air Gallet
	mv airbustr.zip	"Shoot em ups"	# Air Buster: Trouble Specialty Raid Unit (World)
	mv alpham2.zip	"Shoot em ups"	# Alpha Mission II / ASO II - Last Guardian
	mv androdun.zip	"Shoot em ups"	# Andro Dunos
	mv batrider.zip	"Shoot em ups"	# Armed Police Batrider (Japan, version B)
	mv batsugun.zip	"Shoot em ups"	# Batsugun (set 1)
	mv bbakraid.zip	"Shoot em ups"	# Battle Bakraid (Japan) (Wed Apr 7 1999)
	mv bchopper.zip	"Shoot em ups"	# Battle Chopper
	mv bigbang.zip	"Shoot em ups"	# Big Bang
	mv blazeon.zip	"Shoot em ups"	# Blaze On (Japan)
	mv blazstar.zip	"Shoot em ups"	# Blazing Star
	mv blkheart.zip	"Shoot em ups"	# Black Heart
	mv blswhstl.zip	"Shoot em ups"	# Bells & Whistles (Version L)
	mv boogwing.zip	"Shoot em ups"	# Boogie Wings (Euro v1.5, 92.12.07)
	mv brvblade.zip	"Shoot em ups"	# Brave Blade (JAPAN)
	mv cawing.zip	"Shoot em ups"	# Carrier Air Wing (World 901012)
	mv chukatai.zip	"Shoot em ups"	# Chuka Taisen (World)
	mv cobracom.zip	"Shoot em ups"	# Cobra-Command (World revision 5)
	mv cosmogng.zip	"Shoot em ups"	# Cosmo Gang the Video (US)
	mv cotton.zip	"Shoot em ups"	# Cotton (set 3, World, FD1094 317-0181a)
	mv cotton2.zip	"Shoot em ups"	# Cotton 2 (JUET 970902 V1.000)
	mv cottonbm.zip	"Shoot em ups"	# Cotton Boomerang (JUET 980709 V1.000)
	mv cybattlr.zip	"Shoot em ups"	# Cybattler
	mv cyvern.zip	"Shoot em ups"	# Cyvern (Japan)
	mv darius.zip	"Shoot em ups"	# Darius (World)
	mv darius2.zip	"Shoot em ups"	# Darius II (Japan)
	mv darius2d.zip	"Shoot em ups"	# Darius II (dual screen) (Japan)
	mv dariusg.zip	"Shoot em ups"	# Darius Gaiden - Silver Hawk (Ver 2.5O 1994/09/19)
	mv dbreed.zip	"Shoot em ups"	# Dragon Breed (M81 pcb version)
	mv ddonpach.zip	"Shoot em ups"	# DoDonPachi (International)
	mv ddp2.zip	"Shoot em ups"	# Bee Storm - DoDonPachi II
	mv desertwr.zip	"Shoot em ups"	# Desert War / Wangan Sensou
	mv dimahoo.zip	"Shoot em ups"	# Dimahoo (US 000121)
	mv dogyuun.zip	"Shoot em ups"	# Dogyuun
	mv dragnblz.zip	"Shoot em ups"	# Dragon Blaze
	mv dspirit.zip	"Shoot em ups"	# Dragon Spirit (new version)
	mv ecofghtr.zip	"Shoot em ups"	# Eco Fighters (World 931203)
	mv edf.zip	"Shoot em ups"	# E.D.F. : Earth Defense Force
	mv esprade.zip	"Shoot em ups"	# ESP Ra.De. (International Ver 1998 4/22)
	mv fantjour.zip	"Shoot em ups"	# Fantastic Journey
	mv feversos.zip	"Shoot em ups"	# Fever SOS (International)
	mv fshark.zip	"Shoot em ups"	# Flying Shark (World)
	mv fstarfrc.zip	"Shoot em ups"	# Final Star Force (US)
	mv galaga88.zip	"Shoot em ups"	# Galaga '88
	mv gametngk.zip	"Shoot em ups"	# The Game Paradise - Master of Shooting! / Game Tengoku - The Game Paradise
	mv gdarius.zip	"Shoot em ups"	# G-Darius (Ver 2.01J)
	mv gdarius2.zip	"Shoot em ups"	# G-Darius Ver.2 (Ver 2.03J)
	mv gemini.zip	"Shoot em ups"	# Gemini Wing
	mv gforce2.zip	"Shoot em ups"	# Galaxy Force 2
	mv gigawing.zip	"Shoot em ups"	# Giga Wing (US 990222)
	mv gradius.zip	"Shoot em ups"	# Gradius
	mv gradius3.zip	"Shoot em ups"	# Gradius III (Japan)
	mv gradius4.zip	"Shoot em ups"	# Gradius 4: Fukkatsu
	mv gratia.zip	"Shoot em ups"	# Gratia - Second Earth (92047-01 version)
	mv gunbird.zip	"Shoot em ups"	# Gunbird (World)
	mv gunbird2.zip	"Shoot em ups"	# Gunbird 2
	mv gunfront.zip	"Shoot em ups"	# Gun & Frontier (World)
	mv gunlock.zip	"Shoot em ups"	# Gunlock (Ver 2.3O 1994/01/20)
	mv guwange.zip	"Shoot em ups"	# Guwange (Japan)
	mv hellfire.zip	"Shoot em ups"	# Hellfire
	mv hyprduel.zip	"Shoot em ups"	# Hyper Duel (Japan set 1)
	mv inthunt.zip	"Shoot em ups"	# In The Hunt (World)
	mv junofrst.zip	"Shoot em ups"	# Juno First
	mv lethalth.zip	"Shoot em ups"	# Lethal Thunder (World)
	mv lresort.zip	"Shoot em ups"	# Last Resort
	mv lwings.zip	"Shoot em ups"	# Legendary Wings (US set 1)
	mv macross.zip	"Shoot em ups"	# Super Spacefortress Macross / Chou-Jikuu Yousai Macross
	mv macross2.zip	"Shoot em ups"	# Super Spacefortress Macross II / Chou-Jikuu Yousai Macross II
	mv macrossp.zip	"Shoot em ups"	# Macross Plus	
	mv mazinger.zip	"Shoot em ups"	# Mazinger Z
	mv metalb.zip	"Shoot em ups"	# Metal Black (World)
	mv mmatrix.zip	"Shoot em ups"	# Mars Matrix: Hyper Solid Shooting (US 000412)
	mv mysticri.zip	"Shoot em ups"	# Mystic Riders (World)
	mv ncv1.zip	"Shoot em ups"	# Namco Classics Collection Vol.1
	mv nemesis.zip	"Shoot em ups"	# Nemesis
	mv nost.zip	"Shoot em ups"	# Nostradamus
	mv ordyne.zip	"Shoot em ups"	# Ordyne (Japan, English Version)
	mv p47.zip	"Shoot em ups"	# P-47 - The Phantom Fighter (World)
	mv p47aces.zip	"Shoot em ups"	# P-47 Aces
	mv parodius.zip	"Shoot em ups"	# Parodius DA! (World)
	mv phelios.zip	"Shoot em ups"	# Phelios (Japan)
	mv plusalph.zip	"Shoot em ups"	# Plus Alpha
	mv prehisle.zip	"Shoot em ups"	# Prehistoric Isle in 1930 (World)
	mv progear.zip	"Shoot em ups"	# Progear (US 010117)
	mv pulstar.zip	"Shoot em ups"	# Pulstar
	mv raiden.zip	"Shoot em ups"	# Raiden
	mv raiden2.zip	"Shoot em ups"	# Raiden 2 (set 1, US Fabtek)
	mv raystorm.zip	"Shoot em ups"	# Ray Storm (Ver 2.06A)
	mv rdft2.zip	"Shoot em ups"	# Raiden Fighters 2
	mv rfjet.zip	"Shoot em ups"	# Raiden Fighters Jet
	mv rfjetu.zip	"Shoot em ups"	# Raiden Fighters Jet (US)
	mv rohga.zip	"Shoot em ups"	# Rohga Armor Force (Asia/Europe v5.0)
	mv rohgau.zip	"Shoot em ups"	# Rohga Armor Force (US v1.0)
	mv rsgun.zip	"Shoot em ups"	# Radiant Silvergun (JUET 980523 V1.000)
	mv rtype.zip	"Shoot em ups"	# R-Type (Japan)
	mv rtype2.zip	"Shoot em ups"	# R-Type II
	mv rtypeleo.zip	"Shoot em ups"	# R-Type Leo (World)
	mv ryujin.zip	"Shoot em ups"	# Ryu Jin (Japan)
	mv s1945ii.zip	"Shoot em ups"	# Strikers 1945 II
	mv s1945iii.zip	"Shoot em ups"	# Strikers 1945 III (World) / Strikers 1999 (Japan)
	mv salamand.zip	"Shoot em ups"	# Salamander (version D)
	mv salmndr2.zip	"Shoot em ups"	# Salamander 2 (ver JAA)
	mv samuraia.zip	"Shoot em ups"	# Samurai Aces (World)
	mv sexyparo.zip	"Shoot em ups"	# Sexy Parodius (ver JAA)
	mv shienryu.zip	"Shoot em ups"	# Shienryu (JUET 961226 V1.000)
	mv sidearms.zip	"Shoot em ups"	# Side Arms - Hyper Dyne (World)
	mv sokyugrt.zip	"Shoot em ups"	# Soukyugurentai / Terra Diver (JUET 960821 V1.000)
	mv soldivid.zip	"Shoot em ups"	# Sol Divide - The Sword Of Darkness
	mv sonicwi2.zip	"Shoot em ups"	# Aero Fighters 2 / Sonic Wings 2
	mv spacedx.zip	"Shoot em ups"	# Space Invaders DX (US) v2.1
	mv ssi.zip	"Shoot em ups"	# Super Space Invaders '91 (World)
	mv sstriker.zip	"Shoot em ups"	# Sorcer Striker (World)
	mv stdragon.zip	"Shoot em ups"	# Saint Dragon
	mv stmblade.zip	"Shoot em ups"	# Storm Blade (US)
	mv strahl.zip	"Shoot em ups"	# Koutetsu Yousai Strahl (Japan set 1)
	mv stratof.zip	"Shoot em ups"	# Raiga - Strato Fighter (US)
	mv tbyahhoo.zip	"Shoot em ups"	# Twin Bee Yahhoo! (ver JAA)
	mv tcobra2.zip	"Shoot em ups"	# Twin Cobra II (Ver 2.1O 1995/11/30)
	mv tengai.zip	"Shoot em ups"	# Tengai / Sengoku Blade: Sengoku Ace Episode II
	mv tenkomor.zip	"Shoot em ups"	# Tenkomori Shooting (TKM2/VER.A1)
	mv terracre.zip	"Shoot em ups"	# Terra Cresta (YM3526 set 1)
	mv terraf.zip	"Shoot em ups"	# Terra Force
	mv thndrx2.zip	"Shoot em ups"	# Thunder Cross II (Japan)
	mv thunderx.zip	"Shoot em ups"	# Thunder Cross
	mv timeplt.zip	"Shoot em ups"	# Time Pilot
	mv truxton.zip	"Shoot em ups"	# Truxton / Tatsujin
	mv twincobr.zip	"Shoot em ups"	# Twin Cobra (World)
	mv twineag2.zip	"Shoot em ups"	# Twin Eagle II - The Rescue Mission
	mv twineagl.zip	"Shoot em ups"	# Twin Eagle - Revenge Joe's Brother
	mv twinhawk.zip	"Shoot em ups"	# Twin Hawk (World)
	mv twinspri.zip	"Shoot em ups"	# Twinkle Star Sprites
	mv ultrax.zip	"Shoot em ups"	# Ultra X Weapons / Ultra Keibitai
	mv unsquad.zip	"Shoot em ups"	# U.N. Squadron (US)
	mv vasara.zip	"Shoot em ups"	# Vasara
	mv vasara2.zip	"Shoot em ups"	# Vasara 2 (set 1)
	mv viprp1.zip	"Shoot em ups"	# Viper Phase 1 (Japan, New Version)
	mv wndrplnt.zip	"Shoot em ups"	# Wonder Planet (Japan)
	mv xevi3dg.zip	"Shoot em ups"	# Xevious 3D/G (XV31/VER.A)
	mv xevious.zip	"Shoot em ups"	# Xevious (Namco)
	mv xexex.zip	"Shoot em ups"	# Xexex (ver EAA)
	mv xexexj.zip	"Shoot em ups"	# Xexex (ver JAA)
	mv xmultipl.zip	"Shoot em ups"	# X Multiply (Japan)
	mv zerowing.zip	"Shoot em ups"	# Zero Wing
fi

#=========== Sports ==============================================================

dialog --title "Rom sorter" \
--infobox "Finding the best sports games ..." 7 30

mkdir "Sports"

if $ONLINE
then
	bash <(curl -s -L $TSVINPUT | cut -f8)
else
	mv 2020bb.zip	"Sports"	# 2020 Super Baseball (set 1)
	mv 88games.zip	"Sports"	# 88 Games
	mv alpine.zip	"Sports"	# Alpine Ski (set 1)
	mv archrivl.zip	"Sports"	# Arch Rivals (rev 4.0)
	mv bangbead.zip	"Sports"	# Bang Bead
	mv blitz.zip	"Sports"	# NFL Blitz (boot ROM 1.2)
	mv bssoccer.zip	"Sports"	# Back Street Soccer
	mv bstars2.zip	"Sports"	# Baseball Stars 2
	mv cbaj.zip	"Sports"	# Cool Boarders Arcade Jam
	mv cbasebal.zip	"Sports"	# Capcom Baseball (Japan)
	mv clshroad.zip	"Sports"	# Clash-Road
	mv csclub.zip	"Sports"	# Capcom Sports Club (Euro 970722)
	mv cupfinal.zip	"Sports"	# Taito Cup Finals (Ver 1.0O 1993/02/28)
	mv cyberbal.zip	"Sports"	# Cyberball (rev 4)
	mv excitebk.zip	"Sports"	# Vs. Excitebike
	mv extdwnhl.zip	"Sports"	# Extreme Downhill (v1.5)
	mv fbfrenzy.zip	"Sports"	# Football Frenzy
	mv flipshot.zip	"Sports"	# Battle Flip Shot
	mv footchmp.zip	"Sports"	# Football Champ (World)
	mv gtmr.zip	"Sports"	# 1000 Miglia: Great 1000 Miles Rally (94/07/18)
	mv hattrick.zip	"Sports"	# Hat Trick
	mv hvysmsh.zip	"Sports"	# Heavy Smash (Japan version -2)
	mv hyperath.zip	"Sports"	# Hyper Athlete (GV021 JAPAN 1.00)
	mv kingofb.zip	"Sports"	# King of Boxer (English)
	mv lbowling.zip	"Sports"	# League Bowling
	mv machbrkr.zip	"Sports"	# Mach Breakers (Japan)
	mv madgear.zip	"Sports"	# Mad Gear (US)
	mv nagano98.zip	"Sports"	# Nagano Winter Olympics '98 (GX720 EAA)
	mv nbahangt.zip	"Sports"	# NBA Hangtime (rev L1.1 04/16/96)
	mv nbajam.zip	"Sports"	# NBA Jam (rev 3.01 04/07/93)
	mv neodrift.zip	"Sports"	# Neo Drift Out - New Technology
	mv openice.zip	"Sports"	# 2 On 2 Open Ice Challenge (rev 1.21)
	mv overtop.zip	"Sports"	# Over Top
	mv pblbeach.zip	"Sports"	# Pebble Beach - The Great Shot (JUE 950913 V0.990)
	mv pgoal.zip	"Sports"	# Pleasure Goal / Futsal - 5 on 5 Mini Soccer
	mv pigskin.zip	"Sports"	# Pigskin 621AD
	mv pktgaldx.zip	"Sports"	# Pocket Gal Deluxe (Euro v3.00)
	mv pkunwar.zip	"Sports"	# Penguin-Kun Wars (US)
	mv punkshot.zip	"Sports"	# Punk Shot (US 4 Players)
	mv pwrgoal.zip	"Sports"	# Taito Power Goal (Ver 2.5O 1994/11/03)
	mv ringking.zip	"Sports"	# Ring King (US set 1)
	mv rollerg.zip	"Sports"	# Rollergames (US)
	mv rungun.zip	"Sports"	# Run and Gun (ver EAA 1993 10.8)
	mv rushhero.zip	"Sports"	# Rushing Heroes (ver UAB)
	mv shimpact.zip	"Sports"	# Super High Impact (rev LA1 09/30/91)
	mv simpbowl.zip	"Sports"	# Simpsons Bowling (GQ829 UAA)
	mv slammast.zip	"Sports"	# Saturday Night Slam Masters (World 930713)
	mv slapshot.zip	"Sports"	# Slap Shot (Japan)
	mv socbrawl.zip	"Sports"	# Soccer Brawl
	mv spdodgeb.zip	"Sports"	# Super Dodge Ball (US)
	mv speedspn.zip	"Sports"	# Speed Spin
	mv ssideki3.zip	"Sports"	# Super Sidekicks 3 - The Next Glory / Tokuten Ou 3 - eikoue no michi
	mv stakwin2.zip	"Sports"	# Stakes Winner 2
	mv stonebal.zip	"Sports"	# Stone Ball (4 Players)
	mv tbowl.zip	"Sports"	# Tecmo Bowl (World?)
	mv tehkanwc.zip	"Sports"	# Tehkan World Cup
	mv trackfld.zip	"Sports"	# Track & Field
	mv turfmast.zip	"Sports"	# Neo Turf Masters / Big Tournament Golf
	mv ultennis.zip	"Sports"	# Ultimate Tennis
	mv vball.zip	"Sports"	# U.S. Championship V'ball (set 1)
	mv waterski.zip	"Sports"	# Water Ski
	mv wc90.zip	"Sports"	# Tecmo World Cup '90 (set 1)
	mv wg3dh.zip	"Sports"	# Wayne Gretzky's 3D Hockey
	mv winspike.zip	"Sports"	# Winning Spike (ver EAA)
	mv wjammers.zip	"Sports"	# Windjammers / Flying Power Disc
	mv wwfmania.zip	"Sports"	# WWF: Wrestlemania (rev 1.30 08/10/95)
	mv wwfwfest.zip	"Sports"	# WWF WrestleFest (US set 1)
fi

#=========== Vs Fighting ==============================================================

dialog --title "Rom sorter" \
--infobox "Finding the best Vs fighting games ..." 7 30

mkdir "Vs Fighting"

if $ONLINE
then
	bash <(curl -s -L $TSVINPUT | cut -f9)
else
	mv aof3.zip	"Vs Fighting"	# Art of Fighting 3 - The Path of the Warrior / Art of Fighting - Ryuuko no Ken Gaiden
	mv bldyror2.zip	"Vs Fighting"	# Bloody Roar 2 (JAPAN)
	mv bloodwar.zip	"Vs Fighting"	# Blood Warrior
	mv breakrev.zip	"Vs Fighting"	# Breakers Revenge
	mv cybots.zip	"Vs Fighting"	# Cyberbots: Fullmetal Madness (Euro 950424)
	mv daraku.zip	"Vs Fighting"	# Daraku Tenshi - The Fallen Angels
	mv doapp.zip	"Vs Fighting"	# Dead Or Alive ++ (JAPAN)
	mv ehrgeiz.zip	"Vs Fighting"	# Ehrgeiz (EG3/VER.A)
	mv fatfury3.zip	"Vs Fighting"	# Fatal Fury 3 - Road to the Final Victory / Garou Densetsu 3 - haruka-naru tatakai
	mv fgtlayer.zip	"Vs Fighting"	# Fighting Layer (FTL0/VER.A)
	mv garou.zip	"Vs Fighting"	# Garou - Mark of the Wolves (set 1)
	mv gaxeduel.zip	"Vs Fighting"	# Golden Axe - The Duel (JUETL 950117 V1.000)
	mv gundamex.zip	"Vs Fighting"	# Mobile Suit Gundam EX Revue
	mv jojo.zip	"Vs Fighting"	# JoJo's Venture / JoJo no Kimyouna Bouken
	mv kinst.zip	"Vs Fighting"	# Killer Instinct (v1.5d)
	mv kizuna.zip	"Vs Fighting"	# Kizuna Encounter - Super Tag Battle / Fu'un Super Tag Battle
	mv kof2000.zip	"Vs Fighting"	# The King of Fighters 2000
	mv kof96.zip	"Vs Fighting"	# The King of Fighters '96 (set 1)
	mv kof98.zip	"Vs Fighting"	# The King of Fighters '98 - The Slugfest / King of Fighters '98 - dream match never ends
	mv lastbld2.zip	"Vs Fighting"	# Last Blade 2 / Bakumatsu Roman - Dai Ni Maku Gekka no Kenshi, The
	mv mace.zip	"Vs Fighting"	# Mace: The Dark Age (boot ROM 1.0ce, HDD 1.0b)
	mv macea.zip	"Vs Fighting"	# Mace: The Dark Age (HDD 1.0a
	mv martmast.zip	"Vs Fighting"	# Martial Masters
	mv matrim.zip	"Vs Fighting"	# Matrimelee / Shin Gouketsuji Ichizoku Toukon
	mv megaman2.zip	"Vs Fighting"	# Mega Man 2: The Power Fighters (US 960708)
	mv metmqstr.zip	"Vs Fighting"	# Metamoqester
	mv mk2.zip	"Vs Fighting"	# Mortal Kombat II (rev L3.1)
	mv msh.zip	"Vs Fighting"	# Marvel Super Heroes (Euro 951024)
	mv mshvsf.zip	"Vs Fighting"	# Marvel Super Heroes Vs. Street Fighter (Euro 970625)
	mv mtlchamp.zip	"Vs Fighting"	# Martial Champion (ver EAB)
	mv mvsc.zip	"Vs Fighting"	# Marvel Vs. Capcom: Clash of Super Heroes (Euro 980112)
	mv nwarr.zip	"Vs Fighting"	# Night Warriors: Darkstalkers' Revenge (US 950406)
	mv outfxies.zip	"Vs Fighting"	# Outfoxies
	mv plsmaswd.zip	"Vs Fighting"	# Plasma Sword (USA 980316)
	mv primrage.zip	"Vs Fighting"	# Primal Rage (version 2.3)
	mv rbff2.zip	"Vs Fighting"	# Real Bout Fatal Fury 2 - The Newcomers / Real Bout Garou Densetsu 2 - the newcomers (set 1)
	mv ringdest.zip	"Vs Fighting"	# Ring of Destruction: Slammasters II (Euro 940902)
	mv rotd.zip	"Vs Fighting"	# Rage of the Dragons
	mv rvschool.zip	"Vs Fighting"	# Rival Schools (USA 971117)
	mv samsh5sp.zip	"Vs Fighting"	# Samurai Shodown V Special / Samurai Spirits Zero Special (set 1, uncensored)
	mv samsho2.zip	"Vs Fighting"	# Samurai Shodown II / Shin Samurai Spirits - Haohmaru jigokuhen
	mv samsho3.zip	"Vs Fighting"	# Samurai Shodown III / Samurai Spirits - Zankurou Musouken (set 1)
	mv sf2ce.zip	"Vs Fighting"	# Street Fighter II' - Champion Edition (World 920313)
	mv sfa2.zip	"Vs Fighting"	# Street Fighter Alpha 2 (US 960306)
	mv sfa3.zip	"Vs Fighting"	# Street Fighter Alpha 3 (US 980904)
	mv sfex2p.zip	"Vs Fighting"	# Street Fighter EX 2 Plus (USA 990611)
	mv sfexa.zip	"Vs Fighting"	# Street Fighter EX (ASIA 961219)
	mv sfiii3.zip	"Vs Fighting"	# Street Fighter III 3rd Strike: Fight for the Future
	mv sgemf.zip	"Vs Fighting"	# Super Gem Fighter Mini Mix (US 970904)
	mv soulclbr.zip	"Vs Fighting"	# Soul Calibur (SOC14/VER.C)
	mv ssf2t.zip	"Vs Fighting"	# Super Street Fighter II Turbo (World 940223)
	mv starglad.zip	"Vs Fighting"	# Star Gladiator (USA 960627)
	mv svc.zip	"Vs Fighting"	# SvC Chaos - SNK vs Capcom (MVS)
	mv tekken2.zip	"Vs Fighting"	# Tekken 2 Ver.B (TES3/VER.B)
	mv tekken3.zip	"Vs Fighting"	# Tekken 3 (TET1/VER.E1)
	mv tektagt.zip	"Vs Fighting"	# Tekken Tag Tournament (TEG3/VER.C1)
	mv ts2.zip	"Vs Fighting"	# Battle Arena Toshinden 2 (USA 951124)
	mv umk3.zip	"Vs Fighting"	# Ultimate Mortal Kombat 3 (rev 1.2)
	mv vf.zip	"Vs Fighting"	# Virtua Fighter
	mv vsav.zip	"Vs Fighting"	# Vampire Savior: The Lord of Vampire (Euro 970519)
	mv wakuwak7.zip	"Vs Fighting"	# Waku Waku 7
	mv whp.zip	"Vs Fighting"	# World Heroes Perfect
	mv xmcota.zip	"Vs Fighting"	# X-Men: Children of the Atom (Euro 950105)
	mv xmvsf.zip	"Vs Fighting"	# X-Men Vs. Street Fighter (Euro 961004)
fi

#===========Everything else==============================================================

dialog --title "Rom sorter" \
--infobox "Moving everything else to a hidden [Leftovers] folder ..." 7 30

mkdir "[Leftovers]"
echo "#Hidden-folder" > [Leftovers]/.title 	#Write a hidden file to the lefotvers dir, which will make it appear invisible but still accessible in the menu
#cp .BIOS/*.zip	"[Leftovers]"
mv *.zip	"[Leftovers]"
rm .title # Delete unwanted .title folder from root of roms dir
echo "custom_folders=Y" > /tmp/external_vars #Turn PinHP custom folders option 
sed -i -e 's/custom_folders=./custom_folders=Y/' "$CONFIGFILE"
echo "pikeyd_current=" >> /tmp/external_vars #Clear variable to not confuse parent script

joy2key_start "yesno"
dialog --title "Rom sorter" \
--msgbox "All done! " 7 30
joy2key_stop

clear