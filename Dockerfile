FROM ubuntu/nginx

# Install dependencies
RUN apt-get update && \
    apt-get install -y openssh-server

# Add a non-root user
RUN useradd -ms /bin/bash chad
RUN echo 'chad:SaharanNotSahara' | chpasswd
RUN echo 'root:SaharanNotSahara' | chpasswd

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

# Add med flag (3 of 3) as a fake keyring file since docker doesn't support dbus to use an actual keyring
RUN mkdir -p /root/.local/share/keyrings && \
    echo "FLAG_PART_3: k1ngd0m}" > /root/.local/share/keyrings/gnome-keyring.login.secret

# Create a fake secret-tool to access the keyring
COPY secret-tool.c /usr/local/bin/
RUN apt-get install -y build-essential
RUN gcc /usr/local/bin/secret-tool.c -o /usr/local/bin/secret-tool && \
    chown root:root /usr/local/bin/secret-tool && \
    chmod 4755 /usr/local/bin/secret-tool
RUN rm /usr/local/bin/secret-tool.c

# Create a man page for the fake secret-tool
RUN apt-get install -y man-db
COPY secret-tool.1 /opt/fake-man/secret-tool.1
RUN echo -e '#!/bin/sh\nless /opt/fake-man/$1.1' > /usr/local/bin/man && chmod +x /usr/local/bin/man

# Start logging
RUN apt-get install -y rsyslog
RUN echo 'export PROMPT_COMMAND='\''RETRN_VAL=$?; logger -p local1.info "USER=$(whoami) PWD=$PWD CMD=test"'\''' >> /home/chad/.bashrc
RUN echo 'local1.* @10.0.30.161:5555' >> /etc/rsyslog.conf

# Expose both HTTP and SSH ports
EXPOSE 80 22

# Restrict grep to root
RUN chown root:root /usr/bin/grep
RUN chmod 700 /usr/bin/grep

# Start both Apache and SSHD
CMD rsyslogd && service ssh start && nginx -g "daemon off;"