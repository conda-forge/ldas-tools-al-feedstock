#!/bin/bash

mkdir -p _build
pushd _build

# link librt to get clock_gettime on older glibc versions
if [ "$(uname)" == "Linux" ]; then
	export LDFLAGS="-lrt ${LDFLAGS}"
fi

# set OSX_ARCHITECTURES on OSX
if [ "$(uname)" == "Darwin" ]; then
	export CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_OSX_ARCHITECTURES:STRING=${OSX_ARCH}"
fi

# configure
cmake \
	${SRC_DIR} \
	${CMAKE_ARGS} \
	-DCMAKE_BUILD_TYPE=RelWithDebInfo \
	-DCMAKE_CROSSCOMPILING_EMULATOR:STRING="${CMAKE_CROSSCOMPILING_EMULATOR}" \
	-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=true \
;

# build
cmake --build . --parallel ${CPU_COUNT} --verbose

# test
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
	ctest --parallel ${CPU_COUNT} --verbose
fi

cmake --build . --parallel ${CPU_COUNT} --verbose --target install
