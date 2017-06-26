# Kompose-Flask

Project to be used with Kompose (Kubernetes) to generate an Openshift project. The project will run a flask application using uwsgi and it will be exposed using Nginx. Also includes Postgresql and Redis Images.

## Requirements

- Openshift CLI: https://github.com/openshift/origin/tags
- Kompose: http://kompose.io/
- Docker Tools: https://www.docker.com/products/docker-toolbox

 ## Usage

### First method: Generate and upload Openshift yaml template

    kompose -f docker-compose-prod.yml --provider openshift convert -o template.yaml

    oc create -f template.yaml

### Second method: Deploy to Openshift from a docker-compose file

Deploy to Openshift:

    kompose -f docker-compose-prod.yml --provider openshift up -v

Remove the deployed artifacts from Openshift:

    kompose -f docker-compose-prod.yml --provider openshift down -v

 ## Configuration

- `HOST`: Host of the project (using <myproject>.<docker_machine_ip>.xip.io will make the application available on local machines)
- `POSTGRESQL_USER`: User for Postgresql database
- `POSTGRESQL_DATABASE`: Database name
- `POSTGRESQL_PASSWORD`: User Postgresql password


## Other useful commands
    
### Docker Machine managment


    docker-machine start openshift

    docker-machine env openshift

    eval $(docker-machine env openshift)

### Openshift cluster management

    oc cluster up

    oc cluster down
