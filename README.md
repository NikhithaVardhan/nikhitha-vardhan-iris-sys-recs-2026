## Task 3 – Configure Nginx Reverse Proxy

### Objective

The objective of Task 3 was to introduce Nginx as a reverse proxy in front of the Rails application container. Instead of exposing the Rails server directly to clients, all incoming HTTP traffic would first pass through Nginx and then be forwarded internally to the Rails container.

This improves architecture modularity and prepares the system for load balancing in future tasks.


### Initial Setup – Adding Nginx Container

A new service `nginx_cont` was added to the docker-compose.yml file.

The Nginx container used the official `nginx:alpine` image and exposed port:

80:80

A volume was mounted to inject a custom nginx.conf file into the container:

./nginx/nginx.conf:/etc/nginx/nginx.conf:ro

The Rails container was no longer directly accessed via port 8080. Instead, Nginx would handle incoming traffic on port 80 and internally forward requests to the Rails service.

![Docker-compose.yml](Submit_Screenshots/task3/t%20(6).png)

### First Attempt – Unexpected Apache Default Page

After launching the containers and navigating to localhost, instead of the Rails application, an Apache default page was displayed.

This was unexpected and initially confusing.

This helped me understand an important systems concept:

Port conflicts can cause requests to be served by unintended services.

In this case, another service was already running on port 80 on the host system, which resulted in the Apache default page being served instead of the Nginx container.

![Apache-Page](Submit_Screenshots/task3/t%20(1).png)
![Docker-compose.yml](Submit_Screenshots/task3/t%20(3).png)


### Fixing the Port Conflict

After identifying that port 80 was already in use, the conflicting service was stopped. Once the port was freed and containers were restarted, the Apache page disappeared.

However, a new issue appeared.


### Runtime Error – 502 Bad Gateway

After resolving the port conflict, Nginx displayed a 502 Bad Gateway error.

This error indicated that Nginx was running successfully, but it was unable to connect to the upstream Rails container.

From the logs, it was clear that Nginx was trying to proxy requests but failing to reach the backend service.

This was a valuable learning moment:  
A reverse proxy must correctly reference the internal Docker service name, not localhost.

![502-Bad-Gateway](Submit_Screenshots/task3/t%20(2).png)



### Updating nginx.conf for Proper Proxying

The nginx.conf file was updated with the correct configuration:

- Nginx listens on port 80
- Requests to "/" are proxied to http://serv_cont:3000
- Host and X-Forwarded-For headers are forwarded

Key directive used:

proxy_pass http://serv_cont:3000;

Here, `serv_cont` is the Docker service name of the Rails container. Docker’s internal DNS automatically resolves this name.

This corrected the upstream routing issue.

![Nginx-Conf](Submit_Screenshots/task3/t%20(7).png)



### Successful Reverse Proxy Setup

After updating the configuration and restarting the containers, the application loaded successfully through Nginx.

The application was now accessible at:

http://localhost

instead of accessing Rails directly via port 8080.

This confirmed:

- Nginx was properly receiving client requests
- Requests were correctly forwarded to the Rails container
- Response was returned back through Nginx to the client

![Login-Page](Submit_Screenshots/task3/t%20(8).png)



### Functional Verification – Creating and Viewing Posts

To verify that the reverse proxy setup was fully functional and not just rendering static content, multiple application actions were performed:

- Logging in
- Creating new posts
- Viewing posts
- Uploading images
- Updating posts

All CRUD operations worked correctly, confirming that:

- Session handling worked through Nginx
- POST requests were proxied correctly
- Static assets and images were served properly
- Application state was maintained

![Docker-compose.yml](Submit_Screenshots/task3/t%20(9).png)
![Docker-compose.yml](Submit_Screenshots/task3/t%20(10).png)
![Docker-compose.yml](Submit_Screenshots/task3/t%20(11).png)
![Docker-compose.yml](Submit_Screenshots/task3/t%20(13).png)


### Observing Container Status

Using:

docker compose ps

The running containers were verified:

- db_cont
- serv_cont
- nginx_cont

The output confirmed that:

- Nginx was bound to port 80
- Rails containers were running internally
- MySQL was operational

![Docker-compose.yml](Submit_Screenshots/task3/t%20(12).png)



### Key Learning from Task 3

This task helped reinforce several important systems concepts:

- Reverse proxy architecture
- Service-to-service communication using Docker DNS
- Importance of correct upstream configuration
- Diagnosing 502 errors
- Port conflict debugging
- Layered architecture (Client → Nginx → Rails → MySQL)

Instead of exposing the application directly, the system now follows a production-style pattern where a dedicated web server handles traffic routing.
 
