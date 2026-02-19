# Kotalk – TeamSpeak + Jitsi on one host

Run **TeamSpeak 3** (voice) and **Jitsi Meet** (video) on a single VPS with Docker.

- **TeamSpeak**: voice (up to 32 slots with default/non-profit license).
- **Jitsi Meet**: browser-based video (sized for ~10 concurrent users on a 4 GB VPS).

## Quick start

1. **Clone or copy this repo** to your server.

2. **Create env file**  
   Copy `.env.example` to `.env` and set at least:
   - `PUBLIC_URL` – your Jitsi URL (e.g. `https://meet.example.com` or `https://YOUR_VPS_IP`).
   - `JICOFO_AUTH_PASSWORD` and `JVB_AUTH_PASSWORD` – strong random passwords (e.g. `openssl rand -hex 16`).

3. **If using a domain/NAT**  
   Set `DOCKER_HOST_ADDRESS` (and optionally `JVB_ADVERTISE_IPS`) to your server’s public IP or hostname so Jitsi can advertise the correct media address.

4. **Start stack**  
   ```bash
   docker compose up -d
   ```

5. **TeamSpeak**  
   Connect with the TeamSpeak client to `YOUR_VPS_IP:9987`. On first run, the server prints a privilege key and query password in the logs (`docker compose logs teamspeak`); save them for admin.

6. **Jitsi**  
   Open `PUBLIC_URL` in a browser and create/join a room (no account if `ENABLE_AUTH=0`).

## Files

- `Dockerfile` – TeamSpeak 3 server image (based on official `teamspeak` image).
- `docker-compose.yml` – TeamSpeak + Jitsi (web, prosody, jicofo, jvb).
- `.env.example` – Example env for Jitsi (and CONFIG); copy to `.env`.

## Ports

| Service   | Port(s)              | Purpose        |
|----------|----------------------|----------------|
| TeamSpeak | 9987/udp, 10011, 30033 | Voice, query, file transfer |
| Jitsi web | 80, 443              | HTTP/HTTPS      |
| JVB      | 10000/udp            | Media (RTP)     |

Open these on your VPS firewall. For Jitsi behind NAT, set `DOCKER_HOST_ADDRESS` and optionally `JVB_ADVERTISE_IPS` in `.env`.

## Jitsi config

Jitsi stores config under `CONFIG` (default `./jitsi-cfg`). For more options (auth, Let’s Encrypt, etc.) see the [Jitsi Docker handbook](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker) and the [docker-jitsi-meet env.example](https://github.com/jitsi/docker-jitsi-meet/blob/master/env.example). You can copy that file over and run their `gen-passwords.sh` to fill the auth passwords.

## License

TeamSpeak: accept the license with `TS3SERVER_LICENSE=accept` (already set in the Dockerfile/compose). For 32 slots without a commercial license, use the non-profit license from TeamSpeak.
