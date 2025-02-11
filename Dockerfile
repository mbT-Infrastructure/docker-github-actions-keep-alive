FROM madebytimo/python AS builder

RUN pip3-latest install PyGithub
WORKDIR /root/builder
RUN PYTHON_VERSION="$(python3-latest --version | sed 's|Python \([0-9]*\.[0-9]*\)\.[0-9]*|\1|')" \
    && mkdir -p python/bin python/include python/lib \
    && cp --preserve=mode,ownership,timestamps --recursive \
        "/usr/local/bin/python${PYTHON_VERSION}"* /usr/local/bin/python3-latest python/bin \
    && cp --preserve=mode,ownership,timestamps --recursive \
        "/usr/local/include/python${PYTHON_VERSION}" python/include \
    && cp --preserve=mode,ownership,timestamps --recursive \
        "/usr/local/lib/python${PYTHON_VERSION}" python/lib \
    && rm -rf "python/lib/python${PYTHON_VERSION}/site-packages/pip"* \
    && cp --preserve=mode,ownership,timestamps python/bin/python3-latest python/bin/python3

FROM madebytimo/cron

ARG PIP_BREAK_SYSTEM_PACKAGES="true"
ARG PIP_NO_CACHE_DIR="true"

COPY --from=builder /root/builder/python /usr/local

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
