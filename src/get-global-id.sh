#!/bin/bash
set -e

if [[ "$IS_ORG" == "true" ]]; then
  QUERY_TARGET="organization(login: \"$OWNER\")"
else
  QUERY_TARGET="user(login: \"$OWNER\")"
fi

QUERY="
  query {
    $QUERY_TARGET {
      projectV2(number: $PROJECT_NUM) {
        id
        fields(first: 100) {
          nodes {
            ... on ProjectV2SingleSelectField {
              id
              name
              options {
                id
                name
              }
            }
          }
        }
      }
    }
  }
"

gh api graphql -f query="$QUERY" > project_data.json
cat project_data.json

if [[ "$IS_ORG" == "true" ]]; then
  echo "PROJECT_ID=$(jq -r '.data.organization.projectV2.id' project_data.json)" >> $GITHUB_ENV
else
  echo "PROJECT_ID=$(jq -r '.data.user.projectV2.id' project_data.json)" >> $GITHUB_ENV
fi


enc_data=""
echo "$FIELD_KEY_VALUES" | jq -c '.[]' | while IFS= read -r key_value; do
  field_name=$(echo "$key_value" | jq -r '.key')
  value_name=$(echo "$key_value" | jq -r '.value')

  if [[ "$IS_ORG" == "true" ]]; then
    field_id=$(jq -r --arg field_name "$field_name" '.data.organization.projectV2.fields.nodes[] | select(.name == $field_name) | .id' project_data.json)
    value_id=$(jq -r --arg field_name "$field_name" --arg option_name "$value_name" '.data.organization.projectV2.fields.nodes[] | select(.name == $field_name).options[] | select(.name == $option_name) | .id' project_data.json)
  else
    field_id=$(jq -r --arg field_name "$field_name" '.data.user.projectV2.fields.nodes[] | select(.name == $field_name) | .id' project_data.json)
    value_id=$(jq -r --arg field_name "$field_name" --arg option_name "$value_name" '.data.user.projectV2.fields.nodes[] | select(.name == $field_name).options[] | select(.name == $option_name) | .id' project_data.json)
  fi

  $enc_data+="$field_id=$value_id,"
done

echo "FIELD_ID_VALUES=$(echo "$enc_data" | sed 's/,$//')" >> $GITHUB_ENV
