FROM httpd:2.4

# Install dependencies
RUN apt-get update && \
    apt-get install -y openssh-server git && \
    mkdir /var/run/sshd

# Set root password
RUN echo 'root:SaharanNotSahara' | chpasswd

# Allow root login via SSH
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Copy website content
COPY ./public-html/ /usr/local/apache2/htdocs/

# Expose both HTTP and SSH ports
EXPOSE 80 22

# Start both Apache and SSHD
CMD service ssh start && httpd-foreground