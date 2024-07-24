##############
#
# PACKAGED OpenHPC2.x smshost for local virtual cluster
#
### 20240718 bj
#
# Localised Development and Learning Cluster
# developed from the OpenHPC 2.x virtual lab
# 
#
###
# -*- mode: ruby -*-
# vi: set ft=ruby :

################################################
### OPENHPC 2.x Virtual Lab 
###
### A Contribution by the Advanced Computer Engineering (ACE) Lab 
### on behalf of the CHPC's HPC Ecosystems Project
###
### Developed by:
### Lara Timm, HPC Engineer (ACE Lab)
### Eugene de Beste, Senior Cloud/HPC Engineer (ACE Lab)
### Bryan Johnston, Senior Technologist (ACE Lab)
###
################################################

Vagrant.configure("2") do |config|

    config.vm.define "smshost", primary: true do |smshost|

    # if the .box has not been added to local vagrant environment
	#smshost.vm.box = "packaged-openhpc2-smshost.box"
	
	# Otherwise, follow the OpenHPC2 vcluster guide method
	smshost.vm.box = "openhpc/ohpc2"

    smshost.vm.hostname = "smshost"

	# default SSH port has been changed to 2299 to avoid any local conflicts with other labs
    smshost.vm.network "forwarded_port", guest: 22, host: 2299, host_ip: "127.0.0.1", id: "ssh"
    smshost.vm.network "private_network", ip: "10.10.10.10",virtualbox__intnet: "hpcnet"

	# other services currently not used
	#smshost.vm.network "forwarded_port", guest: 443, host: 4433 
	#config.ssh.forward_agent = true  
	#config.ssh.forward_x11 = true 
  
	# additional local interface to support GUI interaction with smshost
	smshost.vm.network "private_network", ip: "192.168.56.99"
  
    smshost.vm.provider "virtualbox" do |vb|
    
      vb.name = "smshost_vcluster_20240724"
      vb.cpus = 2
      vb.memory = "1024"
      vb.gui = false

    end

	# enable the following to add more linux tools to the image upon deployment
	#    smshost.vm.provision "shell" do |s|
	#      s.inline = "sudo yum install vim git tmux -y; sed -i '/smshost/d' /etc/hosts"
	#      end

  end

  config.vm.define "compute00", autostart: false do |compute00|

    compute00.vm.box = "file://./package.box"
    compute00.vm.hostname = "compute00"
    compute00.vm.network "private_network", :adapter=>1, ip: "10.10.10.100", mac: "080027F9F3B1", virtualbox__intnet: "hpcnet"
    #compute00.vm.communicator = ""

    compute00.vm.provider "virtualbox" do |vb|
    
      vb.name = "compute00_vcluster_20240724"
      vb.cpus = 2
      vb.memory = "3072"
      vb.gui = false

    end

  end

  config.vm.define "compute01", autostart: false do |compute01|

    compute01.vm.box = "file://./package.box"
    compute01.vm.hostname = "compute01"
    compute01.vm.network "private_network", :adapter=>1, ip: "10.10.10.101", mac: "080027F59A31", virtualbox__intnet: "hpcnet"
    compute01.vm.communicator = ""

    compute01.vm.provider "virtualbox" do |vb|
    
      vb.name = "compute01_vcluster_20240724"
      vb.cpus = 2
      vb.memory = "3072"
      vb.gui = false

    end

  end

end
