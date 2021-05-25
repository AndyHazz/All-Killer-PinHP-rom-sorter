#!/bin/bash

# Put this script in you PinHP advmame_roms folder, along with a full romset
# Run './rom-sorter.sh' and it will organise them into folders, based
# on work by members of the arcadecontrols.com forum here: 
# http://forum.arcadecontrols.com/index.php/topic,149708.0.html
# Best games from each genre will be moved into their own subfolders
# Everything else will be put in a hidden '.Leftovers' folder

# Initially it's pretty much 'as-is' from the arcadecontrol forum, so will include
# games that won't run well on AdvMame and/or Raspberry pi - over time I'd like to
# update this script to focus on what runs best for AdvMame and pi2jamma

# Move everything back into the root roms dir so we can start from scratch
find . -mindepth 2 -type f -print -exec mv {} . \;

# Remove empty directories
find . -type d -empty -delete


#=========== BIOS files ==============================================================

# First, move all the bios files to one place
# We will later copy all of these into each game genre folder
# ... because we don't know which might be required, and they don't take much space

mkdir ".BIOS"

mv acpsx.zip ".BIOS"		# Acclaim PSX
mv ar_bios.zip ".BIOS"		# Arcadia System BIOS
mv atluspsx.zip ".BIOS"		# Atlus PSX
mv atpsx.zip ".BIOS"	 	# Atari PSX
mv bctvidbs.zip ".BIOS"		# MPU4 Video Firmware
mv cpzn1.zip ".BIOS"		# ZN1
mv cpzn2.zip ".BIOS" 		# ZN2
mv crysbios.zip ".BIOS"		# Crystal System Bios
mv cvs.zip ".BIOS"			# CVS Bios
mv decocass.zip ".BIOS"		# Cassette System
mv hng64.zip ".BIOS"		# Hyper NeoGeo 64 Bios
mv konamigv.zip ".BIOS"		# Baby Phoenix-GV System
mv konamigx.zip ".BIOS"		# System GX
mv macsbios.zip ".BIOS"		# Multi Amenity Cassette System Bios
mv maxaflex.zip ".BIOS"		# Max-A-Flex
mv megaplay.zip ".BIOS"		# Mega Play Bios
mv megatech.zip ".BIOS"		# Mega-Tech Bios
mv neogeo.zip ".BIOS"		# Neo-Geo
mv nss.zip ".BIOS"			# Nintendo Super System Bios
mv pgm.zip ".BIOS"			# PGM (Polygame Master) System Bios
mv playch10.zip ".BIOS"		# PlayChoice-10 Bios
mv psarc95.zip ".BIOS"		# PS Arcade 95
mv skns.zip ".BIOS"			# Super Kaneko Nova System Bios
mv stvbios.zip ".BIOS"		# ST-V Bios
mv taitofx1.zip ".BIOS"		# Taito FX1
mv taitogn.zip ".BIOS"		# Taito GNET
mv tps.zip ".BIOS"			# TPS


#=========== Classics - Horizontal ==============================================================

