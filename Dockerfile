FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:99
ENV RESOLUTION=1920x1080x24

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates xvfb x11vnc fonts-liberation \
    dbus-x11 supervisor curl gnupg websockify novnc socat \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/log/*

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npx playwright install --with-deps chromium \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/log/*

RUN useradd -m -s /bin/bash browser \
    && mkdir -p /home/browser/.cache \
    && cp -r /root/.cache/ms-playwright /home/browser/.cache/ \
    && chown -R browser:browser /home/browser

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY start-chromium.sh /usr/local/bin/start-chromium.sh
RUN chmod +x /usr/local/bin/start-chromium.sh
RUN ln -sf /usr/share/novnc/vnc.html /usr/share/novnc/index.html

EXPOSE 80 9222
HEALTHCHECK CMD curl --fail http://127.0.0.1:9222/json/version || exit 1
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
