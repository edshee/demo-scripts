#!/bin/bash

########################
# include the magic
########################
. demo-magic.sh

# hide the evidence
clear

# demo steps
pe 'make deploy-local'

pe 'cd samples/'

pe 'cat models/sklearn-iris-gs.yaml'

pe 'seldon model load -f models/sklearn-iris-gs.yaml'

pe 'cat pipelines/iris.yaml'

pe 'seldon pipeline load -f pipelines/iris.yaml'

pe 'cat models/tfsimple1.yaml'

pe 'seldon model load -f models/tfsimple1.yaml'

pe 'cat pipelines/tfsimple.yaml'

pe 'seldon pipeline load -f pipelines/tfsimple.yaml'

pe 'seldon model list'

pe 'seldon pipeline list'

pe 'seldon model infer iris '"'"'{"inputs": [{"name": "predict", "shape": [1, 4], "datatype": "FP32", "data": [[1, 2, 3, 4]]}]}'"'"' | jq'

pe 'seldon pipeline infer iris-pipeline '"'"'{"inputs": [{"name": "predict", "shape": [1, 4], "datatype": "FP32", "data": [[1, 2, 3, 4]]}]}'"'"' | jq'

pe 'seldon model infer tfsimple1 '"'"'{"inputs":[{"name":"INPUT0","data":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16],"datatype":"INT32","shape":[1,16]},{"name":"INPUT1","data":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16],"datatype":"INT32","shape":[1,16]}]}'"'"' | jq'

pe 'seldon pipeline infer tfsimple '"'"'{"inputs":[{"name":"INPUT0","data":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16],"datatype":"INT32","shape":[1,16]},{"name":"INPUT1","data":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16],"datatype":"INT32","shape":[1,16]}]}'"'"' | jq'

pe 'cat batch-inputs/iris-input.txt | head -n 1| jq'

pe 'mlserver infer -u localhost:9000 -m iris -i batch-inputs/iris-input.txt -o /tmp/iris-output.txt --workers 5'

pe 'mlserver infer -u localhost:9000 -m iris-pipeline.pipeline -i batch-inputs/iris-input.txt -o /tmp/iris-pipeline-output.txt --workers 5'

pe 'cat /tmp/iris-output.txt | head -n 1 | jq'

pe 'cat /tmp/iris-pipeline-output.txt | head -n 1 | jq'

pe 'cat batch-inputs/tfsimple-input.txt | head -n 1 | jq'

pe 'mlserver infer -u localhost:9000 -m tfsimple1 -i batch-inputs/tfsimple-input.txt -o /tmp/tfsimple-output.txt --workers 10'

pe 'cat /tmp/tfsimple-output.txt | head -n 1 | jq'

pe 'seldon model unload iris'

pe 'seldon model unload tfsimple1'

pe 'seldon pipeline unload iris-pipeline'

pe 'seldon pipeline unload tfsimple'

pe 'cd ../'

pe 'make undeploy-local'
