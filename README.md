# All Killer, No Filler PinHP rom sorter

This script will organise your games into genre folders, choosing only the best quality games for each genre (original list based on work by members of the arcadecontrols.com forum here: http://forum.arcadecontrols.com/index.php/topic,149708.0.html).

Put the [aknf-rom-sorter.sh](https://raw.githubusercontent.com/AndyHazz/All-Killer-PinHP-rom-sorter/main/aknf-rom-sorter.sh) script in the root of your PinHP 'rpi2jamma' folder, along with a full **Non-Merged** Mame 0.106 romset in your 'roms_advmame' folder.

Run the script from PinHP's menu (Options > System Settings Menu > System Settings > Run External File).

## Online updates

Each time you run it (with an active internet connection), the script will update itself, and can also get the latest recommended game list.

## Genres

Best games from each genre will be moved into their own subfolders:

- Beat 'em ups
- Classics
- Platformers
- Puzzle
- Run and gun
- Shoot 'em ups
- Sports
- Vs Fighting

Everything else will be put in a hidden '[Leftovers]' folder, which you can still access by selectring the extra blank line below the visible folders.

## Use the correct rom set

The included rom lists are specifically for AdvanceMame (0.106). Other rom sets may have different zip filenames and the results won't be as good for you.
Partial romsets will work, but you might not get as many games moved into the genre folders.
The script will output (harmless) error messages for any rom zips it can't find.
If you have a split rom set then your rom files might not contain all the required files - some roms (clones) may not run when they're moved to a folder without their parent. Non-merged rom sets will not have this issue as all of the rom files for each machine are present in each zip.
