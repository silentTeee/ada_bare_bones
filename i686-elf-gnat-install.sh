#!/usr/bin/env bash

# Recipe for building and installing a GNAT capable GCC cross-compiler from `x86-64-linux-elf`
# to `i686-elf` from source.
#
# Takes heavy inspiration from https://wiki.osdev.org/GNAT_Cross-Compiler

# The target triplet for the build.
export BUILD_TARGET="i686-elf"
# The install prefix.
export BUILD_PREFIX="${PWD}/toolchain/${BUILD_TARGET}"
# The host target triplet.
export HOST=$(gcc -dumpmachine)

# Update the PATH variable for this script so it includes the build directory.
# This will add our newly built cross-compiler to the PATH.
# After the initial GCC cross-compiler build this initial cross-compiler 
# will be used to build a version with Ada support.
export PATH="${BUILD_PREFIX}/bin:${PATH}"

# The concurrency to use during the build process.
# Adjust this based upon the capabilities of the host system.
concurrency=$(nproc)

# The directory where local library dependencies are installed.
# This is used to find installed dependencies such as MPFR, GMP, MPC, etc.
# This is the default location for installations using aptitude.
# Adjust this as necessary for the target system.
local_lib_dir="/usr/local"

# The directory where the source directories are located.
source_dir="${HOME}/src"
# The directory to use as storage for the intermediate build dirs.
build_dir="${HOME}/src/build"

if [[ ! -d "${source_dir}" ]]; then
	mkdir "${source_dir}" || exit 1
fi

if [[ ! -d "${build_dir}" ]]; then
	mkdir "${build_dir}" || exit 1
fi

cd "${build_dir}" || exit 1


# The versions of each dependency to build
# NOTE: currently assumes that you want to use the versions preinstalled on host
binutils_version=$(ld -v | grep -o -P "\d\.\d\d$")
gcc_version=$(gcc -dumpfullversion)

binutils_dir="binutils-${binutils_version}"
gcc_dir="gcc-${gcc_version}"

# grab pre-built source archives from FTP server, assuming we don't have them
if [[ ! -d "${source_dir}/${binutils_dir}" ]]; then
	wget https://ftp.gnu.org/gnu/binutils/binutils-${binutils_version}.tar.gz -O - | tar -C ${source_dir} -xz || exit 1
fi
if [[ ! -d "${source_dir}/${gcc_dir}" ]]; then
	wget https://ftp.gnu.org/gnu/gcc/gcc-${gcc_version}/gcc-${gcc_version}.tar.gz -O - | tar -C ${source_dir} -xz || exit 1
fi

# Build binutils
if [[ ! -d "${build_dir}/${binutils_dir}" ]]; then
	mkdir "${build_dir}/${binutils_dir}" || exit 1
fi

cd "${build_dir}/${binutils_dir}" || exit 1

${source_dir}/${binutils_dir}/configure          \
	--target="${BUILD_TARGET}"               \
	--prefix="${BUILD_PREFIX}"               \
	--host="${HOST}"                         \
	--disable-nls                            \
	--disable-multilib                       \
	--disable-shared                         \
        --with-sysroot || exit 1

# Check the host environment.
make configure-host || exit 1
make -j${concurrency} || exit 1
make -j${concurrency} install || exit 1

# build GCC target-arch bootstrap

if [[ ! -d "${build_dir}/${gcc_dir}" ]]; then
	mkdir "${build_dir}/${gcc_dir}" || exit 1
fi

cd "${build_dir}/${gcc_dir}" || exit 1

${source_dir}/${gcc_dir}/configure          \
	--target="${BUILD_TARGET}"          \
	--prefix="${BUILD_PREFIX}"          \
	--enable-languages="c"              \
	--disable-multilib                  \
	--disable-shared                    \
	--disable-nls                       \
	--with-gmp=${local_lib_dir}         \
	--with-mpc=${local_lib_dir}         \
	--with-mpfr=${local_lib_dir}        \
	--without-headers || exit 1

make -j${concurrency} all-gcc || exit 1
make -j${concurrency} install-gcc || exit 1

# build final GNAT-GCC with Ada, C and C++ support

cd "${build_dir}" || exit 1

if [[ ! -d "${build_dir}/${gcc_dir}" ]]; then
	mkdir "${build_dir}/${gcc_dir}" || exit 1
fi

cd "${build_dir}/${gcc_dir}" || exit 1

${source_dir}/${gcc_dir}/configure          \
	--target="${BUILD_TARGET}"          \
	--prefix="${BUILD_PREFIX}"          \
	--enable-languages="c,c++,ada"      \
	--disable-libada                    \
	--disable-nls                       \
	--disable-threads                   \
	--disable-multilib                  \
	--disable-shared                    \
	--with-gmp=${local_lib_dir}         \
	--with-mpc=${local_lib_dir}         \
	--with-mpfr=${local_lib_dir}        \
	--without-headers || exit 1

make -j${concurrency} all-gcc || exit 1
make -j${concurrency} all-target-libgcc || exit 1
make -j${concurrency} -C gcc cross-gnattools ada.all.cross || exit 1
make -j${concurrency} install-strip-gcc install-target-libgcc || exit 1
