FROM python:3.9-slim

ARG USERNAME=app
ARG USER_UID=1000

WORKDIR /app

RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential=12.9 \
    curl=7.74.0-1.3+deb11u7 \
    ca-certificates=20210119 \
    && rm -rf /var/lib/apt/lists/*

COPY app /app

RUN pip3 install pip==23.0.1 --no-cache-dir  && \
    pip3 install setuptools==52.0.0 --no-cache-dir --upgrade && \
    pip3 install -r requirements.txt --no-cache-dir

EXPOSE 8501

HEALTHCHECK CMD curl --fail http://localhost:8501/_stcore/health

RUN useradd --uid "$USER_UID" -ms /bin/bash "$USERNAME" && \
    chown -R "${USERNAME}:${USERNAME}" "/home/${USERNAME}"

USER "$USERNAME"

ENTRYPOINT ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
