#!/usr/bin/env python3

from github import Github
from github import Auth
import json
import os
import requests


def get_config():
    """
    Retrieve environment variables
    """
    if not os.getenv("TOKEN"):
        print("Please set the TOKEN environment variable.")
        exit(1)
    token = os.getenv("TOKEN").strip()

    organizations = []
    if os.getenv("ORGANIZATIONS"):
        organizations = os.getenv("ORGANIZATIONS").split(",")
        organizations = [o.strip() for o in organizations]

    repos = []
    if os.getenv("REPOSITORIES"):
        repos = os.getenv("REPOSITORIES").split(",")
        repos = [r.strip() for r in repos]

    print(f"Configuration: \n\tOrganizations: {organizations}\n\tRepositories: {repos}")

    return token, organizations, repos

def get_repos(gh, organizations, repos):
    """
    Get all repos for an organization, and external repos from the config file if the
    ENV VAR was set.
    """

    gh_repos = []
    for organization in organizations:
        org_repos = gh.get_organization(organization).get_repos()
        valid_repos = [r for r in org_repos if not r.archived]
        gh_repos += valid_repos
    for repo in repos:
        gh_repos.append(gh.get_repo(repo))

    return gh_repos

def get_workflows(repos):
    """
    Get all the workflows with a `disabled_inactivity` state.
    """
    disabled_workflows = []

    for repo in repos:
        workflows_to_enable = [
            w for w in repo.get_workflows() if w.state == "disabled_inactivity"
        ]
        if workflows_to_enable:
            print(f"Repo {repo.full_name}: {len(workflows_to_enable)} workflows to enable.")
        disabled_workflows += workflows_to_enable

    return disabled_workflows


def enable_workflows(token, workflows):
    """
    Enable all the workflows.
    """
    for workflow in workflows:
        enable_url = f"{workflow.url}/enable"
        header = {"Authorization": f"Bearer {token}"}
        requests.put(enable_url, headers=header)


def main():
    """
    Enable all inactive workflows.
    """
    token, organizations, repos = get_config()

    auth = Auth.Token(token)
    github = Github(auth=auth)

    gh_repos = get_repos(github, organizations, repos)

    if not repos:
        print("No repos found.")
        exit(1)

    print(f"Scan {len(gh_repos)} repos.")
    workflows = get_workflows(gh_repos)
    print(f"Overall {len(workflows)} workflows need to be reenabled.")
    enable_workflows(token, workflows)
    print("Finished.")

main()
