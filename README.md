# All Killer, No Filler PinHP rom sorter

> **PLEASE NOTE:** This script is no longer necessary as it's now built into the [PinHP image](https://pinhp.github.io/docs/user_manual.html#filtergames), including the 'all killer no filler' rom list, and many more filtering and sorting options. A lot of work went into making the filtering and grouping built into PinHP really powerful and easy to use (within the confines of the Mame launcher behind it all). It's also much faster than my script, because it doesn't have to move roms into folders and can generate the menus on the fly.

> **To replicate this script's behaviour natively in the latest PinHP image, use the 'Filter Games' menu and enable the 'Recommended filter'. Then use the 'Group Games' menu and choose to group by Genre.**

> If, for some reason, you still want to use this script to sort roms into folders then it should still work ok. I'll leave the rest of the original readme and script here on github in case anyone might still find it useful.

This script will organise your games into genre folders, choosing only the best quality games for each genre. Original list based on work by members of the arcadecontrols.com forum here: http://forum.arcadecontrols.com/index.php/topic,149708.0.html. Expanded with some 'best games' from here: http://adb.arcadeitalia.net/?search=mame&emulator_to=318&bestgame=29151&control_type=17%3B2%3B5 and here: https://www.reddit.com/r/MAME/comments/2rawpr/i_compiled_several_best_ofrecommended_arcade/, plus some personal preference ;) I'm gradually removing or marking as slow any games that don't work on Raspberry Pi/PinHP. The script has an option to exclude slow running games.

Put the [aknf-rom-sorter.sh](https://raw.githubusercontent.com/AndyHazz/All-Killer-PinHP-rom-sorter/main/aknf-rom-sorter.sh) script in the root of your PinHP 'rpi2jamma' folder, along with a full **Non-Merged** Mame 0.106 romset in your 'roms_advmame' folder.

Run the script from PinHP's menu (Options > System Settings Menu > System Settings > Run External File).

There's a demo video available here: https://www.youtube.com/watch?v=HIDN9-cbCzs

## Online updates

Each time you run it (with an active internet connection), the script will update itself, and can also get the latest recommended game list.

## Genres

Best games from each genre will be moved into their own subfolders:

- Ball & Paddle
- Driving
- Fighter
- Maze
- Platform
- Puzzle
- Shooter
- Sports
- Vs Fighter

Everything else will be put in a hidden '[Leftovers]' folder, which you can still access by selectring the extra blank line below the visible folders.

There is also an option to separate out 151 NeoGeo games (all the parent roms for NeoGeo, whether they're any good or not) and show them all in a '[NeoGeo]' folder.

## Use the correct rom set

The included rom lists are specifically for AdvanceMame (0.106). Other rom sets may have different zip filenames and the results won't be as good for you.
Partial romsets will work, but you might not get as many games moved into the genre folders.
The script will output (harmless) error messages for any rom zips it can't find.
If you have a split rom set then your rom files might not contain all the required files - some roms (clones) may not run when they're moved to a folder without their parent. Non-merged rom sets will not have this issue as all of the rom files for each machine are present in each zip.
