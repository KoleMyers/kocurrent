# TeamSpeak 3 server for voice (runs alongside Jitsi for video on same host)
# Official image: https://hub.docker.com/_/teamspeak
FROM teamspeak:latest

# Accept license so server can start non-interactively (required)
ENV TS3SERVER_LICENSE=accept

# Ports: 9987/udp voice, 10011 serverquery, 30033 file transfer
EXPOSE 9987/udp 10011 30033

# Optional: set timezone to match host (override in compose if needed)
# ENV TZ=UTC
