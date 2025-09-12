#!/usr/bin/python3

import os
import requests
import json

PR_API_URL = "https://git.crueter.xyz/api/v1/repos/QFRC/QDash/pulls"
FORGEJO_NUMBER = os.getenv("FORGEJO_NUMBER")
FORGEJO_TOKEN = os.getenv("FORGEJO_TOKEN")
DEFAULT_MSG = os.getenv("DEFAULT_MSG")
FIELD = os.getenv("FIELD")

def get_pr_json():
    headers = {"Authorization": f"token {FORGEJO_TOKEN}"}
    response = requests.get(f"{PR_API_URL}/{FORGEJO_NUMBER}", headers=headers)
    return response.json()

def get_pr_field():
    try:
        pr_json = get_pr_json()
        return pr_json.get(FIELD, DEFAULT_MSG)
    except:
        return DEFAULT_MSG

field = get_pr_field().replace("`", "\\`")
print(field if field != "" else DEFAULT_MSG)