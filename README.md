# Installation #

Clone me!  Alternatively, download the archive from:
  http://lab.label-switched.net/tylerc-auto-libs.zip
Unzip it and you're done!

# What Is This? #

Jeremy Schulman (@nwkautomaniac on the Twitters) created a fantastic library that is easily extensible to fit your needs...if you're a programmer or have the time to invest in learning it.  Me?  I want to make it easy.  Not just for myself--for you, too!

To that end, I am working on a number of 'facts' (see Jeremy's documentation on junos-ez-stdlib for more details!) and ways to exploit those facts.  I'm also writing custom libraries when fact exposition isn't adequate.  
The first one you'll see here is 'bgp'.  It's a library, not a fact.  There's sample code here: just make sure you have Ruby installed (Google it--it's easy!) and Jeremy's gem installed ('gem install junos-ez-stdlib') and you should be on your way!  Once you have his gem installed and this repo either cloned or downloaded and unzipped, the fun begins.

# Usage #

Learn to program in Ruby and utilize the libraries!  It's very straightforward--see the section __Example__ below.  The library pretty much documents itself, and the gaps that it has are filled in by the included example.  You don't need to understand Jeremy's junos-ez library, but it certainly wouldn't hurt and will help you understand how to write your own extensions.

# Example #

I've included an example called `bgp_health.rb`.  This can be run on its own and produce usable output that may prove valuable, but it mainly serves as a reference point for how to use the BGP library.

To use the example...

First, you need to edit the settings file.  Don't worry, though!  It's YAML, and even if you don't know what YAML is, it's ridiculously easy to edit.  Change four lines and you're ready to go!  It's self-explanatory, but you'll need to enter your username, password, a filename for output to be logged to, and a filename that will contain a list of routers.  I've included a file called 'rtrs.txt', so feel free to use that file and set the 'routers' filename to that in the settings file.

Once you've done that, you can run the sample script I've included (`bgp_health.rb`).  Doing this is pretty easy--if you're using Linux or OS X (or any other Unix-derivative), just open a terminal, navigate to the directory where the file is, and type:

  `ruby bgp_health.rb`

You can, of course, change the permissions so that you can just type `./bgp_health.rb`.  On Linux, OS X, or other Unix-derivates:

  `chmod 700 bgp_health.rb`

Once you've run the script, open up the logfile (you specified it in the settings file) and view the output.  You'll see most of the relevant information that most people care about at-a-glance.

# Sample Output #

    
    [tylerc@173 bgp-health]$ cat rtrs.txt
    172.16.1.1
    172.16.1.2
    [tylerc@173 bgp-health]$ ./bgp_health.rb
    [tylerc@173 bgp-health]$ cat out.log
    Router: 172.16.1.1
    ========================
    Peer          :  10.1.3.3
      AS          :  65555
      Description :  r3
      State       :  Established
      Up Time     :  8:49
      Table       :  inet.0
        Received  :  0
        Accepted  :  0
        Rejected  :  0
        Active    :  0
    
    
    Router: 172.16.1.2
    ========================
    Peer          :  10.1.3.3
      AS          :  65555
      Description :  foo
      State       :  Established
      Up Time     :  4:19:06
      Table       :  inet.0
        Received  :  0
        Accepted  :  0
        Rejected  :  0
        Active    :  0
    

# What Is This Not? #
So you'll probably notice that there's something that this isn't: a troubleshooting tool.  This is a 'general status tool.'  Don't get mad if it doesn't display some sort of info you wanted for troubleshooting--if you're troubleshooting, you should probably be logged into the device anyway.  Or learn to code and write your own method to do whatever you want to do.  ;)

# License #
This is licensed under the BSD 2-Clause License.  See the LICENSE file for full details.

# Author #
Tyler Christiansen
tylerc@label-switched.net

# Thanks #
Jeremy Schulman, who created the junos-ez-stdlib library/API and encouraged me in my endeavors.

# More to Come #
This is just an example of what can be done and how easy it is to extend Jeremy's framework.  There will be more to come and other ways of doing the same thing.
