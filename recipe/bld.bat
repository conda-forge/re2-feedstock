@echo on

:: Remove -GL from CXXFLAGS as this causes a fatal error
set "CFLAGS= -MD"
set "CXXFLAGS= -MD"

mkdir -p cmake-build
cd cmake-build

cmake -G "NMake Makefiles" ^
    -DBUILD_SHARED_LIBS=ON ^
    -DCMAKE_CXX_STANDARD=17 ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    ..
if %ERRORLEVEL% neq 0 exit 1

nmake
if %ERRORLEVEL% neq 0 exit 1

ctest -E "dfa|exhaustive|random"
if %ERRORLEVEL% neq 0 exit 1

nmake install
if %ERRORLEVEL% neq 0 exit 1
