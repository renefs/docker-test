# docker-test

    kompose -f docker-compose-prod.yml --provider openshift convert -o template.yaml

    oc create -f template.yaml

    docker-machine start openshift

    docker-machine env openshift

    eval $(docker-machine env openshift)

    oc cluster up

    oc cluster down

    kompose -f docker-compose-prod.yml --provider openshift up -v

    kompose -f docker-compose-prod.yml --provider openshift down -v