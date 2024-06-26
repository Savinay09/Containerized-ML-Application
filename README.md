[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/5LexNvYB)
# Final Project: Full End-to-End Machine Learning API

<p align="center">
    <!--Hugging Face-->
        <img src="https://user-images.githubusercontent.com/1393562/197941700-78283534-4e68-4429-bf94-dce7ab43a941.svg" width=7% alt="Hugging Face">
    <!--PLUS SIGN-->
        <img src="https://user-images.githubusercontent.com/1393562/190876627-da2d09cb-5ca0-4480-8eb8-830bdc0ddf64.svg" width=7% alt="Plus">
    <!--FAST API-->
        <img src="https://user-images.githubusercontent.com/1393562/190876570-16dff98d-ccea-4a57-86ef-a161539074d6.svg" width=7% alt="Fast API">
    <!--PLUS SIGN-->
        <img src="https://user-images.githubusercontent.com/1393562/190876627-da2d09cb-5ca0-4480-8eb8-830bdc0ddf64.svg" width=7% alt="Plus">
    <!--REDIS LOGO-->
        <img src="https://user-images.githubusercontent.com/1393562/190876644-501591b7-809b-469f-b039-bb1a287ed36f.svg" width=7% alt="Redis">
    <!--PLUS SIGN-->
        <img src="https://user-images.githubusercontent.com/1393562/190876627-da2d09cb-5ca0-4480-8eb8-830bdc0ddf64.svg" width=7% alt="Plus">
    <!--KUBERNETES-->
        <img src="https://user-images.githubusercontent.com/1393562/190876683-9c9d4f44-b9b2-46f0-a631-308e5a079847.svg" width=7% alt="Kubernetes">
    <!--PLUS SIGN-->
        <img src="https://user-images.githubusercontent.com/1393562/190876627-da2d09cb-5ca0-4480-8eb8-830bdc0ddf64.svg" width=7% alt="Plus">
    <!--Azure-->
        <img src="https://user-images.githubusercontent.com/1393562/192114198-ac03d0ef-7fb7-4c12-aba6-2ee37fc2dcc8.svg" width=7% alt="Azure">
    <!--PLUS SIGN-->
        <img src="https://user-images.githubusercontent.com/1393562/190876627-da2d09cb-5ca0-4480-8eb8-830bdc0ddf64.svg" width=7% alt="Plus">
    <!--K6-->
        <img src="https://user-images.githubusercontent.com/1393562/197683208-7a531396-6cf2-4703-8037-26e29935fc1a.svg" width=7% alt="K6">
    <!--PLUS SIGN-->
        <img src="https://user-images.githubusercontent.com/1393562/190876627-da2d09cb-5ca0-4480-8eb8-830bdc0ddf64.svg" width=7% alt="Plus">
    <!--GRAFANA-->
        <img src="https://user-images.githubusercontent.com/1393562/197682977-ff2ffb72-cd96-4f92-94d9-2624e29098ee.svg" width=7% alt="Grafana">
</p>

