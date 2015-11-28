# == Class: nscd_lean
#
# A super-lean NSCD setup to boost DNS client performance. Enables only the
# hosts cache from NSCD and disables the rest.
#
# === Parameters
#
# [paranoia]
#   'low': Enables negative lookup caching. Due to the NSCD internal cache
#          sweep cycle of 15 seconds, the effect of a negatively cache hostname
#          may last from 1 to 15 seconds.
#   'medium': (default) Disables negative lookup caching.
#   'high': Disables negative lookup caching and enables NSCD's paranoia mode
#           where it restarts itself every hour.
#
# === Examples
#
#  class { 'nscd_lean':
#    paranoia => 'medium'
#  }
#
# === Authors
#
# new23d
#
class nscd_lean($paranoia = 'medium') {

  unless ($::osfamily == 'RedHat' and ($::operatingsystemmajrelease == 6 or $::operatingsystemmajrelease == 7)) {
    fail("${::osfamily} ${::operatingsystemmajrelease} not supported.")
  }

  if ($paranoia == 'low') {
    $cfg_paranoia = 'no'
    $cfg_nttl = 1
  }
  elsif ($paranoia == 'medium') {
    $cfg_paranoia = 'no'
    $cfg_nttl = 0
  }
  else {
    $cfg_paranoia = 'yes'
    $cfg_nttl = 0
  }

  file {'/etc/nscd.conf':
    content => template('nscd_lean/nscd.conf.erb')
  }

  package {'nscd':
    ensure => installed
  }

  service {'nscd':
    ensure => running,
    enable => true
  }

  File['/etc/nscd.conf'] ~> Service['nscd']
}

