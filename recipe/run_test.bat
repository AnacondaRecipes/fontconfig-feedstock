
fc-cache --help
fc-cat --help
fc-list --help
fc-match --help
fc-pattern --help
fc-query --help
fc-scan --help
fc-validate --help

REM Test for libraries.
echo "Testing for presence of libfontconfig.a in build output"
test -f "${PREFIX}/lib/libfontconfig.a"
echo "Testing for presence of libfontconfig in build output"
if not exist %PREFIX%/Library/lib/fontconfig.lib exit /b 1 
if not exist %PREFIX%/Library/bin/fontconfig-1.dll exit /b 1

dir %PREFIX%\Library
dir %PREFIX%\Library\lib
if not exist %PREFIX%/Library/pkgconfig/fontconfig.pc exit /b 1
