# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "debian-9-amd64"

  config.vm.define :test do |test|
    # You do NOT want to have librarian-puppet work on a synced_dir if it's using nfs: this could destroy all your files on the host.
    test.vm.provision "install librarian-puppet and install dependencies", type: "shell" do |s|
      s.inline = <<-SHELL
        apt-get update
        apt-get install -y librarian-puppet git
        cd /tmp/vagrant-puppet/
        [[ -L Puppetfile ]] || ln -s /vagrant/tests/Puppetfile Puppetfile
        librarian-puppet install --verbose
      SHELL
    end

    test.vm.provision :puppet do |puppet|
      puppet.manifests_path = "tests"
      puppet.manifest_file = "init.pp"
      puppet.options = ["--modulepath", "/tmp/vagrant-puppet/modules"]
    end
  end
end
