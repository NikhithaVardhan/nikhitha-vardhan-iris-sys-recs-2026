## Bonus Task – Automated Backup Daemon

### Objective

The objective of this task was to design and implement a lightweight backup daemon that periodically archives critical application data and configuration files.

Unlike manual backups, this solution runs continuously in the background as a dedicated container, ensuring automated and recurring data protection.

This introduces operational reliability and disaster recovery capability into the system.


------------------------------------------------------------

### Architectural Rationale

Backups are a cross-cutting operational concern, not application logic.

Instead of embedding backup logic inside the Rails application container, a separate container was created following microservice principles.

This ensures:

- Isolation of backup logic
- Independent lifecycle management
- Clean separation of concerns
- Production-aligned architecture


------------------------------------------------------------

### Backup Daemon Service Configuration

A new service `backup-daemon` was added to docker-compose.yml.

It mounts:

- db_data → read-only access to database volume
- rails_storage → read-only access to uploaded content
- ./nginx → configuration backup
- ./backups → host directory where archives are stored

The service is configured with:

restart: always

This ensures the daemon restarts automatically if it crashes.

![](Submit_Screenshots/task10/t%20(1).png)

------------------------------------------------------------

### Container Implementation

A dedicated Dockerfile was created inside the `backup-daemon` directory.

It uses:

FROM alpine:latest

Minimal base image for lightweight execution.

Required utilities were installed:

apk add --no-cache tar bash

The backup script is copied and executed as the container’s main process.

![](Submit_Screenshots/task10/t%20(2).png)


------------------------------------------------------------

### Backup Script Logic

The daemon script runs an infinite loop:

while true

Every cycle:

1. Generates a timestamp
2. Creates a compressed archive (.tar.gz)
3. Stores it inside /backups
4. Sleeps for 1800 seconds (30 minutes)

Key command used:

tar -czf "$BACKUP_DIR/$ARCHIVE_NAME" /data /configs

This archives:

- Database data
- Rails storage
- Nginx configuration

![](Submit_Screenshots/task10/t%20(3).png)


------------------------------------------------------------

### Automated Backup Generation

After running the stack, multiple timestamped backup files were automatically generated.

Running:

ls backups

Displayed several archive files:

backup_2026-02-11-08-46.tar.gz  
backup_2026-02-11-18-06.tar.gz  
backup_2026-02-12-12-39.tar.gz  
backup_2026-02-12-12-46.tar.gz  

The presence of multiple files with different timestamps confirms that:

- The daemon runs continuously
- Backups are created periodically
- Archival logic is functioning correctly

![](Submit_Screenshots/task10/t%20(4).png)


------------------------------------------------------------

### Verification of Archive Contents

Each archive contains:

- /data (database + storage volumes)
- /configs (Nginx configuration)

This ensures that both application state and infrastructure configuration are preserved.

The use of compressed tar archives ensures:

- Reduced storage footprint
- Portable backup files
- Easy restoration process


------------------------------------------------------------

### Operational Benefits

This task introduced key systems engineering principles:

- Background daemon processes
- Volume-based backup strategies
- Automated archival with timestamps
- Separation of compute and storage
- Disaster recovery readiness

With this implementation, the system now supports:

Container failure → No data loss  
Service restart → Backup continuity  
Infrastructure rebuild → Restore capability  


------------------------------------------------------------

### Final System Evolution

After completing all tasks, the system now includes:

- Containerized Rails + MySQL
- Reverse proxy and load balancing
- Persistence layer
- Monitoring and logging stack
- CI pipeline
- Automated backup daemon

This reflects a production-oriented architecture with reliability, observability, and automation built into the system lifecycle.
