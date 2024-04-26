FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu22.04

RUN apt update && apt install -y python3 python3-pip git libopenmpi-dev

WORKDIR app

COPY ./pyproject.toml ./pyproject.toml
COPY ./moellava/__init__.py ./moellava/__init__.py
COPY ./moellava/model/__init__.py ./moellava/model/__init__.py
COPY ./moellava/serve/__init__.py ./moellava/serve/__init__.py


RUN pip install --upgrade pip  # enable PEP 660 support
RUN pip install -e .
RUN pip install -e ".[train]"
RUN pip install flash-attn --no-build-isolation

RUN pip install -U "huggingface_hub[cli]" "huggingface_hub"

COPY ./moellava ./moellava
COPY ./scripts ./scripts

ENV HF_HOME="/app/.cache"
#ENV NO_PROXY="localhost, 127.0.0.1, ::1"

EXPOSE 7860
ENTRYPOINT ["python3", "moellava/serve/gradio_web_server.py"]
CMD []