FROM python:3.10.14-bookworm

WORKDIR app

COPY ./* .

RUN pip install --upgrade pip  # enable PEP 660 support
RUN pip install -e .
RUN pip install -e ".[train]"
RUN pip install flash-attn --no-build-isolation

EXPOSE 9920

ENTRYPOINT ["python", "moellava/serve/gradio_web_server.py"]