# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'debian/bullseye64'

  config.vm.define :test do |test|
    # This shell script will make sure that you have your module copied in
    # place with all of its current dependencies as they are declared in
    # metadata.json.
    # Note though that only the latest git commit will get deployed; you won't
    # be able to test changes that are still uncommitted. This is a bit
    # annoying.
    # Also, because librarian-puppet caches things, if you create a new commit
    # in the module, you will need to either destroy/up the VM or ssh in, and
    # run the following:
    #    sudo -i
    #    cd /tmp/vagrant-puppet
    #    libraria-puppet clean
    #    rm Puppetfile.lock
    # After the above you can run vagrant provision to test the newest commit.
    #
    # You do NOT want to have librarian-puppet work on a synced_dir if it's
    # using nfs: this could destroy all your files on the host.
    test.vm.provision 'install librarian-puppet and install dependencies', type: 'shell' do |s|
      s.inline = <<-SHELL
        apt-get update
        apt-get install -y librarian-puppet git
        cd /tmp/vagrant-puppet/
        [[ -L Puppetfile ]] || ln -s /vagrant/tests/Puppetfile Puppetfile
        librarian-puppet install --verbose
      SHELL
    end

    test.vm.provision :puppet do |puppet|
      puppet.manifests_path = 'tests'
      # Change this to any file name in tests/ to run another test
      puppet.manifest_file = 'init.pp'
      puppet.options = ['--modulepath', '/tmp/vagrant-puppet/modules']
    end
  end
end
