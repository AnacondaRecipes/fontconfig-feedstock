#!/bin/bash

# Get an updated config.sub and config.guess
cp -r ${BUILD_PREFIX}/share/libtool/build-aux/config.* .

sed -i.orig s:'@PREFIX@':"${PREFIX}":g src/fccfg.c

# So that -Wl,--as-needed works (sorted to appear before before libs)
autoreconf -vfi

# Get an updated config.sub and config.guess
cp -r ${BUILD_PREFIX}/share/libtool/build-aux/config.* .

# See:
# https://github.com/Homebrew/homebrew-core/blob/master/Formula/fontconfig.rb
# https://bugs.freedesktop.org/show_bug.cgi?id=105366
if [[ ${target_platform} == osx-64 ]]; then
  # NOTE: conda-forge's recipe does not include the next three lines to avoid
  # linking to their libuuid, but that may be due to differences between their
  # `util-linux` version and our `libuuid`-project one.
  export UUID_CFLAGS=" "
  export UUID_LIBS=" "
  # `true` here to avoid error in shell conditional.
  sed -i -e 's|PKGCONFIG_REQUIRES_PRIVATELY=\"\$PKGCONFIG_REQUIRES_PRIVATELY uuid\"|true|g' configure

  FONT_DIRS=--with-add-fonts="${PREFIX}"/fonts,/System/Library/Fonts,/Library/Fonts,~/Library/Fonts,/System/Library/Assets/com_apple_MobileAsset_Font3,/System/Library/Assets/com_apple_MobileAsset_Font4
else
  FONT_DIRS=--with-add-fonts="${PREFIX}"/fonts
fi

./configure --prefix="${PREFIX}"                \
            --enable-libxml2                    \
            --enable-static                     \
            --disable-docs                      \
            "${FONT_DIRS}"


make -j${CPU_COUNT} ${VERBOSE_AT}
make install

make check ${VERBOSE_AT}

# Remove computed cache with local fonts
rm -Rf "${PREFIX}"/var/cache/fontconfig

# Leave cache directory, in case it's needed
mkdir -p "${PREFIX}"/var/cache/fontconfig
touch "${PREFIX}"/var/cache/fontconfig/.leave
