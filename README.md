vagrant-dev-lamp
================

Base LAMP (PHP) stack with vagrant that includes remote debugging, profiling with xhprof and other common PHP QA tools.

## Spec

* __Apache__
    * mod_rewrite  
    * mod_php  
    * Main virtualhost set up  
        * Document root /vagrant/www/ (synched VM folder)
        * Name lampdev
        * port 80
    * xhprof virtualhost  
        * Document root /var/xhprof/ 
        * Name xhprof
        * port 8000
* __MySQL__
* __PHP__
    * APC op-code cache  
    * PEAR  
    * PHP QA tools (phpunit, phpdoc, code sniffer etc.)  
    * XDebug - setup for remote debugging
    * __xhprof__ - PHP profiler, auto enabled for all PHP files served from /vagrant/www/
* __Basic utilities__  
    * curl  
    * vim
* __Networking__
    * VM Port 80 (http) traffic forwarded to port 8888 on host - point your browser at localhost:8888
    * VM Port 22 (ssh) traffic forwarded to port 2222 on host - ssh to localhost:2222 
    * VM Port 22 (ssh) traffic forwarded to port 9000 on host - ssh to localhost:9001 
    * VM Port 22 (ssh) traffic forwarded to port 8000 on host - ssh to localhost:8000 


## Quick Guide

__Pre-requisites:__  
__1.__ Install Virtualbox  
__2.__ Install vagrant  
__3.__ Install vagrant base box

    # You can use an alternative base box if you wish
    vagrant box add precise64 http://files.vagrantup.com/precise64.box

Then ...
    
    # Clone the Vagrant LAMP stack configuration
    git clone --recursive https://github.com/pipe-devnull/vagrant-dev-lamp.git
    # enter the cloned directory
    cd vagrant-dev-lamp
    # Build the VM using vagrant
    vagrant up