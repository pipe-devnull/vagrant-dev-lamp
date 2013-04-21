###########################################
# Simple DEV lampstack
#
# - Base set up
# - Apahce, Mysql, PHP (with apc) & some 
#   basic utils
#
###########################################

###########################################
# PHP installation & base php extensions
###########################################
class php {

  exec { 'apt-get updatec':
    command => '/usr/bin/apt-get update'
  }


  # Installs PHP and restart Apache
  package { ['php5', 'php-apc','libapache2-mod-php5']:
    ensure  => installed,
    notify  => Service['apache2'],
    require => [Package['mysql-client'], Package['apache2']],
  }
}

###########################################
# Some basic utils I like having available 
###########################################
class Util {
  
  package { "curl":
    ensure  => present,
  }

  package { "vim":
    ensure  => present,
  }
}

###########################################
# Basic apache installation & VHOST setup 
  using vhost file in vagrant-dev/conf
###########################################
class vhost {

  # Ensures Apache2 is installed
  package { 'apache2':
    name => 'apache2',
    ensure => installed,
  }
 
  # Ensures the Apache service is running
  service { 'apache2':
    ensure  => running,
    require => Package['apache2'],
  }

  # Setup the virtual host
  file { '/etc/apache2/sites-enabled/site.conf':
    source  => '/vagrant/conf/vhost',
    notify  => Service['apache2'],
    require => Package['apache2'],
  }

include apache
include mysql
include php
include vhost
include util