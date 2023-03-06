https://docs.streamlit.io/knowledge-base/tutorials/deploy/docker

docker build -t streamlit-demo .

docker run --rm -e OPENAI_API_KEY=$OPENAI_API_KEY -p 8501:8501 --name streamlit-demo streamlit-demo

http://localhost:8501

