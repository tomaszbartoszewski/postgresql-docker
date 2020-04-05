#!/bin/bash

exec 2>/dev/null

echo "Start PostgreSQL and Flyway in Docker Compose"

docker-compose -f docker-compose-postgres.yml up > /dev/null &

COUNT_FILES_TO_EXECUTE=$(ls -1 sql_versions | wc -l)
docker run --rm --network="host" -v $(pwd)/tests:/tests pgtap-tester:latest -h 127.0.0.1 -p 5432 -u example-username -w pass -d db-name -t '/tests/*.sql' -f $COUNT_FILES_TO_EXECUTE  2>&1 | tee test_output.txt

echo "Stop PostgreSQL and Flyway in Docker Compose"
docker-compose -f docker-compose-postgres.yml down -v

TEST_RESULT=$(cat test_output.txt | grep Result: | cut -c9-100)

cat test_output.txt
rm test_output.txt

if [ "$TEST_RESULT" != "PASS" ]
then
    echo "Tests failed"
    exit 1
else
    echo "Tests passed"
    exit 0
fi