FROM quay.io/toolbx-images/ubuntu-toolbox:latest AS browserbox

ARG BROWSER_NAME="${BROWSER_NAME:-brave}"

RUN case "$BROWSER_NAME" in \
    brave) \
      curl -fsSLo "/usr/share/keyrings/brave-browser-archive-keyring.gpg" https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg && \
      echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | \
      tee "/etc/apt/sources.list.d/brave-browser-release.list" && \
      apt update -y && \
      apt install -y brave-browser \
      ;; \
    firefox) \
      apt install -y software-properties-common && \
      add-apt-repository ppa:mozillateam/ppa && \
      echo "Package: *\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 1001" | \
      tee "/etc/apt/preferences.d/mozilla-firefox" && \
      apt update -y && \
      apt install -y firefox \
      ;; \
    esac
