# README

## Development setup

- Install ruby-2.7.2 - use whatever ruby manager you want (both rvm and rbenv will work). If you run into any issues finding this version, make sure `ruby-builder` is up to date.

### Dependencies

- Install the dependencies. Installation is OS dependent. You can use `brew` if using a MacOS. On Ubuntu you can use `sudo apt-get install.`
  * Node
  * Yarn
  * Postgres
  * Redis

> ### :exclamation: On Ubuntu and probably other linux distributions
> Yarn: `curl --compressed -o- -L https://yarnpkg.com/install.sh | bash`
>
> Postgres:
>  * Install `postgresql-contrib` and `libpq-dev` along with `postgresql`, see [tutorial][postgres-ubuntu-tutorial].
>  * Make sure you create a new user for yourself with the corresponding privileges.
>  * Create a new user with the password as specified in `database.yml` by using the postgres command `CREATE USER new_user with PASSWORD 'your_super_secret_password';`
>
> Redis:
>  * Install `redis-server`
>  * Edit the `supervised` directive to `systemd`, see [tutorial][redis-ubuntu-tutorial].

- To create a new postgres user
  * Start the postgres CLI (`psql postgres` for macOS)
  * Run `CREATE ROLE nbjc_app LOGIN SUPERUSER PASSWORD 'password1';`

- Start the services.
	> If you installed these with `brew`, you can start them with `brew services start <SERVICE>`. 
	> If you're using Ubuntu, you can check the status of these services with the `sudo systemctl status <SERVICE_NAME>` bash command.
  * Postgres
  * Redis

- Install gems with `bundle install`

### Adding and removing a new model

- If you need to remove a model, first migrate down the relevant version
```sh
rails db:migrate:down VERSION=<NUMBER>
```

- Then destroy the model
```sh
rails destroy model <MODEL_NAME>
```

#### Seeding the database

- If you have a list that you want to seed the database with, first create a file with that list. For example, `indicators.txt`:

```text
ATM
LGBTQ+ Friendly
ASL
Wheelchair Ramp
Gender-neutral Restroom
Black-owned
POC-owned
```

- Convert that easily to paste into a seeding script by running in your terminal:

```sh
cat indicators.txt | awk '{for (i=1;i<NF;i++) {getline}; printf("{name: \x22%s\x22}, ", $0)}'
```

You can paste the output of the output into the seeding script:

```sh
{name: "ATM"}, {name: "ASL"}, {name: "Gender-neutral Restroom"}, {name: "Black-owned"}, {name: "POC-owned"}
```

### Start up the app

- Get the database up and running: `rake db:create`

- Get the schema setup: `rake db:migrate`
> Note: if you make a change in a migration file that has not been committed and do not see the change reflected in the schema run `rake db:rollback` and rerun the migration.

- Start the app: `rails s`

[redis-ubuntu-tutorial]: https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-redis-on-ubuntu-20-04
	[postgres-ubuntu-tutorial]: https://www.digitalocean.com/community/tutorials/how-to-install-postgresql-on-ubuntu-20-04-quickstart
