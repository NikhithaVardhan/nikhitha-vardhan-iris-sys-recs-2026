## Task 8 – Monitoring and Observability Stack

### Objective

The objective of Task 8 was to introduce observability into the system by implementing a full monitoring and logging stack.

Until this stage, the system was functional but lacked visibility into runtime behavior. This task focused on collecting metrics, visualizing performance, and centralizing logs to improve operational insight.

The monitoring stack implemented includes:

- Prometheus (metrics collection)
- cAdvisor (container-level metrics)
- Nginx Exporter (web server metrics)
- Grafana (visualization)
- Loki (log aggregation)
- Promtail (log shipping)


------------------------------------------------------------

### Prometheus Configuration

Prometheus was introduced as the core metrics collection engine.

Inside prometheus.yml, multiple scrape jobs were configured:

- prometheus → self-monitoring
- nginx → scraping metrics from nginx-exporter
- containers → scraping metrics from cAdvisor

The scrape interval was configured to 5 seconds to ensure near real-time metric updates.

![](Submit_Screenshots/task8/(51).png)

After starting the stack, Prometheus targets were verified through the UI.

All configured endpoints appeared under the Targets section, confirming successful metric scraping.

![](Submit_Screenshots/task8/(49).png)


------------------------------------------------------------

### Container-Level Monitoring using cAdvisor

cAdvisor was deployed to monitor container-level resource usage.

It provided:

- CPU usage
- Memory usage
- Network throughput
- Disk I/O
- Container isolation metrics

The cAdvisor UI confirmed active monitoring of all running containers.

![](Submit_Screenshots/task8/(55).png)
![](Submit_Screenshots/task8/(56).png)
![](Submit_Screenshots/task8/(57).png)
![](Submit_Screenshots/task8/(58).png)
![](Submit_Screenshots/task8/(59).png)

This validated that real-time container metrics were being generated and exposed for Prometheus scraping.


------------------------------------------------------------

### Nginx Metrics Exporter

To monitor web server performance, nginx-prometheus-exporter was configured.

It scraped metrics from:

http://nginx_cont/nginx_status

These metrics included:

- Active connections
- Requests per second
- Handled connections
- Reading/Writing/Waiting states

This enabled visibility into traffic behavior at the reverse proxy layer.


------------------------------------------------------------

### Grafana Visualization Layer

Grafana was deployed to visualize metrics collected by Prometheus.

After accessing Grafana at:

http://localhost:3001

The Prometheus data source was configured.

![](Submit_Screenshots/task8/(54).png)
![](Submit_Screenshots/task8/(60).png)

A dashboard was created to visualize:

- CPU usage
- Memory usage
- Network traffic
- Container statistics

Initially, connection issues were encountered (connection refused error while querying Prometheus).

![](Submit_Screenshots/task8/(64).png)

This issue was resolved by correcting service names and ensuring network alignment between Grafana and Prometheus containers.

Once fixed, dashboards began displaying real-time metrics.


------------------------------------------------------------

### Centralized Logging with Loki and Promtail

Beyond metrics, centralized logging was introduced.

Loki was deployed as a log aggregation system.

Promtail was configured to:

- Monitor Docker container log files
- Push logs to Loki
- Label logs by job and container

The promtail configuration defined:

- Loki push endpoint (http://loki:3100/loki/api/v1/push)
- Log file path: /var/lib/docker/containers/*/*.log
- Position tracking file

![](Submit_Screenshots/task8/Screenshot%202026-02-15%20080226.png)

Docker Compose was updated to include:

- loki service
- promtail service
- Proper network attachment

  ![](Submit_Screenshots/task8/Screenshot%202026-02-15%20080336.png)


This allowed centralized collection of container logs for future querying and visualization.


------------------------------------------------------------

### Log Verification

Logs from services such as:

- Grafana
- Prometheus
- cAdvisor

were verified using:

docker compose logs <service_name>

This confirmed that:

- Services started successfully
- Configuration overrides were applied
- Metrics ingestion was functioning

![](Submit_Screenshots/task8/(61).png)
![](Submit_Screenshots/task8/(62).png)
![](Submit_Screenshots/task8/(63).png)


------------------------------------------------------------

### Key Learning from Task 8

This task demonstrated that building a production-ready system requires observability, not just functionality.

Key concepts reinforced:

- Metrics vs logs
- Pull-based monitoring (Prometheus model)
- Exporter pattern
- Container-level telemetry
- Log aggregation architecture
- Service networking in monitoring stacks
- Debugging distributed system connectivity issues

The system evolved from a functional deployment to a monitored and observable architecture capable of real-time performance insight and operational debugging.


------------------------------------------------------------

### Architectural Overview After Task 8

Client
  ↓
Nginx (Reverse Proxy + Metrics)
  ↓
Rails Containers
  ↓
MySQL

Monitoring Layer:
- Prometheus ← cAdvisor + Nginx Exporter
- Grafana ← Prometheus
- Promtail → Loki (Centralized Logs)

This layered architecture reflects production-style monitoring and logging integration.
