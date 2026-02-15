## Task 5 – Implement Data Persistence

### Objective

The objective of Task 5 was to ensure that critical application data remains intact even if containers are stopped, removed, or restarted.

By default, Docker containers are ephemeral. Any data stored inside a container’s filesystem is lost when the container is destroyed. This task focused on separating storage from compute by using Docker volumes.


### Implementing Database Persistence

The MySQL container stores its data in:

/var/lib/mysql

To ensure database durability, a named Docker volume was mounted:

db_data:/var/lib/mysql

This ensures that even if the MySQL container is removed, the underlying database files remain preserved inside the Docker volume.



### Implementing Rails Storage Persistence

The Rails application stores uploaded images and attachments in:

/app/storage

A named volume was mounted:

rails_storage:/app/storage

This ensures that user-uploaded content remains available even after container restarts.



### Verifying Volume Creation

To confirm that volumes were properly created, the following command was executed:

docker volume ls

The output clearly showed named volumes corresponding to the project, including:

- nikhitha-vardhan-iris-sys-recs-2026_db_data  
- nikhitha-vardhan-iris-sys-recs-2026_rails_storage  

This confirmed that Docker volumes were successfully provisioned.

![](Submit_Screenshots/task5/t%20(1).png)

### Persistence Verification – Before Restart

To verify persistence, a post was created with an uploaded image.

The post titled “flower” was successfully created and displayed correctly in the application.

This confirmed that:

- Database entries were stored
- Image was saved via ActiveStorage
- Application was functioning normally

![](Submit_Screenshots/task5/t%20(2).png)
![](Submit_Screenshots/task5/t%20(3).png)


### Container Restart Test

To simulate container removal, the containers were restarted using:

docker compose down  
docker compose up -d

This recreates containers but does not remove named volumes.


### Persistence Verification – After Restart

After restarting the containers, the application was accessed again.

The previously created post and uploaded image were still present and fully accessible.

This verified that:

- Database data persisted across container lifecycle
- Uploaded images were retained
- Volume mounts were correctly configured

![](Submit_Screenshots/task5/t%20(4).png)


### Key Learning from Task 5

This task demonstrated a critical systems concept:

Containers are ephemeral, but data must be durable.

Key concepts reinforced:

- Difference between container filesystem and Docker volumes
- Named volumes vs bind mounts
- Separation of compute and storage
- Stateful vs stateless components
- Production readiness considerations

With persistence implemented, the system moved from a temporary development setup to a more production-aligned architecture capable of surviving container restarts and redeployments.
