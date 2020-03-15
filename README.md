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