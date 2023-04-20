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

pe 'cat ./models/tfsimple1.yaml'

pe 'seldon model load -f ./models/tfsimple1.yaml'

pe 'seldon model status tfsimple1 | jq'

pe 'seldon model metadata tfsimple1'

pe 'seldon model infer tfsimple1 '"'"'{"inputs":[{"name":"INPUT0","data":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16],"datatype":"INT32","shape":[1,16]},{"name":"INPUT1","data":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16],"datatype":"INT32","shape":[1,16]}]}'"'"' | jq'

pe 'seldon model load -f ./models/tfsimple2.yaml'

pe 'seldon model status tfsimple2 -w ModelAvailable'

pe 'cat ./pipelines/tfsimples.yaml'

pe 'seldon pipeline load -f ./pipelines/tfsimples.yaml'

pe 'seldon pipeline status tfsimples | jq'

pe 'seldon pipeline infer tfsimples '"'"'{"inputs":[{"name":"INPUT0","data":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16],"datatype":"INT32","shape":[1,16]},{"name":"INPUT1","data":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16],"datatype":"INT32","shape":[1,16]}]}'"'"' | jq'

pe 'seldon pipeline inspect tfsimples --format json | fx'

pe 'seldon pipeline unload tfsimples'

pe 'seldon model unload tfsimple1'

pe 'seldon model unload tfsimple2'

pe 'cd ../'

pe 'make undeploy-local'
