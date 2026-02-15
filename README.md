## Task 4 – Implement Load Balancing

### Objective

The objective of Task 4 was to scale the Rails application horizontally by running multiple Rails containers and configuring Nginx to distribute traffic between them.

Instead of routing all traffic to a single application container, requests would now be distributed across multiple backend instances to improve scalability and availability.


### Scaling Rails Containers

The Rails service was scaled to run multiple instances. This introduced horizontal scaling at the application layer.

Now the architecture became:

Client → Nginx → Multiple Rails Containers → MySQL

All Rails containers shared the same database container, ensuring consistent data storage.
![Scaling](Submit_Screenshots/task4/t%20(2).png)

### Updating Nginx Configuration for Load Balancing

The Nginx configuration was modified to introduce an upstream block:

upstream rails_backend {
    server serv_cont:3000;
}

proxy_pass http://rails_backend;

This allowed Nginx to forward requests to backend containers instead of a single fixed instance.

By default, Nginx uses round-robin load balancing to distribute traffic.
![Scaling](Submit_Screenshots/task4/t%20(3).png)
![Scaling](Submit_Screenshots/task4/t%20(5).png)


### Issue Encountered – Session Instability

After enabling load balancing, an unexpected issue was observed during user authentication.

The application required email login. However, due to round-robin distribution:

- The login request would hit one Rails container.
- The next request would be routed to another container.
- The new container did not recognize the existing session.
- The login page refreshed repeatedly.

As a result, multiple authentication attempts were triggered, which was visible through repeated login notifications.

This revealed an important systems concept:

Load balancing across stateful application servers can break session continuity if sessions are stored locally per instance.

![Scaling](Submit_Screenshots/task4/t%20(1).png)

### Solution – Enabling Session Affinity using ip_hash

To resolve the issue, the upstream configuration was modified as follows:

upstream rails_backend {
    ip_hash;
    server serv_cont:3000;
}

The ip_hash directive ensures that requests from the same client IP are consistently routed to the same backend container.

This enabled session stickiness, preventing login refresh loops and maintaining user authentication across requests.


### Verification

After enabling ip_hash:

- Login persisted correctly.
- No repeated authentication prompts occurred.
- CRUD operations worked reliably.
- Application stability improved under load balancing.

 ![Scaling](Submit_Screenshots/task4/t%20(7).png)


### Key Learning from Task 4

This task demonstrated that horizontal scaling introduces new challenges related to state management.

Key concepts learned:

- Horizontal scaling vs vertical scaling
- Round-robin load balancing
- Stateless vs stateful applications
- Session stickiness (session affinity)
- Importance of consistent request routing in multi-instance deployments

This task highlighted that scaling is not only about increasing the number of containers, but also about properly managing session and state consistency across distributed services.
