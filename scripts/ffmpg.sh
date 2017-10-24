# #############################################
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# #############################################

# FFmpeg compilation for Ubuntu and Debian.
# https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu

apt-get install -y autoconf automake build-essential libass-dev libfreetype6-dev libtheora-dev libtool libvorbis-dev pkg-config texinfo wget zlib1g-dev yasm libx264-dev libx265-dev libmp3lame-dev libopus-dev libvpx-dev libfdk-aac-dev

# Create a directory for sources.
FFMPEG=${work}/ffmpeg
SOURCES=${FFMPEG}/sources
BIN=/usr/local/bin
BUILD=${FFMPEG}/build
mkdir -p ${SOURCES} ${BUILD}
if [ ! -d ${BIN} ]; then
	mkdir -p ${BIN}
fi

sudo apt-get install -y cmake mercurial
cd ${SOURCES}
hg clone https://bitbucket.org/multicoreware/x265
cd ${SOURCES}/x265/build/linux
PATH="${BIN}${PATH}" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${BUILD}" -DENABLE_SHARED:bool=off ../../source
make
make install

cd ${SOURCES}
wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg
PATH="${BIN}:$PATH" PKG_CONFIG_PATH="${BUILD}/lib/pkgconfig" ./configure \
  --prefix="${BUILD}" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I${BUILD}/include" \
  --extra-ldflags="-L${BUILD}/lib" \
  --extra-libs=-lpthread \
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
PATH="${BIN}:${PATH}" make
make install
make distclean
hash -r

echo "FFmpeg Compilation is Finished!"

