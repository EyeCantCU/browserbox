FROM quay.io/toolbx-images/ubuntu-toolbox:latest AS browserbox

ARG BROWSER_NAME="${BROWSER_NAME:-brave}"
ARG ENGINE_TYPE="${ENGINE_TYPE:-blink}"

# Use apt user for browser installation
RUN echo "_apt ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER _apt

# Install browser
RUN sudo apt update -y && \
    if [[ "$ENGINE_TYPE" == "blink" ]]; then \
      echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | \
      sudo debconf-set-selections && \
      sudo apt install -y ttf-mscorefonts-installer \
    ; fi && \
    case "$BROWSER_NAME" in \
    brave) \
      sudo curl -fsSLo "/usr/share/keyrings/brave-browser-archive-keyring.gpg" https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg && \
      echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | \
      sudo tee "/etc/apt/sources.list.d/brave-browser-release.list" && \
      sudo apt update -y && \
      sudo apt install -y brave-browser \
      ;; \
    chrome) \
      sudo curl -fsSLo "/etc/apt/keyrings/linux_signing_key.pub" https://dl-ssl.google.com/linux/linux_signing_key.pub && \
      echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/linux_signing_key.pub] http://dl.google.com/linux/chrome/deb/ stable main" | \
      sudo tee "/etc/apt/sources.list.d/google-chrome.list" && \
      sudo apt update -y && \
      sudo apt install -y google-chrome-stable \
      ;; \
    chromium) \
      sudo apt install -y chromium-browser \
      ;; \
    firefox) \
      sudo apt install -y software-properties-common && \
      sudo add-apt-repository ppa:mozillateam/ppa && \
      echo "Package: *\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 1001" | \
      sudo tee "/etc/apt/preferences.d/mozilla-firefox" && \
      sudo apt update -y && \
      sudo apt install -y firefox \
      ;; \
    floorp) \
      curl -fsSL https://ppa.ablaze.one/KEY.gpg | \
      sudo gpg --dearmor -o "/usr/share/keyrings/Floorp.gpg" && \
      sudo curl -sS --compressed -o "/etc/apt/sources.list.d/Floorp.list" 'https://ppa.ablaze.one/Floorp.list' && \
      sudo apt update -y && \
      sudo apt install -y floorp \
      ;; \
    esac

# Return to root user
USER root

# Cleanup
RUN sed -i '/_apt ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers && \
    sed -i '/root ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers
