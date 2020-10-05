#bin/bash
cd /usr/local/src/
apt-get update && apt-get upgrade
apt-get install curl gnupg2 wget git cmake automake autoconf libavformat-dev liblua5.1-0-dev libtool build-essential pkg-config ca-certificates libssl-dev lsb-release systemd-coredump liblz4-tool libz-dev libjpeg-dev libsqlite3-dev libcurl4-openssl-dev libpcre3-dev libswscale-dev php-cli libspeex-dev libspeexdsp-dev libedit-dev libtiff-dev yasm haveged libldns-dev uuid-dev libopus-dev libopusfile-dev libsndfile-dev libshout3-dev libmpg123-dev libmp3lame-dev -y
apt-get install libtool-bin git -y

git config --global pull.rebase true
git clone https://github.com/signalwire/freeswitch.git
cd /usr/local/src/freeswitch 
git checkout v1.10.5
cd /usr/local/src
git clone https://github.com/freeswitch/spandsp.git
cd /usr/local/src/spandsp 
git checkout master
cp /usr/local/src/spandsp /usr/local/src/freeswitch/libs/spandsp -r 
cd /usr/local/src/
git clone https://github.com/freeswitch/sofia-sip.git
cd /usr/local/src/sofia-sip
git checkout master
cp /usr/local/src/sofia-sip /usr/local/src/freeswitch/libs/sofia-sip -r
cd /usr/local/src/

git clone https://github.com/dpirch/libfvad.git
cp /usr/local/src/libfvad /usr/local/src/freeswitch/libs/libfvad -r

git clone https://github.com/warmcat/libwebsockets.git
cd /usr/local/src/libwebsockets && git checkout v3.2-stable
cp /usr/local/src/libwebsockets /usr/local/src/freeswitch/libs/libwebsockets -r
cd /usr/local/src/

git clone https://github.com/davehorton/drachtio-freeswitch-modules.git
cp -r /usr/local/src/drachtio-freeswitch-modules/modules/mod_audio_fork /usr/local/src/freeswitch/src/mod/applications/mod_audio_fork

git clone https://github.com/davehorton/ansible-role-fsmrf.git
cd  /usr/local/src/ansible-role-fsmrf/
git checkout fs-v1.10.5
cd ..
cp /usr/local/src/ansible-role-fsmrf/files/configure.ac.lws /usr/local/src/freeswitch/configure.ac  
cp /usr/local/src/ansible-role-fsmrf/files/Makefile.am.lws /usr/local/src/freeswitch/Makefile.am
cp /usr/local/src/ansible-role-fsmrf/files/modules.conf.in.lws /usr/local/src/freeswitch/build/modules.conf.in
cp /usr/local/src/ansible-role-fsmrf/files/modules.conf.vanilla.xml.lws /usr/local/src/freeswitch/conf/vanilla/autoload_configs/modules.conf.xml

cd /usr/local/src/freeswitch/libs/libwebsockets
mkdir -p build && cd build && cmake .. && make && make install

cd /usr/local/src/freeswitch/libs/libfvad
autoreconf -i && ./configure && make && make install

cd /usr/local/src/freeswitch/libs/spandsp
./bootstrap.sh && ./configure && make && make install

cd /usr/local/src/freeswitch/libs/sofia-sip
./bootstrap.sh && ./configure && make && make install

cd /usr/local/src
 cp /usr/local/src/drachtio-freeswitch-modules/modules/mod_google_transcribe/ /usr/local/src/freeswitch/src/mod/applications/ -r 
 cp /usr/local/src/drachtio-freeswitch-modules/modules/mod_google_tts/ /usr/local/src/freeswitch/src/mod/applications/ -r 
 cp /usr/local/src/drachtio-freeswitch-modules/modules/mod_dialogflow/ /usr/local/src/freeswitch/src/mod/applications/ -r 
 cp /usr/local/src/drachtio-freeswitch-modules/modules/mod_aws_transcribe/ /usr/local/src/freeswitch/src/mod/applications/ -r 

cp /usr/local/src/ansible-role-fsmrf/files/configure.ac.extra /usr/local/src/freeswitch/configure.ac  
cp /usr/local/src/ansible-role-fsmrf/files/Makefile.am.extra /usr/local/src/freeswitch/Makefile.am
cp /usr/local/src/ansible-role-fsmrf/files/modules.conf.in.extra /usr/local/src/freeswitch/build/modules.conf.in
cp /usr/local/src/ansible-role-fsmrf/files/modules.conf.vanilla.xml.extra /usr/local/src/freeswitch/conf/vanilla/autoload_configs/modules.conf.xml

cd /usr/local/src
git clone https://github.com/aws/aws-sdk-cpp.git
cp /usr/local/src/aws-sdk-cpp /usr/local/src/freeswitch/libs/aws-sdk-cpp -r

cd /usr/local/src/freeswitch/libs/aws-sdk-cpp
mkdir -p build && cd build
cmake .. -DBUILD_ONLY=transcribestreaming -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBUILD_SHARED_LIBS=OFF
make

cd /usr/local/src/
git clone https://github.com/grpc/grpc
cd /usr/local/src/grpc 
git checkout v1.24.2
git submodule update --init --recursive
cd /usr/local/src/grpc/third_party/protobuf
./autogen.sh && ./configure && make install
cd /usr/local/src/grpc
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH && make && make install

cd /usr/local/src/
git clone https://github.com/davehorton/googleapis
cd googleapis
git checkout dialogflow-v2-support
cp /usr/local/src/googleapis /usr/local/src/freeswitch/libs/ -r 
cd /usr/local/src/freeswitch/libs/googleapis
LANGUAGE=cpp make

cd /usr/local/src/freeswitch
./bootstrap.sh -j
./configure --with-lws=yes --with-extra=yes

make
make install
