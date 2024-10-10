#!/bin/bash
set -e

REPOSITORY_NAME=$(echo "$REPOSITORY" | cut -d '/' -f2)

if [[ "$EVENT_NAME" == "issues" ]]; then
  ITEM_ID=$(gh api graphql -f query='
  query($name: String!) {
    repository(owner: "$OWNER", name: $name) {
      $QUERY_TARGET {
        projectItems(first: 1) {
          nodes {
            id
          }
        }
      }
    }
  }' -f name="$REPOSITORY_NAME" --jq '.data.repository.issue.projectItems.nodes[0].id')
else
  ITEM_ID=$(gh api graphql -f query='
  query($name: String!) {
    repository(owner: "$OWNER", name: $name) {
      $QUERY_TARGET {
        projectItems(first: 1) {
          nodes {
            id
          }
        }
      }
    }
  }' -f name="$REPOSITORY_NAME" --jq '.data.repository.pull_request.projectItems.nodes[0].id')
fi

echo "ITEM_ID=$ITEM_ID" >> $GITHUB_ENV
