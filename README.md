# All Killer, No Filler PinHP rom sorter

Put this script in your PinHP advmame_roms folder, along with a full **Non-Merged** Mame 0.106 romset

Run './rom-sorter.sh' and it will organise them into folders, choosing only the best quality games - original list based on work by members of the arcadecontrols.com forum here: 
http://forum.arcadecontrols.com/index.php/topic,149708.0.html

## Online updates
If you choose 'y' to using online source for latest selections (and you have a working network connection), the script will load the rom lists directly from this google sheet: https://docs.google.com/spreadsheets/d/1wRonk0JNBbDrkwBDsLfxjvKqC9_81c4ni1Q_vza8uyA/edit?usp=sharing - over time I'll update this sheet to add new roms that people like, and remove roms that don't work well on PinHP - add comments to the google sheet or raise an issue on here if there are changes you think would be good.

Alternatively, if you'd like to manage your own list - copy my google sheet and change the 'TSVINPUT' variable in the script. You can publish to web the 'Shell commands' sheet in .tsv format and use the URL google provides for you.

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

Everything else will be put in a hidden '[Leftovers]' folder

## Use the correct rom set
The included rom lists are specifically for AdvanceMame (0.106). Other rom sets may have different zip filenames and the results won't be as good for you.
Partial romsets will work, but you might not get as many games moved into the genre folders.
The script will output (harmless) error messages for any rom zips it can't find.
If you have a split rom set then your rom files might not contain all the required files - some roms (clones) may not run when they're moved to a folder without their parent. Non-merged rom sets will not have this issue as all of the rom files for each machine are present in each zip.
