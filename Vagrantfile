# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
	config.vm.box = "ubuntu/xenial64"
  	config.vm.host_name = "develop-php"

  	# Mount shared folder using NFS
    config.vm.synced_folder ".", "/vagrant",
        id: "core",
        :nfs => true,
        :mount_options => ['nolock,vers=3,udp,noatime']



  	config.vm.network "forwarded_port", guest: 80, host: 8080

	# Do some network configuration
    config.vm.network "private_network", ip: "192.168.100.100"

  	#config.vm.network "public_network"

  	config.vm.provider "virtualbox" do |vb|
    	# Display the VirtualBox GUI when booting the machine
    	vb.gui = false

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
  	end

	config.vm.provision :shell, :path => "bootstrap.sh"

end
