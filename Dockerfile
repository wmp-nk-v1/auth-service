# UNCOMMENT THIS FOR RUNNING WITHOUT SONARQUBE SCAN
FROM        docker.io/library/golang:1.26 AS builder
WORKDIR     /app
COPY        ./ /app/
RUN         CGO_ENABLED=0 go build -o auth-service ./cmd/server

FROM        docker.io/redhat/ubi9
COPY        --from=builder  /app/auth-service .
ENTRYPOINT  [ "./auth-service" ]

# USE THIS FOR RUNNING WITH SONARQUBE SCAN
# FROM        docker.io/library/golang:1.26 AS builder
# WORKDIR     /app
# COPY        ./ /app/
# RUN         go mod tidy && CGO_ENABLED=0 go build -o auth-service ./cmd/server

# FROM        sonarsource/sonar-scanner-cli AS sonar-scanner
# WORKDIR     /usr/src
# COPY        --from=builder /app /usr/src
# RUN         sonar-scanner \
#             -Dsonar.host.url=http://34.207.195.225:9000 \
#             -Dsonar.login=admin -Dsonar.password=admin123 -Dsonar.qualitygate.wait=true \
#             -Dsonar.projectKey=auth-service \
#             -Dsonar.sources=. && \
#             touch /tmp/scan-success

# FROM        docker.io/redhat/ubi9
# COPY        --from=sonar-scanner /tmp/scan-success /tmp/
# COPY        --from=builder  /app/auth-service .
# ENTRYPOINT  [ "./auth-service" ]
