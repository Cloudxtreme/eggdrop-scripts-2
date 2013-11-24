# --------------------------------------------------------------------------- #
# $Author: pdq $
# $Revision: 3 $
# $Id: linuxTCL.tcl 1 2012-12-10 09:14 pdq $
# --------------------------------------------------------------------------- #

# --------------------------------------------------------------------------- #
# Requirements :
#    - http package
#    - Tcl 8.5
#    - Eggdrop 1.6.19
# --------------------------------------------------------------------------- #

# --------------------------------------------------------------------------- #
# Description :
#
# This script enables the searching of various linux websites, wikis and repos.
#
# Activate the script in the party line with:
# .chanset #chan +linuxTCL
#
# Usage:
#
# Search for linux package:
#  !package <distro> <package>
#
# Example:
#  Retrieve the package info for archlinux vlc:
#  !package arch vlc
#  > bot | https://www.archlinux.org/packages/?q=vlc
#
# --------------------------------------------------------------------------- #
#
# Search for wiki:
#  !wiki <search term>
#  !arch <Search term>
#  !gentoo <Search term> 
#  !ubuntu <Search term> 
#  !wiki <Search term> 
#  !awesome <Search term> 
#  !yubnub <command> <Search term> 
#  
# Example:
#  Retrieve the archlinux wiki info for vlc:
#  !arch vlc
#  > bot | https://wiki.archlinux.org/index.php/vlc 
#
# --------------------------------------------------------------------------- #

# --------------------------------------------------------------------------- #
# Author : pdq
# Contact: http://www.linuxdistrocommunity.com/forums
# --------------------------------------------------------------------------- #

# --------------------------------------------------------------------------- #
# Licence :
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
# --------------------------------------------------------------------------- #

# requirements
if {[catch {package require http}]} {
    putlog "linuxTCL : You need the http package to run this script."
    return
}

if {[catch {package require Tcl 8.5}]} {
    putlog "linuxTCL : You need at least Tcl 8.5 to run this script."
    return
}
 
