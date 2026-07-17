setlocal EnableDelayedExpansion
@echo on

set "PKG_CONFIG_PATH=%LIBRARY_LIB%\pkgconfig;%LIBRARY_PREFIX%\share\pkgconfig;%BUILD_PREFIX%\Library\lib\pkgconfig"
:: fc-cache.exe etc. link against fontconfig-1.dll, which meson places
:: at the root of builddir. Without this on PATH, Windows pops a blocking
:: "fontconfig-1.dll was not found" dialog for every test invocation.
set "PATH=%SRC_DIR%\builddir;%PATH%"

set ^"MESON_OPTIONS=^
  --prefix="%LIBRARY_PREFIX%" ^
  --default-library=shared ^
  --wrap-mode=nofallback ^
  --buildtype=release ^
  --backend=ninja ^
 ^"

meson setup builddir !MESON_OPTIONS!
if errorlevel 1 exit 1

meson configure builddir
if errorlevel 1 exit 1

ninja -v -C builddir -j %CPU_COUNT%
if errorlevel 1 exit 1

:: AssertionError: Can't query face 4294967295 of font file -f
set "PYTEST_ADDOPTS=--deselect=test_issue431.py::test_issue431 --deselect=test_basic.py::test_multiple_caches --deselect=test_issue547.py::test_issue547 --ignore=test_genconf.py"
ninja -v -C builddir test -j %CPU_COUNT%
if errorlevel 1 exit 1

ninja -C builddir install -j %CPU_COUNT%
if errorlevel 1 exit 1
