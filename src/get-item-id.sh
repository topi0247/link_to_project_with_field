#!/bin/bash
set -e

REPOSITORY_NAME=$(echo "$REPOSITORY" | cut -d '/' -f2)

if [[ "$EVENT_NAME" == "issues" ]]; then
  QUERY_TARGET="issue(number: $ISSUE_NUMBER)"
else
  QUERY_TARGET="pullRequest(number: $PR_NUMBER)"
fi

QUERY="
  query {
    repository(owner: \"$OWNER\", name: \"$REPOSITORY_NAME\") {
      $QUERY_TARGET {
        projectItems(first: 1) {
          nodes {
            id
          }
        }
      }
    }
  }
"

if [[ "$EVENT_NAME" == "issues" ]]; then
  ITEM_ID=$(gh api graphql -f query="$QUERY" --jq '.data.repository.issue.projectItems.nodes[0].id')
else
  ITEM_ID=$(gh api graphql -f query="$QUERY" --jq '.data.repository.pullRequest.projectItems.nodes[0].id')
  echo "ITEM_ID=$ITEM_ID"
fi

echo "ITEM_ID=$ITEM_ID" >> $GITHUB_ENV
