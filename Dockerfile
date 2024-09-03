FROM madebytimo/cron

ARG PIP_BREAK_SYSTEM_PACKAGES="true"
ARG PIP_NO_CACHE_DIR="true"

RUN install-autonomous.sh install Python \
    && rm -rf /var/lib/apt/lists/* \
    && pip install PyGithub

COPY  files/entrypoint.sh files/github-actions-keep-alive.py /usr/local/bin/

ENV CRON="0 4 * * 3"
ENV ORGANIZATIONS=""
ENV REPOSITORIES=""
ENV TOKEN=""

ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "sleep", "infinity" ]

LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source=\
"https://github.com/mbT-Infrastructure/docker-github-actions-keep-alive"
