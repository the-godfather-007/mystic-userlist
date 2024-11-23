A Mystic BBS Mod that allows for scrolling, ranking, and emailing members within the user list. Tested on A49 Pre-Alpha and other version of Mystic BBS in both Linux and Windows. Not tested for user bases above 400.

The purpose of this mod is to give SysOps more graniular visibility to the way users are interacting on their BBSes, utilizing the Mystic BBSes traditional User list in a light bar, scrollable fashion, that when arrow keys left or right are pressed change the data and ranks by the highlighted column. The top rows being the highest ranking users in that given category. This gives SysOps the opportunity to see if more people are uploading, downloading, calling often, etc.. for 80x25 themed BBSes.

The current state of this mod allows for any user or SysOp to also press [ENTER] to email the highlighted user.|
For appearance the mod displays Amiga fonts within an ANSI header, footer, and ansi wrapped box.  No changes to the code are necessary, just be aware of two things with ANSI files under note at the end of this readme file.

Not built out, contributors welcome Future version will add scalable wide screen support where when the user calls in 132x80 themed BBSes more data such as game play usage, and other flags can be set to custom tailor more data giving users and SysOps to BBS usage. The "box" and data will need to be flexible and add or subtract based on the users terminal mod up to 160c width and as low as 80c width. This mod will not support less than 80c.

Contributions are also always welcome for a groovy header file that is not "The Underground" Specific, but for now its what I have. This mod is in beta test phase, and not supported at this time if troubles arise. As always, use at your own risk.

Instructions are pretty simple:
place the .mpl into your /mystic/themes/default/scripts directory
place the .ans into your /mystic/themes/default/text directory
from your mystic root ~/mystic or C:\mystic or wherever you keep your binaries compile the mod:
./mplc /mystic/themes/default/scripts/rcsuserlist1b.mps 

From within your desired menu (maybe test in your sysop menu / playground until you have a custom ansi or maybe when this is complete) add a menu command,
assign it a hot key, and create:
Menu command: GX MPL program
Data: rcsuserlist1b

Modding the ANSI file:
It's been a while since I've worked on this mod.  I don't recall if I made it scalable to the size of the header, however with 80x25 I don't see the point in making a larger header when the purpose is to view the data not a pretty header. Couple of tips:

1.  Keep your header file to the same size as the included ANSI file.
2.  Using Mobieus is the easiest way:  Select 'Edit,' and change the canvas size to the total row size of the header.  Example:  If the header is 8 rows, set the canvas to 80x8.  No spacing below your ansi creation is necessary.
3.  "Save as without sauce" using Moebius!! back to your /mystic/themes/default/textr/ directory.  

The above are tips I've learned that, for the most part, keep me from having to remove lines and unecessary sauce from within a text editor.  Moebius is a fantastic ANSI art program you can find here:

https://blocktronics.github.io/moebius/
Test it out and start to contribute!
