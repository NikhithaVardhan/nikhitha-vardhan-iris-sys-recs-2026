
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






## Branch-Level Documentation

Each task was implemented in a dedicated branch, and every branch contains:

- Its own README.md file
- Relevant configuration files
- Step-by-step implementation details
- Task-specific screenshots

This allows reviewers to examine the system evolution stage by stage without ambiguity.

Direct branch links are provided below:

## Branch Links

Each task was implemented in a dedicated branch as shown below:

| Task | Description | Branch Link |
|------|------------|-------------|
| Task 1 | Dockerize Rails Application | [task-1-dockerize-rails](https://github.com/NikhithaVardhan/nikhitha-vardhan-iris-sys-recs-2026/tree/task-1-dockerize-rails) |
| Task 2 | Rails + MySQL Containers | [task-2-rails-mysql](https://github.com/NikhithaVardhan/nikhitha-vardhan-iris-sys-recs-2026/tree/task-2-rails-mysql) |
| Task 3 | Nginx Reverse Proxy | [task-3-nginx-reverse-proxy](https://github.com/NikhithaVardhan/nikhitha-vardhan-iris-sys-recs-2026/tree/task-3-nginx-reverse-proxy) |
| Task 4 | Load Balancing | [task-4-loadbalancing](https://github.com/NikhithaVardhan/nikhitha-vardhan-iris-sys-recs-2026/tree/task-4-loadbalancing) |
| Task 5 | Persistence | [task-5-persistence](https://github.com/NikhithaVardhan/nikhitha-vardhan-iris-sys-recs-2026/tree/task-5-persistence) |
| Task 6 | Compose Orchestration | [task-6-compose-orchestration](https://github.com/NikhithaVardhan/nikhitha-vardhan-iris-sys-recs-2026/tree/task-6-compose-orchestration) |
| Task 7 | Rate Limiting | [task-7-rate-limiting](https://github.com/NikhithaVardhan/nikhitha-vardhan-iris-sys-recs-2026/tree/task-7-rate-limiting) |
| Task 8 | Monitoring Stack | [task-8-monitoring-solution](https://github.com/NikhithaVardhan/nikhitha-vardhan-iris-sys-recs-2026/tree/task-8-monitoring-solution) |
| Bonus | CI Pipeline | [task-9-CI-pipeline](https://github.com/NikhithaVardhan/nikhitha-vardhan-iris-sys-recs-2026/tree/task-9-CI-pipeline) |
| Bonus | Backup Daemon | [task-backup-daemon](https://github.com/NikhithaVardhan/nikhitha-vardhan-iris-sys-recs-2026/tree/task-backup-daemon) |



## Conclusion

This assignment demonstrates the end-to-end deployment of a containerized Rails application extended with networking, persistence, monitoring, automation, and backup capabilities.

Rather than focusing solely on application development, the emphasis was placed on infrastructure design, service isolation, observability, and operational reliability.

The final system reflects a layered, production-oriented architecture and showcases practical systems engineering skills aligned with modern container-based deployments.





