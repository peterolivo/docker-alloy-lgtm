FROM redhat/ubi8

ENV GRAFANA_VERSION="11.0.0"
ENV PROMETHEUS_VERSION="2.52.0"
ENV TEMPO_VERSION="2.4.2"
ENV LOKI_VERSION="3.0.0"
ENV ALLOY_VERSION="1.1.1"

# TARGETARCH is automatically detected and set by the Docker daemon during the build process. If the build starts
# on an amd64 architecture, than the TARGETARCH will be set to `amd64`.
# More details on the variables can be found here: https://docs.docker.com/desktop/extensions-sdk/extensions/multi-arch/
ARG TARGETARCH
ENV TARGETARCH=${TARGETARCH}

RUN mkdir /alloy-lgtm
WORKDIR /alloy-lgtm

RUN yum install -y unzip jq procps

RUN curl -sOL https://dl.grafana.com/oss/release/grafana-$GRAFANA_VERSION.linux-${TARGETARCH}.tar.gz && \
    tar xfz grafana-$GRAFANA_VERSION.linux-${TARGETARCH}.tar.gz && \
    rm grafana-$GRAFANA_VERSION.linux-${TARGETARCH}.tar.gz

RUN curl -sOL https://github.com/prometheus/prometheus/releases/download/v$PROMETHEUS_VERSION/prometheus-$PROMETHEUS_VERSION.linux-${TARGETARCH}.tar.gz && \
    tar xfz prometheus-$PROMETHEUS_VERSION.linux-${TARGETARCH}.tar.gz && \
    mv prometheus-$PROMETHEUS_VERSION.linux-${TARGETARCH} prometheus-$PROMETHEUS_VERSION && \
    rm prometheus-$PROMETHEUS_VERSION.linux-${TARGETARCH}.tar.gz

RUN curl -sOL https://github.com/grafana/tempo/releases/download/v$TEMPO_VERSION/tempo_${TEMPO_VERSION}_linux_${TARGETARCH}.tar.gz && \
    mkdir tempo-$TEMPO_VERSION/ && \
    tar xfz tempo_${TEMPO_VERSION}_linux_${TARGETARCH}.tar.gz -C tempo-$TEMPO_VERSION/ && \
    rm tempo_${TEMPO_VERSION}_linux_${TARGETARCH}.tar.gz

RUN curl -sOL https://github.com/grafana/loki/releases/download/v$LOKI_VERSION/loki-linux-${TARGETARCH}.zip && \
    mkdir loki-$LOKI_VERSION && \
    unzip loki-linux-${TARGETARCH} -d loki-$LOKI_VERSION/ && \
    rm loki-linux-${TARGETARCH}.zip

RUN curl -sOL https://github.com/grafana/alloy/releases/download/v$ALLOY_VERSION/alloy-linux-${TARGETARCH}.zip && \
    mkdir alloy-$ALLOY_VERSION && \
    unzip alloy-linux-${TARGETARCH}.zip -d alloy-$ALLOY_VERSION && \
    rm alloy-linux-${TARGETARCH}.zip

COPY prometheus.yaml .
COPY run-prometheus.sh .
COPY grafana-datasources.yaml ./grafana-v$GRAFANA_VERSION/conf/provisioning/datasources/
COPY grafana-dashboards.yaml grafana-v$GRAFANA_VERSION/conf/provisioning/dashboards/
COPY grafana-dashboard-red-metrics-classic.json .
COPY grafana-dashboard-red-metrics-native.json .
COPY grafana-dashboard-jvm-metrics.json .
COPY run-grafana.sh .
COPY loki-config.yaml .
COPY run-loki.sh .
COPY tempo-config.yaml .
COPY run-tempo.sh .
COPY config.alloy .
COPY run-alloy.sh .
COPY run-all.sh .

CMD ./run-all.sh
