#!/bin/bash

DATABASE=
HOST=
PORT=
USER=
PASSWORD=
TESTS=
FLYWAY_SCRIPTS_COUNT=

function usage() { echo "Usage: $0 -h host -d database -p port -u username -w password -t tests -f number of flyway scripts" 1>&2; exit 1; }

while getopts d:h:p:u:w:t:f: OPTION
do
  case $OPTION in
    d)
      DATABASE=$OPTARG
      ;;
    h)
      HOST=$OPTARG
      ;;
    p)
      PORT=$OPTARG
      ;;
    u)
      USER=$OPTARG
      ;;
    w)
      PASSWORD=$OPTARG
      ;;
    t)
      TESTS=$OPTARG
      ;;
    f)
      FLYWAY_SCRIPTS_COUNT=$OPTARG
      ;;
    *)
      usage
      ;;
  esac
done

if [[ -z $DATABASE ]] || [[ -z $HOST ]] || [[ -z $PORT ]] || [[ -z $USER ]] || [[ -z $TESTS ]]
then
  usage
  exit 1
fi

#waiting for postgres
while ! curl http://$HOST:$PORT/ 2>&1 | grep "52"
do
    echo "Waiting for PostgreSQL..."
    sleep 1
done

APPLIED_SCRIPTS=0
echo "$FLYWAY_SCRIPTS_COUNT scripts to apply"
while [ "$APPLIED_SCRIPTS" -ne "$FLYWAY_SCRIPTS_COUNT" ]
do
    echo "Waiting for Flyway to finish"
    APPLIED_SCRIPTS_RESPONSE=$(PGPASSWORD=$PASSWORD psql -h $HOST -p $PORT -U $USER -d $DATABASE -t -c 'SELECT count(DISTINCT script) FROM flyway_schema_history;' | tr -d '[:space:]')
    if [ ! -z "$APPLIED_SCRIPTS_RESPONSE" ]; then
        APPLIED_SCRIPTS=$APPLIED_SCRIPTS_RESPONSE
        echo "$APPLIED_SCRIPTS scripts executed already"
    fi
    sleep 1
done

echo "Postgres is ready, installing pgTAP"
PGPASSWORD=$PASSWORD psql -h $HOST -p $PORT -d $DATABASE -U $USER -f /usr/local/share/postgresql/extension/pgtap.sql > /dev/null

rc=$?
# exit if pgtap failed to install
if [[ $rc != 0 ]] ; then
  echo "pgTap was not installed properly. Unable to run tests!"
  exit $rc
fi

echo "pgTAP installed, running tests: $TESTS"
# run the tests
PGPASSWORD=$PASSWORD pg_prove -h $HOST -p $PORT -d $DATABASE -U $USER $TESTS
rc=$?
# exit with return code of the tests
exit $rc
