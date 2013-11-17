Chef Crunch
===========

This repo is a collection of _extremely specific_ cookbooks designed to recreate my desktop environment and configurations on an _extremely specific_ platform.

These cookbooks are not designed for general installations of each application. Most will only be applicable for Debian stable (current Wheezy) or even Crunchbang Linux even more specifically.

feel free to file an issue if you come across this and want to know more about a configuration, cookbook, or package

(Possibly) Interesting Installations or Configurations
--------------------------------------------------------------------------

It's highly doubtful that these cookbooks are useful to any outside situations, as there is little user configuration, comments, or generalized steps (heavily relies on apt-get). But there may be some tidbits that you may find useful in a general sense

### Apt Languages
This run list performs `apt-get update`, _a lot_. And in general, that's a command I like to run a lot. And I notice there are many requests for `[repo-url] Translation-en_US` and most of them fail with 404's. To stop this, I add a file to `/etc/apt/apt.conf.d/[filename]` that just contains the line `Acquire::Languages "none";

### Sublime Text

This one I'm not so proud of, but it's an automated hack of Sublime Text 2 and 3. No, you don't really _need_ to hack this program since it's free and contains an extremely innocuous reminder to purchase. I highly recommend simply using the free version if you have not purchased a license.

I have purchased a license, and I'd like to keep my copies in a registered state. However I don't want to publish my license key to github, and can't rely on the gitignore-have-a-local-copy method. This repo is my method of completely reinstalling my machine when I bork it, and lose _all_ my files.

Instead, I rely on a small hack to alter the binary of sublime text to hinder the crypto call, and then feed it a bogus license. Said bogus license is included in this repo. It is already widely found on the internet, as is the hack. I won't go into detail about it, as I sincerely don't condone this if you don't possess a legitimately purchased license. But it is interesting once you understand it (open a hex editor and read what string you are changing)


### wireshark

to capture network interfaces on a debian system, wireshark generally requires root privileges. It certainly requires it as default. To enable user-level access, `/usr/share/doc/wireshark/README.debian` explains that `dpkg-reconfigure wireshark-common` must be run. When performing this manually, a graphical interface is presented a-la ncurses or tasksel. This presented a challenge to automate, except for the probably infrequently used `debconf-communicate`. Which even the docs suggest you don't use. You must find the name of the parameter/setting you wish to change (in this case it was `install-setuid` and you must determine what states it accepts (I toggled it using the GUI and used a _getter_ to see the stored value). The following command automated the reconfigure setting:

```bash
echo "set wireshark-common/install-setuid true" | debconf-communicate
dpkg-reconfigure -fnoninteractive wireshark-common
```
 