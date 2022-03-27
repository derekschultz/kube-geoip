FROM alpine

WORKDIR /api

RUN apk --no-cache add curl python3 py3-pip gcc

COPY ./requirements.txt /api/requirements.txt

RUN pip3 install --upgrade pip && \
    pip3 install --no-cache-dir --upgrade -r /api/requirements.txt

COPY ./geoip.py /api/geoip.py

CMD ["uvicorn", "geoip:app", "--host", "0.0.0.0", "--port", "8000"]