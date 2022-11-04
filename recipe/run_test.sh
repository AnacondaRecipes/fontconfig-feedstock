#!/bin/bash -ex

# Test CLI.
fc-cache --help
fc-cat --help
fc-list --help
fc-match --help
fc-pattern --help
fc-query --help
fc-scan --help
fc-validate --help

# Test for libraries.
echo "Testing for presence of libfontconfig.a in build output"
echo ${target_platform}
test -f "${PREFIX}/lib/libfontconfig.a"
if [[ ${target_platform} == osx-* ]]; then # osx-*?
    echo "Testing for presence of libfontconfig.dylib in build output"
    test -f "${PREFIX}/lib/libfontconfig.dylib"
else
    echo "Testing for presence of libfontconfig.so in build output"
    test -f "${PREFIX}/lib/libfontconfig.so"
fi

# Test for correct parsing of font .conf files.
# This should not give anything to sterr (for example, "invalid doctype "fontconfig"", see PR #6.
echo "Testing for correct parsing of font .conf files"
fc-list 2> /dev/stdout 1> /dev/null | (if grep .; then exit -1; fi)
