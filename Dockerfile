FROM debian:12-slim

RUN apt update

# Set up the non-interactive mode to avoid prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for adding repositories and downloading packages
RUN apt install -y --no-install-recommends gnupg2 software-properties-common wget

# Add repository for the latest Python
RUN wget -qO - https://www.python.org/ftp/python/key.asc | gpg --dearmor > python.gpg
RUN mv python.gpg /usr/share/keyrings/
RUN echo "deb [signed-by=/usr/share/keyrings/python.gpg] https://www.python.org/ftp/python $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/python.list > /dev/null

# Add repository for FFmpeg
RUN apt install -y --no-install-recommends lsb-release
RUN wget -qO - https://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2021.12.26_all.deb -O /tmp/deb-multimedia-keyring.deb
RUN dpkg -i /tmp/deb-multimedia-keyring.deb && rm /tmp/deb-multimedia-keyring.deb
RUN echo "deb [signed-by=/usr/share/keyrings/python.gpg] https://www.deb-multimedia.org $(lsb_release -sc) main non-free" | tee /etc/apt/sources.list.d/deb-multimedia.list > /dev/null

RUN apt update

WORKDIR /env

CMD ["bash"]