- [Final Project: Full End-to-End Machine Learning API](#final-project-full-end-to-end-machine-learning-api)
  - [Base Requirement](#base-requirement)
  - [Project Overview](#project-overview)
  - [Lab Objectives](#lab-objectives)
  - [Helpful Information](#helpful-information)
    - [Model Background](#model-background)
    - [Pydantic Model Expectations](#pydantic-model-expectations)
    - [Poetry Dependancies](#poetry-dependancies)
    - [Git Large File Storage (LFS)](#git-large-file-storage-lfs)
  - [Submission](#submission)
  - [Grading](#grading)
  - [Time Expectations](#time-expectations)

## Base Requirement

Expose both your `project` and `lab4` over your virtual service to show that we can support multiple services

The following URLs should be available at a minimum:

- [ ] /project/bulk-predict
- [ ] /lab4/predict
- [ ] /lab4/bulk-predict

You can expose the following with some minor (1 line) changes to your application configuration since `/docs` calls `/openapi.json` and that is hard-coded by default.

- [ ] /lab4/docs
- [ ] /project/docs

Provided is a minimal Virtual Service definition that you can extend for multiple matches.

```{yaml}
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: winegarj-vs
  namespace: winegarj
spec:
  gateways:
    - istio-ingress/winegarj-gateway
  hosts:
    - winegarj.mids255.com
  http:
    - match:
        - uri:
            prefix: "/lab4/"
        - uri:
            prefix: "/lab4"
      rewrite:
        uri: "/"
      route:
        - destination:
            host: prediction-service
            port:
              number: 8000
```

## Project Overview

The goal of `project` is to take everything you have learned in this class and deploy a fully functional prediction API accessible to end users.

You will:

- Utilize `Poetry` to define your application dependancies
- Package up an existing NLP model ([DistilBERT](https://arxiv.org/abs/1910.01108)) for running efficient CPU-based sentiment analysis from `HuggingFace`
- Create a `FastAPI` application to serve prediction results from user requests
- Test your application with `pytest`
- Utilize `Docker` to package your application as a logic unit of compute
- Cache results with `Redis` to protect your endpoint from abuse
- Deploy your application to `Azure` with `Kubernetes`
- Use `K6` to load test your application
- Use `Grafana` to visualize and understand the dynamics of your system

## Lab Objectives

- [ ] Write pydantic models to match the specified ***input*** model

    ```javascript
    {
        "text": ["example 1", "example 2"]
    }
    ```

- [ ] Write pydantic models to match the specified output model

    ```javascript
    {
        "predictions":
        [
            [
                {
                    "label":"POSITIVE",
                    "score":0.7127904295921326
                },
                {
                    "label":"NEGATIVE",
                    "score":0.2872096002101898
                }
            ],
            [
                {
                    "label":"POSITIVE",
                    "score":0.7186233401298523
                },
                {
                    "label":"NEGATIVE",
                    "score":0.2813767194747925
                }
            ]
        ]
    }
    ```

- [ ] Pull the [following model](https://huggingface.co/winegarj/distilbert-base-uncased-finetuned-sst2) locally to allow for loading into your application. Put this at the root of your project directory for an easier time.
- [ ] Add the model files to your `.gitignore` since the file is large, and we don't want to manage `git-lfs` and incur costs for wasted space. `HuggingFace` is hosting the model for us.
- [ ] Create and execute `pytest` tests to ensure your application is working as intended
- [ ] Build and deploy your application locally (Hint: Use `kustomize`)
- [ ] Push your image to `ACR`.
  - [ ] Use a prefix based on your namespace, and call the image `project`
- [ ] Deploy your application to `AKS` similar to labs 4/5
  - [ ] **Make sure to adjust your virtual service to expose both `project` and `lab4`**
- [ ] Run `k6` against your application with the provided `load.js`
- [ ] Capture screenshots of your `grafana` dashboard for your service/workload during the execution of your `k6` script
- [ ] Feel extremely proud about all the learning you went through over the semester and how this will help you develop professionally and enable you to deploy an API effectively during your capstone. There is much to learn, but getting the fundamentals are key.

## Helpful Information

### Model Background

Please review the `train.py` to see how the model was trained and pushed to `HuggingFace` as an artifact store for models and their associated configuration.
This model took 5 minutes to transfer learn on 2x A4000 GPUs with a 256 batch size, taking 15 GB of memory on each GPU.
Training on CPUs would likely have taken several days. The given implementation allows for maximum text sequences of `512` tokens for each input.
***Do not try to run the training script on your local machine.***

Model loading examples are provided in `example.py`. In this file, we directly load the model from `HuggingFace`; however, this is extremely inefficient given the size of the underlying model (256 MB) for a production environment.
We will pull down the model locally as part of our build process.

Model prediction pipelines are included in the `transformers` API provided by `HuggingFace,` which dramatically reduces the complexity of the Inferencing application.
An example is provided in `mlapi/example.py` and is instrumented already in your `main.py` application.

### Pydantic Model Expectations

We provide you with a pytest file, `test_mlapi.py,` which has the structure of how you should design your pydantic models.
You will have to do some reverse engineering so that your model matches our expectations.

### Poetry Dependancies

Do not run `poetry update` it will take a long time due to the handling of `torch` dependencies.
Do a `poetry install` instead.

### Git Large File Storage (LFS)

You might need to install `git lfs` <https://git-lfs.github.com/>

## Submission

All code will be graded off your repo's `main` branch and `AKS` deployment.
No additional forms or submission processes are needed.

## Grading

All items are conditional on a `95%` cache rate, and after a `10 minute` sustained load:

|                  **Criteria**                  |                          **0%**                          |                            **50%**                            |                        **90%**                         |                   **100%**                   |
|:---------------------------------------------: |:-------------------------------------------------------: |:------------------------------------------------------------: |:-----------------------------------------------------: |:-------------------------------------------: |
| *Functional API*                               | No Endpoints Work                                        | Some Endpoints Functional                                     | Most Endpoints Functional                              | All Criteria Met                             |
| *Caching*                                      | No Attempt at Caching                                    | Caching system instantiated but not used                      | Caching system created but missing some functionality  | All Criteria Met                             |
| *Kubernetes Practices*                         | No Attempt at Deployments                                | Deployments exist but lack key functionality                  | Kubernetes deployment mostly functional                | All Criteria Met                             |
| *Testing*                                      | No Testing is done                                       | Minimal amount of testing done. No testing of new endpoints.  | Only "happy path" tested and with minimal cases        | All Criteria Met                             |
| *Passing Provided Tests*                       | Pydantic model does not adhere to our given pytest file  | Pydantic model somewhat passes pytest file                    | Pydantic model mostly passes pytest file               | All Criteria Met                             |
| *Model Loading*                                | Model loads from hugging face on API instantiation       | N/A                                                           | N/A                                                    | Model is loaded into the container at build  |
| *Predict Endpoint Performance*                 | Endpoint performs at 1 request/second                    | Endpoint performs at 5 requests/second                        | Endpoint performs at 9 request/second                  | Endpoint performs at 10 requests/second      |
| *Predict Endpoint Latency @ 10 Virtual Users*  | p(99) < 10 seconds                                       | p(99) < 5 seconds                                             | p(99) < 3 seconds                                      | p(99) < 2 seconds                            |

## Time Expectations

This project will take approximately ~10 hours.
