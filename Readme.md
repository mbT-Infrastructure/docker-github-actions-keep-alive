# Github Actions Keep Alive image

This image contains a Python script which reenables by inactivity disabled workflows. It is a
modified version of that used in [`invenia/KeepActionsAlive`].

The Python script is executed regularly by cron.

## Installation

1. Pull from [Docker Hub], download the package from [Releases] or build using `builder/build.sh`

## Usage

This Container image extends the [cron image].

### Environment variables

-   `CRON`
    -   The time to run the check. The default is `0 4 * * 3`.
-   `ORGANIZATIONS`
    -   Comma separated list of organizations of which all repos should be scanned. For example
        `mbT-Infrastructure`.
-   `REPOSITORIES`
    -   Comma separated list of repos that should be scanned. For example
        `mbT-Infrastructure/docker-github-actions-keep-alive`.
-   `TOKEN`
    -   GitHub token with `actions read and write` permissions.

## Development

To run for development execute:

```bash
docker compose --file docker-compose-dev.yaml up --build
```

[cron image]: https://github.com/mbT-Infrastructure/docker-cron
[`invenia/KeepActionsAlive`]: https://github.com/invenia/KeepActionsAlive
[Docker Hub]: https://hub.docker.com/r/madebytimo/github-actions-keep-alive
[Releases]: https://github.com/mbT-Infrastructure/docker-github-actions-keep-alive/releases
