# Prerequisites
* Ubuntu 22.04LTS or derivative distro
* GNAT cross-target compiler (my current is 11.2.0) built from source, with symlink in lib folder to zfp_rts folder
    * TODO: move toolchain into project folder, to make life easier
* `grub-mkrescue` installed
    * on Debian-based systems without GRUB, install the `grub-common`package
        * depending on how old your system
    * if your system is using UEFI instead of BIOS, then you also need `grub-pc-bin`
* `gprbuild` installed

