# About
This project was heavily inspired by the [Ada Bare Bones tutorial](https://wiki.osdev.org/Ada_Bare_Bones). There is a [GitHub project](https://github.com/Lucretia/bare_bones) for it produced by the original author, but I had trouble getting it to work for me, and I wanted to create a fully self-contained project like what AOSP does (one mega-repo complete with toolchain, libraries, and a runtime).

# Prerequisites
* Ubuntu 22.04LTS or derivative distro host OS
* An i686 baremetal FSF GNAT cross-compiler (more on this in the next section)
* `wget`
* `gcc`
* `grub-mkrescue` installed
    * on Debian-based systems without GRUB, install the `grub-common`package
    * if your system is using UEFI instead of BIOS, then you also need `grub-pc-bin`
* `gprbuild` installed

# Generating the i686 Baremetal Cross-Compiler
You can tweak the `i686-elf-gnat-install.sh` to build the GNAT version you want. This script was heavily inspired by the commands on the page https://wiki.osdev.org/GNAT_Cross-Compiler

By default it uses the version of the native GCC install and builds the cross-compiler in this project's *toolchain* folder. It doesn't do any cleanup in case you mess something up, so that you can save time on the rebuild, but obviously this can be changed.

# TODO
* Add behavior to copy relevant files from *zfp_rts/src/* folder to *zfp_rts/build/adainclude/* (or just remove the former entirely)
* Make the x86_zfp_runtime.gpr configuration a bit more robust
    * I created the .cgpr file based on recommendations from the page https://docs.adacore.com/gprbuild-docs/html/gprbuild_ug/companion_tools.html#. It's unclear whether using a .cgpr is considered the "idiomatic" way of doing things anymore, now that Alire exists.

# Stretch Goals
* Rearchitect the project to use Alire
