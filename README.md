# Elm Rails Actioncable Example

An example app showing multi-client concurrent updates of shared
persistent state via websockets implemented with [Elm](http://elm-lang.org/)
and [Rails Actioncable](https://github.com/rails/rails/tree/master/actioncable)
(no locking or conflict detection)

Also illustrates [Command Query Responsibility Segregation](http://martinfowler.com/bliki/CQRS.html)
and (a form of) [Event Sourcing](http://martinfowler.com/eaaDev/EventSourcing.html)

The functionality of the app is to update two different types
of Domain Entities: a TextualEntity which contains a single string field,
and a NumericEntity which contains a single number (integer) field.

Note that for simplicity, there is only one instance of each type of entity,
so there's no concept of IDs or processing multiple entities of the same type.

## Requirements

* Ruby >= 2.3
* Bundler >= 1.12
* Rails >= 5.0.0.rc1
* Postgres (used for persistence as well as pubsub backing for Actioncable)

## Installing/fixing postgres on OSX

```
brew update

brew install postgresql
# or
brew upgrade postgresql

brew info postgresql # follow instructions to run on boot

# DANGEROUS!
rm -rf /usr/local/var/postgres

initdb /usr/local/var/postgres -E utf8
```

## App Setup

* `bin/setup`

## Running App in Dev Env

* `bin/start`
* Open two different browsers to http://127.0.0.1:3000 (NOT localhost!)
* Type into all of them, data is synchronized
* Close them and reopen, state is persistent
* Run `bin/setup` to reset state (by recreating databases)

## Running App in Simulated Production Env

(Note: Foreman defaults to using port 5000)

* `RAILS_ENV=production rake db:create`
* `RAILS_ENV=production rake db:migrate`
* In a new terminal: `tail -f log/*`

```
bin/start-local-prod
```

* App Server: [127.0.0.1:5000](http://127.0.0.1:5000)

Flags for debugging local prod env:

```
SKIP_EAGER_LOAD=true SKIP_CACHE_CLASSES=true bin/start-local-prod
```

## Running Elm Test Suite

* `npm test` (run and exit, for use in CI)
* `npm run tdd` ("autorunner", requires `brew install watch`)

If you get Elm compilation errors, try `npm run clean`

## Deploying to CloudFoundry

* `cf login`, enter email, password, org, and space.
* `cf push elm-rails-actioncable-example`
* Initial setup only (app still needs setup to run):
  * Add ElephantSQL Postgres service - any instance name, same space/app
  * cf restage elm-rails-actioncable-example

## How app was initially created

* Ensure proper ruby/rails version is being used
* `rails new elm-rails-actioncable-example --api --no-skip-action-cable --skip-test --skip-action-mailer`

# TODO:

* (done) Per-client cable connections, so only new clients receive getEventsSince.
  See http://edgeguides.rubyonrails.org/action_cable_overview.html#server-side-components-connections
* (done) Split out client connection state to sub-record and separate namespace
* (done for events since channel) Do not attempt send outbound port requests if connection is down (test in prod_local)
* Make update function handle commands generically by event, not per command.
* Add coloring to connection state - green/red.
