from fastapi import FastAPI
import geoip2.database
import ipaddress
import os
import requests
import tarfile

def download_db():
    print("Downloading latest database...")
    url = "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=CYYMJOmUj1Ai3BK0&suffix=tar.gz"
    file = "GeoLite2-City.tar.gz"

    response = requests.get(url)
    # print(response.status_code)
    with open(file, 'wb') as f:
        f.write(response.content)
    f.close()

    with open('GeoLite2-City.mmdb', 'wb') as f:
        with tarfile.open(file, 'r:gz') as tar:
            for member in tar.getmembers():
                if os.path.splitext(member.name)[1] == '.mmdb':
                    r = tar.extractfile(member)
                    if r is not None:
                        content = r.read()
                    r.close
                    f.write(content)
        tar.close()
    f.close()

# Call this before we start the API
download_db()

app = FastAPI()

@app.get("/lookup/{ip_addr}")
async def lookup_ip(ip_addr: str):
    if validate_ip_address(ip_addr):
        with geoip2.database.Reader('GeoLite2-City.mmdb') as reader:
            response = reader.city(ip_addr)
        return { "latitude": response.location.latitude, "longitude": response.location.longitude }

def validate_ip_address(address):
    try:
        ip = ipaddress.ip_address(address)
        print("IP address {} is valid. The object returned is {}".format(address, ip))
        return True
    except ValueError:
        print("IP address {} is not valid".format(address))
        return False