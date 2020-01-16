FROM ubuntu:18.04

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
ENV DISTCCD_PATH=/usr/bin
# ENV OPTIONS --allow 1.1.1.1 --allow 2.2.2.2

RUN apt-get update && apt-get install -y gpg wget && rm -rf /var/lib/apt/lists/*

RUN echo "deb http://ppa.launchpad.net/jonathonf/gcc-9.2/ubuntu bionic main" | tee -a /etc/apt/sources.list.d/gcc.list
RUN echo "deb-src http://ppa.launchpad.net/jonathonf/gcc-9.2/ubuntu bionic main" | tee -a /etc/apt/sources.list.d/gcc.list
#RUN echo "deb http://ppa.launchpad.net/jonathonf/gcc-8.3/ubuntu bionic main" | tee -a /etc/apt/sources.list.d/gcc.list
#RUN echo "deb-src http://ppa.launchpad.net/jonathonf/gcc-8.3/ubuntu bionic main" | tee -a /etc/apt/sources.list.d/gcc.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4AB0F789CBA31744CC7DA76A8CF63AD3F06FC659 

RUN echo "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-9 main" | tee -a /etc/apt/sources.list.d/clang.list
RUN echo "deb-src http://apt.llvm.org/bionic/ llvm-toolchain-bionic-9 main" | tee -a /etc/apt/sources.list.d/clang.list
RUN echo "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-8 main" | tee -a /etc/apt/sources.list.d/clang.list
RUN echo "deb-src http://apt.llvm.org/bionic/ llvm-toolchain-bionic-8 main" | tee -a /etc/apt/sources.list.d/clang.list
RUN echo "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic main" | tee -a /etc/apt/sources.list.d/clang.list
RUN echo "deb-src http://apt.llvm.org/bionic/ llvm-toolchain-bionic main" | tee -a /etc/apt/sources.list.d/clang.list
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -

RUN apt-get update && \
  apt-get install -y distcc gcc gcc-8 gcc-9 g++ g++-8 g++-9 ccache clang clang-8 clang-9 && \
  rm -rf /var/lib/apt/lists/*

EXPOSE 3632
EXPOSE 3633

USER distccd

ENTRYPOINT /usr/bin/distccd --verbose --no-detach --daemon --stats --log-level debug --log-stderr $OPTIONS

