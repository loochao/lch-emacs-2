LooChao's Emacs Configuration
=============================
Quite a few codes are adopted from internet, whose copyrights belongs
to the origin authors. 



# To install
----------
- $git clone git@github.com:loochao/loochao-emacs-configuration.git
this command will download loochao-emacs-configuration which contains
all the files needed. 

- Rename this dir into ~/Dropbox/.emacs.d
- Softlink dotEmacs from .emacs.d/rc/ to ~/.emacs
- Done, enjoy.

# Directory structure
etc -- configuration file used by system like .bashrc
# Problems
- w3m buffer need to be renamed, but if rename, will cause desktop do not work at emacs startup.
- emms-dump, using emms-start will not highlight current playing songs.
# Versions of Emacs required
Emacs 24.3 will work, test on MacOSX 10.8, WindowsXP, Debian.
Powerline will not work with 24.2
