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

pe 'cat ./models/sklearn1.yaml'

pe 'cat ./models/sklearn2.yaml'

pe 'seldon model load -f ./models/sklearn1.yaml'

pe 'seldon model load -f ./models/sklearn2.yaml'

pe 'seldon model status iris | jq'

pe 'seldon model status iris2 -w ModelAvailable'

pe 'seldon model infer iris '"'"'{"inputs": [{"name": "predict", "shape": [1, 4], "datatype": "FP32", "data": [[1, 2, 3, 4]]}]}'"'"''

pe 'seldon model infer iris2 -i 50 '"'"'{"inputs": [{"name": "predict", "shape": [1, 4], "datatype": "FP32", "data": [[1, 2, 3, 4]]}]}'"'"''

pe 'cat ./experiments/ab-default-model.yaml'

pe 'seldon experiment start -f ./experiments/ab-default-model.yaml'

pe 'seldon experiment list'

pe 'seldon experiment status experiment-sample -w | jq'

pe 'seldon model infer iris -i 50 '"'"'{"inputs": [{"name": "predict", "shape": [1, 4], "datatype": "FP32", "data": [[1, 2, 3, 4]]}]}'"'"''

pe 'seldon model infer iris --show-headers '"'"'{"inputs": [{"name": "predict", "shape": [1, 4], "datatype": "FP32", "data": [[1, 2, 3, 4]]}]}'"'"''

pe 'seldon model infer iris -s -i 50 '"'"'{"inputs": [{"name": "predict", "shape": [1, 4], "datatype": "FP32", "data": [[1, 2, 3, 4]]}]}'"'"''

pe 'seldon model infer iris --inference-mode grpc -s -i 50 '"'"'{"model_name":"iris","inputs":[{"name":"input","contents":{"fp32_contents":[1,2,3,4]},"datatype":"FP32","shape":[1,4]}]}'"'"''

pe 'seldon experiment stop experiment-sample'

pe 'seldon model unload iris'

pe 'seldon model unload iris2'

# start pipeline demo
clear

pe 'cat ./models/add10.yaml'

pe 'cat ./models/mul10.yaml'

pe 'seldon model load -f ./models/add10.yaml'

pe 'seldon model load -f ./models/mul10.yaml'

pe 'seldon model status add10 -w ModelAvailable'

pe 'seldon model status mul10 -w ModelAvailable'

pe 'cat ./pipelines/mul10.yaml'

pe 'cat ./pipelines/add10.yaml'

pe 'seldon pipeline load -f ./pipelines/add10.yaml'

pe 'seldon pipeline load -f ./pipelines/mul10.yaml'

pe 'seldon pipeline status pipeline-add10 -w PipelineReady'

pe 'seldon pipeline status pipeline-mul10 -w PipelineReady'

pe 'seldon pipeline infer pipeline-add10 --inference-mode grpc '"'"'{"model_name":"add10","inputs":[{"name":"INPUT","contents":{"fp32_contents":[1,2,3,4]},"datatype":"FP32","shape":[4]}]}'"'"' | jq'

pe 'seldon pipeline infer pipeline-mul10 --inference-mode grpc '"'"'{"model_name":"add10","inputs":[{"name":"INPUT","contents":{"fp32_contents":[1,2,3,4]},"datatype":"FP32","shape":[4]}]}'"'"' | jq'

pe 'cat ./experiments/addmul10.yaml'

pe 'seldon experiment start -f ./experiments/addmul10.yaml'

pe 'seldon experiment status addmul10 -w | jq'

pe 'seldon pipeline infer pipeline-add10 -i 50 --inference-mode grpc '"'"'{"model_name":"add10","inputs":[{"name":"INPUT","contents":{"fp32_contents":[1,2,3,4]},"datatype":"FP32","shape":[4]}]}'"'"''

pe 'cat ./models/add20.yaml'

pe 'seldon model load -f ./models/add20.yaml'

pe 'seldon model status add20 -w ModelAvailable'

