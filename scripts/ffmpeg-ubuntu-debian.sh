# FFmpeg compilation for Ubuntu and Debian.
# https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu

apt install -y autoconf automake build-essential libass-dev libfreetype6-dev libtheora-dev libtool libvorbis-dev pkg-config texi2html zlib1g-dev mercurial cmake yasm libx264-dev libmp3lame-dev libopus-dev

# Create a directory for sources.
FFMPEG=~/ffmpeg
SOURCES=${FFMPEG}/sources
BIN=/usr/local/bin
BUILD=${FFMPEG}/build
mkdir -p ${SOURCES} ${BUILD}

cd ${SOURCES} 
hg clone https://bitbucket.org/multicoreware/x265
cd ${SOURCES}/x265/build/linux
PATH="${BIN}:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${BUILD}" -DENABLE_SHARED:bool=off ../../source
make
make install
make distclean
cd x265/build/linux
PATH="${BIN}:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${BUILD}" -DENABLE_SHARED:bool=off ../../source && make && make install && make distclean; cd ${SOURCES}


cd ${SOURCES}
wget -O fdk-aac.tar.gz https://github.com/mstorsjo/fdk-aac/tarball/master
tar xzvf fdk-aac.tar.gz
cd mstorsjo-fdk-aac*
autoreconf -fiv
./configure --prefix="${BUILD}" --disable-shared
make
make install
make distclean


cd ${SOURCES}
wget http://storage.googleapis.com/downloads.webmproject.org/releases/webm/libvpx-1.5.0.tar.bz2
tar xjvf libvpx-1.5.0.tar.bz2
cd libvpx-1.5.0
PATH="${BIN}:$PATH" ./configure --prefix="${BUILD}" --disable-examples --disable-unit-tests
PATH="${BIN}" make
make install
make clean


cd ${SOURCES}
wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg
PATH="${BIN}:$PATH" PKG_CONFIG_PATH="${BUILD}/lib/pkgconfig" ./configure \
  --prefix="${BUILD}" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I${BUILD}/include" \
  --extra-ldflags="-L${BUILD}/lib" \
  --bindir="${BIN}" \
  --enable-gpl \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-nonfree
PATH="${BIN}:$PATH" make
make install
make distclean
hash -r

echo "FFmpeg Compilation is Finished!"






