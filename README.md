# All Killer, No Filler PinHP rom sorter

Put this script in your PinHP advmame_roms folder, along with a full Non-Merged Mame 0.106 romset (i.e. AdvanceMAME 2006 Reference set from archive.org)

Run './rom-sorter.sh' and it will organise them into folders, choosing only the best quality games based on work by members of the arcadecontrols.com forum here: 
http://forum.arcadecontrols.com/index.php/topic,149708.0.html

Best games from each genre will be moved into their own subfolders:

- Classics
- Platformers
- Beat 'em ups
- Run and gun
- Puzzle
- Sports
- Shoot 'em ups
- Vs Fighting

Everything else will be put in a hidden '[Leftovers]' folder

Partial romsets will work, but you might not get as many games moved into the genre folders.
The script will output (harmless) error messages for any rom zips it can't find.
