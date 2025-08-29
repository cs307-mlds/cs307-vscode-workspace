# start from PL vscode image
FROM prairielearn/workspace-vscode-base:latest
ARG CACHEBUST=2025-08-15-14-16-03

# set a new label for the image
LABEL org.label-schema.license="AGPL-3.0" \
      org.label-schema.vcs-url="daviddalpiaz/cs307-vscode-workspace" \
      org.label-schema.vendor="VSCode Workspace for Python and Jupyter in CS 307 @ UIUC" \
      maintainer="David Dalpiaz <dalpiaz2@illinois.edu>"

# install Python and required packages via uv
USER coder
COPY pyproject.toml /home/coder/
RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
    && cd /home/coder \
    && /home/coder/.local/bin/uv sync --compile-bytecode

# add the virtual environment to PATH for all users
ENV PATH="/home/coder/.venv/bin:$PATH"

# copy custom VSCode settings
COPY --chown=coder:coder settings.json /home/coder/.local/share/code-server/User/

# install VSCode extensions
USER coder
RUN code-server --disable-telemetry --force \
    --install-extension ms-python.python \
    --install-extension ms-toolsai.jupyter \
    && rm -rf /home/coder/.local/share/code-server/CachedExtensionVSIXs
