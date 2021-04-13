ARG FROM_IMAGE_NAME=nvcr.io/nvidia/pytorch:20.03-py3
FROM ${FROM_IMAGE_NAME}

ADD . /workspace/tacotron2
WORKDIR /workspace/tacotron2
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir uvicorn gunicorn
RUN pip install --no-cache-dir fastapi

#COPY ./start.sh /start.sh
RUN chmod +x /workspace/tacotron2/app/start.sh

#COPY ./gunicorn_conf.py /gunicorn_conf.py

#COPY ./start-reload.sh /start-reload.sh
RUN chmod +x /workspace/tacotron2/app/start-reload.sh

ENV PYTHONPATH=/workspace/tacotron2/app

ENV PORT=8000
EXPOSE 8000

CMD ["/workspace/tacotron2/app/start.sh"]
