FROM mcr.microsoft.com/vscode/devcontainers/python:3.9

ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN if [ "$USER_GID" != "1000" ] || [ "$USER_UID" != "1000" ]; then groupmod --gid $USER_GID vscode && usermod --uid $USER_UID --gid $USER_GID vscode; fi

RUN pwd
RUN ls
COPY requirements.txt /tmp/
RUN pip3 install --upgrade pip
RUN pip3 install --requirement /tmp/requirements.txt

ENV DBT_PROFILES_DIR=/workspaces/dbt_duckdb_quarto

# install quarto
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/etc/apt/trusted.gpg.d/githubcli-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/trusted.gpg.d/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
RUN apt update
RUN apt install gh
RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.0.37/quarto-1.0.37-linux-amd64.deb
RUN dpkg -i quarto*
RUN quarto --version
