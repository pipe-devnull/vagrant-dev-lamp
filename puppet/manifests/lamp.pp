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
  package { ['php5', 'php-apc','libapache2-mod-php5']:
    ensure  => installed,
    notify  => Service['apache2'],
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