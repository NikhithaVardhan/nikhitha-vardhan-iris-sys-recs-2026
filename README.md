## Task 6 – Docker Compose Orchestration

### Objective

The objective of Task 6 was to unify all services under a single declarative configuration using Docker Compose.

Instead of managing individual containers manually, the entire system — including Rails, MySQL, Nginx, volumes, and networking — was defined inside a single docker-compose.yml file.


### Why Orchestration Was Necessary

By Task 5, the system consisted of multiple interacting components:

- MySQL database container
- One or more Rails application containers
- Nginx reverse proxy
- Persistent Docker volumes

Managing these services individually would be complex and error-prone. Docker Compose allows the entire stack to be described declaratively and launched using a single command.


### Centralized Service Definition

All services were defined inside docker-compose.yml, including:

- Image names
- Environment variables
- Volume mounts
- Port mappings
- Service dependencies
- Network configuration

This ensured that the entire infrastructure could be recreated consistently.


### Service Dependencies

The depends_on directive was used to define startup order between services.

For example:

- Rails depends on MySQL
- Nginx depends on Rails

Although depends_on does not guarantee service readiness, it ensures containers start in logical order.


### Unified Network Configuration

All services were attached to a common Docker network.

This allowed services to communicate using service names instead of IP addresses.

Example:

- Rails connects to MySQL using host: db_cont
- Nginx proxies requests to serv_cont

Docker’s internal DNS handles service name resolution automatically.


### Simplified Deployment

After orchestration was implemented, the entire system could be started using:

docker compose up -d

And stopped using:

docker compose down

This significantly simplified deployment and improved reproducibility.


### Horizontal Scaling Using Docker Compose

Rails containers were scaled using the following command:

docker compose up --scale serv_cont=3 -d

This launched multiple instances of the Rails application service while keeping a single MySQL container.

The scaled containers were automatically attached to the same Docker network and were accessible to Nginx for load balancing.


### Verification

To verify orchestration:

- docker compose ps was executed to confirm all services were running
- Application was accessed through Nginx
- Database connectivity was confirmed
- Volumes were preserved
- Load balancing remained functional

This confirmed that orchestration did not break previous tasks.


### Key Learning from Task 6

This task reinforced important systems concepts:

- Infrastructure as Code
- Declarative system configuration
- Service dependency modeling
- Container lifecycle management
- Reproducible deployments

The system transitioned from a set of individual containers to a fully orchestrated multi-service architecture.
