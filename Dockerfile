RUN apt-get update && apt-get dist-upgrade --yes
RUN apt-get install --yes git
RUN git clone https://github.com/robdyke/ubuntu-defaults-image-rd.git .
RUN ./build.sh amd64
