#!/bin/bash

########################
# include the magic
########################
. demo-magic.sh

# hide the evidence
clear

# demo steps
pe 'cd ../../sandpit/core-v2/'

pe 'make deploy-local'

pe 'cd samples/'

pe 'seldon'

pe 'seldon completion bash'

pe 'seldon'

pe 'seldon model --help'

pe 'cat models/sklearn1.yaml'

pe 'seldon model load -f models/sklearn1.yaml'

pe 'seldon model status iris | jq'

pe 'seldon model load -f models/tfsimple1.yaml'

pe 'seldon model status tfsimple1 -w ModelAvailable'

pe 'seldon model list'

pe 'seldon model metadata tfsimple1'

pe 'seldon model infer iris '"'"'{"inputs": [{"name": "predict", "shape": [1, 4], "datatype": "FP32", "data": [[1, 2, 3, 4]]}]}'"'"' | jq'

pe 'seldon model load -f ./models/tfsimple2.yaml'

pe 'cat ./pipelines/tfsimples.yaml'

pe 'seldon pipeline load -f ./pipelines/tfsimples.yaml'

pe 'seldon pipeline status tfsimples | jq'

pe 'seldon pipeline infer tfsimples '"'"'{"inputs":[{"name":"INPUT0","data":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16],"datatype":"INT32","shape":[1,16]},{"name":"INPUT1","data":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16],"datatype":"INT32","shape":[1,16]}]}'"'"' | jq'

pe 'seldon pipeline inspect tfsimples --format json | fx'

pe 'seldon experiment start -f experiments/ab.yaml'

pe 'seldon experiment status experiment-iris | jq'

pe 'cat experiments/ab.yaml'

pe 'seldon model list'

pe 'seldon experiment stop experiment-iris'

pe 'seldon server list'

pe 'seldon server status mlserver | jq'

pe 'seldon pipeline unload tfsimples'

pe 'seldon model unload tfsimple1'

pe 'seldon model unload iris'

pe 'seldon config --help'

pe 'seldon config add local config/local.json'

pe 'seldon config activate local'

pe 'seldon config list'

pe 'cat config/local.json'

pe 'cd ../'

pe 'make undeploy-local'
