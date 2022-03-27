from fastapi import FastAPI
import ipaddress
import geoip2.database

### Database URL
# https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-ASN&license_key=YOUR_LICENSE_KEY&suffix=tar.gz
#

app = FastAPI()

    ### pseudocode ###
    # validate string is an ip address
    # lookup ip address in geoip2 db
    # fetch latitude and longitude
@app.get("/lookup/{ip_addr}")
async def lookup_ip(ip_addr: str):
    if validate_ip_address(ip_addr):
        # The ASN and Country DBs do not have a response.location, so we're using City
        with geoip2.database.Reader('GeoLite2-City.mmdb') as reader:
            response = reader.city(ip_addr)
        return { "latitude": response.location.latitude, "longitude": response.location.longitude }

    # if validate_ip_address(ip_addr):
    #     print("Good")
    #     return { "latitude": response.location.latitude, "longitude": response.location.longitude }

def validate_ip_address(address):
    try:
        ip = ipaddress.ip_address(address)
        print("IP address {} is valid. The object returned is {}".format(address, ip))
        return True
    except ValueError:
        print("IP address {} is not valid".format(address))
        return False