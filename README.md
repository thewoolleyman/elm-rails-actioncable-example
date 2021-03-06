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

Note that for simplicity, you can only create multiple instances
of the TextualEntity, to illustrate handling lists of multiple
entity instances.

For the NumericEntity, there is only ever exactly one instance of it
in the list, which is automatically created and always has an entityId of 1.

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

* `npm test` (run tests and exit, for use in CI)
* `npm tdd` (resident test autorunner)

If you get Elm compilation errors, try `npm run clean`

NOTE: Tests are not comprehensive.  They are mostly to show an example
of testing in Elm.

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

* Add submit button / spinner to text field
* More test organization and tests: import App to get full compilation, add suites
* Keep history of command failures, only display count and last one
* Can add and delete multiple textual entities
* Can add and delete multiple numeric entities
