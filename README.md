## Running PostgreSQL and Flyway in Docker

To run PostgreSQL in Docker and apply schema using flyway, you have to run:
```
./run_in_docker.sh
```

Press Ctrl+C when you no longer need db to run. To remove instance from your local machine run:
```
./destroy_docker_instance.sh
```

If you want to read more about this repo, check this [blog post](https://writeitdifferently.com/postgresql/flyway/2020/03/15/running-postgresql-and-flyway-with-docker-compose.html).

## Used materials

For this repo I used other's work, you can find it here:
https://github.com/docker-library/postgres/issues/306#issuecomment-345063809
https://github.com/walm/docker-pgtap
https://medium.com/engineering-on-the-incline/unit-testing-postgres-with-pgtap-af09ec42795
https://medium.com/engineering-on-the-incline/unit-testing-functions-in-postgresql-with-pgtap-in-5-simple-steps-beef933d02d3

pgTAP documentation https://pgtap.org/