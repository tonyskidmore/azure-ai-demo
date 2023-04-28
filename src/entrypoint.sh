#!/bin/sh
set -e
sudo service ssh start
exec streamlit run app.py --server.port=8501 --server.address=0.0.0.0
