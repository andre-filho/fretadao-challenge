#!/bin/bash

bundle check || bundle update

while ! pg_isready -h db -p 5432 -q -U postgres; do
  >&2 echo "___________________________________________"
	>&2 echo "PG IS NOT READY"
  >&2 echo "___________________________________________"

	sleep 1
done

>&2 echo "___________________________________________"
>&2 echo "PG IS UP"
>&2 echo "___________________________________________"


if !(bundle exec rails db:migrate); then
  >&2 echo "___________________________________________"
  >&2 echo "DATABASE DOES NOT EXIST... CREATING..."
  >&2 echo "___________________________________________"

	bundle exec rails db:create
  >&2 echo "___________________________________________"
	>&2 echo "DATABASE CREATED"
  >&2 echo "___________________________________________"

	bundle exec rails db:migrate
  >&2 echo "___________________________________________"
	>&2 echo "DATABASE MIGRATED"
  >&2 echo "___________________________________________"

  bundle exec rails db:seed
  >&2 echo "___________________________________________"
  >&2 echo "DATABASE SEEDED"
  >&2 echo "___________________________________________"

else
  >&2 echo "___________________________________________"
  >&2 echo "DATABASE EXISTS... CONTINUING..."
  >&2 echo "___________________________________________"

	bundle exec rails db:migrate
  >&2 echo "___________________________________________"
	>&2 echo "DATABASE MIGRATED"
  >&2 echo "___________________________________________"

fi

if (cat ./tmp/pids/server.pid); then
  >&2 echo "___________________________________________"
  >&2 echo "SERVER PID EXISTS... REMOVING..."
  >&2 echo "___________________________________________"

  rm ./tmp/pids/server.pid
  >&2 echo "___________________________________________"
  >&2 echo "SERVER PID REMOVED"
  >&2 echo "___________________________________________"

else
  >&2 echo "___________________________________________"
  >&2 echo "SERVER PID DO NOT EXISTS... CREATING PID..."
  >&2 echo "___________________________________________"

fi

echo "___________________________________________"
echo 'STARTING SERVER...'
echo "___________________________________________"


bundle exec rails s -p 3000 -b '0.0.0.0'
