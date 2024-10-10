#!/bin/bash
set -e

if [[ "$EVENT_NAME" == "issues" ]]; then
  URL=$ISSUE_HTML_URL
elif [[ "$EVENT_NAME" == "pull_request" ]]; then
  URL=$PR_HTML_URL
fi

gh project item-add $PROJECT_NUM --owner $OWNER --url $URL
