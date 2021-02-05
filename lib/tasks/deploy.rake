# use SSHKit directly
require 'sshkit'
require 'sshkit/dsl'
include SSHKit::DSL

# set the identifier used to used to tag our Docker images
deploy_tag = ENV['DEPLOY_TAG']

# set the name of the environment we are deploying to (e.g. staging, production, etc.)
deploy_env = ENV['DEPLOY_ENV'] || :production

# set the location on the server of where we want files copied to and commands executed from, defaults to /home/USER
deploy_path = ENV['DEPLOY_PATH'] || "/home/#{ENV['USER']}"

# connect to server
server = SSHKit::Host.new hostname: ENV['IP'], port: ENV['SERVER_PORT'], user: ENV['USER']

namespace :deploy do
  desc 'copy to server files needed to run and manage Docker containers'
  task :configs do
    on server do
      upload! File.expand_path('../../docker-compose.yml', __dir__), deploy_path
    end
  end
end

namespace :docker do
  desc 'logs into Docker Hub for pushing and pulling'
  task :login do
    on server do
      within deploy_path do
        execute 'docker', 'login', '-u', ENV['DOCKER_USER'], '-p', "'#{ENV['DOCKERHUB_PASSWORD']}'"
      end
    end
  end

  desc 'stops all Docker containers via Docker Compose'
  task stop: 'deploy:configs' do
    on server do
      within deploy_path do
        with rails_env: deploy_env, deploy_tag: deploy_tag do
          execute 'docker-compose', '-f', 'docker-compose.production.yml', 'stop'
        end
      end
    end
  end

  desc 'starts all Docker containers via Docker Compose'
  task start: 'deploy:configs' do
    on server do
      within deploy_path do
        with rails_env: deploy_env, deploy_tag: deploy_tag do
          execute 'docker-compose', '-f', 'docker-compose.yml', 'up', '-d'

          # write the deploy tag to file so we can easily identify the running build
          execute 'echo', deploy_tag , '>', 'deploy.tag'
        end
      end
    end
  end

  desc 'pulls images from Docker Hub'
  task pull: 'docker:login' do
    on server do
      within deploy_path do
          execute 'docker', 'pull', "#{ENV['DOCKER_USER']}/#{ENV['IMAGE_NAME']}:#{deploy_tag}"
      end
    end
  end

  desc 'runs database migrations in application container via Docker Compose'
  task migrate: 'deploy:configs' do
    on server do
      within deploy_path do
        with rails_env: deploy_env, deploy_tag: deploy_tag do
          execute 'docker-compose', '-f', 'docker-compose.yml', 'run', 'app', 'bundle', 'exec', 'rake', 'db:migrate'
        end
      end
    end
  end

  desc 'pulls images, stops old containers, updates the database, and starts new containers'
  task deploy: %w{docker:pull docker:stop docker:migrate docker:start} # pull images manually to reduce down time
end
