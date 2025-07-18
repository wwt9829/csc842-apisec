FROM ubuntu/nginx

# Install dependencies
RUN apt-get update && \
    apt-get install -y openssh-server

# Set root password
RUN echo 'root:SaharanNotSahara' | chpasswd

# Add a non-root user
RUN useradd -ms /bin/bash chad
RUN echo 'chad:SaharanNotSahara' | chpasswd

# Allow root login via SSH
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Copy website content (easy flag)
COPY ./public-html/ /var/www/html

# Install git
RUN apt-get install -y git

# Configure git identity
RUN git config --global user.name "Container Chad" && \
    git config --global user.email "chad@localhost"

# Create a repo and a commit
WORKDIR /var/www/html
RUN git init
RUN git add * && git commit -m "initial commit"

# Add the .gitignore and med flag (1 of 3) as a file
COPY copywrong /usr/share/doc/base-files/
COPY .gitignore /var/www/html

# Add med flag (2 of 3) as environment variable
RUN echo 'FLAG_PART_2=_t0_th3_' >> /etc/environment

# Create a fake keyring file and fake secret-tool since docker doesn't support dbus
RUN mkdir -p /root/.local/share/keyrings && \
    echo "FLAG_PART_3: k1ngd0m}" > /root/.local/share/keyrings/gnome-keyring.login.secret && \
    echo -e '#!/bin/sh\nif [ "$1" = "lookup" ]; then\n  cat /root/.local/share/keyrings/gnome-keyring.login.secret\nelse\n  echo "Usage: secret-tool lookup <attr> <value>" >&2; exit 1\nfi' > /usr/local/bin/secret-tool && \
    chmod u+s,+x /usr/local/bin/secret-tool

# Create a fake man page for the fake secret-tool
RUN apt-get install -y man-db
COPY secret-tool.1 /opt/fake-man/secret-tool.1
RUN echo -e '#!/bin/sh\nless /opt/fake-man/$1.1' > /usr/local/bin/man && chmod +x /usr/local/bin/man

# Expose both HTTP and SSH ports
EXPOSE 80 22

# Start both Apache and SSHD
CMD service ssh start && nginx -g "daemon off;"