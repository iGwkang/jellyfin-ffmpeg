#!/bin/bash

SCRIPT_REPO="https://github.com/madler/zlib.git"
SCRIPT_COMMIT="15c45adb76e81a7e3a8a9e17b2a56eb90f668f44"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" zlib
    cd zlib

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --static
    )

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        export CC="${FFBUILD_CROSS_PREFIX}gcc"
        export AR="${FFBUILD_CROSS_PREFIX}ar"
    else
        echo "Unknown target"
        return -1
    fi

    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install
}

ffbuild_configure() {
    echo --enable-zlib
}

ffbuild_unconfigure() {
    echo --disable-zlib
}
