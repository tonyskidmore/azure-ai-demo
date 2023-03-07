# azure-ai-demo

## Overview

This repo contains code for creating and deploying an example [Streamlit](https://streamlit.io/) application.  Streamlit is a great Python based library that allows the easy creation of simple but effective web applications.  

The demo application was created to show how you can use the following:

* Showcase Streamlit's capabilities
* Putting a web front end in front of a pre-trained machine learning model.
* Using OpenAI REST API as part of an application.
* Using Azure Cognitive Services to provide easy to consume AI to enhance your application.

## Build the application locally

If you have Docker installed locally you can build and test the container application locally by following the steps in `src` directory [README](https://github.com/tonyskidmore/azure-ai-demo/blob/main/src/README.md).


## Deploying to Azure and Azure DevOps

This repo contains Terraform code to deploy the demo Streamlit containerized application to an Azure Web App, including all of the necessary resources to support the deployment e.g. Virtual network, Subnets, Container registry, KeyVault and Cognitive Services.  

It will also create an Azure DevOps project, AzureRM service connection, Pipelines (terraform and application), Scale Set Agent pool with an associated self-hosted Azure Virtual Machine Scale Set on the Virtual network.  

See the bootstrap [README](https://github.com/tonyskidmore/azure-ai-demo/blob/main/bootstrap/README.md) for more details.  


## Azure Cognitive Services

If you don't want to do the full automated deployment above but want to test the Translator demo then you can [Create a Translator resource](https://learn.microsoft.com/en-us/azure/cognitive-services/Translator/create-translator-resource) in the Azure portal and follow the [Build the application locally](#build-the-application-locally) steps.

## OpenAI ChatGPT

To test the ChatGPT functionality you will need to create an [OpenAI](https://beta.openai.com/signup) account.  Once you have done that you will need to [sign in](https://platform.openai.com/account) and [create a key](https://platform.openai.com/account/api-keys).  

You will use this to set the `OPENAI_API_KEY` when following either the [Build the application locally](#build-the-application-locally) or [Deploying to Azure and Azure DevOps](#deploying-to-azure-and-azure-devops) sections.

## Acknowledgements

Thanks to [Nicolas Renotte](https://github.com/nicknochnack) for his [I tried to build a Python Machine Learning Streamlit App in 7 Minutes | Coding Challenge](https://www.youtube.com/watch?v=Ebb4gUI2IpQ) YouTube video, which formed the elements of the *Pre-Trained ML Model* section of the app (there is a link to the original source code on that page in the app).
