#!/bin/bash

export LC_ALL='C.UTF8'
# save current pwd
CURRENTPWD=$PWD

# Check whether the relevant dependencies have been installed
grouppkg='Development Tools'
packages=("autoconf" "automake" "python3" "libmpc-devel" "mpfr-devel" "gmp-devel" "gawk" "bison" "flex" "texinfo" "patchutils" "gcc" "gcc-c++" "zlib-ng-compat-devel" "expat-devel" "libslirp-devel" "qemu-system-riscv")

if dnf group list installed | grep -q "$grouppkg"; then
  echo "Group package $grouppkg installed"
else
  echo "Group package $grouppkg not installed"
  echo "Install dependent repos"
  sudo dnf group install -y "$groupkg"
fi

for package in "${packages[@]}"
do
    # Use dnf list installed to check
    if ! dnf list installed "$package" &> /dev/null; then
        echo "Package '$package' not installed"
	sudo dnf install -y $package
    else
        echo "Package '$package' installed"
    fi
done

# Prepare clone riscv-gnu-toolchain
git clone https://github.com/riscv-collab/riscv-gnu-toolchain.git
cd riscv-gnu-toolchain
mkdir run-toolchain
toolchainpwd="$PWD/run-toolchain"
./configure --prefix=$toolchainpwd
if [ $? -ne 0 ]; then
    echo "configure failed!"
    exit 1
fi
# To build the Newlib cross-compiler
make
if [ $? -ne 0 ]; then
    echo "make and make install failed!"
    exit 1
fi
#$(( $(nproc) - 1 ))

# Prepare clone gdb source
cd $CURRENTPWD
git clone https://github.com/bminor/binutils-gdb.git
cd binutils-gdb
mkdir run-riscv-gdb
gdbpwd="$PWD/run-riscv-gdb"
./configure --program-prefix=riscv64-linux-gnu- --target=riscv64-linux-gnu --prefix=${gdbpwd}
if [ $? -ne 0 ]; then
    echo "configure failed!"
    exit 1
fi
# To build riscv64-linux-gnu-gdb
make
if [ $? -ne 0 ]; then
    echo "make and make install failed!"
    exit 1
fi
make install

# Generate final configuration file
#cd $CURRENTPWD
#touch init-on-fedora
#cat ""
