#!/bin/sh

DIR="/tmp/tmp.`date +%s`.lucid32_current"
mktemp -d $DIR
pushd $DIR

vagrant init lucid32 http://files.vagrantup.com/lucid32.box
vagrant up
vagrant ssh -c "sudo apt-get update -y -q"

echo
echo "NOTE: Please enter the following command at the prompt:"
echo
echo "sudo apt-get upgrade -y -q"
echo
echo "User interaction is currently required to bypass GRUB screen"
echo "When you are finished, type \"exit\""
echo

vagrant ssh

# GRUB config will cause an interactive menu to appear here :(

# Create Vagrantfile.pkg
echo 'Vagrant::Config.run do |config|
  # Forward apache
  config.vm.forward_port 80, 8080
  config.vm.forward_port 8000, 8000
end' > Vagrantfile.pkg

vagrant package --vagrantfile Vagrantfile.pkg --output lucid32_current.box

if [ $1 != "" ]; then
	echo "Moving lucid32_current.box to $1"
	mv lucid32_current.box $1 && echo "Success"
	echo "Output file: $1
else
	echo "Output file: $DIR/lucid32_current.box
fi

echo
echo "NOTE: You may want to remove temp dir $DIR"
echo

popd