pe 'cat ./experiments/add1020.yaml'

pe 'seldon experiment start -f ./experiments/add1020.yaml'

pe 'seldon experiment status add1020 -w | jq'

pe 'seldon model infer add10 -i 50 --inference-mode grpc '"'"'{"model_name":"add10","inputs":[{"name":"INPUT","contents":{"fp32_contents":[1,2,3,4]},"datatype":"FP32","shape":[4]}]}'"'"''

pe 'seldon pipeline infer pipeline-add10 -i 100 --inference-mode grpc '"'"'{"model_name":"add10","inputs":[{"name":"INPUT","contents":{"fp32_contents":[1,2,3,4]},"datatype":"FP32","shape":[4]}]}'"'"''

pe 'seldon experiment stop addmul10'

pe 'seldon experiment stop add1020'

pe 'seldon pipeline unload pipeline-add10'

pe 'seldon pipeline unload pipeline-mul10'

pe 'seldon model unload add10'

pe 'seldon model unload add20'

pe 'seldon model unload mul10'

# model mirror
clear

pe 'seldon model load -f ./models/sklearn1.yaml'

pe 'seldon model load -f ./models/sklearn2.yaml'

pe 'cat ./experiments/sklearn-mirror.yaml'

pe 'seldon experiment start -f ./experiments/sklearn-mirror.yaml'

pe 'seldon experiment status sklearn-mirror -w | jq'

pe 'seldon model infer iris -i 50 '"'"'{"inputs": [{"name": "predict", "shape": [1, 4], "datatype": "FP32", "data": [[1, 2, 3, 4]]}]}'"'"''

pe 'curl -s 0.0.0:9006/metrics | grep seldon_model_infer_total | grep iris2_1'

pe 'seldon experiment stop sklearn-mirror'

pe 'seldon model unload iris'

pe 'seldon model unload iris2'

# pipeline mirror
clear

pe 'seldon model load -f ./models/add10.yaml'

pe 'seldon model load -f ./models/mul10.yaml'

pe 'cat ./pipelines/mul10.yaml'

pe 'cat ./pipelines/add10.yaml'

pe 'seldon pipeline load -f ./pipelines/add10.yaml'

pe 'seldon pipeline load -f ./pipelines/mul10.yaml'

pe 'seldon pipeline status pipeline-add10 -w PipelineReady'

pe 'seldon pipeline status pipeline-mul10 -w PipelineReady'

pe 'cat ./experiments/addmul10-mirror.yaml'

pe 'seldon experiment start -f ./experiments/addmul10-mirror.yaml'

pe 'seldon experiment status addmul10-mirror -w | jq'

pe 'seldon pipeline infer pipeline-add10 --inference-mode grpc '"'"'{"model_name":"add10","inputs":[{"name":"INPUT","contents":{"fp32_contents":[1,2,3,4]},"datatype":"FP32","shape":[4]}]}'"'"' | jq'

pe 'curl -s 0.0.0:9007/metrics | grep seldon_model_infer_total | grep mul10_1'

pe 'curl -s 0.0.0:9007/metrics | grep seldon_model_infer_total | grep add10_1'

pe 'seldon pipeline infer pipeline-add10 --inference-mode grpc '"'"'{"model_name":"add10","inputs":[{"name":"INPUT","contents":{"fp32_contents":[1,2,3,4]},"datatype":"FP32","shape":[4]}]}'"'"' | jq'

pe 'curl -s 0.0.0:9007/metrics | grep seldon_model_infer_total | grep mul10_1'

pe 'curl -s 0.0.0:9007/metrics | grep seldon_model_infer_total | grep add10_1'

pe 'seldon pipeline inspect pipeline-mul10 --format json | fx'

pe 'seldon experiment stop addmul10-mirror'

pe 'seldon pipeline unload pipeline-add10'

pe 'seldon pipeline unload pipeline-mul10'

pe 'seldon model unload add10'

pe 'seldon model unload mul10'

pe 'cd ../'

pe 'make undeploy-local'
