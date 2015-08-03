## Description ##

This is a madman's take on the advanced MPD widget\client for AwesomeWM.

All changes are currently highly experimental, and once satisfied I am unlikly to continue development. So, Unless you are interested in one of the experimental features, I suggest you use the base project [located here](https://github.com/alexander-yakushev/awesompd).

Keep in mind that some of the 'new' features implimented here, such as the OSD(onscreen display) were taken from the base project's "yet unreleased" version located in owner's awesomerc repository.

Here is a small gif showing the current version in a relitivly unchanged enviorment.
![Imgur](https://i.imgur.com/0IiOsK7.gif)


### Some Changes ###
Imported:
- [x] Onscreen display/widgit

Other:
- [x] Make text scroll based on width, not character count.
- [x] Make text scroll smoothly, as if the text widget were moving behind a mask. (partial, uses pango ellipsize) I believe this is likely to be added to the original as well, once awesomewm releases a version with scroll support.
- [ ] Make text fade in/out.
- [ ] Make a text bouncer (moving left and right, stagging/WIP, trying to fix bug with short strings first)
- [x] Make event based, allowing user to add functions to events like OnTrackChange, OnUpdateTrack, OnPlay, OnMouseEnterOSD. (WIP)
- [x] 

TODO:
- [x] Make text scroll based on width, not character count.
- [x] Make text scroll smoothly, as if the text widget were moving behind a mask. (partial, uses pango ellipsize)
- [ ] Make text fade in/out.
- [WIP] title and album scoll_boxes should be in sync (percentage scrolled
  wise)
- [ ] scroll_boxes should be capable of slowing/pausing on beginning/end
- [ ] scroll_boxes should be capable of slowing/pausing incrementilly
- [WIP] scroll_boxes should be capable of "bouncing" left and right.
- [ ] Find a way to shorten text the same way pango does with ellipsize
  to fit the widgit, without having an ellips.
