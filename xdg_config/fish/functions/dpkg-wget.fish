function dpkg-wget -a url
	cd (mktemp -d)
	wget $url
	sudo dpkg -i *.deb
	cd -
end
