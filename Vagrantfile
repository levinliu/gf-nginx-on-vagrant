Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.box_check_update = false
  config.vm.provider "virtualbox"

  $num_vms = 1
  (1..$num_vms).each do |id|
    config.vm.define "nginx-node#{id}" do |node|
      node.vm.hostname = "nginx-node#{id}"
      node.vm.network :private_network, ip: "10.64.4.#{id}",  auto_config: true
      config.vm.network "forwarded_port", guest: 80, host: 80, auto_correct: true # nginx  
      config.vm.network "forwarded_port", guest: 8084, host: 8084, auto_correct: true # server 01
      config.vm.network "forwarded_port", guest: 8082, host: 8082, auto_correct: true # server 02
      node.vm.provider :virtualbox do |vb, override|
        vb.name = "nginx-node#{id}"
        vb.gui = false
        vb.memory = 2048
        vb.cpus = 1
      end
      config.vm.provision "shell", path: "provision.sh"

    end
  end
end
