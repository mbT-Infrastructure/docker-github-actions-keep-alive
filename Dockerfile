FROM madebytimo/python AS python

RUN pip3 install PyGithub
WORKDIR /root/builder
RUN mkdir -p python/bin python/include python/lib \
    && cp --no-dereference --preserve=mode,ownership,timestamps \
    /usr/local/bin/python* /usr/local/bin/python3-latest python/bin \
    && cp --no-dereference --preserve=mode,ownership,timestamps --recursive \
    /usr/local/include/python* python/include \
    && cp --no-dereference --preserve=mode,ownership,timestamps --recursive \
    /usr/local/lib/python* python/lib \
    && rm -rf python/lib/python*/site-packages/pip*

FROM madebytimo/cron

COPY --from=python /root/builder/python /usr/local

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
