###########################################
# Simple DEV lampstack
#
# - Base set up
# - Apahce, Mysql, PHP (with apc) & some 
#   basic utils
#
###########################################


###########################################
# Initialize environment
###########################################
class init {
  exec { 'apt-get updatec':
    command => '/usr/bin/apt-get update'
  }
}

###########################################
# PHP installation & base php extensions
###########################################
class php {

  # Installs PHP and restart Apache
  package { ['php5', 'php-apc','libapache2-mod-php5', 'php5-xdebug']:
    ensure  => installed,
    notify  => Service['apache2'],
  }

  # Installs PEAR add QA channel and XHPROF
  # install phpunit and xhprof
  package { ['php-pear']:
    ensure  => installed,
    notify  => Service['apache2'],
  }

}

###########################################
# Install common php tooling
# using phpqatools pear channel
###########################################
class php_tools {
  
  $pear_command="pear -d preferred_state=${preferred_state} install"

  # Set auto discover to true
  exec { 'add QA channel':
    command => 'pear config-set auto_discover 1'
  }

  # install!
  exec { 'add QA channel':
    command => 'pear install pear.phpqatools.org/phpqatools'
  }

}


###########################################
# Some basic utils I like having available 
###########################################
class util {
  
  package { "curl":
    ensure  => present,
  }

  package { "vim":
    ensure  => present,
  }
}

###########################################
# Basic apache installation & VHOST setup 
# using vhost file in vagrant-dev/conf
###########################################
class vhostsetup {

   apache::vhost { 'default':
      docroot             => '/vagrant/www',
      server_name         => 'lampdev',
      server_admin        => ' webmaster@locahost',
      docroot_create      => true,
      priority            => '',
      template            => 'apache/virtualhost/vhost.conf.erb',
  }
    
}

include init
include apache
include mysql
include php
include vhostsetup
include util
include php_tools