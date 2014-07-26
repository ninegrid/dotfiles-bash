dotfiles-bash
========

> Default Ordnace Targeting Files In Linux, Especially Sourcecode


dependencies
--------

* [rvm](https://rvm.io)
* [n](https://github.com/visionmedia/n)

setup
--------

# Method 1

Scripts are currently loaded from a canonical path: `~/.files/bash/`.

```sh
git clone https://github.com/ninegrid/dotfiles-bash.git ~/.files/bash
```
# Method 2

Alternatively, clone the repository to your preferred location and symlink.

```sh
git clone http://github.com/ninegrid/dotfiles-bash.git $PREFERRED
mkdir ~/.files && ln -s $PREFERRED ~/.files/bash
```

todo
--------

* write the ps1 for node version as managed by [n](https://github.com/visionmedia/n)
* make an animated gif of the prompt for an example in the README


