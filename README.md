
# IRIS Systems Recruitment 2026 – Systems Task Submission

## Assignment Overview

This repository contains the implementation of the IRIS Systems Recruitment 2026 Systems Task.

The objective of this assignment was to deploy a Rails application using Docker containers and progressively extend it with:

- Containerized application deployment
- Database isolation
- Reverse proxy configuration using Nginx
- Load balancing
- Persistent storage
- Docker Compose orchestration
- Rate limiting
- Monitoring using Prometheus & Grafana
- Centralized logging
- Automated backups (Bonus)

Each task was implemented incrementally and documented with screenshots as required.


### Development Strategy

- Each branch represents a fully working stage of the system.
- Every task builds on the previous task’s implementation.
- Features were not developed independently; instead, the system was progressively enhanced.


###Branch Structure

```
main
│
└── task-1-dockerize-rails
    │
    └── task-2-rails-mysql
        │
        └── task-3-nginx-reverse-proxy
            │
            └── task-4-loadbalancing
                │
                └── task-5-persistence
                    │
                    └── task-6-compose-orchestration
                        │
                        └── task-7-rate-limiting
                            │
                            └── task-8-monitoring-solution
                                │
                                ├── task-9-CI-pipeline
                                │
                                └── task-backup-daemon
```




---

## Task 1 – Pack the Rails Application in a Docker Image

### Objective

The goal of this task was to package the provided Rails application into a Docker container image to ensure portability, reproducibility, and environment consistency.

---

### Docker Environment Setup

Docker Desktop was configured with the WSL2 backend to enable Linux container support on Windows.

![Docker Desktop Setup](Submit_Screenshots/task1/(1).png)

---

### Cleaning Previous Docker Images

Before building the new image, existing Docker images were inspected and cleaned to avoid conflicts.

![Docker Images Cleanup](Submit_Screenshots/task1/(2).png)

---

### Inspecting Application Dependencies

The application's `Gemfile` was reviewed to understand required Ruby gems and system dependencies.

![Gemfile Dependencies](Submit_Screenshots/task1/(4).png)

The database configuration was also examined to understand how ActiveRecord connects to the database.

![Database Configuration](Submit_Screenshots/task1/(5).png)

The port that needs to be exposed was also found in config > puma.rb and the entry point of rails app and its structure was also examined.
![Port Configuration](Submit_Screenshots/task1/(6).png)
![App Entry Inspection](Submit_Screenshots/task1/(7).png)

---

### Writing the Dockerfile

A custom Dockerfile was created using the official Ruby base image:

*dockerfile
FROM ruby:3.4.1*

System-level dependencies were installed using apt-get, and the application files were copied into the container. Dependencies were installed using:
RUN bundle install
It woulod be better if we include node during installation too as I observed minute percentage of JavaScript too.
![DockerFile](Submit_Screenshots/task1/(8).png)

###Building the Docker Image

The Docker image was built using:
docker build -t rails-img .

![Dockerimage](Submit_Screenshots/task1/(9).png)

###Errors faced
During the bundle install step, a bundler version mismatch error occurred due to incompatibility between the lockfile and the installed bundler version.

This issue was resolved by ensuring that the correct bundler version compatible with the lockfile was installed inside the container.
![GemfileIssue](Submit_Screenshots/task1/(10).png)

###System-Level Dependency Error
An error occurred stating that libmysqlclient-dev had no installation candidate.

This issue was resolved by replacing the deprecated package with the appropriate MariaDB development library compatible with the Ruby base image.
![DependencyIssue](Submit_Screenshots/task1/(11).png)

###Successfully Running the Rails Server
After resolving dependency issues, the image was successfully built and the Rails server was launched inside the container.
docker run -p 8080:3000 rails-img
![DockerImageShow](Submit_Screenshots/task1/(12).png)
![DockerImage run](Submit_Screenshots/task1/(13).png)


###Runtime Database Connection Error
Upon accessing the application, an ActiveRecord::ConnectionNotEstablished error occurred because the database container had not yet been configured.

This error highlighted the need to separate the database into its own container and configure proper inter-container networking, which is addressed in Task 2.
![Error1](Submit_Screenshots/task1/(14).png)
![logs_of_Error](Submit_Screenshots/task1/(15).png)



## Task 2 – Run Rails & Database in Separate Containers

### Objective
The objective of Task 2 was to separate the Rails application and MySQL database into independent Docker containers and establish proper inter-container communication. This ensures service isolation, improved scalability, and adherence to containerized deployment best practices.


### Initial Docker Compose Setup

A docker-compose.yml file was introduced to orchestrate multiple services. Two containers were defined:

db_cont – running MySQL 8.0  
serv_cont – running the Rails application  

The MySQL container was configured with environment variables such as:

`MYSQL_ROOT_PASSWORD`  
`MYSQL_DATABASE`  

A named Docker volume `db_data` was attached to persist database data at `/var/lib/mysql`.

The Rails container exposed port `8080:3000` and was configured to depend on the database container using `depends_on`.

This setup ensured both containers were started together, but it did not yet guarantee successful database connectivity.

![DBSetup1](Submit_Screenshots/task2/ (1).png)


### Runtime Error – Database Connection Failure

After launching the containers, the Rails application failed with:

ActiveRecord::ConnectionNotEstablished  
"Can't connect to local server through socket '/var/run/mysqld/mysqld.sock'"

This error occurred because Rails was still attempting to connect via a local UNIX socket instead of connecting to the MySQL container over the Docker network.

This highlighted an important concept in containerized environments: services must communicate using Docker service names as hostnames rather than relying on local socket-based connections.

![DBRuntimeError](Submit_Screenshots/task2/ (2).png)


### Updating database.yml to Use Environment Variables

To resolve this issue, the `database.yml` file was modified to dynamically fetch connection details from environment variables.

Instead of hardcoding values, the following configuration was introduced:

host: `<%= ENV["DB_HOST"] %>`  
username: `<%= ENV["DB_USER"] %>`  
password: `<%= ENV["DB_PASSWORD"] %>`  
database: `<%= ENV["DB_NAME"] %>`  

This allowed the Rails container to connect to the MySQL container using the Docker service name (`db_cont`) as the host.

This approach follows Twelve-Factor App principles and ensures that configuration is environment-driven rather than hardcoded inside the application.

![Database.ymlcheck](Submit_Screenshots/task2/ (4).png)


### Running Migrations Inside the Container

After resolving the connection issue, another runtime error indicated pending migrations.

To fix this, migrations were executed inside the Rails container using:

docker compose exec serv_cont rails db:migrate

After running migrations:

- Required tables were created  
- Schema was updated  
- Database structure became synchronized with the application  

This ensured the application database was fully initialized within the containerized environment.

![MigrationsCheck](Submit_Screenshots/task2/ (6).png)


### Successful Application Startup

After correcting the environment configuration and running migrations, the Rails application successfully connected to the MySQL container.

The application became accessible at:

http://localhost:8080

The homepage loaded correctly, confirming that:

- Containers were communicating successfully  
- Database connection was properly established  
- Environment variables were functioning as expected  

![AppStart](Submit_Screenshots/task2/ (5).png)

