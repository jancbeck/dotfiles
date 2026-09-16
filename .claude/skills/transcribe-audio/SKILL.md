---
name: transcribe-audio
description: "Transcribe an audio or video file to text, SRT, VTT, Markdown, or JSON using the Spokenly CLI, with optional speaker labels. Use when asked to transcribe a recording, get a transcript, or caption an audio/video file on macOS."
---

# transcribe-audio

Transcribe audio/video with the **Spokenly** CLI. Spokenly runs on the Mac; the CLI forwards the file to the running app, which transcribes locally (if a local model like NVIDIA Parakeet is selected) or via Spokenly's server.

## Preflight

- `command -v spokenly` — must resolve. If missing: the user installs it from **Spokenly → General Settings → Install CLI** (macOS asks for a password to symlink into `/usr/local/bin`).
- The **Spokenly app must be running** in the background, or the command errors out.
- The model is whatever is selected in the app's **Transcribe File** section. For fully on-device transcription, a local model must be selected there — the CLI has no flag for it.

## Command

```bash
spokenly transcribe <file...> [options]
```

| Flag | Meaning |
|------|---------|
| `-f, --format <fmt>` | `text` (default), `srt`, `vtt`, `markdown`, `json` |
| `-s, --speakers` | Include speaker labels (Speaker 1, Speaker 2, …) |
| `-V, --version` | Print CLI version |
| `-h, --help` | Help |

Output goes to stdout — redirect to a file. Multiple files transcribe in sequence.

## Recipes

```bash
# Conversation → Markdown with speakers, saved beside the source
spokenly transcribe interview.m4a --format markdown --speakers > interview.transcript.md

# Subtitles
spokenly transcribe talk.mp4 --format vtt > talk.vtt

# Straight to clipboard
spokenly transcribe memo.mp3 | pbcopy

# JSON with timestamps for downstream tooling
spokenly transcribe meeting.mp3 --format json | jq '.segments[].text'
```

## Notes

- `--speakers` fills `speakerId` in JSON and prefixes lines in text/markdown; speaker identity is diarized (Speaker N), not named — rename in a post-pass if you know who is who.
- Machine transcripts carry artifacts (filler words, the occasional hallucinated proper noun). Treat the raw output as a draft; clean only if the transcript itself is a deliverable.
- Requires Spokenly **2.18.13+**. Full docs: https://spokenly.app/llms-full.txt
