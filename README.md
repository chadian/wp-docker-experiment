# Docker Wordpress Experiment
## Summary
This an experiment using docker to create a project-based LAMP development environment. As an example this project uses wordpress.

## Setup
First you will need to make sure you have a working docker engine to use.

### Create the image
In the project directory containing the Dockerfile, in terminal run:  
`docker build -t wp-docker .`
This will create a docker image tagged `wp-docker` for use.

### Run the image
In the same project directory containing the Dockerfile, in terminal run:  
`docker run -d -v $(pwd):/var/www/html -v $(pwd)/.docker/mysql/storage:/var/lib/mysql -p 8890:80 wp-docker`  
This will start the LAMP stack with the `wp-docker` image, running on port `8890`, with the current folder as the webroot.

Note: After executing this command docker will return the hash of the container that has just been launched. 

### Run commands within the container environment
If you need to work within the container environment, in terminal run:
`docker exec -it container_hash_or_name bash`  

Replace `container_hash_or_name` with the container's hash or name which can be obtained from `docker ps`.

### Other commands
The rest of the commands for managing the container are not specific to this environment and can be referenced from the docker documentation.

## Background
### The problem
It seems that within web agencies, especially ones working on LAMP stacks, development environments easily become unweildly. Due to the popularity of the LAMP stack, it has created a unique problem in that everyone has it installed, in almost every possible combination and configuration.

This issues is compounded by:

- Major OS X releases update AMP versions and replace any configuration that existed
- On OS X, running homebrew or MAMP installs yet another set of these binaries and their configurations
- Extensions on windows will often be in different file formats, and require a different set of instructions to setup
- System-level apache, mysql, and php binaries/configurations don't always match what is required for production, which often varies from project to project

### The goal
Essentially, there are two main goals:

- Everyone works on the *same* environment, that mirrors production
- The environment is tracked per project, in source control

These goals aim to avoid the "works on my machine" syndrome, and to eliminate any surprise production bugs that may arise due to apache, mysql, and php version mismatch.

### The solution
Vagrant, in theory, is a great solution. It addresses both goals but introduces issues of its own. Vagrant, is based on abstracting a headless virtual machine, with standardized images and provisioning. Each application running requires a full blown vm and with it configuration to manage memory, storage, shared folders, and then integration with the OS.

Enter docker. It seems to come so much closer to the mark. Docker is only interested in giving you a container that let's you focus on your application environment. The image can be easily built, changed, re-configured, and shared with everyone. These containers share a common *engine* with other containers, but without leaking their implementations.

This allows everyone to work on the same environment, provisioned by a Dockerfile tracked in source control, and can vary from project to project.

### The gotchas
Docker containers are linux containers. This means they share a linux kernel, and need to run in a linux environment. If you are on OSX or Windows there are ways to get Docker running, and Docker is focused on speeding up docker provisioning with tools like Docker Machine. This usually ends up adding a VM to your local  machine, but the single VM can power many concurrent containers which is much more performant.  

I love the idea that Docker proposes that every entity, or service, of the application should likely live in its own container. So LAMP in the *docker way* would best be served by several containers: apache (either with php or with php in its own container), and mysql. One of the biggest wins of doing this is that you can deploy these isolated containers to production. In theory, you are almost gauraunteed that the setup you have locally will be a working setup in production. But, for many agencies the production environment is something that is not within the realm of control. The option to deploy a docker container is not an option. The client likely doesn't want to hire a devops team to manage their wordpress blog, their $10/mo hosting with cPanel is going to do the trick.

### My docker solution, and this experiment
While it might not be the *docker way*, I wanted to see if I could have a single docker image that could be easily booted, restarted, and persisted within a project, and in a way that is consistent and reliable. Changes in setting up the environment specific to the project can be committed to the repo and shared with developers.