#!/bin/bash
set -ex

if [[ "${target_platform}" == osx-* ]]; then
  export CXXFLAGS="${CXXFLAGS} -DTARGET_OS_OSX=1"
fi

if [[ "${target_platform}" == "${build_platform}" ]]; then
  export CMAKE_ARGS="${CMAKE_ARGS} -DRE2_BUILD_TESTING=ON"
fi

mkdir build
cd build

cmake -GNinja \
    ${CMAKE_ARGS} \
    -DCMAKE_CXX_STANDARD=17 \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=ON \
    ..

cmake --build .

if [[ "${target_platform}" == "${build_platform}" ]]; then
    # same test filter as upstream uses, see
    # https://github.com/google/re2/blob/main/.github/cmake.sh
    ctest --output-on-failure -E "dfa|exhaustive|random"
fi

cmake --install .
