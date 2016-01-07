all:
	sudo docker run --interactive --tty --privileged --volume ${shell pwd}:/build:rw  ubuntu:trusty /bin/bash -c "cd build ; sudo ./pre.sh ; sudo ./build.sh;"
	sudo ./post.sh

clean:
	sudo rm -rf archbuild/
