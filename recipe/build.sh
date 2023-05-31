#!/bin/bash
set -ex

if [[ "${target_platform}" == osx-* ]]; then
  export CXXFLAGS="${CXXFLAGS} -DTARGET_OS_OSX=1"
fi

mkdir build-cmake
cd build-cmake

cmake -GNinja \
    ${CMAKE_ARGS} \
    -DCMAKE_CXX_STANDARD=17 \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DRE2_BUILD_TESTING=OFF \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=ON \
    ..

cmake --build .
cmake --install .
