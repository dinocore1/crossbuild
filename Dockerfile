FROM ubuntu:18.04

RUN dpkg --add-architecture i386 && \
  apt-get update -qq \
  && apt-get install -y \
  vim \
  openjdk-8-jdk \
  git \
  cmake \
  g++ \
  mingw-w64 \
  unzip \
  wget \
  wine32 \
  build-essential \
  autoconf automake libtool \
  software-properties-common \
  && rm -rf /var/lib/apt/lists/*


RUN cd opt/ && git clone https://github.com/dinocore1/ZooKeeper.git \
  && cd ZooKeeper && ./gradlew installDist

ENV PATH /opt/ZooKeeper/build/install/zookeeper/bin:${PATH}

####### Android NDK ###############

ENV ANDROID_NDK_HOME /opt/android-ndk
ENV ANDROID_NDK_VERSION r16b

RUN mkdir /opt/android-ndk-tmp && \
    cd /opt/android-ndk-tmp && \
    wget -q https://dl.google.com/android/repository/android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip && \
    unzip -q android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip && \
    mv ./android-ndk-${ANDROID_NDK_VERSION} ${ANDROID_NDK_HOME} && \
    cd ${ANDROID_NDK_HOME} && \
    rm -rf /opt/android-ndk-tmp

ENV PATH ${PATH}:${ANDROID_NDK_HOME}

###########################################

######## Inno Setup ######

RUN add-apt-repository --yes ppa:arx/release && \
    apt-get update -qq && \
    apt-get install -y -q innoextract && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /opt/innosetup && \
    cd /opt/innosetup && \
    wget -O is.exe http://www.jrsoftware.org/download.php/is.exe && \
    innoextract is.exe && \
    mkdir -p /root/.wine/drive_c/inno && \
    cp -a app/* /root/.wine/drive_c/inno && \
    cd / && rm -rf /opt/innosetup

RUN echo '#!/bin/sh\n\
unset DISPLAY\n\
scriptname=$1\n\
[ -f "$scriptname" ] && scriptname=$(winepath -w "$scriptname")\n\
wine "C:\inno\ISCC.exe" "$scriptname" "/q"\n'\
>> /usr/bin/iscc && chmod a+x /usr/bin/iscc

########### MingW 64 Setup #################

COPY assets/x86-win.cmake /root/

ADD https://bitbucket.org/alexkasko/openjdk-unofficial-builds/downloads/openjdk-1.7.0-u80-unofficial-windows-i586-image.zip /opt/
RUN cd /opt && unzip openjdk-1.7.0-u80-unofficial-windows-i586-image.zip && rm openjdk-1.7.0-u80-unofficial-windows-i586-image.zip