namespace eval linuxTCL {
    # ------------------ Configuration  ------------------ #
    # Commands
    variable linuxTCL_command_name {wiki arch gentoo ubuntu awesome package yubnub linuxhelp linux man}
    variable linuxTCL_command_flags "-|-"
    variable linuxTCL_command_char "!"
    variable script_name "linuxTCL"
    # NOTICE: use notice to display message
    # PRIVMSGNICK: use it to query the user
    # PRIVMSG: use it to speak to the channel
    variable helptype "QUERY"
    variable querytype "PRIVMSG"
    variable versiontype "PRIVMSG"
    # -------------- Configuration ends here -------------- #
    variable version "0.0.2"
    setudef flag linuxTCL
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#       W A R N I N G        DON'T Change anything below here        W A R N I N G       #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

proc ::linuxTCL::helpmenu {nick uhost hand chan arg} {
	message_method $::linuxTCL::helptype $nick $chan "<*> Welcome to $chan's Linux search help menu $nick!"
	message_method $::linuxTCL::helptype $nick $chan "<*> I'm $::botnick, your resident robot"
	message_method $::linuxTCL::helptype $nick $chan "<*> Use one of the following public commands:"
	message_method $::linuxTCL::helptype $nick $chan "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	message_method $::linuxTCL::helptype $nick $chan "!arch <Search term> -=- Search Archlinux Wiki"
	message_method $::linuxTCL::helptype $nick $chan "!gentoo <Search term> -=- Search gentoo Wiki"
	message_method $::linuxTCL::helptype $nick $chan "!ubuntu <Search term> -=- Search Ubuntu Wiki"
	message_method $::linuxTCL::helptype $nick $chan "!wiki <Search term> -=- Search Wikipedia"
	message_method $::linuxTCL::helptype $nick $chan "!awesome <Search term> -=- Search AwesomeWM Wiki"
	message_method $::linuxTCL::helptype $nick $chan "!yubnub <command> <Search term> -=- Web CLI"
    # http://yubnub.org/kernel/ls?args= Type in a command, or 'ls dictionary' to search all commands for 'dictionary', etc."
	message_method $::linuxTCL::helptype $nick $chan "!man <Search term> -=- Search Man pages"
	message_method $::linuxTCL::helptype $nick $chan "!package <repo> <package> -=- Search packages"
	message_method $::linuxTCL::helptype $nick $chan "Supported repos: arch, gentoo, ubuntu, debian, fedora, aur"
	return 1
}

proc ::linuxTCL::linuxhelp {nick uhost hand chan arg} {
	if {![channel get $chan linuxTCL]} { return }
	helpmenu
}

proc ::linuxTCL::linux {nick uhost hand chan arg} {
	if {![channel get $chan linuxTCL]} { return }
	if {$arg != "help"} {
		message_method $::linuxTCL::querytype $nick $chan "try !linux help"
		return 0
	} else {
		helpmenu
	}
}

proc ::linuxTCL::package {nick uhost hand chan arg} {
	if {![channel get $chan linuxTCL]} { return }
    set arg [split $arg]
	if {[llength $arg] < 2} {
	    message_method $::linuxTCL::querytype $nick $chan "!package <distro> <package>"
	    return 0
	  } else {
	  	set searchterm [join [lrange $arg 1 end]]
	  	set distro [lindex $arg 0]
		set clean [string map { " " "%20" } $searchterm]
		if {$distro == "arch"} {
			set url "http://www.archlinux.org/packages/?q=$clean"
		} elseif {$distro == "gentoo"} {
			set url "http://www.gentoo-portage.com/Search?search=$clean"
		} elseif {$distro == "ubuntu"} {
			set url "http://packages.ubuntu.com/search?keywords=$clean"
		} elseif {$distro == "debian"} {
			set url "http://packages.debian.org/search?keywords=$clean"
		} elseif {$distro == "fedora"} {
			set url "https://admin.fedoraproject.org/pkgdb/acls/list/?searchwords=$clean"
		} elseif {$distro == "aur"} {
			set url "http://aur.archlinux.org/packages.php?K=$clean"
		}
		set page [webdata $url]
		if {$page == "timeout"} { 
			message_method $::linuxTCL::querytype $nick $chan "URL has timed out. Please try again later."
		} elseif {$page == ""} {
			message_method $::linuxTCL::querytype $nick $chan "URL services are currently down."
		} else {
			message_method $::linuxTCL::querytype $nick $chan $url
			return 1
		}		
	}
}

proc ::linuxTCL::man {nick uhost hand chan arg} {
	if {![channel get $chan linuxTCL]} { return }
	if {$arg == ""} {
	    message_method $::linuxTCL::querytype $nick $chan "!man <searchterm>"
	    return 0
	} else {
		set clean [string map { " " "_" } $arg]
		set url "http://man.he.net/?section=all&topic=$clean"
		set page [webdata $url]
		if {$page == "timeout"} { 
			message_method $::linuxTCL::querytype $nick $chan "URL has timed out. Please try again later."
	    } else {
			message_method $::linuxTCL::querytype $nick $chan $url
			return 1
		}		
	}
}

proc ::linuxTCL::arch {nick uhost hand chan arg} {
	if {![channel get $chan linuxTCL]} { return }
	if {$arg == ""} {
	    message_method $::linuxTCL::querytype $nick $chan "!arch <wiki>"
	    return 0
	} else {
		set clean [string map { " " "_" } $arg]
		set url "https://wiki.archlinux.org/index.php?search=$clean"
		set page [webdata $url]
		if {$page == "timeout"} { 
			message_method $::linuxTCL::querytype $nick $chan "URL has timed out. Please try again later."
	    } else {
			message_method $::linuxTCL::querytype $nick $chan $url
			return 1
		}		
	}
}

proc ::linuxTCL::gentoo {nick uhost hand chan arg} {
	if {![channel get $chan linuxTCL]} { return }
	if {$arg == ""} {
	    message_method $::linuxTCL::querytype $nick $chan "!gentoo <wiki>"
	    return 0
	} else {
		set clean [string map { " " "_" } $arg]
		set url "http://en.gentoo-wiki.com/w/index.php?search=$clean"
		set page [webdata $url]
		if {$page == "timeout"} { 
			message_method $::linuxTCL::querytype $nick $chan "URL has timed out. Please try again later."
		} else {
			message_method $::linuxTCL::querytype $nick $chan $url
			return 1
		}		
	}
}

proc ::linuxTCL::ubuntu {nick uhost hand chan arg} {
	if {![channel get $chan linuxTCL]} { return }
	if {$arg == ""} {
	    message_method $::linuxTCL::querytype $nick $chan "!ubuntu <wiki>"
	    return 0
	} else {
		set clean [string map { " " "_" } $arg]
		set url "https://wiki.ubuntu.com/$clean"
		set page [webdata $url]
		if {$page == "timeout"} { 
			message_method $::linuxTCL::querytype $nick $chan "URL has timed out. Please try again later."
		} elseif {$page == ""} {
			message_method $::linuxTCL::querytype $nick $chan "URL services are currently down."
		} else {
			message_method $::linuxTCL::querytype $nick $chan $url
			return 1
		}		
	}
}

proc ::linuxTCL::wiki {nick uhost hand chan arg} {
	if {![channel get $chan linuxTCL]} { return }
	if {$arg == ""} {
	    message_method $::linuxTCL::querytype $nick $chan "!wiki <wiki>"
	    return 0
	} else {
		set clean [string map { " " "_" } $arg]
		set url "https://en.wikipedia.org/wiki/Special:Search/$clean"
		set page [webdata $url]
		if {$page == "timeout"} { 
			message_method $::linuxTCL::querytype $nick $chan "URL has timed out. Please try again later."
		} else {
			message_method $::linuxTCL::querytype $nick $chan "$url $page"
			return 1
		}		
	}
}

proc ::linuxTCL::awesome {nick uhost hand chan arg} {
	if {![channel get $chan linuxTCL]} { return }
	if {$arg == ""} {
	    message_method $::linuxTCL::querytype $nick $chan "!awesome <wiki>"
	    return 0
	} else {
		set clean [string map { " " "_" } $arg]
		set url "http://awesome.naquadah.org/w/index.php?search=$clean&go=Go"
		set page [webdata $url]
		if {$page == "timeout"} { 
			message_method $::linuxTCL::querytype $nick $chan "URL has timed out. Please try again later."
		} else {
			message_method $::linuxTCL::querytype $nick $chan $url
			return 1
		}		
	}
}

proc ::linuxTCL::yubnub {nick uhost hand chan arg} {
	if {![channel get $chan linuxTCL]} { return }
    set arg [split $arg]
	if {[llength $arg] < 2} {
	    message_method $::linuxTCL::querytype $nick $chan "!yubnub <command> <searchterm>"
	    return 0
	  } else {
	  	set searchterm [join [lrange $arg 1 end]]
	  	set cmd [lindex $arg 0]
		set clean [string map { " " "%20" } $searchterm]
		set url "http://yubnub.org/parser/parse?command=$cmd%20$clean"
		set page [webdata $url]
		if {$page == "timeout"} { 
			message_method $::linuxTCL::querytype $nick $chan "URL has timed out. Please try again later."
		} elseif {$page == ""} {
			message_method $::linuxTCL::querytype $nick $chan "URL services are currently down."
		} else {
			message_method $::linuxTCL::querytype $nick $chan $url
			return 1
		}		
	}
}

# choose the reply method
proc ::linuxTCL::message_method {type nick chan message} {
    if { [string compare $type "NOTICE"] == 0 } {
        puthelp "$type $nick :$message"
    } elseif { [string compare $type "QUERY"] == 0 } {
        puthelp "PRIVMSG $nick :$message"
    } else {
	    puthelp "$type $chan :$message"
    }
}

proc ::linuxTCL::webdata {website} {
	if { [catch { set token [http::geturl $website -timeout 500000]} error] } {  return 0
	} elseif { [http::ncode $token] == "404" } { return 0
	} elseif { [http::status $token] == "ok" } { set data [http::data $token]
	} elseif { [http::status $token] == "timeout" } {  return "timeout"
	} elseif { [http::status $token] == "error" } {  return 0 }
	http::cleanup $token
	if { [info exists data] } { return $data
	} else { return geturl }
}

# make commands available
namespace eval ::linuxTCL {
    foreach ::linuxTCL::name $::linuxTCL::linuxTCL_command_name {
        bind pub $::linuxTCL::linuxTCL_command_flags $::linuxTCL::linuxTCL_command_char$::linuxTCL::name ::linuxTCL::$::linuxTCL::name
    }
    putlog "Loaded $::linuxTCL::script_name.tcl version $::linuxTCL::version by pdq"
}