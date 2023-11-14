
install_musl_cross() {
    # Install musl-cross-make
    echo "Installing musl-cross-make..."
    mkdir -p $HOME/opt/cross/x86_64-linux-musl-cross || exit 1

    cp ./dragonos-config-stage1.mak ./config.mak || exit 1

    make clean || exit 1
    make -j $(nproc) || exit 1
    make install || exit 1
    mv ./output/* $HOME/opt/cross/x86_64-linux-musl-cross || exit 1

    # Add musl-cross-make to PATH
    echo "export PATH=\"\$PATH:$HOME/opt/cross/x86_64-linux-musl-cross/bin\"" >> $HOME/.bashrc || exit 1
    echo "export PATH=\"\$PATH:$HOME/opt/cross/x86_64-linux-musl-cross/bin\"" >> $HOME/.zshrc || exit 1
    source $HOME/.bashrc || exit 1
    source $HOME/.zshrc || exit 1
}

build_stage2(){
    echo "Building stage 2..."
    cp ./dragonos-config-stage2.mak ./config.mak || exit 1
    make clean || exit 1
    make -j $(nproc) || exit 1
    make install || exit 1
}

# Check if the toolchain is installed

__TOOLCHAIN_INSTALLED=1
# Check if x86_64-linux-musl-gcc and x86_64-linux-musl-g++ are installed
if ! command -v x86_64-linux-musl-gcc &> /dev/null
then
    echo "x86_64-linux-musl-gcc could not be found."
    __TOOLCHAIN_INSTALLED=0
fi

if ! command -v x86_64-linux-musl-g++ &> /dev/null
then
    echo "x86_64-linux-musl-g++ could not be found"
    __TOOLCHAIN_INSTALLED=0
fi

# Check if the toolchain is installed
if [ $__TOOLCHAIN_INSTALLED -eq 0 ]
then
    install_musl_cross || exit 1
fi

build_stage2 || exit 1

