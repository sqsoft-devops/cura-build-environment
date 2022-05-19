mkdir installation
mkdir build
cd build 
cmd /k "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
cmake -G "NMake Makefiles" -DCMAKE_PREFIX_PATH=../installation -DCMAKE_INSTALL_PREFIX=../installation -DCMAKE_BUILD_TYPE=Release ..
cmake --build .