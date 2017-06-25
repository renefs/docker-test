# docker-test

    kompose -f docker-compose-prod.yml --provider openshift convert -o template.yaml

    oc create -f template.yaml