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

### Building the Docker Image

The Docker image was built using:
docker build -t rails-img .

![Dockerimage](Submit_Screenshots/task1/(9).png)

### Errors faced
During the bundle install step, a bundler version mismatch error occurred due to incompatibility between the lockfile and the installed bundler version.

This issue was resolved by ensuring that the correct bundler version compatible with the lockfile was installed inside the container.
![GemfileIssue](Submit_Screenshots/task1/(10).png)

### System-Level Dependency Error
An error occurred stating that libmysqlclient-dev had no installation candidate.

This issue was resolved by replacing the deprecated package with the appropriate MariaDB development library compatible with the Ruby base image.
![DependencyIssue](Submit_Screenshots/task1/(11).png)

### Successfully Running the Rails Server
After resolving dependency issues, the image was successfully built and the Rails server was launched inside the container.
docker run -p 8080:3000 rails-img
![DockerImageShow](Submit_Screenshots/task1/(12).png)
![DockerImage run](Submit_Screenshots/task1/(13).png)


### Runtime Database Connection Error
Upon accessing the application, an ActiveRecord::ConnectionNotEstablished error occurred because the database container had not yet been configured.

This error highlighted the need to separate the database into its own container and configure proper inter-container networking, which is addressed in Task 2.
![Error1](Submit_Screenshots/task1/(14).png)
![logs_of_Error](Submit_Screenshots/task1/(15).png)

