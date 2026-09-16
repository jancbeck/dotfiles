---
name: gemini-image
description: Generate images using Gemini API. Use when user wants to create/generate an image.
allowed-tools: Bash(*), Read
---

# Generate Image

Generate an image from a text prompt using the Gemini image generation API.

## Instructions

1. Verify `GEMINI_API_KEY` variable is set in environment. Run the generation script with the user's prompt:
   ```bash
 bash ~/.claude/skills/gemini-image/scripts/generate.sh <prompt>
   ```
2. The script outputs any text response followed by the path to the generated PNG file.
3. Use the Read tool to display the generated image to the user.
4. If the script fails, show the error message to the user.
