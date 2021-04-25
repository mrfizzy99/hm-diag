# Detects all the hardware and responds them for diagnostics json

# Pin Definitions

# Stores the SPI bus to be used, the reset pin,
# and the network interface mac to use.

variant_definitions = {
# Nebra Indoor Hotspot
"NEB-IN" : {
    'spibus': 'spidev1.2',
    'reset' : 38,
    'mac' : 'eth0',
    'fcc-id' : '2AZDM-HNTIN',
    'ic-id': '27187-HNTIN'
    },
# Nebra Outdoor Hotspot
"NEB-OUT" : {'spibus': 'spidev1.2', 'reset' : 38, 'mac' : 'eth0'},
# Nebra Light Pi Zero Hotspot
"NEB-LITE-PZW" : {'spibus': 'spidev1.2', 'reset' : 22, 'mac' : 'wlan0'},
# Nebra Light Pocket Beaglebone Hotspot
"NEB-LITE-PBB" : {'spibus': 'spidev0.0', 'reset' : 42, 'mac' : 'eth0'},
# Original Helium Hotspot
"HELIUM-HOTSPOT" : {'spibus': 'spidev0.0', 'reset' : 42, 'mac' : 'wlan0'},
# RAK Hotspot
"RAK-HOTSPOT" : {'spibus': 'spidev0.0', 'reset' : 42, 'mac' : 'wlan0'},
# Syncrobit Hotspot
"SYNCROBIT" : {'spibus': 'spidev0.0', 'reset' : 42, 'mac' : 'wlan0'}
}

# List of USB Wi-Fi Adaptors used

usb_wifi_adaptor_ids = {
"148f:5370" : "RT5370"
}

# List of LTE adaptor combinations

lte_adaptor_ids = {
"2c7c:0125" : "QUECTEL-EC25"
}
