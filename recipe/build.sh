#!/bin/bash
set -e
set -x

builddir="${SRC_DIR}/cmake-build"
mkdir -p ${builddir}
cd ${builddir}

export CXXFLAGS="-fPIC ${CXXFLAGS}"
export CFLAGS="-fPIC ${CFLAGS}"

# Build shared libraries
cmake -DBUILD_SHARED_LIBS=ON \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=${PREFIX} \
      -DCMAKE_OSX_DEPLOYMENT_TARGET="${MACOSX_VERSION_MIN}" \
      "${SRC_DIR}"
make -j "${CPU_COUNT}"
ctest -E "dfa|exhaustive|random"
make -j "${CPU_COUNT}" install

# Build static libraries
cmake -DBUILD_SHARED_LIBS=OFF \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=${PREFIX} \
      -DCMAKE_OSX_DEPLOYMENT_TARGET="${MACOSX_VERSION_MIN}" \
      "${SRC_DIR}"
make -j "${CPU_COUNT}"
make -j "${CPU_COUNT}" install
