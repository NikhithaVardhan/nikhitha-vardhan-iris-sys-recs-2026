## Bonus Task – CI Pipeline for Automated Docker Build & Push

### Objective

The objective of Task 9 was to automate the Docker image build and deployment process using GitHub Actions.

Instead of manually building Docker images and pushing them to Docker Hub, a Continuous Integration (CI) pipeline was implemented to:

- Automatically build the Docker image on every push
- Authenticate securely with Docker Hub
- Push the image to a remote registry
- Ensure reproducibility and automation


------------------------------------------------------------

### Workflow Trigger Configuration

A GitHub Actions workflow file was created inside:

.github/workflows/create-docker-image.yml

The workflow was configured to trigger on pushes to:

- main
- task-9-CI-pipeline

This ensures that any update to relevant branches automatically initiates a new pipeline run.

![](Submit_Screenshots/task9/t%20(5).png)

------------------------------------------------------------

### CI Workflow Structure

The pipeline consists of the following stages:

1. Checkout Repository  
   Uses `actions/checkout@v4` to fetch repository code.

2. Login to Docker Hub  
   Uses `docker/login-action@v3` with credentials stored securely in GitHub Secrets:
   - DOCKERHUB_USERNAME
   - DOCKERHUB_TOKEN

3. Setup Docker Buildx  
   Enables advanced Docker build features for CI environments.

4. Build and Push Docker Image  
   Uses `docker/build-push-action@v5` to:
   - Build the Docker image
   - Tag it as: username/rails-img:latest
   - Push it to Docker Hub


------------------------------------------------------------

### Initial Pipeline Failure & Debugging

The first workflow execution failed.

Error observed:

docker buildx build requires 1 argument

This occurred because the build context was not properly specified in the workflow configuration.

![](Submit_Screenshots/task9/t%20(2).png)


After fixing the build command, a second error occurred:

invalid tag "/rails-img:latest": invalid reference format

This highlighted a formatting mistake in the Docker image tag.

The issue was resolved by correctly defining the tag as:

${{ secrets.DOCKERHUB_USERNAME }}/rails-img:latest

![](Submit_Screenshots/task9/t%20(3).png)


------------------------------------------------------------

### Successful Pipeline Execution

After correcting the configuration issues, the workflow executed successfully.

The pipeline:

- Checked out repository
- Authenticated with Docker Hub
- Built Docker image
- Pushed image to Docker Hub registry

![](Submit_Screenshots/task9/t%20(4).png)


------------------------------------------------------------

### Docker Hub Verification

The Docker Hub repository confirmed that the image was successfully pushed.

Repository:

nikhithavardhans/rails-img

The image was visible with the latest tag.

![](Submit_Screenshots/task9/t%20(6).png)
![](Submit_Screenshots/task9/t%20(7).png)


------------------------------------------------------------

### Key Learning from Task 9

This task demonstrated the power of CI automation.

Key concepts reinforced:

- CI pipeline configuration using GitHub Actions
- Secure secret management
- Docker image tagging conventions
- Automated build reproducibility
- Debugging CI failures through logs
- Integrating container workflows with remote registries

The system transitioned from manual image management to automated, repeatable image deployment.


------------------------------------------------------------

### Architectural Impact

With CI implemented, the workflow became:

Code Push → GitHub Actions → Docker Build → Docker Hub Push → Deployable Image

This ensures:

- Faster iteration
- Reduced manual errors
- Standardized image builds
- Production-aligned development workflow
