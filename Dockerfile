FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu22.04

RUN apt update && apt install -y python3 python3-pip git libopenmpi-dev

WORKDIR app

COPY ./pyproject.toml ./pyproject.toml
COPY ./moellava ./moellava
COPY ./scripts ./scripts

RUN pip install --upgrade pip  # enable PEP 660 support
RUN pip install -e .
RUN pip install -e ".[train]"
RUN pip install flash-attn --no-build-isolation

RUN pip install -U "huggingface_hub[cli]" "huggingface_hub"

ENV HF_HOME="/app/.cache"

EXPOSE 9920

ENTRYPOINT ["python3", "moellava/serve/gradio_web_server.py"]