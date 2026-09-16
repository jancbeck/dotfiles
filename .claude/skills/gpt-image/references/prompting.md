# Prompting

Condensed from OpenAI's [image prompting guide](https://developers.openai.com/api/docs/guides/image-prompting). Set API parameters with CLI flags, not in the prompt.

## Choose a model

| Model | Use when |
| --- | --- |
| `gpt-image-2.5-flare` | Speed matters. Quality comparable to `gpt-image-2`, lower latency. First candidate for an existing `gpt-image-2` workflow. |
| `gpt-image-2.5-sunburst` | Quality matters. Better than `gpt-image-2`; try it when `gpt-image-2` falls short on a complex request. |
| `gpt-image-2` | Existing, validated workflows. |

Both 2.5 models support generation, edits, and transparent backgrounds, and are better at precise edits and subject preservation. Once Sunburst meets the bar, test Flare with the same prompt and inputs and switch if quality holds.

## Parameters

- `quality`: `auto`, `low`, `medium`, `high`; 2.5 models add `xhigh` and `max`. Start at `medium`; use `high` for small text, dense labels, legends, and slides. Use `xhigh`/`max` only when a lower setting misses a concrete requirement. The same label does not mean the same quality or latency across models.
- `size`: `auto` or `WIDTHxHEIGHT`. Common sizes: `1024x1024`, `1536x1024`, `1024x1536`, `1536x864` (deck slides), `2048x2048`, `2048x1152`, `3840x2160`, `2160x3840`. Outputs above `2560x1440` (3,686,400 pixels) are experimental.
- `background=transparent`: use PNG or WebP, and also ask for transparency in the prompt. Check the alpha channel on hair, glass, shadows, and edges. A drawn checkerboard is not transparency.
- `output_compression`: JPEG or WebP only.
- `input_fidelity`: omit for `gpt-image-2*`; image inputs are always high fidelity.

## Fundamentals

1. **Define the result.** Name the subject and the intended use (product photo, ad, diagram, slide). Give composition, aspect, and placement. For complex requests, use labeled sections: Scene, Subject, Details, Style, Constraints.
2. **Use a maintainable format.** Prose, bullet lists, and JSON-like structures all work; no special syntax is needed.
3. **Describe visible details.** Materials, lighting, colors, medium, framing, texture. Say "photorealistic" or "real photograph" when that is the goal. Lens and film cues shape the look but aren't exact physical simulation. For atmospheric scenes, specify scale, atmosphere, and color rather than mood words.
4. **Specify people and actions.** Body framing ("full body visible, feet included"), relative scale, gaze, and how hands interact with objects.
5. **Specify exact text.** Quote the copy, say how many times it appears, and give its position and typography. Spell unusual words letter by letter. Add "no extra text". Verify spelling afterwards.
6. **Separate changes from constraints.** For edits, write "change only X" and list what to preserve (identity, geometry, layout, lighting, labels, camera angle). Exclude unwanted text, logos, and watermarks.
7. **Assign roles to references.** Number each input image and give it a purpose (subject, style, clothing, background), then say how they combine.
8. **Iterate one change at a time.** Feed the previous output back as the edit input, request one change, and restate critical constraints if the result drifts. If a region must stay pixel-identical, composite it instead of relying on the prompt.

## Patterns

- **Photorealism:** "candid photograph … 35mm film, medium close-up at eye level, 50mm lens, soft daylight, shallow depth of field, subtle grain. Honest and unposed; no glamorization, no heavy retouching."
- **Infographic or process:** name the process and audience, list every component, and check labels and relationships for accuracy.
- **Slides, charts, diagrams:** write it as an artifact spec: the deliverable, canvas, hierarchy, the real numbers and labels, the typeface, and "no clip art, stock photos, gradients, or decorative clutter". Use a landscape size and `high` quality.
- **Educational visuals:** audience, lesson objective, required labels, a flat consistent icon style, clear arrows, white space, "avoid tiny text".
- **Logos:** "original, non-infringing", vector-like shapes, a strong silhouette, legible at small sizes, flat design. For transparent output: "single centered logo, generous padding, clean alpha edges, no backdrop, checkerboard, or watermark". Use `--n` for variations.
- **UI mockups:** describe the product as if it already shipped (layout, hierarchy, spacing, real elements) and avoid concept-art language. Optionally "place in an iPhone frame".
- **Comics:** one concrete, action-focused visual beat per panel ("Panel 1: …").
- **Historical scenes:** name the place and date and ask for period-accurate clothing and staging, then check the result.
- **Translate text:** "Translate the text to Spanish. Do not change any other aspect of the image." Check for leftover words.
- **Style transfer:** "Use the same style from the input image and generate <new subject>."
- **Preserve identity:** "Do not change her face, facial features, skin tone, body shape, pose, or identity. Replace only the clothing … match lighting, shadows, and color temperature. Do not change the background, camera angle, or framing."
- **Compositing:** "Place the dog from image 2 into image 1, right next to the woman, with matching lighting. Do not change anything else."
- **Product cutout:** "Extract the product and isolate it on a fully transparent background. Crisp silhouette, no halos. Preserve geometry and label legibility exactly. No backdrop, checkerboard, or shadow." Use `--background transparent --format png`.
- **Sketch to render:** "Preserve the exact layout, proportions, and perspective. Realistic materials and lighting. Do not add new elements or text."
- **Remove or replace an object:** "Remove the flower from the man's hand. Do not change anything else." / "Replace ONLY the white chairs with wooden chairs; preserve camera angle, lighting, shadows, and surrounding objects."
- **Consistent character:** first establish a reference (appearance, outfit, proportions, style, constraints). For each new scene, pass that image in and repeat a "Character Consistency" list plus "Do not redesign the character".
- **Cards and merchandise:** scene, mood, style (materials, studio lighting), constraints ("original design, no trademarks, logos, or watermarks"), and "Include ONLY this text (verbatim): …".

## Check the result

- Is required text accurate and legible? Are labels and relationships correct?
- Are identities, product shapes, labels, and reference details intact?
- Did the edit change only what was requested?
- If transparency is required, does the file have a real alpha channel?
