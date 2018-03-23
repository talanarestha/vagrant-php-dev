# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
	config.vm.box = "ubuntu/xenial64"
  	config.vm.host_name = "develop-php"

  	# Mount shared folder
    config.vm.synced_folder ".", "/vagrant"

  	config.vm.network "forwarded_port", guest: 80, host: 8080

	# Do some network configuration
	# private network disable. it has issue with windows 10 and virtualbox
    #config.vm.network "private_network", ip: "192.168.100.2"
		
  	#config.vm.network "public_network"
	config.ssh.insert_key = true

  	config.vm.provider "virtualbox" do |vb|
    	# Display the VirtualBox GUI when booting the machine
    	vb.gui = false
		
		# Vagrant name
		vb.name = "PHP-Dev01"

		host = RbConfig::CONFIG['host_os']

        if host =~ /darwin/
            cpus = `sysctl -n hw.ncpu`.to_i
            mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4

        elsif host =~ /linux/
            cpus = `nproc`.to_i
            mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4

        # Windows...
        else
            cpus = 4
            mem = 2048
        end

        vb.customize ["modifyvm", :id, "--memory", mem]
        vb.customize ["modifyvm", :id, "--cpus", cpus]
		
		vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  	end

	config.vm.provision :shell, :path => "bootstrap.sh"

end
