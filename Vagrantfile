Vagrant.configure("2") do |config|

  # Define the Ansible Control Machine
  config.vm.define "control" do |control|
    control.vm.box = "ubuntu/jammy64"# Changed to a more recent Ubuntu LTS for control
    control.vm.box_version = "20241002.0.0"
    control.vm.network "private_network", ip: "192.168.33.23"
    control.vm.hostname = "control"
    control.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = "1" # Optional: Allocate 1 CPU
    end
    # Provision Ansible on the control machine
    control.vm.provision "shell", inline: <<-SHELL
      sudo apt update
      sudo apt install -y software-properties-common
      sudo apt-add-repository --yes --update ppa:ansible/ansible
      sudo apt install -y ansible
      echo "Ansible installation complete on control machine."
    SHELL
  end


  # Define Web Server 03 (Ubuntu)
  config.vm.define "web03" do |web03|
    web03.vm.box = "ubuntu/jammy64"# Changed to a more recent Ubuntu LTS for control
    web03.vm.box_version = "20241002.0.0"
    web03.vm.network "private_network", ip: "192.168.33.30"
    web03.vm.hostname = "web03"
    web03.vm.provider "virtualbox" do |vb|
      vb.memory = "512"
      vb.cpus = "1" # Optional: Allocate 1 CPU
    end
  end



  # Define Web Server 01 (CentOS)
  config.vm.define "web01" do |web01|
    web01.vm.box = "eurolinux-vagrant/centos-stream-9"
    web01.vm.network "private_network", ip: "192.168.33.24"
    web01.vm.hostname = "web01"
    web01.vm.provider "virtualbox" do |vb|
      vb.memory = "512" # Reduced memory for target VMs
      vb.cpus = "1"
    end
  end

  # Define Web Server 02 (CentOS)
  config.vm.define "web02" do |web02|
    web02.vm.box = "eurolinux-vagrant/centos-stream-9"
    web02.vm.network "private_network", ip: "192.168.33.25"
    web02.vm.hostname = "web02"
    web02.vm.provider "virtualbox" do |vb|
      vb.memory = "512"
      vb.cpus = "1"
    end
  end



  # Define DB Server 01 (CentOS) - Added as per the setup description
  config.vm.define "db01" do |db01|
    db01.vm.box = "eurolinux-vagrant/centos-stream-9"
    db01.vm.network "private_network", ip: "192.168.33.15" # Changed IP to avoid conflict with web03
    db01.vm.hostname = "db01"
    db01.vm.provider "virtualbox" do |vb|
      vb.memory = "512"
      vb.cpus = "1"
    end
  end



end
