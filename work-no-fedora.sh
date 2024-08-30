#!/bin/bash

# Check whether the relevant dependencies have been installed
grouppkg='Development Tools'
packages=("autoconf" "automake" "python3" "libmpc-devel" "mpfr-devel" "gmp-devel" "gawk" "bison" "flex" "texinfo" "patchutils" "gcc" "gcc-c++" "zlib-ng-compat-devel" "expat-devel" "libslirp-devel" "qemu-system-riscv")

if dnf group list installed | grep -q "$grouppkg"; then
  echo "Group package $grouppkg installed"
else
  echo "Group package $grouppkg not installed"
  sudo dnf install "$groupkg"
fi

for package in "${packages[@]}"
do
    # Use dnf list installed to check
    if ! dnf list installed "$package" &> /dev/null; then
        echo "Package '$package' not installed"
	sudo dnf install $package
    else
        echo "Package '$package' installed"
    fi
done

# Prepare clone riscv-gnu-toolchain
git clone https://github.com/riscv-collab/riscv-gnu-toolchain.git
cd riscv-gnu-toolchain
mkdir 
