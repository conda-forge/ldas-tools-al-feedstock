:: use local build folder
mkdir build
cd build

:: configure
cmake .. ^
	-G "NMake Makefiles" ^
	-DCMAKE_BUILD_TYPE=Release ^
	-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=true ^
	-DCMAKE_INSTALL_PREFIX:PATH="%LIBRARY_PREFIX%"
if errorlevel 1 exit 1

:: build
cmake --build . --parallel %CPU_COUNT%
if errorlevel 1 exit 1

:: test
ctest -V
if errorlevel 1 exit 1

:: install
cmake --build . --target install --parallel %CPU_COUNT%
if errorlevel 1 exit 1
