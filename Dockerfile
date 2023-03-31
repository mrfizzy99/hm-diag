# Docker Container that runs the Nebra Diagnostics Tool

ARG BUILD_BOARD

####################################################################################################
################################## Stage: builder ##################################################
FROM balenalib/"$BUILD_BOARD"-debian-python:bullseye-build-20221215 AS builder

ENV PYTHON_DEPENDENCIES_DIR=/opt/python-dependencies

RUN mkdir /tmp/build
WORKDIR /tmp/build

COPY quectel/ ./quectel
COPY hw_diag/ ./hw_diag
COPY bigquery/ ./bigquery
COPY requirements.txt ./requirements.txt
COPY setup.py ./setup.py
COPY MANIFEST.in ./MANIFEST.in

RUN install_packages \
        build-essential \
        libdbus-glib-1-dev && \
    pip3 install --no-cache-dir --target="$PYTHON_DEPENDENCIES_DIR" . && \
    tar -xf ./quectel/qfirehose/QFirehose_Linux_Android_V1.4.9.tar.xz
    # firehose build, the tar is obtained from quectel and cleaned from build artifacts,
    # recompressed by us.

# TODO test start
# Temporary action for generating required binaries
RUN wget --progress=dot:giga "https://github.com/helium/gateway-mfr-rs/releases/download/v0.4.1/gateway-mfr-0.4.1-arm-unknown-linux-gnueabihf.tar.gz" && \
    wget --progress=dot:giga "https://github.com/helium/gateway-mfr-rs/releases/download/v0.4.1/gateway-mfr-0.4.1-aarch64-unknown-linux-gnu.tar.gz" && \
    tar -xvf "gateway-mfr-0.4.1-arm-unknown-linux-gnueabihf.tar.gz" && \
    mv gateway_mfr $PYTHON_DEPENDENCIES_DIR/hm_pyhelper/gateway_mfr_arm && \
    tar -xvf "gateway-mfr-0.4.1-aarch64-unknown-linux-gnu.tar.gz" && \
    mv gateway_mfr $PYTHON_DEPENDENCIES_DIR/hm_pyhelper/gateway_mfr_aarch64
# TODO testing end

# docker linter wants WORKDIR for changing directory
WORKDIR /tmp/build/QFirehose_Linux_Android_V1.4.9
RUN make

# No need to cleanup the builder

####################################################################################################
################################### Stage: runner ##################################################
FROM balenalib/"$BUILD_BOARD"-debian-python:bullseye-run-20221215 AS runner

ENV PYTHON_DEPENDENCIES_DIR=/opt/python-dependencies

RUN \
    install_packages \
        wget \
        i2c-tools \
        libdbus-1-3 \
        gpg \
        libatomic1

# Nebra uses /opt by convention
WORKDIR /opt/

# Import gpg key
COPY keys/manufacturing-key.gpg ./

# Copy packages from builder
COPY --from=builder "$PYTHON_DEPENDENCIES_DIR" "$PYTHON_DEPENDENCIES_DIR"

# copy modem flashing tool
COPY --from=builder /tmp/build/QFirehose_Linux_Android_V1.4.9/QFirehose /usr/sbin/QFirehose

# copy db migration files
COPY migrations/ /opt/migrations/migrations
COPY alembic.ini /opt/migrations/alembic.ini

# copy start admin session script
COPY start_admin_session /usr/sbin/start_admin_session

# Getting RUN layers together
RUN gpg --import manufacturing-key.gpg && \
    rm manufacturing-key.gpg && \
    chmod 700 /usr/sbin/start_admin_session && \
    mkdir -p /opt/nebra

# Add python dependencies to PYTHONPATH
ENV PYTHONPATH="${PYTHON_DEPENDENCIES_DIR}:${PYTHONPATH}"
ENV PATH="${PYTHON_DEPENDENCIES_DIR}/bin:${PATH}"

# Copy environment variables startup script
COPY setenv.sh /opt/nebra/setenv.sh

# Copy container startup script
COPY start_diagnostics.sh /opt/start_diagnostics.sh

ENTRYPOINT ["/opt/start_diagnostics.sh"]