mkdir "[Classics]"
cp .BIOS/*.zip "[Classics]"

mv astdelux.zip "[Classics]"
mv berzerk.zip "[Classics]"
mv bosco.zip "[Classics]"
mv bubbles.zip "[Classics]"
mv buckrog.zip "[Classics]"
mv cloak.zip "[Classics]"
mv defender.zip "[Classics]"
mv dowild.zip "[Classics]"
mv elevator.zip "[Classics]"
mv gauntlet.zip "[Classics]"
mv joust.zip "[Classics]"
mv junglek.zip "[Classics]"
mv ldrun.zip "[Classics]"
mv mpatrol.zip "[Classics]"
mv mtrap.zip "[Classics]"
mv pepper2.zip "[Classics]"
mv popeye.zip "[Classics]"
mv rallyx.zip "[Classics]"
mv rampage.zip "[Classics]"
mv rbtapper.zip "[Classics]"
mv robotron.zip "[Classics]"
mv sharrier.zip "[Classics]"
mv skykid.zip "[Classics]"
mv tapper.zip "[Classics]"
mv timber.zip "[Classics]"
mv wow.zip "[Classics]"
mv zookeep.zip "[Classics]"

#=========== Classics - Vertical ==============================================================

mv anteater.zip "[Classics]"
mv astinvad.zip "[Classics]"
mv astrob.zip "[Classics]"
mv bagman.zip "[Classics]"
mv btime.zip "[Classics]"
mv carnival.zip "[Classics]"
mv centiped.zip "[Classics]"
mv circusc.zip "[Classics]"
mv congo.zip "[Classics]"
mv digdug.zip "[Classics]"
mv digdug2.zip "[Classics]"
mv dkong.zip "[Classics]"
mv dkong3.zip "[Classics]"
mv dkongjr.zip "[Classics]"
mv docastle.zip "[Classics]"
mv dommy.zip "[Classics]"
mv drmicro.zip "[Classics]"
mv eyes.zip "[Classics]"
mv frogger.zip "[Classics]"
mv galaga.zip "[Classics]"
mv galaxian.zip "[Classics]"
mv gorf.zip "[Classics]"
mv gyruss.zip "[Classics]"
mv invaders.zip "[Classics]"
mv jjack.zip "[Classics]"
mv journey.zip "[Classics]"
mv joust2.zip "[Classics]"
mv jrpacman.zip "[Classics]"
mv kangaroo.zip "[Classics]"
mv krull.zip "[Classics]"
mv ladybug.zip "[Classics]"
mv mappy.zip "[Classics]"
mv milliped.zip "[Classics]"
mv mooncrst.zip "[Classics]"
mv mrdo.zip "[Classics]"
mv mspacman.zip "[Classics]"
mv mspacmnf.zip "[Classics]"
mv nibbler.zip "[Classics]"
mv pacman.zip "[Classics]"
mv pacmanf.zip "[Classics]"
mv pandoras.zip "[Classics]"
mv panic.zip "[Classics]"
mv pengo.zip "[Classics]"
mv phoenix.zip "[Classics]"
mv pooyan.zip "[Classics]"
mv puckman.zip "[Classics]"
mv punchout.zip "[Classics]"
mv qbert.zip "[Classics]"
mv rocnrope.zip "[Classics]"
mv sbagman.zip "[Classics]"
mv scobra.zip "[Classics]"
mv scramble.zip "[Classics]"
mv scregg.zip "[Classics]"
mv shollow.zip "[Classics]"
mv tutankhm.zip "[Classics]"
mv vanguard.zip "[Classics]"
mv zaxxon.zip "[Classics]"

#=========== Platformers ==============================================================

mkdir "[Platformers]"
cp .BIOS/*.zip "[Platformers]"

mv alexkidd.zip "[Platformers]"
mv arabian.zip "[Platformers]"
mv athena.zip "[Platformers]"
mv bigkarnk.zip "[Platformers]"
mv bjourney.zip "[Platformers]"
mv blktiger.zip "[Platformers]"
mv bnzabros.zip "[Platformers]"
mv bombjack.zip "[Platformers]"
mv bonkadv.zip "[Platformers]"
mv bubblem.zip "[Platformers]"
mv bublbob2.zip "[Platformers]"
mv bublbobl.zip "[Platformers]"
mv cadash.zip "[Platformers]"
mv chinagat.zip "[Platformers]"
mv cninja.zip "[Platformers]"
mv dondokod.zip "[Platformers]"
mv drgnbstr.zip "[Platformers]"
mv dynagear.zip  "[Platformers]"
mv ghouls.zip "[Platformers]"
mv gng.zip "[Platformers]"
mv hcastle.zip "[Platformers]"
mv hharry.zip "[Platformers]"
mv indytemp.zip "[Platformers]"
mv jjsquawk.zip  "[Platformers]"
mv joemacr.zip "[Platformers]"
mv karnov.zip "[Platformers]"
# mv keith.zip "[Platformers]" Unknown filename - todo, find mame 0.106 equivalent?
mv kicker.zip "[Platformers]"
mv kidniki.zip "[Platformers]"
mv liquidk.zip "[Platformers]"
mv liquidku.zip  "[Platformers]"
mv maglord.zip "[Platformers]"
mv marvland.zip "[Platformers]"
mv mcatadv.zip "[Platformers]"
mv momoko.zip "[Platformers]"
mv mp_soni2.zip "[Platformers]"
mv mp_sonic.zip "[Platformers]"
mv msword.zip "[Platformers]"
mv mtwins.zip "[Platformers]"
mv mystwarr.zip "[Platformers]"
mv nemo.zip "[Platformers]"
mv nitd.zip "[Platformers]"
mv nspirit.zip "[Platformers]"
mv osman.zip "[Platformers]"
mv pacland.zip "[Platformers]"
mv penbros.zip "[Platformers]"
mv pigout.zip "[Platformers]"
mv rastan.zip "[Platformers]"
mv recalh.zip  "[Platformers]"
mv rodland.zip "[Platformers]"
mv sabotenb.zip "[Platformers]"
mv shdancer.zip "[Platformers]"
mv shinobi.zip "[Platformers]"
mv snowbro2.zip "[Platformers]"
mv snowbros.zip "[Platformers]"
mv spelunkr.zip "[Platformers]"
mv spinmast.zip "[Platformers]"
mv strider.zip "[Platformers]"
mv suprmrio.zip "[Platformers]"
mv teddybb.zip "[Platformers]"
mv thoop.zip "[Platformers]"
mv tigeroad.zip "[Platformers]"
mv tnzs.zip "[Platformers]"
mv toki.zip "[Platformers]"
mv tophuntr.zip "[Platformers]"
mv trojan.zip "[Platformers]"
mv tumblep.zip "[Platformers]"
mv wardner.zip "[Platformers]"
mv wb3.zip "[Platformers]"
mv wbml.zip "[Platformers]"
# mv wbmlvc.zip "[Platformers]" Unknown filename - todo, find mame 0.106 equivalent?
mv wboy.zip "[Platformers]"
mv willow.zip "[Platformers]"
mv wiz.zip "[Platformers]"

#=========== Beat 'em ups ==============================================================

mkdir "[Beat 'em ups]"
cp .BIOS/*.zip "[Beat 'em ups]"

mv 64street.zip "[Beat 'em ups]"
mv altbeast.zip "[Beat 'em ups]"
# mv aoh.zip "[Beat 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
mv arabfgt.zip "[Beat 'em ups]"
mv armwar.zip "[Beat 'em ups]"
mv astorm.zip "[Beat 'em ups]"
mv avengers.zip "[Beat 'em ups]"
mv avsp.zip "[Beat 'em ups]"
mv baddudes.zip "[Beat 'em ups]"
mv batcir.zip "[Beat 'em ups]"
# mv bigfight.zip "[Beat 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
mv bmaster.zip "[Beat 'em ups]"
mv brapboys.zip "[Beat 'em ups]"
# mv bsmt2000.zip "[Beat 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
mv btoads.zip "[Beat 'em ups]"
mv burningf.zip "[Beat 'em ups]"
mv captaven.zip "[Beat 'em ups]"
mv captcomm.zip "[Beat 'em ups]"
mv crimfght.zip "[Beat 'em ups]"
# mv crimfght2.zip "[Beat 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
mv crysking.zip "[Beat 'em ups]"
mv ctribe.zip "[Beat 'em ups]"
mv ddragon.zip "[Beat 'em ups]"
mv ddragon2.zip "[Beat 'em ups]"
mv ddsom.zip "[Beat 'em ups]"
mv ddtod.zip "[Beat 'em ups]"
mv denjinmk.zip "[Beat 'em ups]"
mv dino.zip "[Beat 'em ups]"
mv dynwar.zip "[Beat 'em ups]"
mv edrandy.zip "[Beat 'em ups]"
mv eightman.zip "[Beat 'em ups]"
mv ffight.zip "[Beat 'em ups]"
mv ga2.zip "[Beat 'em ups]"
mv gaia.zip "[Beat 'em ups]"
mv gaiapols.zip "[Beat 'em ups]"
mv ganryu.zip "[Beat 'em ups]"
mv gauntdl.zip "[Beat 'em ups]"
mv gauntleg.zip "[Beat 'em ups]"
mv goldnaxe.zip "[Beat 'em ups]"
mv grdians.zip "[Beat 'em ups]"
mv growl.zip "[Beat 'em ups]"
mv hook.zip "[Beat 'em ups]"
mv kbash.zip "[Beat 'em ups]"
mv knights.zip "[Beat 'em ups]"
mv kod.zip "[Beat 'em ups]"
mv kov.zip "[Beat 'em ups]"
mv kov2.zip "[Beat 'em ups]"
# mv legendoh.zip "[Beat 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
mv lightbr.zip "[Beat 'em ups]"
mv metamrph.zip "[Beat 'em ups]"
mv mp_sor2.zip "[Beat 'em ups]"
mv mutnat.zip "[Beat 'em ups]"
mv mwalk.zip "[Beat 'em ups]"
mv nbbatman.zip "[Beat 'em ups]"
mv ninjak.zip "[Beat 'em ups]"
mv nslasher.zip "[Beat 'em ups]"
mv orlegend.zip "[Beat 'em ups]"
mv pow.zip "[Beat 'em ups]"
mv pulirula.zip "[Beat 'em ups]"
mv punisher.zip "[Beat 'em ups]"
mv riotcity.zip "[Beat 'em ups]"
mv rmpgwt.zip "[Beat 'em ups]"
mv roboarmy.zip "[Beat 'em ups]"
mv sailormn.zip "[Beat 'em ups]"
mv sengoku.zip "[Beat 'em ups]"
mv sengoku3.zip "[Beat 'em ups]"
mv shadfrce.zip "[Beat 'em ups]"
mv silentd.zip "[Beat 'em ups]"
mv silkroad.zip "[Beat 'em ups]"
mv simpsons.zip "[Beat 'em ups]"
# mv simpsons2p3.zip "[Beat 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
mv spidman.zip "[Beat 'em ups]"
mv splatter.zip "[Beat 'em ups]"
# mv theroes.zip "[Beat 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
mv tmnt.zip "[Beat 'em ups]"
mv tmnt2.zip "[Beat 'em ups]"
# mv tmnt22pu.zip "[Beat 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
mv tmnt2pj.zip "[Beat 'em ups]"
mv uccops.zip "[Beat 'em ups]"
mv vamphalf.zip "[Beat 'em ups]"
mv vendetta.zip "[Beat 'em ups]"
# mv vendetta2p.zip "[Beat 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
mv vigilant.zip "[Beat 'em ups]"
mv viostorm.zip "[Beat 'em ups]"
mv warriorb.zip "[Beat 'em ups]"
mv wizdfire.zip "[Beat 'em ups]"
mv wof.zip "[Beat 'em ups]"
mv xmen.zip "[Beat 'em ups]"
# mv xmen2pu.zip "[Beat 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?


#=========== Run and Gun ==============================================================

mkdir "[Run and gun]"
cp .BIOS/*.zip "[Run and gun]"

mv aliens.zip "[Run and gun]"
mv aliensyn.zip "[Run and gun]"
mv avspirit.zip "[Run and gun]"
mv battlera.zip "[Run and gun]"
mv bayroute.zip "[Run and gun]"
mv biomtoy.zip "[Run and gun]"
mv bionicc.zip "[Run and gun]"
mv bucky.zip "[Run and gun]"
mv commando.zip "[Run and gun]"
mv contra.zip "[Run and gun]"
mv crimec.zip "[Run and gun]"
mv crkdown.zip "[Run and gun]"
mv cyberlip.zip "[Run and gun]"
mv demonwld.zip "[Run and gun]"
mv dmnfrnt.zip  "[Run and gun]"
mv elvactr.zip "[Run and gun]"
mv eprom.zip "[Run and gun]"
mv eswat.zip "[Run and gun]"
mv flamegun.zip "[Run and gun]"
mv gberet.zip "[Run and gun]"
mv gbusters.zip "[Run and gun]"
mv ghostb.zip "[Run and gun]"
mv gundhara.zip "[Run and gun]"
mv gunforc2.zip "[Run and gun]"
mv gunforce.zip  "[Run and gun]"
mv gunsmoke.zip "[Run and gun]"
mv ikari3.zip "[Run and gun]"
mv mercs.zip  "[Run and gun]"
# mv moomesa.zip "[Run and gun]" Unknown filename - todo, find mame 0.106 equivalent?
mv mslug.zip "[Run and gun]"
mv mslug2.zip "[Run and gun]"
mv mslug3.zip "[Run and gun]"
mv mslug4.zip "[Run and gun]"
mv mslug5.zip "[Run and gun]"
mv mslugx.zip "[Run and gun]"
# mv mystwarr.zip "[Run and gun]" Duplicate - also in platformers
mv nam1975.zip "[Run and gun]"
mv narc.zip "[Run and gun]"
mv ncommand.zip "[Run and gun]"
mv oscar.zip "[Run and gun]"
mv outzone.zip "[Run and gun]"
mv rambo3.zip "[Run and gun]"
mv robocop.zip "[Run and gun]"
mv robocop2.zip "[Run and gun]"
mv rthun2.zip  "[Run and gun]"
mv rthunder.zip "[Run and gun]"
mv scontra.zip "[Run and gun]"
mv secretag.zip "[Run and gun]"
mv shocktr2.zip "[Run and gun]"
mv shocktro.zip "[Run and gun]"
mv ssriders.zip  "[Run and gun]"
# mv ssridersubc.zip "[Run and gun]" Unknown filename - todo, find mame 0.106 equivalent?
mv suratk.zip "[Run and gun]"
mv thndzone.zip "[Run and gun]"
# mv wmsnarc.zip "[Run and gun]" Unknown filename - todo, find mame 0.106 equivalent?
mv xsleena.zip "[Run and gun]"



#mv calibr50.zip  "[Run and gun]"
#mv gwar.zip "[Run and gun]"
#mv hbarrel.zip "[Run and gun]"
#mv ikari.zip "[Run and gun]"
#mv midres.zip "[Run and gun]"
#mv searchar.zip "[Run and gun]"
#mv timesold.zip "[Run and gun]"
#mv victroad.zip "[Run and gun]"
#mv xybots.zip "[Run and gun]"


#=========== Puzzle ==============================================================

mkdir "[Puzzle]"
cp .BIOS/*.zip "[Puzzle]"

#mv mosaicf2.zip "[Puzzle]"
mv aquarush.zip "[Puzzle]"
mv ar_spot.zip "[Puzzle]"
mv bakubaku.zip "[Puzzle]"
mv bangball.zip "[Puzzle]"
mv blockhl.zip "[Puzzle]"
mv blockout.zip "[Puzzle]"
mv columns.zip "[Puzzle]"
mv crospang.zip "[Puzzle]"
mv cshift.zip "[Puzzle]"
mv deroon.zip "[Puzzle]"
mv dharma.zip "[Puzzle]"
mv drmario.zip "[Puzzle]"
mv emeralda.zip "[Puzzle]"
mv ghostlop.zip "[Puzzle]"
mv htchctch.zip "[Puzzle]"
mv joyjoy.zip "[Puzzle]"
mv klax.zip "[Puzzle]"
mv landmakr.zip "[Puzzle]"
mv locomotn.zip "[Puzzle]"
mv magdrop3.zip "[Puzzle]"
mv magerror.zip "[Puzzle]"
mv miexchng.zip "[Puzzle]"
mv motos.zip "[Puzzle]"
mv mrdrillr.zip "[Puzzle]"
# mv msgogo.zip "[Puzzle]" Unknown filename - todo, find mame 0.106 equivalent?
# mv mushitam.zip "[Puzzle]" Unknown filename - todo, find mame 0.106 equivalent?
mv ohmygod.zip "[Puzzle]"
mv pbobble2.zip "[Puzzle]"
mv pbobble4.zip "[Puzzle]"
mv plotting.zip "[Puzzle]"
mv pururun.zip "[Puzzle]"
mv puyopuy2.zip "[Puzzle]"
mv puzzledp.zip "[Puzzle]"
mv puzzli2.zip "[Puzzle]"
# mv puzzli2s.zip "[Puzzle]" Unknown filename - todo, find mame 0.106 equivalent?
mv puzzloop.zip "[Puzzle]"
# mv pzloop2.zip "[Puzzle]" Unknown filename - todo, find mame 0.106 equivalent?
mv qix.zip "[Puzzle]"
mv riskchal.zip "[Puzzle]"
mv senkyu.zip "[Puzzle]"
mv spang.zip  "[Puzzle]"
mv spf2t.zip "[Puzzle]"
mv tetrisp2.zip "[Puzzle]"
# mv tgm2.zip "[Puzzle]" Unknown filename - todo, find mame 0.106 equivalent?
mv tokkae.zip "[Puzzle]"
mv uopoko.zip "[Puzzle]"
mv watrball.zip "[Puzzle]"

#=========== Sports ==============================================================

mkdir "[Sports]"
cp .BIOS/*.zip "[Sports]"

#mv wrally.zip "[Sports]" #Unfortunately won't work in AdvMame
mv 2020bb.zip "[Sports]"
mv 88games.zip "[Sports]"
mv alpine.zip "[Sports]"
mv archrivl.zip "[Sports]"
# mv archrivlb.zip "[Sports]" Unknown filename - todo, find mame 0.106 equivalent?
mv bangbead.zip "[Sports]"
mv blitz.zip "[Sports]"
mv bssoccer.zip "[Sports]"
mv bstars2.zip "[Sports]"
# mv carket.zip "[Sports]" Unknown filename - todo, find mame 0.106 equivalent?
mv cbaj.zip "[Sports]"
mv cbasebal.zip "[Sports]"
mv clshroad.zip "[Sports]"
mv csclub.zip "[Sports]"
mv cupfinal.zip "[Sports]"
mv cyberbal.zip "[Sports]"
mv excitebk.zip "[Sports]"
mv extdwnhl.zip "[Sports]"
mv fbfrenzy.zip "[Sports]"
mv flipshot.zip "[Sports]"
mv footchmp.zip "[Sports]"
mv gtmr.zip "[Sports]"
mv hattrick.zip "[Sports]"
mv hvysmsh.zip "[Sports]"
mv hyperath.zip "[Sports]"
mv kingofb.zip "[Sports]"
mv lbowling.zip "[Sports]"
mv machbrkr.zip "[Sports]"
mv madgear.zip "[Sports]"
mv nagano98.zip "[Sports]"
mv nbahangt.zip "[Sports]"
mv nbajam.zip "[Sports]"
mv neodrift.zip "[Sports]"
mv openice.zip "[Sports]"
mv overtop.zip "[Sports]"
mv pblbeach.zip "[Sports]"
mv pgoal.zip "[Sports]"
mv pigskin.zip "[Sports]"
mv pktgaldx.zip "[Sports]"
mv pkunwar.zip "[Sports]"
mv punkshot.zip "[Sports]"
# mv punkshot2.zip "[Sports]" Unknown filename - todo, find mame 0.106 equivalent?
mv pwrgoal.zip "[Sports]"
mv ringking.zip "[Sports]"
mv rollerg.zip "[Sports]"
mv rungun.zip "[Sports]"
mv rushhero.zip "[Sports]"
mv shimpact.zip "[Sports]"
mv simpbowl.zip "[Sports]"
mv slammast.zip "[Sports]"
mv slapshot.zip "[Sports]"
mv socbrawl.zip "[Sports]"
mv spdodgeb.zip "[Sports]"
mv speedspn.zip "[Sports]"
mv ssideki3.zip "[Sports]"
mv stakwin2.zip "[Sports]"
mv stonebal.zip "[Sports]"
# mv stonebal2.zip "[Sports]" Unknown filename - todo, find mame 0.106 equivalent?
mv tbowl.zip "[Sports]"
mv tehkanwc.zip "[Sports]"
mv trackfld.zip "[Sports]"
# mv trackfld_audio.zip "[Sports]" Unknown filename - todo, find mame 0.106 equivalent?
mv turfmast.zip "[Sports]"
mv ultennis.zip "[Sports]"
mv vball.zip "[Sports]"
mv waterski.zip "[Sports]"
mv wc90.zip "[Sports]"
mv wg3dh.zip "[Sports]"
mv winspike.zip "[Sports]"
mv wjammers.zip "[Sports]"
mv wwfmania.zip "[Sports]"
mv wwfwfest.zip "[Sports]"
# mv ym2608.zip "[Sports]" Unknown filename - todo, find mame 0.106 equivalent?



#=========== Vertical Shmups ==============================================================

#Raiden Jet Fighters and Viper Phase will need to run an update the first time
#they are launched - let it finish then enter MAME's in game menu TAB to switch
#the jumper setting from update to off - then relaunch - If the game gives an error
#message delete the nvram file found in MAMEs nvram folder and update it again


mkdir "[Shoot 'em ups]"
cp .BIOS/*.zip "[Shoot 'em ups]"

#mv 1943.zip "[Shoot 'em ups]"
#mv agallet.zip "[Shoot 'em ups]"
#mv batrider.zip "[Shoot 'em ups]"
#mv batsugun.zip "[Shoot 'em ups]"
#mv dimahoo.zip "[Shoot 'em ups]"
#mv rdft2.zip "[Shoot 'em ups]"
#mv rfjet.zip "[Shoot 'em ups]"
mv 1942.zip "[Shoot 'em ups]"
# mv 1943u.zip "[Shoot 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
mv 19xx.zip "[Shoot 'em ups]"
# mv aerofgts.zip "[Shoot 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
# mv agalletu.zip  "[Shoot 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
# mv batrideru.zip "[Shoot 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
# mv batsugunsp.zip "[Shoot 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
mv bbakraid.zip "[Shoot 'em ups]"
# mv bgaregga.zip "[Shoot 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
mv bigbang.zip "[Shoot 'em ups]"
mv blswhstl.zip "[Shoot 'em ups]"
mv brvblade.zip "[Shoot 'em ups]"
mv cosmogng.zip "[Shoot 'em ups]"
mv cybattlr.zip "[Shoot 'em ups]"
mv cyvern.zip "[Shoot 'em ups]"
mv ddonpach.zip "[Shoot 'em ups]"
mv ddp2.zip "[Shoot 'em ups]"
# mv ddpdoj.zip "[Shoot 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
mv desertwr.zip "[Shoot 'em ups]"
# mv dimahoou.zip "[Shoot 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
mv dogyuun.zip "[Shoot 'em ups]"
mv dragnblz.zip "[Shoot 'em ups]"
mv dspirit.zip "[Shoot 'em ups]"
# mv espgal.zip "[Shoot 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
# mv espgal2.zip "[Shoot 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
mv esprade.zip "[Shoot 'em ups]"
mv feversos.zip "[Shoot 'em ups]"
mv fshark.zip "[Shoot 'em ups]"
mv fstarfrc.zip "[Shoot 'em ups]"
# mv futaribl.zip "[Shoot 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
# mv galaga.zip "[Shoot 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
mv galaga88.zip "[Shoot 'em ups]"
mv gametngk.zip "[Shoot 'em ups]"
mv gemini.zip "[Shoot 'em ups]"
mv gunbird.zip "[Shoot 'em ups]"
mv gunbird2.zip "[Shoot 'em ups]"
mv gunfront.zip "[Shoot 'em ups]"
mv gunlock.zip "[Shoot 'em ups]"
mv guwange.zip "[Shoot 'em ups]"
# mv gyruss.zip "[Shoot 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
# mv ibarablk.zip "[Shoot 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
# mv ket.zip "[Shoot 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
mv lethalth.zip "[Shoot 'em ups]"
mv lwings.zip "[Shoot 'em ups]"
mv macross.zip "[Shoot 'em ups]"
mv macrossp.zip "[Shoot 'em ups]"
mv mazinger.zip "[Shoot 'em ups]"
# mv mmpork.zip "[Shoot 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
# mv mooncrst.zip "[Shoot 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
# mv mushisam.zip "[Shoot 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
mv ncv1.zip "[Shoot 'em ups]"
mv nost.zip "[Shoot 'em ups]"
mv phelios.zip "[Shoot 'em ups]"
# mv pinkswts.zip "[Shoot 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
mv plusalph.zip "[Shoot 'em ups]"
mv raiden.zip "[Shoot 'em ups]"
mv raiden2.zip "[Shoot 'em ups]"
# mv rdft2u.zip "[Shoot 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
mv rfjetu.zip "[Shoot 'em ups]"
mv ryujin.zip "[Shoot 'em ups]"
mv s1945ii.zip "[Shoot 'em ups]"
mv s1945iii.zip "[Shoot 'em ups]"
mv samuraia.zip "[Shoot 'em ups]"
mv shienryu.zip "[Shoot 'em ups]"
mv spacedx.zip "[Shoot 'em ups]"
mv ssi.zip "[Shoot 'em ups]"
mv sstriker.zip "[Shoot 'em ups]"
mv stmblade.zip "[Shoot 'em ups]"
mv tcobra2.zip "[Shoot 'em ups]"
mv tenkomor.zip "[Shoot 'em ups]"
mv terracre.zip "[Shoot 'em ups]"
mv timeplt.zip "[Shoot 'em ups]"
mv truxton.zip "[Shoot 'em ups]"
mv twincobr.zip "[Shoot 'em ups]"
mv twineag2.zip "[Shoot 'em ups]"
mv twineagl.zip "[Shoot 'em ups]"
mv twinhawk.zip "[Shoot 'em ups]"
mv ultrax.zip "[Shoot 'em ups]"
mv vasara.zip "[Shoot 'em ups]"
mv vasara2.zip "[Shoot 'em ups]"
mv viprp1.zip "[Shoot 'em ups]"
# mv vspsx.zip "[Shoot 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
mv wndrplnt.zip "[Shoot 'em ups]"
mv xevious.zip "[Shoot 'em ups]"


#=========== Horizontal Shmups ==============================================================

#change the extension of this file to bat
#put it in your mame roms folder
#click on the bat file and it will mv all these roms to the "[Shoot 'em ups]" folder
#the originals will still be in your mame rom folder


#mv boogwing.zip "[Shoot 'em ups]"
#mv rohga.zip "[Shoot 'em ups]"
mv airbustr.zip "[Shoot 'em ups]"
mv alpham2.zip "[Shoot 'em ups]"
mv androdun.zip "[Shoot 'em ups]"
mv bchopper.zip "[Shoot 'em ups]"
mv blazeon.zip "[Shoot 'em ups]"
mv blazstar.zip "[Shoot 'em ups]"
mv blkheart.zip "[Shoot 'em ups]"
# mv boogwingu.zip "[Shoot 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
# mv bosco.zip "[Shoot 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
mv cawing.zip "[Shoot 'em ups]"
# mv choplift.zip "[Shoot 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
mv chukatai.zip "[Shoot 'em ups]"
mv cobracom.zip "[Shoot 'em ups]"
mv cotton.zip "[Shoot 'em ups]"
mv cotton2.zip "[Shoot 'em ups]"
mv cottonbm.zip "[Shoot 'em ups]"
mv darius.zip "[Shoot 'em ups]"
mv darius2.zip "[Shoot 'em ups]"
mv darius2d.zip "[Shoot 'em ups]"
mv dariusg.zip "[Shoot 'em ups]"
mv dbreed.zip "[Shoot 'em ups]"
# mv deathsml.zip "[Shoot 'em ups]" Unknown filename - todo, find mame 0.106 equivalent?
mv ecofghtr.zip "[Shoot 'em ups]"
mv edf.zip "[Shoot 'em ups]"
mv fantjour.zip "[Shoot 'em ups]"
mv gdarius.zip "[Shoot 'em ups]"
mv gdarius2.zip "[Shoot 'em ups]"
mv gforce2.zip "[Shoot 'em ups]"
mv gigawing.zip "[Shoot 'em ups]"
mv gradius.zip "[Shoot 'em ups]"
mv gradius3.zip "[Shoot 'em ups]"
mv gradius4.zip "[Shoot 'em ups]"
mv gratia.zip "[Shoot 'em ups]"
mv hellfire.zip "[Shoot 'em ups]"
mv hyprduel.zip "[Shoot 'em ups]"
mv inthunt.zip "[Shoot 'em ups]"
mv junofrst.zip "[Shoot 'em ups]"
mv lresort.zip "[Shoot 'em ups]"
mv macross2.zip "[Shoot 'em ups]"
mv metalb.zip "[Shoot 'em ups]"
mv mmatrix.zip "[Shoot 'em ups]"
mv mysticri.zip "[Shoot 'em ups]"
mv nemesis.zip "[Shoot 'em ups]"
mv ordyne.zip "[Shoot 'em ups]"
mv p47.zip "[Shoot 'em ups]"
mv p47aces.zip "[Shoot 'em ups]"
mv parodius.zip "[Shoot 'em ups]"
mv prehisle.zip "[Shoot 'em ups]"
mv progear.zip "[Shoot 'em ups]"
mv pulstar.zip "[Shoot 'em ups]"
mv raystorm.zip "[Shoot 'em ups]"
mv rohgau.zip "[Shoot 'em ups]"
mv rsgun.zip "[Shoot 'em ups]"
mv rtype.zip "[Shoot 'em ups]"
mv rtype2.zip "[Shoot 'em ups]"
mv rtypeleo.zip "[Shoot 'em ups]"
mv salamand.zip "[Shoot 'em ups]"
mv salmndr2.zip "[Shoot 'em ups]"
mv sexyparo.zip "[Shoot 'em ups]"
mv sidearms.zip "[Shoot 'em ups]"
mv sokyugrt.zip "[Shoot 'em ups]"
mv soldivid.zip "[Shoot 'em ups]"
mv sonicwi2.zip "[Shoot 'em ups]"
mv stdragon.zip "[Shoot 'em ups]"
mv strahl.zip "[Shoot 'em ups]"
mv stratof.zip "[Shoot 'em ups]"
mv tbyahhoo.zip "[Shoot 'em ups]"
mv tengai.zip "[Shoot 'em ups]"
mv terraf.zip "[Shoot 'em ups]"
mv thndrx2.zip "[Shoot 'em ups]"
mv thunderx.zip "[Shoot 'em ups]"
mv twinspri.zip "[Shoot 'em ups]"
mv unsquad.zip "[Shoot 'em ups]"
mv xevi3dg.zip "[Shoot 'em ups]"
mv xexex.zip "[Shoot 'em ups]"
mv xexexj.zip "[Shoot 'em ups]"
mv xmultipl.zip "[Shoot 'em ups]"
mv zerowing.zip "[Shoot 'em ups]"

#=========== Vs Fighting ==============================================================

#The following CHDs will also be needed

#jojo
#kinst
#kinst2
#mace
#sfiii3

#Tekken 2 and Star Gladiator are commented out because there are better sequels available
#If your computer is not fast enough to run the sequels you may want to include them

mkdir "[Vs Fighting]"
cp .BIOS/*.zip "[Vs Fighting]"

#mv starglad.zip "[Vs Fighting]"
#mv tekken2.zip "[Vs Fighting]"
mv aof3.zip "[Vs Fighting]"
# mv asurabus.zip "[Vs Fighting]" Unknown filename - todo, find mame 0.106 equivalent?
mv bldyror2.zip "[Vs Fighting]"
mv bloodwar.zip "[Vs Fighting]"
mv breakrev.zip "[Vs Fighting]"
mv cybots.zip "[Vs Fighting]"
mv daraku.zip "[Vs Fighting]"
mv doapp.zip "[Vs Fighting]"
mv ehrgeiz.zip "[Vs Fighting]"
mv fatfury3.zip "[Vs Fighting]"
mv fgtlayer.zip "[Vs Fighting]"
mv garou.zip "[Vs Fighting]"
mv gaxeduel.zip "[Vs Fighting]"
mv gundamex.zip "[Vs Fighting]"
mv jojo.zip "[Vs Fighting]"
mv kinst.zip "[Vs Fighting]"
mv kinst2.zip "[Vs Fighting]"
mv kizuna.zip "[Vs Fighting]"
mv kof2000.zip "[Vs Fighting]"
mv kof96.zip "[Vs Fighting]"
mv kof98.zip "[Vs Fighting]"
mv lastbld2.zip "[Vs Fighting]"
mv mace.zip "[Vs Fighting]"
mv macea.zip "[Vs Fighting]"
mv martmast.zip "[Vs Fighting]"
mv matrim.zip "[Vs Fighting]"
mv megaman2.zip "[Vs Fighting]"
mv metmqstr.zip "[Vs Fighting]"
mv mk2.zip "[Vs Fighting]"
mv msh.zip "[Vs Fighting]"
mv mshvsf.zip "[Vs Fighting]"
mv mtlchamp.zip "[Vs Fighting]"
mv mvsc.zip "[Vs Fighting]"
mv nwarr.zip "[Vs Fighting]"
mv outfxies.zip "[Vs Fighting]"
mv plsmaswd.zip "[Vs Fighting]"
mv primrage.zip "[Vs Fighting]"
mv rbff2.zip "[Vs Fighting]"
mv ringdest.zip "[Vs Fighting]"
mv rotd.zip "[Vs Fighting]"
mv rvschool.zip "[Vs Fighting]"
mv samsh5sp.zip "[Vs Fighting]"
mv samsho2.zip "[Vs Fighting]"
mv samsho3.zip "[Vs Fighting]"
mv sf2ce.zip "[Vs Fighting]"
mv sfa2.zip "[Vs Fighting]"
mv sfa3.zip "[Vs Fighting]"
mv sfex2p.zip "[Vs Fighting]"
mv sfexa.zip "[Vs Fighting]"
mv sfiii3.zip "[Vs Fighting]"
mv sgemf.zip "[Vs Fighting]"
mv soulclbr.zip "[Vs Fighting]"
mv ssf2t.zip "[Vs Fighting]"
mv svc.zip "[Vs Fighting]"
mv svcpcb.zip "[Vs Fighting]"
mv tekken3.zip "[Vs Fighting]"
mv tektagt.zip "[Vs Fighting]"
# mv tms32031.zip "[Vs Fighting]" Unknown filename - todo, find mame 0.106 equivalent?
mv ts2.zip "[Vs Fighting]"
mv umk3.zip "[Vs Fighting]"
mv vf.zip "[Vs Fighting]"
mv vsav.zip "[Vs Fighting]"
mv wakuwak7.zip "[Vs Fighting]"
mv whp.zip "[Vs Fighting]"
mv xmcota.zip "[Vs Fighting]"
mv xmvsf.zip "[Vs Fighting]"


#===========Everything else==============================================================

mkdir "[[Leftovers]]"
echo "#Hidden-folder" > [[Leftovers]]/.title 	#Write a hidden file to the lefotvers dir, which will make it appear invisible but still accessible in the menu
cp .BIOS/*.zip "[[Leftovers]]"
mv *.zip "[[Leftovers]]"
rm .title # Delete unwanted .title folder from root of roms dir
