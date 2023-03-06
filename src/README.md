https://docs.streamlit.io/knowledge-base/tutorials/deploy/docker

docker build -t streamlit-demo .

docker run \
  --rm \
  -e OPENAI_API_KEY=$OPENAI_API_KEY \
  -e COG_SERVICE_KEY=key \
  -e COG_SERVICE_REGION="uksouth" \
  -e COG_SERVICE_ENDPOINT=https://api.cognitive.microsofttranslator.com \
  -p 8501:8501 \
  --name streamlit-demo streamlit-demo

http://localhost:8501

