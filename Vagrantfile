# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV["LC_ALL"] = "en_US.UTF-8"
# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.ssh.insert_key=false
 
  ### ENABLE PLUGINS
  config.landrush.enabled = true
  config.hostmanager.enabled = true

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  
  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL

  config.vm.provision "shell", path: "hostname.sh", run: "always"

  #####################################################################
  ###                         Virtual Machines                      ###
  #####################################################################

  ## JBoss EAP Domain Controller 01
  config.vm.define "jbdc01", autostart: true do |jbdc01|
    jbdc01.vm.box = "eap6base"

    ### MV System Settings
    jbdc01.vm.provider "virtualbox" do |vb|
      # Customize the amount of memory on the VM:
      vb.memory = "512"
    end

    ### Networking
    jbdc01.vm.hostname = "jbdc01.arch.redhat.dev"
    # Enable Landrush dns plugin
    jbdc01.landrush.enabled = true
    jbdc01.landrush.tld = 'arch.redhat.dev'
    # Enable host-manager plugin 
    jbdc01.hostmanager.enabled = true
    jbdc01.hostmanager.manage_host = false
    jbdc01.hostmanager.manage_guest = true
    jbdc01.hostmanager.ip_resolver = proc do |vm, resolving_vm|
      if vm.id
        `VBoxManage guestproperty get #{vm.id} "/VirtualBox/GuestInfo/Net/1/V4/IP"`.split()[1]
      end
    end

    ### Synced folders
    jbdc01.vm.synced_folder "./jbdc01/", "/vagrant", id: "vagrant-root",
      owner: "vagrant",
      group: "vagrant",
      mount_options: ["dmode=777,fmode=664"]
    jbdc01.vm.synced_folder "./jbdc01/jbossshare", "/jbossshare", id: "jboss-share",
      owner: "jboss",
      group: "jboss",
      mount_options: ["dmode=775,fmode=664"]

    jbdc01.vm.synced_folder "./deployments", "/deployments", id: "apps-deployment",
      owner: "jboss",
      group: "jboss",
      mount_options: ["dmode=775,fmode=664"]

    ### Provisioning
    jbdc01.ssh.username = "jboss"
    
    jbdc01.vm.provision "file", source: "./jbdc01/data/domain/mgmt-users.properties", 
      destination: "/etc/jbossas/domain/mgmt-users.properties"

    jbdc01.vm.provision "file", source: "./jbdc01/data/domain/mgmt-groups.properties", 
      destination: "/etc/jbossas/domain/mgmt-groups.properties"

    jbdc01.vm.provision "file", source: "./jbdc01/data/domain/host-master.xml", 
      destination: "/etc/jbossas/domain/host.xml"

    jbdc01.vm.provision "shell",
      inline: "sudo service jbossas-domain start",
      run: "always"

    jbdc01.vm.provision "shell",
      path: "jbdc01/provision.sh"


  end



  ## JBoss EAP Domain Controller 02
  config.vm.define "jbdc02", autostart: false do |jbdc02|
    jbdc02.vm.box = "eap6base"

    ### MV System Settings
    jbdc02.vm.provider "virtualbox" do |vb|
      # Customize the amount of memory on the VM:
      vb.memory = "512"
    end

    ### Networking
    jbdc02.vm.hostname = "jbdc02.arch.redhat.dev"
    # Enable Landrush dns plugin
    jbdc02.landrush.enabled = true
    jbdc02.landrush.tld = 'arch.redhat.dev'
    # Enable host-manager plugin 
    jbdc02.hostmanager.enabled = true
    jbdc02.hostmanager.manage_host = false
    jbdc02.hostmanager.manage_guest = true
    jbdc02.hostmanager.ip_resolver = proc do |vm, resolving_vm|
      if vm.id
        `VBoxManage guestproperty get #{vm.id} "/VirtualBox/GuestInfo/Net/1/V4/IP"`.split()[1]
      end
    end

    ### Synced folders
    jbdc02.vm.synced_folder "./jbdc02/", "/vagrant", id: "vagrant-root",
      owner: "vagrant",
      group: "vagrant",
      mount_options: ["dmode=777,fmode=664"]

    ### Provisioning
    jbdc02.ssh.username = "jboss"

    jbdc02.vm.provision "file", source: "./jbdc02/data/domain/host-slave.xml", 
      destination: "/etc/jbossas/domain/host.xml"

    jbdc02.vm.provision "shell",
      inline: "sudo service jbossas-domain start",
      run: "always"

  end

  ## JBoss EAP Load Balancer 01
  config.vm.define "jblb01", autostart: true do |jblb01|
    jblb01.vm.box = "http22base"

    ### MV System Settings
    jblb01.vm.provider "virtualbox" do |vb|
      # Customize the amount of memory on the VM:
      vb.memory = "256"
    end

    ### Networking
    jblb01.vm.hostname = "jblb01.arch.redhat.dev"
    # Enable Landrush dns plugin
    jblb01.landrush.enabled = true
    jblb01.landrush.tld = 'arch.redhat.dev'
    # Enable host-manager plugin 
    jblb01.hostmanager.enabled = true
    jblb01.hostmanager.manage_host = false
    jblb01.hostmanager.manage_guest = true
    jblb01.hostmanager.ip_resolver = proc do |vm, resolving_vm|
      if vm.id
        `VBoxManage guestproperty get #{vm.id} "/VirtualBox/GuestInfo/Net/1/V4/IP"`.split()[1]
      end
    end

    ### Synced folders
    jblb01.vm.synced_folder "./jblb01/", "/vagrant", id: "vagrant-root",
      owner: "vagrant",
      group: "vagrant",
      mount_options: ["dmode=777,fmode=664"]

    ### Provisioning
    jblb01.vm.provision "shell",
      inline: "sudo systemctl start httpd22.service",
      run: "always"

  end



  ## JBoss EAP Load Balancer 02
  config.vm.define "jblb02", autostart: true do |jblb02|
    jblb02.vm.box = "http22base"

    ### MV System Settings
    jblb02.vm.provider "virtualbox" do |vb|
      # Customize the amount of memory on the VM:
      vb.memory = "256"
    end

    ### Networking
    jblb02.vm.hostname = "jblb02.arch.redhat.dev"
    # Enable Landrush dns plugin
    jblb02.landrush.enabled = true
    jblb02.landrush.tld = 'arch.redhat.dev'
    # Enable host-manager plugin 
    jblb02.hostmanager.enabled = true
    jblb02.hostmanager.manage_host = false
    jblb02.hostmanager.manage_guest = true
    jblb02.hostmanager.ip_resolver = proc do |vm, resolving_vm|
      if vm.id
        `VBoxManage guestproperty get #{vm.id} "/VirtualBox/GuestInfo/Net/1/V4/IP"`.split()[1]
      end
    end

    ### Synced folders
    jblb02.vm.synced_folder "./jblb02/", "/vagrant", id: "vagrant-root",
      owner: "vagrant",
      group: "vagrant",
      mount_options: ["dmode=777,fmode=664"]

    ### Provisioning
    jblb02.vm.provision "shell",
      inline: "sudo systemctl start httpd22.service",
      run: "always"

  end


  ## JBoss DataGrid 01
  config.vm.define "jbdg01", autostart: true do |jbdg01|
    jbdg01.vm.box = "datagridbase"

    ### MV System Settings
    jbdg01.vm.provider "virtualbox" do |vb|
      # Customize the amount of memory on the VM:
      vb.memory = "768"
    end

    ### Networking
    jbdg01.vm.hostname = "jbdg01.arch.redhat.dev"
    # Enable Landrush dns plugin
    jbdg01.landrush.enabled = true
    jbdg01.landrush.tld = 'arch.redhat.dev'
    # Enable host-manager plugin 
    jbdg01.hostmanager.enabled = true
    jbdg01.hostmanager.manage_host = false
    jbdg01.hostmanager.manage_guest = true
    jbdg01.hostmanager.ip_resolver = proc do |vm, resolving_vm|
      if vm.id
        `VBoxManage guestproperty get #{vm.id} "/VirtualBox/GuestInfo/Net/1/V4/IP"`.split()[1]
      end
    end

    ### Synced folders
    jbdg01.vm.synced_folder "./jbdg01/", "/vagrant", id: "vagrant-root",
      owner: "vagrant",
      group: "vagrant",
      mount_options: ["dmode=777,fmode=664"]
    jbdg01.vm.synced_folder "./jbdg01/jbossshare", "/jbossshare", id: "jboss-share",
      owner: "jboss",
      group: "jboss",
      mount_options: ["dmode=775,fmode=664"]

    ### Provisioning
    jbdg01.vm.provision "shell",
      inline: "sysctl -w net.core.wmem_max=1048576;sysctl -w net.core.rmem_max=26214400;sudo service jboss-datagrid-clustered start",
      run: "always"

  end


  ## JBoss DataGrid 02
  config.vm.define "jbdg02", autostart: false do |jbdg02|
    jbdg02.vm.box = "datagridbase"

    ### MV System Settings
    jbdg02.vm.provider "virtualbox" do |vb|
      # Customize the amount of memory on the VM:
      vb.memory = "768"
    end

    ### Networking
    jbdg02.vm.hostname = "jbdg02.arch.redhat.dev"
    # Enable Landrush dns plugin
    jbdg02.landrush.enabled = true
    jbdg02.landrush.tld = 'arch.redhat.dev'
    # Enable host-manager plugin 
    jbdg02.hostmanager.enabled = true
    jbdg02.hostmanager.manage_host = false
    jbdg02.hostmanager.manage_guest = true
    jbdg02.hostmanager.ip_resolver = proc do |vm, resolving_vm|
      if vm.id
        `VBoxManage guestproperty get #{vm.id} "/VirtualBox/GuestInfo/Net/1/V4/IP"`.split()[1]
      end
    end

    ### Synced folders
    jbdg02.vm.synced_folder "./jbdg02/", "/vagrant", id: "vagrant-root",
      owner: "vagrant",
      group: "vagrant",
      mount_options: ["dmode=777,fmode=664"]
    jbdg02.vm.synced_folder "./jbdg02/jbossshare", "/jbossshare", id: "jboss-share",
      owner: "jboss",
      group: "jboss",
      mount_options: ["dmode=775,fmode=664"]

    ### Provisioning
    jbdg02.vm.provision "shell",
      inline: "sysctl -w net.core.wmem_max=1048576;sysctl -w net.core.rmem_max=26214400;sudo service jboss-datagrid-clustered start",
      run: "always"

  end


  ## JBoss DataGrid 03
  config.vm.define "jbdg03", autostart: false do |jbdg03|
    jbdg03.vm.box = "datagridbase"

    ### MV System Settings
    jbdg03.vm.provider "virtualbox" do |vb|
      # Customize the amount of memory on the VM:
      vb.memory = "768"
    end

    ### Networking
    jbdg03.vm.hostname = "jbdg03.arch.redhat.dev"
    # Enable Landrush dns plugin
    jbdg03.landrush.enabled = true
    jbdg03.landrush.tld = 'arch.redhat.dev'
    # Enable host-manager plugin 
    jbdg03.hostmanager.enabled = true
    jbdg03.hostmanager.manage_host = false
    jbdg03.hostmanager.manage_guest = true
    jbdg03.hostmanager.ip_resolver = proc do |vm, resolving_vm|
      if vm.id
        `VBoxManage guestproperty get #{vm.id} "/VirtualBox/GuestInfo/Net/1/V4/IP"`.split()[1]
      end
    end

    ### Synced folders
    jbdg03.vm.synced_folder "./jbdg03/", "/vagrant", id: "vagrant-root",
      owner: "vagrant",
      group: "vagrant",
      mount_options: ["dmode=777,fmode=664"]
    jbdg03.vm.synced_folder "./jbdg03/jbossshare", "/jbossshare", id: "jboss-share",
      owner: "jboss",
      group: "jboss",
      mount_options: ["dmode=775,fmode=664"]

    ### Provisioning
    jbdg03.vm.provision "shell",
      inline: "sysctl -w net.core.wmem_max=1048576;sysctl -w net.core.rmem_max=26214400;sudo service jboss-datagrid-clustered start",
      run: "always"

  end


  ## JBoss DataGrid 04
  config.vm.define "jbdg04", autostart: false do |jbdg04|
    jbdg04.vm.box = "datagridbase"

    ### MV System Settings
    jbdg04.vm.provider "virtualbox" do |vb|
      # Customize the amount of memory on the VM:
      vb.memory = "768"
    end

    ### Networking
    jbdg04.vm.hostname = "jbdg04.arch.redhat.dev"
    # Enable Landrush dns plugin
    jbdg04.landrush.enabled = true
    jbdg04.landrush.tld = 'arch.redhat.dev'
    # Enable host-manager plugin 
    jbdg04.hostmanager.enabled = true
    jbdg04.hostmanager.manage_host = false
    jbdg04.hostmanager.manage_guest = true
    jbdg04.hostmanager.ip_resolver = proc do |vm, resolving_vm|
      if vm.id
        `VBoxManage guestproperty get #{vm.id} "/VirtualBox/GuestInfo/Net/1/V4/IP"`.split()[1]
      end
    end

    ### Synced folders
    jbdg04.vm.synced_folder "./jbdg04/", "/vagrant", id: "vagrant-root",
      owner: "vagrant",
      group: "vagrant",
      mount_options: ["dmode=777,fmode=664"]
    jbdg04.vm.synced_folder "./jbdg04/jbossshare", "/jbossshare", id: "jboss-share",
      owner: "jboss",
      group: "jboss",
      mount_options: ["dmode=775,fmode=664"]

    ### Provisioning
    jbdg04.vm.provision "shell",
      inline: "sysctl -w net.core.wmem_max=1048576;sysctl -w net.core.rmem_max=26214400;sudo service jboss-datagrid-clustered start",
      run: "always"

  end


  ## JBoss EAP Host Controller 01
  config.vm.define "jbhc01", autostart: true do |jbhc01|
    jbhc01.vm.box = "eap6base"

    ### MV System Settings
    jbhc01.vm.provider "virtualbox" do |vb|
      # Customize the amount of memory on the VM:
      vb.memory = "1280"
    end

    ### Networking
    jbhc01.vm.hostname = "jbhc01.arch.redhat.dev"
    # Enable Landrush dns plugin
    jbhc01.landrush.enabled = true
    jbhc01.landrush.tld = 'arch.redhat.dev'
    # Enable host-manager plugin 
    jbhc01.hostmanager.enabled = true
    jbhc01.hostmanager.manage_host = false
    jbhc01.hostmanager.manage_guest = true
    jbhc01.hostmanager.ip_resolver = proc do |vm, resolving_vm|
      if vm.id
        `VBoxManage guestproperty get #{vm.id} "/VirtualBox/GuestInfo/Net/1/V4/IP"`.split()[1]
      end
    end

    ### Synced folders
    jbhc01.vm.synced_folder "./jbhc01/", "/vagrant", id: "vagrant-root",
      owner: "vagrant",
      group: "vagrant",
      mount_options: ["dmode=777,fmode=664"]

    ### Provisioning
    jbhc01.ssh.username = "jboss"

    jbhc01.vm.provision "file", source: "./jbhc01/data/domain/host-controller.xml", 
      destination: "/etc/jbossas/domain/host.xml"

    jbhc01.vm.provision "shell",
      inline: "sudo service jbossas-domain start",
      run: "always"

  end



  ## JBoss EAP Host Controller 02
  config.vm.define "jbhc02", autostart: true do |jbhc02|
    jbhc02.vm.box = "eap6base"

    ### MV System Settings
    jbhc02.vm.provider "virtualbox" do |vb|
      # Customize the amount of memory on the VM:
      vb.memory = "1280"
    end

    ### Networking
    jbhc02.vm.hostname = "jbhc02.arch.redhat.dev"
    # Enable Landrush dns plugin
    jbhc02.landrush.enabled = true
    jbhc02.landrush.tld = 'arch.redhat.dev'
    # Enable host-manager plugin 
    jbhc02.hostmanager.enabled = true
    jbhc02.hostmanager.manage_host = false
    jbhc02.hostmanager.manage_guest = true
    jbhc02.hostmanager.ip_resolver = proc do |vm, resolving_vm|
      if vm.id
        `VBoxManage guestproperty get #{vm.id} "/VirtualBox/GuestInfo/Net/1/V4/IP"`.split()[1]
      end
    end

    ### Synced folders
    jbhc02.vm.synced_folder "./jbhc02/", "/vagrant", id: "vagrant-root",
      owner: "vagrant",
      group: "vagrant",
      mount_options: ["dmode=777,fmode=664"]

    ### Provisioning
    jbhc02.ssh.username = "jboss"

    jbhc02.vm.provision "file", source: "./jbhc02/data/domain/host-controller.xml", 
      destination: "/etc/jbossas/domain/host.xml"

    jbhc02.vm.provision "shell",
      inline: "sudo service jbossas-domain start",
      run: "always"

  end


  ## JBoss EAP Host Controller 03
  config.vm.define "jbhc03", autostart: false do |jbhc03|
    jbhc03.vm.box = "eap6base"

    ### MV System Settings
    jbhc03.vm.provider "virtualbox" do |vb|
      # Customize the amount of memory on the VM:
      vb.memory = "1280"
    end

    ### Networking
    jbhc03.vm.hostname = "jbhc03.arch.redhat.dev"
    # Enable Landrush dns plugin
    jbhc03.landrush.enabled = true
    jbhc03.landrush.tld = 'arch.redhat.dev'
    # Enable host-manager plugin 
    jbhc03.hostmanager.enabled = true
    jbhc03.hostmanager.manage_host = false
    jbhc03.hostmanager.manage_guest = true
    jbhc03.hostmanager.ip_resolver = proc do |vm, resolving_vm|
      if vm.id
        `VBoxManage guestproperty get #{vm.id} "/VirtualBox/GuestInfo/Net/1/V4/IP"`.split()[1]
      end
    end

    ### Synced folders
    jbhc03.vm.synced_folder "./jbhc03/", "/vagrant", id: "vagrant-root",
      owner: "vagrant",
      group: "vagrant",
      mount_options: ["dmode=777,fmode=664"]

    ### Provisioning
    jbhc03.ssh.username = "jboss"

    jbhc03.vm.provision "file", source: "./jbhc03/data/domain/host-controller.xml", 
      destination: "/etc/jbossas/domain/host.xml"

    jbhc03.vm.provision "shell",
      inline: "sudo service jbossas-domain start",
      run: "always"

  end


  ## JBoss EAP Host Controller 04
  config.vm.define "jbhc04", autostart: false do |jbhc04|
    jbhc04.vm.box = "eap6base"

    ### MV System Settings
    jbhc04.vm.provider "virtualbox" do |vb|
      # Customize the amount of memory on the VM:
      vb.memory = "1280"
    end

    ### Networking
    jbhc04.vm.hostname = "jbhc04.arch.redhat.dev"
    # Enable Landrush dns plugin
    jbhc04.landrush.enabled = true
    jbhc04.landrush.tld = 'arch.redhat.dev'
    # Enable host-manager plugin 
    jbhc04.hostmanager.enabled = true
    jbhc04.hostmanager.manage_host = false
    jbhc04.hostmanager.manage_guest = true
    jbhc04.hostmanager.ip_resolver = proc do |vm, resolving_vm|
      if vm.id
        `VBoxManage guestproperty get #{vm.id} "/VirtualBox/GuestInfo/Net/1/V4/IP"`.split()[1]
      end
    end

    ### Synced folders
    jbhc04.vm.synced_folder "./jbhc04/", "/vagrant", id: "vagrant-root",
      owner: "vagrant",
      group: "vagrant",
      mount_options: ["dmode=777,fmode=664"]

    ### Provisioning
    jbhc04.ssh.username = "jboss"

    jbhc04.vm.provision "file", source: "./jbhc04/data/domain/host-controller.xml", 
      destination: "/etc/jbossas/domain/host.xml"

    jbhc04.vm.provision "shell",
      inline: "sudo service jbossas-domain start",
      run: "always"

  end


end
