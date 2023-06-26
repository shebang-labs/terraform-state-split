FROM ruby
ENV WORKDIR /terraform
ENV LIBDIR /terraform-state-split
ENV TF_VERSION 1.5.0

################################
# Install Terraform
################################
RUN wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip

# Unzip
RUN unzip terraform_${TF_VERSION}_linux_amd64.zip

# Move to local bin
RUN mv terraform /usr/local/bin/
# Check that it's installed
RUN terraform --version && rm terraform_${TF_VERSION}_linux_amd64.zip

################################
# Install terraform-state-split dependencies
################################
ADD . $LIBDIR

RUN gem install bundler

RUN cd $LIBDIR && bundle install

################################
# Set working directory and run
################################
WORKDIR $WORKDIR
CMD ruby $LIBDIR/resource_mover.rb
