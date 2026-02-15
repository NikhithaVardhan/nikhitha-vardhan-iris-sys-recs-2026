## Task 7 – Implement Rate Limiting

### Objective

The objective of Task 7 was to protect the application from excessive or abusive traffic by implementing request rate limiting at the Nginx layer.

Rate limiting ensures that a single client cannot overwhelm the backend services by sending too many requests in a short period of time.


### Implementing Rate Limiting in Nginx

Rate limiting was configured inside nginx.conf using the following directives:

limit_req_zone $binary_remote_addr zone=perip:10m rate=5r/s;

This directive:

- Tracks requests per client IP address
- Allocates 10MB shared memory for tracking
- Limits each IP to 5 requests per second

Inside the server block:

limit_req zone=perip burst=10 nodelay;

This allows:

- Short bursts of traffic (up to 10 requests)
- Immediate rejection once the threshold is exceeded



### Configuration Overview

The configuration was placed inside the http block and applied to the root location.

Key components:

- limit_req_zone → defines tracking mechanism
- limit_req → enforces the restriction
- proxy_pass → forwards valid requests to Rails backend
- ip_hash → maintains session affinity

![](Submit_Screenshots/task7/t%20(16).png)

### Testing Rate Limiting

To simulate rapid requests, the following command was executed:

for i in {1..50}; do curl -s -o /dev/null -w "%{http_code}\n" http://localhost; done

This sends 50 HTTP requests in quick succession.

![](Submit_Screenshots/task7/t%20(14).png)


### Observed Behavior

Initially, requests returned HTTP 200 (OK).

After exceeding the configured threshold, the server began returning:

HTTP/1.1 503 Service Temporarily Unavailable

This confirmed that rate limiting was actively blocking excessive traffic.

![](Submit_Screenshots/task7/t%20(1).png)
![](Submit_Screenshots/task7/t%20(10).png)


### Log Verification

Nginx logs showed entries similar to:

limiting requests, excess: 10.515 by zone "limit_req"

This confirmed that:

- The rate limit threshold was reached
- Nginx actively rejected additional requests
- The backend application was protected from overload

![](Submit_Screenshots/task7/t%20(11).png)



### Stress Test Output

The curl loop output clearly showed a mixture of:

200  
503  
503  
503  

This demonstrated that:

- Valid requests within threshold were served
- Excessive requests were blocked
- Rate limiting was functioning correctly

![](Submit_Screenshots/task7/t%20(14).png)
![](Submit_Screenshots/task7/t%20(15).png)

### Key Learning from Task 7

This task reinforced important security and performance concepts:

- Protecting backend services from abuse
- Application-layer rate limiting
- Reverse proxy as first line of defense
- Traffic control before hitting application servers
- Observability through logs

By implementing rate limiting at the Nginx layer, the system gained protection against request floods and potential denial-of-service behavior.

This step strengthened the system's production-readiness and security posture.
