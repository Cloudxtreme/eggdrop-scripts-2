##
#
# alice.tcl v1.4.0 - by strikelight ([sL] @ EFNet) (March 2, 2004)
#
# - Read the README.TXT for script details, help, and contact info.
#
##

#### CONFIGURATION ####

## File to save alice cookies to ##
set alice_cookiesfile "$nick.cookies"

## Every night, expire cookies that have not been accessed in how many days? ##
set alice_cookiesexpire 5

## Let your bot respond to private messages? (0 = No, 1 = Yes) ##
set alice_respondpriv 1

## Let your bot respond to comments in channel when bot's name is mentioned? ##
# (0 = No, 1 = Yes) [ For eggdrop versions less than 1.5.x
# ( 1.5.x+ users should use .chanset #channel +alice ) ]
set alice_respondchan 0

## Require bot's nick to be in all lines of a public conversation in order
# for it to respond, after initial contact? (ie. <someone> alice: hello there)
# (if alice_respondchan is set to 1, or channel is set to +alice, else ignore this)
# (0 = No, 1 = Yes)
set alice_respondrequirenick 1

## Respond with user's nick? (ie. <alice> user: Hi, how are you?)
# (if alice_respondchan is set to 1, or channel is set to +alice, else ignore this)
# (0 = No, 1 = Yes)
set alice_respondwithnick 1

## Channels to listen on (if alice_respondchan is set to 1, else ignore this) ##
# (Separate multiple channels by space, use * to indicate all channels)
# [ For eggdrop versions less than 1.5.x only , 1.5.x+ users should
#   use .chanset #channel +alice ]
# eg. set alice_channels "#channel1 #channel2 #etc"  .. or :
set alice_channels "*"

## Also if alice_respondchan is set to 1 or channel is set to +alice,
# (otherwise ignore this), how long a silence should the bot wait for
# user's text in a channel after the first contact is made before
# giving up on their conversation? (in minutes)
set alice_timeoutchat 5

## Log conversations?
# 0 = No
# 1 = Yes
set alice_logging 0

## If logging on, what directory should the logs be stored in?
# (Note1: If directory doesn't exist, you must create it)
# (Note2: Ignore this if you don't want to log)
set alice_log_path "logs/"

## Ignore private messages that start with the following words
set alice_ignoreprivate {
  op
  invite
  pass
  addhost
  ident
}

## Ignore public messages that start with the following words
set alice_ignorepublic {
  !list
  @find
}

## Relay responses the bot sends to a user via msg to the partyline?
# 0 = No
# 1 = Yes
set alice_relaypriv 1

## Which server should I use for the alice engine?
# 0 = www.alicebot.org (Alice)
# 1 = www.agentruby.com (Ruby)
# 2 = www.tfxsoft.com (A Program-E Server)
# 3 = jaczone.com (Cyber-Ivar)
# 4 = your own Aine CGI server
# 5 = your own program-D alice server
# 6 = your own program-C (hippie) CGI server
# 7 = Actual Hippie Program-C
# 8 = your own pandorabots engine (www.pandorabots.com)
# 9 = A runabot.com AOL Instant Messenger bot (www.runabot.com)
set alice_engine 2

# If using your own alice server (Aine CGI, program-D, program-C CGI, pandorabots, runabot) enter the url here:
# or if you notice one of the pre-programmed engines url's have changed, you may enter it here and see
# if it might help.
#set alice_url "http://yourserver.here.com/hippie.cgi" ;# hippie.cgi example
#set alice_url "http://yourserver.com/aine/aine.cgi" ;# aine.cgi example
#set alice_url "http://yourserver.here.com:2001/" ;# program-D example
#set alice_url "http://www.pandorabots.com/pandora/talk?botid=<your bot id here>" ;# pandorabots example
#set alice_url "http://www.runabot.com/perl/webcaim/107826533724334?botname=Alice" ;# runabot example

# If using your own actual Hippie Program-C, set path here:
#set alice_hippie_path "/home/user/eggdrop/C/command_alice"

# If using your own actual Hippie Program-C, set path to ini file here:
#set alice_hippie_inipath "/home/user/eggdrop/C/data/alice.ini"

# If using your own actual Hippie Program-C, set path to log info here:
#set alice_hippie_logpath "/home/user/eggdrop/C/log/"

#### END OF CONFIGURATION (STOP EDITTING HERE!!) ####
 