from flask import Flask, request
import subprocess

app = Flask(__name__)


#retrieves entered SSID and pwd and updates wpa_wifi
@app.route('/submit', methods=['POST'])
def submit():
    data = request.form
    ssid = data.get('ssid')
    pwd = data.get('pwd')
    
    wps = f'''
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={{
    ssid="{ssid}"
    psk="{pwd}"
}}
    '''
    with open("/home/admin/config/wifi/wps_wifi.conf", 'w') as f:
        f.write(wps)
    
    rc = subprocess.run(["sudo", "/home/admin/config/start_wifi.sh"])
    
    return 'Connection Successful.'
    

if __name__ == "__main__":
    app.run(host='localhost',port=8080)
