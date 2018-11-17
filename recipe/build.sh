#!/bin/bash

CXXFLAGS=$(echo "${CXXFLAGS}" | sed "s/-std=c++17/-std=c++14/g")

./configure \
    --prefix=${PREFIX} \
    --with-optimization=high \
    --without-doxygen
make -j ${CPU_COUNT}
make -j ${CPU_COUNT} check
make -j ${CPU_COUNT} install
