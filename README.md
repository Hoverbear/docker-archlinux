[![Build Status](https://travis-ci.org/Hoverbear/docker-archlinux.svg?branch=master)](https://travis-ci.org/Hoverbear/docker-archlinux)

A simple, ultra-minimal [Arch Linux](http://archlinux.org/) base image for Docker.

* Occupies ~170mb on disk.
* Consumes ~5mb running `/bin/bash` on a fresh container.
* Honest, [public build/deploy logs](https://travis-ci.org/Hoverbear/docker-archlinux).
* Simple, unopinionated package selection, a subset of `base`.
* Agnostic to versions, easily and quickly updated.

> Out of date? Broken? Open an issue or email me (email on Github user page). In a rush? Build it yourself, see below.

## Using ##

You can try out this base image as an interactive container. From here you can play around as `root` and do whatever.

```bash
docker run --tty --interactive --rm hoverbear/archlinux /bin/bash
```

You can also use this image from a `Dockerfile`, you'll likely want to refer to the [reference](https://docs.docker.com/engine/reference/builder/).

```dockerfile
FROM hoverbear/archlinux:latest
MAINTAINER Andrew Hobden <andrew@hoverbear.org>

# Do whatever...

# You'll probably change this.
ENTRYPOINT /bin/bash
```

## Contributing ##

You'll need:

* `docker`
* 64-bit Linux 2.6.23 or higher.

You can build the image, and give it a dry run.

```bash
make
```

This will spawn one of the official Ubuntu images and build the container in there. After it will import the created image into your `docker` and attempt to spawn it.

Note that things are deliberately as simple as possible. If you're making a contribution please endeavor to leave things **more understandable and straightforward** than you found it. This code is meant to be trustyworthy and auditable.

## License ##

The MIT License (MIT)

Copyright (c) 2016 Andrew Hobden

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
