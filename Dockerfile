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

# Expose both HTTP and SSH ports
EXPOSE 80 22

# Start both Apache and SSHD
CMD service ssh start && nginx -g "daemon off;"