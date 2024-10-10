#!/bin/bash
set -e

for field_id_value in $(echo "$FIELD_ID_VALUES" | tr ',' '\n'); do
  field_id=$(echo $field_id_value | cut -d '=' -f1)
  value_id=$(echo $field_id_value | cut -d '=' -f2)

  gh project item-edit --id "$ITEM_ID" --field-id "$field_id" --project-id "$PROJECT_ID" --single-select-option-id "$value_id"
done
