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
  package { ['php5', 'php-apc','libapache2-mod-php5', 'php5-xdebug', 'php5-mysql']:
    ensure  => installed,
    notify  => Service['apache2'],
  }

  # Install phpunit and xhprof
  package { ['php-pear']:
    ensure  => installed,
    notify  => Service['apache2'],
  }

  file { '/etc/php5/conf.d/xdebug.ini':
    source => '/vagrant/conf/xdebug.ini',
    notify  => Service['apache2'],
  }
  
}

###########################################
# Install common php tooling
# - using phpqatools pear channel
# - xhprof via pecl with graphviz for callgraphs
##################################### ######
class php_tools {

  # Set auto discover to true
  exec { 'set_auto_discovery':
    command => '/usr/bin/pear config-set auto_discover 1',
  }

  # install!
  exec { 'install_phpqatools':
    command => '/usr/bin/pear install pear.phpqatools.org/phpqatools',
    require => Exec['set_auto_discovery'],
  }

  # Install xhprof
  exec { 'install_xhprof':
    command => '/usr/bin/pecl install -f xhprof',
  }

  # Installs PHP and restart Apache
  package { ['graphviz']:
    ensure  => installed,
    notify  => Service['apache2'],
  }

  # Setup xhprof vhost & dir - this may be a bit debian specific, suggestions welcome

  # Install xhprof
  exec { 'xhprof_s1': command => '/bin/mkdir -p /var/xhprof'}


  # Symlink the xhprof HTML directory
  file { "/var/xhprof/xhprof_html":
    target =>  "/usr/share/php/xhprof_html",
    ensure => link,
    owner  => 'vagrant',
    group  => 'vagrant',
    require => Exec['xhprof_s1'],
  }

  # Symlink the xhprof lib directory
  file { "/var/xhprof/xhprof_lib":
    target =>  "/usr/share/php/xhprof_lib",
    ensure => link,
    owner  => 'vagrant',
    group  => 'vagrant',
    require => Exec['xhprof_s1'],
  }

  # Copy profiler header & footer files into place 

  # Copy header
  file { "/var/xhprof/header.php":
    source => [
      "/vagrant/conf/xhprof/header.php",
    ],
    require => Exec['xhprof_s1'],
  }

  # Copy footer
  file { "/var/xhprof/footer.php":
    source => [
      "/vagrant/conf/xhprof/footer.php",
    ],
    require => Exec['xhprof_s1'],
  }

  # Create xhprof output tmp directory
  file { "/tmp/xhprof":
    ensure => "directory",
    owner  => "www-data",
    group  => "www-data",
    mode   => 755,
  }
  
  # Setup the xhprof vhost, use standard template
  apache::vhost { 'xhprof':
      docroot             => '/var/xhprof',
      port                => '8000',
      server_name         => 'lampdev',
      server_admin        => 'webmaster@locahost',
      docroot_create      => true,
      priority            => '',
      template            => '/vagrant/conf/xhprof-vhost-template',
  }

  # Add xhprof ini and restart apache
  file { "/etc/php5/conf.d/xhprof.ini":
    source => [
      "/vagrant/conf/xhprof.ini",
    ],
    notify  => Service['apache2'],
  }

}


###########################################
# Any basic utils I like having available 
###########################################
class util {

  package { "curl":
    ensure  => present,
  }

  package { "vim":
    ensure  => present,
  }

  package { "make":
    ensure  => present,
  }

}

###########################################
# Basic apache installation & VHOST setup 
# using vhost template file in vagrant-dev/conf.
#
# Setting this host up with profiler links
###########################################
class vhostsetup {

   apache::vhost { 'default':
      docroot             => '/vagrant/www',
      server_name         => 'lampdev',
      server_admin        => 'webmaster@locahost',
      docroot_create      => true,
      priority            => '',
      template            => '/vagrant/conf/main-vhost-template',
  }

}

include init
include apache
include mysql
include php
include vhostsetup
include util
include php_tools