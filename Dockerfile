# Docker Container that runs the Nebra Diagnostics Tool

FROM arm32v6/alpine:3.12.4

WORKDIR /opt/

RUN apk add --no-cache \
    python3=3.8.10-r0 \
    i2c-tools=4.1-r3 \
    usbutils=012-r1 \
    py3-pip=20.1.1-r0

RUN mkdir /tmp/build
COPY ./ /tmp/build
WORKDIR /tmp/build
RUN pip install --no-cache -r /tmp/build/requirements.txt
RUN python3 setup.py install
RUN rm -rf /tmp/build
COPY bin/gateway_mfr /usr/local/bin
ENTRYPOINT ["gunicorn", "--bind", "0.0.0.0:5000", "hw_diag:wsgi_app"]
