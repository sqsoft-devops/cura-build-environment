mkdir installer
mkdir build && cd build
cmake -DCMAKE_PREFIX_PATH=../installer -DCMAKE_INSTALL_PREFIX=../installer -DCMAKE_BUILD_TYPE=Release ..
cmake --build .
