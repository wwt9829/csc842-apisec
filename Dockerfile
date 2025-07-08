FROM ubuntu/nginx

# Install dependencies
RUN apt-get update && \
    apt-get install -y openssh-server

# Set root password
RUN echo 'root:SaharanNotSahara' | chpasswd

# Allow root login via SSH
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Copy website content (easy flag)
COPY ./public-html/ /var/www/html

# Install Git
RUN apt-get install -y git

# Configure Git identity
RUN git config --global user.name "Container Chad" && \
    git config --global user.email "chad@localhost"

# Create a repo and commit
WORKDIR /var/www/html
RUN git init
RUN git add /var/www/html/index.html && git commit -m "initial commit"

# Add the .gitignore and med flag (1 of 3) as a file
COPY copywrong /usr/share/doc/base-files/
COPY .gitignore /var/www/html

# Add med flag (2 of 3) as environment variable
ENV FLAG_PART_2="(2/3)_t0_th3_"
RUN export FLAG_PART_2="(2/3)_t0_th3_"

# Expose both HTTP and SSH ports
EXPOSE 80 22

# Create a believable keyring file and fake secret-tool script
RUN mkdir -p /root/.local/share/keyrings && \
    echo "flag{3/3}_k3y!" > /root/.local/share/keyrings/gnome-keyring.login.secret && \
    echo -e '#!/bin/sh\nif [ "$1" = "lookup" ]; then\n  cat /root/.local/share/keyrings/gnome-keyring.login.secret\nelse\n  echo "Usage: secret-tool lookup <attr> <value>" >&2; exit 1\nfi' > /usr/local/bin/secret-tool && \
    chmod +x /usr/local/bin/secret-tool

# Restore man page support
RUN apt-get install -y man-db
COPY secret-tool.1 /opt/fake-man/secret-tool.1
RUN echo -e '#!/bin/sh\nless /opt/fake-man/$1.1' > /usr/local/bin/man && chmod +x /usr/local/bin/man

# Start both Apache and SSHD
CMD service ssh start && nginx -g "daemon off;" && export FLAG_PART_2="(2/3)_t0_th3_"