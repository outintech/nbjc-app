FROM ruby:2.7.2
MAINTAINER devs@outintech.com

ARG USER_ID
ARG GROUP_ID
ARG RAILS_MASTER_KEY

RUN addgroup --gid $GROUP_ID user
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user

# Set an environment variable where the Rails app is installed to inside of Docker image
ENV RAILS_ROOT /var/www/nbjc_app
RUN mkdir -p $RAILS_ROOT 

# nodejs
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg -o /root/yarn-pubkey.gpg && apt-key add /root/yarn-pubkey.gpg
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y --no-install-recommends nodejs yarn

# Set working directory
WORKDIR $RAILS_ROOT
# Setting env up
ENV RAILS_ENV='production'
ENV RACK_ENV='production'
ENV RAILS_MASTER_KEY ${RAILS_MASTER_KEY}

# Adding gems
RUN gem install rails bundler
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle config set without 'development test'
RUN bundle install --jobs 20 --retry 5

# Adding project files
COPY . .
RUN chown -R user:user /var/www/nbjc_app
USER $USER_ID
RUN yarn install --check-files
VOLUME ["$INSTALL_PATH/public"]

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
ENTRYPOINT ["entrypoint.sh"]

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
