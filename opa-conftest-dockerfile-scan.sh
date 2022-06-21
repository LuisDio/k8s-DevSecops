## opa-conftest-dockerfile-scan.sh

#!/bin/bash

docker run --rm -v $PWD:/project openpolicyagent/conftest test --policy opa-docker-security.rego Dockerfile

    # Opa scan result processing
    exit_code=$?
    echo "Exit Code : $exit_code"

    # Check scan results
    if [[ "${exit_code}" == 1 ]]; then
        echo "Image scanning failed. Vulnerabilities found"
        exit 1;
    else
        echo "Image scanning passed. No CRITICAL vulnerabilities found"
    fi;