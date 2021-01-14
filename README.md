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
> Postgres:
>  * Install `postgresql-contrib` and `libpq-dev` along with `postgresql`, see [tutorial][postgres-ubuntu-tutorial].
>  * Make sure you create a new user for yourself with the corresponding privileges.
>  * Create a new user with the password as specified in `database.yml` by using the postgres command `CREATE USER new_user with PASSWORD 'your_super_secret_password';`
> Redis:
>  * Install `redis-server`
>  * Edit the `supervised` directive to `systemd`, see [tutorial][redis-ubuntu-tutorial].

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

- Get the [schema][schema] setup: `rake db:migrate`
> Note: if you make a change in a migration file that has not been committed and do not see the change reflected in the schema run `rake db:rollback` and rerun the migration.

- Seed the database" `rake db:seed`
> If you need to drop the database and reseed use `rake db:reset`

- Start the app: `rails s`

#### Test the routes

- To get a full list of available routes check `rails routes`

##### Mocked routes

- Filtered by indicators with id 1 and 2 (ATM and ASL): [api/v1/spaces?price=3&search=bakery][bakeries]
- A single space's details: [api/v1/space/1][fake-space-details]
- All indicators: [api/v1/indicators][indicators]

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
</table>
</div>


[redis-ubuntu-tutorial]: https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-redis-on-ubuntu-20-04
[postgres-ubuntu-tutorial]: https://www.digitalocean.com/community/tutorials/how-to-install-postgresql-on-ubuntu-20-04-quickstart
[schema]: https://github.com/outintech/nbjc-app/blob/main/db/schema.rb
[fake-space-details]: https://00895f10-199e-4807-b94f-a924c303a692.mock.pstmn.io/api/v1/spaces/1
[bakeries]: https://00895f10-199e-4807-b94f-a924c303a692.mock.pstmn.io/api/v1/spaces
[indicators]: https://00895f10-199e-4807-b94f-a924c303a692.mock.pstmn.io/api/v1indicators
[schema-sheet]: https://docs.google.com/spreadsheets/d/1825fpT5UzzrGEKcjvgeZmKQ9xdnfNUvj3xu11WbTxKQ/edit?usp=sharing
