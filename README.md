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
>
> Redis:
>  * Install `redis-server`
>  * Edit the `supervised` directive to `systemd`, see [tutorial][redis-ubuntu-tutorial]. Follow the tutorial to the end of step 3, don't set a redis password.

- Create a new user with the password see `database.yml`.
  * Open the postgres console `psql postgres`
  * Check all your users and roles using the `du` postgres command
  * If you don't have a user you can create one by using the postgres command `CREATE USER new_user with PASSWORD 'your_super_secret_password';`
  * Create the role for the app using `CREATE ROLE nbjc_app LOGIN SUPERUSER PASSWORD 'pw_from_database_yml';`
  > NOTE: Don't forget to update the database.yml file if you are using a different pw.

- Start the services.
	> If you installed these with `brew`, you can start them with `brew services start <SERVICE>`. 
	> If you're using Ubuntu, you can check the status of these services with the `sudo systemctl status <SERVICE_NAME>` bash command.
  * Postgres
  * Redis

- Install gems with `bundle install`
- Check your local env setup with `config/local_env.yml.example`

### Start up the app

- Get the database up and running: `rake db:create`

- Get the [schema][schema] setup: `rake db:migrate`
> Note: if you make a change in a migration file that has not been committed and do not see the change reflected in the schema run `rake db:rollback` and rerun the migration.

- Seed the database" `rake db:seed`
> If you need to drop the database and reseed use `rake db:reset`

- Start the app: `rails s`

#### Seeding the database

- All CSV files under `db/seed_data/` will automatically be used to seed the DB
- To add seeding data for a new table, create a new file under the mentioned directory that matches the table name
- All CSV files in the directory must contain a header row and columns matching (at least) all required fields
- See `db/seed_data/languages.csv` (which will seed the `languages` table) for an example

#### Test the routes

- To get a full list of available routes check `rails routes`

##### Mocked routes

- Filtered by indicators with id 1 and 2 (ATM and ASL): [api/v1/spaces?price=3&search=bakery][bakeries]
- A single space's details: [api/v1/space/1][fake-space-details]
- All indicators: [api/v1/indicators][indicators]

### Adding and removing a new model

- If you need to remove a model, first migrate down the relevant version
```sh
rails db:migrate:down VERSION=<NUMBER>
```

- Then destroy the model
```sh
rails destroy model <MODEL_NAME>
```

##### Spaces
<div>
<table>
  <tr>
    <td>Endpoint</td>
    <td>Description</td>
    <td>Payload (JSON)</td>
    <td>Example Resonse</td>
  </tr>
  <tr>
    <td><pre>POST /api/v1/spaces</pre></td>
    <td>Create a new space, for a list of the fields and their types, refer to the schema and descriptions [here][schema-sheet]</td>
    <td>
      <pre lang="json">
{
    "space": {
        "provider_urn": "yelp:bxU7CnSO9cFhq_1tQyX40A",
        "provider_url": "https://www.yelp.com/biz/name",
        "name": "787 Coffee",
        "price_level": 2, 
        "address_attributes": {
            "address_1": "131 E 7th St",
            "address_2": "",
            "city": "New York",
            "postal_code": "10009",
            "country": "US",
            "state": "NY"
        },
        "languages_attributes": [
            {
                "name": "Polish"
            }
        ],
        "indicators_attributes": [
            {
                "id": 2
            }
        ],
        "photos_attributes": [
            {
                "url": "https://s3-media2.fl.yelpcdn.com/photo.jpg",
                "cover": true
            }
        ],
        "reviews_attributes": [
            {
                "anonymous": true,
                "vibe_check": 3,
                "rating": 4,
                "content": "This is a great place."
            }
        ],
        "phone": "+16466492774",
        "hours_of_op": {
            "open": [
                {
                    "is_overnight": false,
                    "start": "0800",
                    "end": "1500",
                    "day": 0
                }
            ]
        }
    }
}
      </pre>
    </td>
    <td><pre>201 success</pre></td>
  </tr>
    <tr>
    <td><pre>GET /api/v1/spaces/:space_id</pre></td>
    <td>Get a space's details</td>
    <td>Includes all possible fields</td>
    <td>See the mock response for a fake space <pre>/spaces/1</pre></td>
  </tr>
  <tr>
    <td><pre>GET /api/vi/spaces?search=terms and filtering</pre></td>
    <td>Get all spaces with the search terms in their names</td>
    <td>The search terms should be the values for the "search" key, the price between 1-4 and the indicators should be an array of indicator ids.
	      <pre lang="json">
			  {
				  "search": "bakery",
				  "filtering": {
					  "price": 2,
					  "indicators": [1, 2]
				  }
			  }
		  </pre>
	</td>
    <td>See this the mock for <pre>api/v1/spaces?price=3&search=bakery</pre></td>
  </tr>
  <tr>
    <td>PUT /api/v1/spaces/:space_id</td>
    <td>Update a space's details</td>
    <td>See the POST route for available fields for update</td>
    <td>202 Success</td>
  </tr>
    <tr>
    <td>DELETE /api/v1/spaces/:space_id</td>
    <td>Deletes a space</td>
    <td>Only admins will be able to delete a space</td>
    <td>204 Success</td>
  </tr>
</table>
</div>

# Authentication and Authorization

## Auth0
Diagram for login [here][auth-flow]

### Testing
- To get a bearer token for testing, login to the auth0 dashboard, navigate to the nbjc-app API and on the testing tab follow the instructions.


## Running tests
`rspec`

## Deployment

You can find the build pipeline in the circleci dashboard. Reach out in Slack for the pipeline link. Deployments only happen for tagged versions. See the circleci config in the `.circleci` folder.
- See the tagging guidelines [here][tagging]

### Contribution
- A PR can only be merged when both build and test circleci jobs pass.

# Authentication and Authorization

## Auth0
Diagram for login [here][auth-flow]

### Testing
- To get a bearer token for testing, login to the auth0 dashboard, navigate to the nbjc-app API and on the testing tab follow the instructions.



[redis-ubuntu-tutorial]: https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-redis-on-ubuntu-20-04
[postgres-ubuntu-tutorial]: https://www.digitalocean.com/community/tutorials/how-to-install-postgresql-on-ubuntu-20-04-quickstart
[schema]: https://github.com/outintech/nbjc-app/blob/main/db/schema.rb
[fake-space-details]: https://00895f10-199e-4807-b94f-a924c303a692.mock.pstmn.io/api/v1/spaces/1
[bakeries]: https://00895f10-199e-4807-b94f-a924c303a692.mock.pstmn.io/api/v1/spaces
[indicators]: https://00895f10-199e-4807-b94f-a924c303a692.mock.pstmn.io/api/v1indicators
[schema-sheet]: https://docs.google.com/spreadsheets/d/1825fpT5UzzrGEKcjvgeZmKQ9xdnfNUvj3xu11WbTxKQ/edit?usp=sharing
[tagging]: https://git-scm.com/book/en/v2/Git-Basics-Tagging
[auth-flow]: https://auth0.com/docs/flows/authorization-code-flow-with-proof-key-for-code-exchange-pkce

