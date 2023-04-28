# Build the app
You can build the Streamlit container locally if you have Docker installed.
If you want to test Azure Cognitive services and OpenAI ChatGBT you will need to first the required environment variables:

| environment variable      | description                                                         |
|---------------------------|---------------------------------------------------------------------|
| COG_SERVICE_KEY           | One of the keys from an Azure Cognitive Services translator service |
| COG_SERVICE_REGION        | The Azure region where the Translator service was deployed          |
| COG_SERVICE_ENDPOINT      | The Translator HTTPS endpoint to query                              |
| OPENAI_API_KEY            | Yours OpenAI REST API key                                            |

_Note:_ You can build and run the container without the OpenAI and Cognitive Services values, but those pages just won't work.

To build locally perform the instructions below:

````bash

docker build -t streamlit-demo .

docker run \
  --rm \
  -e OPENAI_API_KEY="$OPENAI_API_KEY" \
  -e COG_SERVICE_KEY=key \
  -e COG_SERVICE_REGION="uksouth" \
  -e COG_SERVICE_ENDPOINT=https://api.cognitive.microsofttranslator.com \
  -p 8501:8501 \
  --name streamlit-demo streamlit-demo

# open http://localhost:8501 in your local browser

````

## Azure App Service SSH

The app has SSH enabled for Azure App Service as per [Azure App Service -Enable SSH](https://learn.microsoft.com/en-us/azure/app-service/configure-custom-container?pivots=container-linux&tabs=debian#enable-ssh).  This is for debug and demonstration purposes.

See [Open an SSH session to a Linux container in Azure App Service](https://learn.microsoft.com/en-us/azure/app-service/configure-linux-open-ssh-session) on how to leverage this feature.
