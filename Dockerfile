FROM httpd:2.4

# Install dependencies
RUN apt-get update && \
    apt-get install -y openssh-server && \
    mkdir /var/run/sshd

# Set root password
RUN echo 'root:SaharanNotSahara' | chpasswd

# Allow root login via SSH
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Copy website content (easy flag)
COPY ./public-html/ /usr/local/apache2/htdocs/

# Install Git
RUN apt-get install -y git

# Configure Git identity
RUN git config --global user.name "Container Chad" && \
    git config --global user.email "chad@localhost"

# Create a repo and commit
WORKDIR /usr/local/apache2/htdocs/
RUN git init
RUN git add * && git commit -m "initial commit"

# Expose both HTTP and SSH ports
EXPOSE 80 22

# Start both Apache and SSHD
CMD service ssh start && httpd-foreground