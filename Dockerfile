FROM alpine

# ENV LICENSE_KEY="CYYMJOmUj1Ai3BK0"
# ENV URL="https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=CYYMJOmUj1Ai3BK0&suffix=tar.gz"

WORKDIR /api

RUN apk --no-cache add curl python3 py3-pip gcc && \
    curl "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=CYYMJOmUj1Ai3BK0&suffix=tar.gz" --output GeoLite2-City.tar.gz && \
    tar -zxvf GeoLite2-City.tar.gz && \
    # ./GeoLite2-City_*/GeoLite2-City.mmdb ./GeoLite2-City.mmdb
    mv ./GeoLite2-City_*/GeoLite2-City.mmdb /api/GeoLite2-City.mmdb

### TODO:
# Build container with Python web API
# COPY GeoLite DB
# Launch API server

COPY ./requirements.txt /api/requirements.txt

RUN pip3 install --upgrade pip && \
    pip3 install --no-cache-dir --upgrade -r /api/requirements.txt

COPY ./geoip.py /api/geoip.py

CMD ["uvicorn", "geoip:app", "--host", "0.0.0.0", "--port", "8000"]