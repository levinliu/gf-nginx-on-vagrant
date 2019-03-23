Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.box_check_update = false
  config.vm.provider "virtualbox"

  $num_vms = 1
  (1..$num_vms).each do |id|
    config.vm.define "nginxbox#{id}" do |node|
      node.vm.hostname = "nginxbox#{id}"
      #node.vm.network :private_network, ip: "10.64.4.#{id}",  auto_config: true
      config.vm.network "forwarded_port", guest: 80, host: 80, auto_correct: true # nginx  
      config.vm.network "forwarded_port", guest: 9127, host: 9127, auto_correct: true
      config.vm.network "forwarded_port", guest: 8080, host: 8080, auto_correct: true # port for nginx if 80 port is blocked
      config.vm.network "forwarded_port", guest: 8081, host: 8081, auto_correct: true # service port
      config.vm.network "forwarded_port", guest: 8082, host: 8082, auto_correct: true # service port
      config.vm.network "forwarded_port", guest: 8083, host: 8083, auto_correct: true # service port
      config.vm.network "forwarded_port", guest: 8084, host: 8084, auto_correct: true # service port
      config.vm.network "forwarded_port", guest: 8085, host: 8085, auto_correct: true # service port
      config.vm.network "forwarded_port", guest: 8086, host: 8086, auto_correct: true # service port
      node.vm.provider :virtualbox do |vb, override|
        vb.name = "nginxbox#{id}"
        vb.gui = false
        vb.memory = 2048
        vb.cpus = 1
      end
      config.vm.provision "file", source: "lib/nginx-1.4.2.tar.gz", destination: "/tmp/nginx.tar.gz"
      config.vm.provision "file", source: "lib/openssl-1.0.1t.tar.gz", destination: "/tmp/openssl.tar.gz"
      config.vm.provision "file", source: "lib/pcre-8.34.tar.gz", destination: "/tmp/pcre.tar.gz"
      config.vm.provision "file", source: "lib/zlib-1.2.11.tar.gz", destination: "/tmp/zlib.tar.gz"
      config.vm.provision "file", source: "nginx.conf", destination: "/tmp/nginx.conf"
      config.vm.provision "file", source: "demo-app", destination: "/tmp/app"
      config.vm.provision "shell", path: "provision.sh"

    end
  end
end
