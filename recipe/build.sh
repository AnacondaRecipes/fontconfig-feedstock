#!/bin/bash

sed -i.orig s:'@PREFIX@':"${PREFIX}":g src/fccfg.c
export LDFLAGS="$LDFLAGS -L$PREFIX/lib -Wl,-rpath,${PREFIX}/lib"

chmod +x configure

./configure --prefix "${PREFIX}"              \
            --enable-libxml2                  \
            --enable-static                   \
            --disable-docs                    \
            --with-add-fonts=${PREFIX}/fonts

make -j${CPU_COUNT} ${VERBOSE_AT}
make check
make install

# Remove computed cache with local fonts
rm -Rf "${PREFIX}/var/cache/fontconfig"

# Leave cache directory, in case it's needed
mkdir -p "${PREFIX}/var/cache/fontconfig"
touch "${PREFIX}/var/cache/fontconfig/.leave"
