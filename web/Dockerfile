# Base image
FROM nginx
# Install dependencies
RUN apt-get update -qq && apt-get -y install apache2-utils
# establish where Nginx should look for files
ENV RAILS_ROOT /var/www/nbjc_app
# Set our working directory inside the image
WORKDIR $RAILS_ROOT
# create log directory
RUN mkdir log
# Copy Nginx config template
COPY web/nginx.conf /tmp/docker.nginx
# substitute variable references in the Nginx config template for real values from the environment 
# put the final config in its place
RUN envsubst '$RAILS_ROOT' < /tmp/docker.nginx > /etc/nginx/conf.d/default.conf
EXPOSE 80
EXPOSE 443
