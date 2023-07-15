FROM alpine:3.18 AS catch2-dev
WORKDIR /

RUN apk add --no-cache build-base git openssh cmake

RUN wget https://github.com/catchorg/Catch2/archive/refs/tags/v3.3.2.zip -O /catch2.zip && unzip /catch2.zip -d /catch2

WORKDIR /catch2/Catch2-3.3.2
RUN cmake -E make_directory build

WORKDIR /catch2/Catch2-3.3.2/build
RUN cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_LIBDIR=/usr/lib/ /catch2/Catch2-3.3.2
RUN cmake --build . -j4
RUN cmake --install .



FROM catch2-dev AS lexy-catch2-dev

WORKDIR /
RUN wget https://github.com/foonathan/lexy/archive/refs/tags/v2022.12.1.zip -O /lexy.zip && unzip /lexy.zip -d /lexy

WORKDIR /lexy/lexy-2022.12.1/
RUN cmake -E make_directory build

WORKDIR /lexy/lexy-2022.12.1/build
RUN cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_LIBDIR=/usr/lib/ \
    -DLEXY_BUILD_BENCHMARKS=OFF \
    -DLEXY_BUILD_EXAMPLES=OFF \
    -DLEXY_BUILD_TESTS=OFF \
    -DLEXY_BUILD_DOCS=OFF \
		-DLEXY_BUILD_PACKAGE=OFF \
		-DLEXY_ENABLE_INSTALL=ON \
    /lexy/lexy-2022.12.1

RUN cmake --build . -j4
RUN cmake --install .



FROM lexy-catch2-dev AS bython-dev

WORKDIR /
RUN apk add --no-cache llvm16-dev clang16-dev clang16-extra-tools clang16-bash-completion \
    gdb cppcheck

ENTRYPOINT [ "/bin/sh" ]

