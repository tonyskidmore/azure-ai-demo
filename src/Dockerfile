FROM python:3.9-slim

ARG USERNAME=app
ARG USER_UID=1000

RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update && apt-get install -y --no-install-recommends \
    dialog \
    openssh-server \
    build-essential=12.9 \
    curl=7.74.0-1.3+deb11u7 \
    sudo \
    ca-certificates=20210119

COPY entrypoint.sh /
COPY app /app
COPY sshd_config /etc/ssh

RUN echo "root:Docker!" | chpasswd && \
    chmod u+x /entrypoint.sh && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN pip3 install pip==23.0.1 --no-cache-dir  && \
    pip3 install setuptools==52.0.0 --no-cache-dir --upgrade && \
    pip3 install -r requirements.txt --no-cache-dir

EXPOSE 8501 2222

HEALTHCHECK CMD curl --fail http://localhost:8501/_stcore/health

RUN useradd --uid "$USER_UID" -ms /bin/bash "$USERNAME" && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${USERNAME}" && \
    chmod 0440 "/etc/sudoers.d/${USERNAME}" && \
    chown -R "${USERNAME}:${USERNAME}" "/home/${USERNAME}" && \
    chmod +x /entrypoint.sh

USER "$USERNAME"

ENTRYPOINT [ "/entrypoint.sh" ]

# ENTRYPOINT ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
