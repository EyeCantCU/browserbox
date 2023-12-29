FROM quay.io/toolbx-images/ubuntu-toolbox:latest AS browserbox

ARG BROWSER_NAME="${BROWSER_NAME:-brave}"

# Use apt user for browser installation
RUN echo "_apt ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER _apt

# Install browser
RUN sudo apt update -y && \
    case "$BROWSER_NAME" in \
    brave) \
      sudo curl -fsSLo "/usr/share/keyrings/brave-browser-archive-keyring.gpg" https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg && \
      echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | \
      sudo tee "/etc/apt/sources.list.d/brave-browser-release.list" && \
      sudo apt update -y && \
      sudo apt install -y brave-browser \
      ;; \
    firefox) \
      sudo apt install -y software-properties-common && \
      sudo add-apt-repository ppa:mozillateam/ppa && \
      echo "Package: *\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 1001" | \
      sudo tee "/etc/apt/preferences.d/mozilla-firefox" && \
      sudo apt update -y && \
      sudo apt install -y firefox \
      ;; \
    esac

# Return to root user
USER root

# Cleanup
RUN sed -i '/_apt ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers && \
    sed -i '/root ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers
