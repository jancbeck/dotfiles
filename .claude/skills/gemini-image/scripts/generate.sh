#!/usr/bin/env bash
set -euo pipefail

if [ -z "${GEMINI_API_KEY:-}" ]; then
  echo "Error: GEMINI_API_KEY env var not set" >&2
  exit 1
fi

if [ $# -eq 0 ]; then
  echo "Usage: generate.sh <prompt>" >&2
  exit 1
fi

PROMPT="$*"
MODEL="gemini-2.5-flash-image"
URL="https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent?key=${GEMINI_API_KEY}"

RESPONSE=$(curl -s -X POST "$URL" \
  -H "Content-Type: application/json" \
  -d "$(jq -n --arg prompt "$PROMPT" '{
    contents: [{
      parts: [{ text: $prompt }]
    }],
    generationConfig: {
      responseModalities: ["TEXT", "IMAGE"]
    }
  }')")

# Check for API error
if echo "$RESPONSE" | jq -e '.error' >/dev/null 2>&1; then
  echo "API error: $(echo "$RESPONSE" | jq -r '.error.message')" >&2
  exit 1
fi

# Extract base64 image data from first inlineData part
IMAGE_DATA=$(echo "$RESPONSE" | jq -r '
  .candidates[0].content.parts[]
  | select(.inlineData)
  | .inlineData.data' | head -1)

if [ -z "$IMAGE_DATA" ] || [ "$IMAGE_DATA" = "null" ]; then
  echo "No image returned. Text response:" >&2
  echo "$RESPONSE" | jq -r '.candidates[0].content.parts[] | select(.text) | .text' >&2
  exit 1
fi

# Print any text parts
TEXT=$(echo "$RESPONSE" | jq -r '.candidates[0].content.parts[] | select(.text) | .text' 2>/dev/null || true)
if [ -n "$TEXT" ]; then
  echo "$TEXT"
fi

mkdir -p /tmp/claude
OUTFILE="/tmp/claude/gemini-$(date +%s).png"
echo "$IMAGE_DATA" | base64 -d > "$OUTFILE"
echo "$OUTFILE"
