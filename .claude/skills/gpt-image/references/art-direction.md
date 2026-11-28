# Art direction

How to get images out of GPT Image that look like art or like a real photograph, not like a stock poster. These findings come from about 300 generations for a concept-art project (an alternate-history city at giant scale) with `gpt-image-2.6-sunburst` and `-flare`. The principles carry over to other subjects and styles; the examples are only illustrations.

Read [prompting.md](./prompting.md) first for parameters and OpenAI's own patterns. This file covers what those patterns do not: why the default output looks artificial, and which prompt choices change that.

## The default look and why it happens

Without direction, GPT Image produces a "house style". You will recognise it, and so will the user:

- **Poster composition.** The subject is centred, seen from the front, complete and legible. Every element the prompt names appears, fully visible.
- **Even, tone-mapped light.** Shadows are lifted and highlights pulled down, as if processed in HDR. Mid-tones carry strong local contrast, like a clarity filter. Real photographs have areas that fall into darkness; these images do not.
- **Detail everywhere.** Every brick, tile, crowd member and window is rendered at the same sharpness. The eye has nowhere to rest, and the background competes with the subject.
- **The most obvious version of every noun.** "Byzantine" gives the Hagia Sophia, "ship" gives a gilded prow, "Roman" gives togas and marble. Gold, ornament and symbols pile up on everything.
- **Posed people.** Figures stand like actors on a set, look important, and do one task each.

Each of these traits has a prompt-side fix. Style words alone do not change them; they only change colour and medium on top of the same composition.

## Principles

### 1. The subject line decides the composition; style words only change the finish

In a test of 30 style variations on one fixed subject (film stocks, cinematographers, painters, lighting, Midjourney parameters), 28 images had the same composition: a centred, frontal gate with a cypress on the left. The style words changed grading and medium, nothing else.

So put the camera into the subject line: vantage point, distance, crop, what is in front. For example:

- "From the top of a column where a boy has climbed, looking straight down at an army marching along the avenue."
- "Seen from the deck of a rowing galley, oarsmen in the foreground, passing under a tower."
- "High on scaffolding inside a dome under construction, the city visible through an unfinished window far below."

Varied vantage points produced the biggest jump in quality of the whole project.

### 2. One strong idea per prompt

The model has room for about one dominant instruction. A long world description pushes the style words out, and a strong style line pushes the content out. When a round "loses" its style or its scale, the cause is almost always a paragraph added elsewhere in the prompt.

A structure that worked:

1. The scene with its vantage point (one or two sentences).
2. A short style line (one sentence).
3. At most one or two control lines aimed at a known failure (light, people, detail).

Shared "world" paragraphs are useful for consistency across a series, but keep them short and expect them to dilute the style.

### 3. Name the parts, not the label

Famous labels pull in their famous image. "Constantinople" or "Byzantine cathedral" always produced a Hagia Sophia copy; a negative ("no Hagia Sophia") was not enough. Describing what the building is made of worked: "hundreds of small domes on tall drums stacked in uneven tiers of brick and pale stone, timber galleries, no single big central dome". The same applies to any iconic subject: describe its parts, materials and construction, and leave out its name.

### 4. Use the vocabulary the training data was labelled with

Abstract descriptions ("loose brushwork, restrained palette, soft light") reach a generic middle. Names of artists, cinematographers, films, media and film stocks reach specific clusters of images and bring their whole art direction with them: composition, darkness, gradients, vignette.

| Style line | Effect |
|---|---|
| "cinematic still, Roger Deakins cinematography" | Dark, calm, silhouettes, real shadows; the most reliable photographic look |
| "Denis Villeneuve epic, Greig Fraser cinematography, anamorphic 35mm film" | Monumental, hazy, strong gradients |
| "Andrei Tarkovsky film still, rain, muted colour" | Quiet, soft, low contrast, environmental mood |
| "architectural capriccio oil painting in the manner of Hubert Robert" | Warm, airy painting; works best with people doing things in the foreground |
| "epic romantic oil painting in the manner of John Martin and Ivan Aivazovsky" | Sublime scale, glowing haze, dramatic sky |
| "J. M. W. Turner watercolour" | Light dissolves form; often too washed out |
| "charcoal drawing in the manner of Hugh Ferriss" | Dramatic, but the model will not draw truly rough charcoal |
| "35mm film photograph, Kodak Portra 400" | Natural daylight photo; on its own close to the default look |
| "octane render, unreal engine, trending on artstation, 8k" | The busiest result; avoid |
| "--ar 3:2 --style raw" (Midjourney parameters) | No effect |

**Blocked names.** OpenAI's filter rejects some artist names, mostly living or recently deceased ones. Blocked in testing: Craig Mullins, Roger Dean, Moebius, Syd Mead, Zdzisław Beksiński, John Singer Sargent, Nicholas Roerich (once). Accepted: Roger Deakins, Greig Fraser, Denis Villeneuve, Ridley Scott, Andrei Tarkovsky, Hubert Robert, John Martin, Ivan Aivazovsky, Turner, Hugh Ferriss, Chesley Bonestell, Caravaggio, Gérôme, Alma-Tadema. The filter is not deterministic: the same prompt can pass on a second try. When a style prompt is blocked, retry once, then drop one name at a time.

### 5. Describe light as physics, not as mood

"Golden hour" or "dramatic lighting" gives the even, poster light. Describing what light does gave the believable result:

> Low raking sun, light bouncing off water and stone into the shadows, warm rim light and specular glints on gold, bronze and wet surfaces, cool reflected sky light in the shade, parts of the frame in real shadow. Haze only in the far distance, never over the main subject.

Add a dynamic-range line against the tone-mapped look:

> A single exposure with natural dynamic range: shadows fall dark, no HDR tone mapping, no local-contrast boost, no sharpening, soft mid-tones.

This line removes the tone-mapped look, but the light can still be even: every part of the frame exposed well, the histogram a neat bell curve. That evenness is what makes an image read as a film set or a render. The fix that gave a real in-camera look was to describe the exposure itself, as a compromise a camera makes:

> Light is uneven and physical: one low natural source, bounce light off stone, rim light on hair and shoulders. The camera exposes for the subject and the rest is a compromise: large parts of the frame fall into deep shadow where figures read only as silhouettes, the brightest sky and sunlit stone clip to white. Backgrounds, buildings and trees sink into darkness and are not fully legible. Imperfections of a real lens and film: slight chromatic aberration at the edges, halation around highlights, fine film grain, a casual slightly off-centre framing. No HDR, no local-contrast boost, no sharpening, no even fill light, no evenly lit film-set look.

Why it works: a real camera has less dynamic range than the scene, so the photographer chooses what is exposed well and lets the rest go. Naming that choice gives the model permission to lose detail, which it otherwise never does. The background keeps its silhouette, so the place still feels large, and the eye goes to the well-lit subject. A light-only edit of a finished image ("keep this image exactly; change only the light and photographic quality") with this block improved images that were already good.

Do not overshoot: "the background falls into deep shadow" on its own turned a whole hillside into a flat black shape. Ask for silhouettes and shapes that stay readable, not for darkness.

Haze and fog are tempting because they hide detail. Used everywhere they make the image empty; keep them to the distance.

### 6. Say where the detail goes

For painterly styles, a detail hierarchy written in the language of the medium removes the noise:

> Paint in large flat planes of colour, like a gouache or oil sketch done in a few minutes. Walls, fog, sky and paving are simple, nearly flat tones with a few broad strokes. No fine texture, no grime, no cracks, no speckle, no wisps or swirls; detail only on the one focal object.

Findings:

- The full block works; a one-line version ("no grime, no speckle") brings the noise back.
- Name the focal area explicitly ("Focal area: the chariots at the turn") so the model knows where to spend detail.
- For photographic styles, depth of field does the same job: "foreground figures blurred by shallow depth of field, main subject sharp".
- Only `gpt-image-2.6-sunburst` honours the hierarchy. `-flare` keeps a mottled grain on every surface even with the same prompt. Use Flare for layout sketches only.
- `--quality` and `--complexity` matter much less than the wording. Higher quality adds more fine detail, which works against calm surfaces unless the hierarchy is in the prompt.

### 7. Scale needs a comparison and a vantage point

"Giant", "colossal" or "built by giants" alone gives a large but normal building. What worked:

- A familiar object next to it: "ordinary three-storey houses reach only to the bottom of its first arcade", "a full-sized galley passes under one arch like a toy", "the envoys reach only to the guard's knee".
- A vantage point that shows distance: looking down from a column or tower, looking up from a boat at water level, seeing a city from far out at sea.
- Crowds as texture: "tens of thousands of men in formation", "a crowd that dissolves into colour".

Scale is the first thing to disappear when the scene description grows. Check for it in every round.

### 8. Give people agency

Posed figures make an image look like a film set. Ask for social behaviour:

> People are varied in age and body and busy with their own work and with each other: talking, arguing, laughing, helping, ignoring the main event; nobody poses or looks at the camera.

Dress them by class and context, and avoid two clichés. The model's "historical" default is the film cliché of everyone in rags, filthy and unkempt. But people everywhere invest in how they look, and appearance was a main way to improve one's standing: ordinary people wear plain, well-kept, mended clothes and combed hair. The streets can be dirty; the people mostly are not. Overcorrecting is the second trap: "clean, well-fitted clothes, trimmed beards" turned oarsmen and clerks into nobles in purple and jewellery. Say the class: "ordinary working people in plain, well-kept everyday clothes, not new, not ragged, no jewellery; expensive dyes such as purple only on the rich".

The model also fills every scene with the same stock extras: a beggar, a child chasing a chicken, a pouch of gold coins on a table. Ban them unless the scene needs them, and check every object for sense: who leaves coins on a table next to children? Replace props with ones that explain the action (a customs clerk checks bills of lading and weighs a pepper sample).

A people line added to every prompt makes every scene crowded. Use it only where the scene calls for a crowd; a quiet scene (two men in a boat in a cistern) gets no people line.

The images users liked most showed something in progress (oxen hauling a column, children jumping into the sea while two hold back, mosaicists at work), not a finished, static scene. Prefer "people doing X together" over "a person doing X".

### 9. Restraint in accents

When everything is gold, nothing stands out. "Gold appears in at most one small place in the picture" made the one gold object (a basket of mosaic tesserae) the focus. Apply the same to any accent: one red cloak, one lit window, one icon.

### 10. Anchor the fantastic with the ordinary

A fig tree, a fisherman mending nets, laundry on a roof: ordinary objects make an impossible place believable. But keep them small. When the anchor fills the foreground, the place itself is lost.

### 11. Reference images

Pass images through `edits` and give each one a role:

- **Style only:** "Images 1 and 2 are style references only: copy their colour grade, lens character, light and atmosphere, not their content." This was the fastest way to reach a Midjourney-like look. Match the reference to the scene: glamorous, high-contrast references made humble scenes look fake, while soft film-photo references suited everyday scenes.
- **Composition draft:** pass an earlier output and say "The input image is a draft for composition and content. Keep … Re-render it in the style below." This keeps a good layout while changing the style or fixing details.
- **Repeated edits drift.** Each edit of an edit loses a little and amplifies the last instruction. After two rounds, go back to the best earlier image as the draft, and make one change per round.
- **Camera angle:** a screenshot works as "a reference for camera angle, framing and rendering only; do not copy its content".

### 12. The style line must match the camera

A style line written for an eye-level shot ("foreground figures blurred by shallow depth of field") makes the model invent a foreground. In aerial views it added people on a roof, which turned the view into a crane shot. Aerial views needed their own style line: "nothing in the foreground: no rooftop, no railing, no onlookers, the camera floats free". Give the height and tilt as numbers ("60 metres up, tilted 45 to 60 degrees down so the ground fills most of the frame").

Wide views also tend to look like several pictures joined together, each on its own plane. A geometry line fixes most of it: "one block planned as a whole, every building on the same continuous ground plane, streets and walls parallel or at real angles, roofs and courtyards line up, the horizon straight, the far city at the same scale and level". Ban famous landmarks on the skyline by shape, not only by name, or the model adds them ("no giant domed cathedral").

### 13. Grading afterwards does not fix composition

A film-emulation pass (lifted blacks, split toning, halation, vignette, grain) applied to a poster image only produced a worse-looking poster. The look of a photograph comes from what is framed and what is left out. Post-processing can finish a good image, but it cannot rescue a bad one.

## Process

- **Explore with grids, not single images.** Change one variable across 20 to 30 images (style words, or scenes and vantage points) and let the user pick favourites. Iterating one prompt at a time is slow and expensive.
- **Show results so they can be judged.** Build an HTML page with every image at full size, two per row, the full prompt or the changed setting under each, and click-to-open. Small composites hide exactly the texture problems the user is judging. Number the images; letters get garbled by voice transcription.
- **Look at every image before sending it.** Give a verdict per image. The user wants an opinion, not "I haven't checked". Fine texture is hard to see in a thumbnail, so inspect 1:1 crops when noise is the question.
- **Track cost.** Pass `--save-response` and read `usage` (input and output tokens). In late 2026, about 1,100 output tokens at medium and about 1,370 at high for 1536x1024 on Sunburst, roughly $0.04 to $0.05 per image. Blocked and failed images may still be billed.
- **Do not give up on a goal without testing it.** "Wide shots of giant buildings will always look like posters" was wrong; better style words fixed it in the next round.

## Practical limits

- **Minimum size.** `gpt-image-2*` rejects images under 655,360 pixels. `1088x608` is the smallest 16:9; `1536x1024` is a good default.
- **Output filter.** It blocks images it judges as nudity even when the prompt asks for none, especially bath, beach and swimming scenes. Dress everyone explicitly ("everyone fully clothed in long linen robes"). It also blocks unpredictably; retry once before rewriting.
- **Long downloads.** Behind some proxies, large base64 responses are cut off (`IncompleteRead`). JPEG output with compression keeps responses smaller. If it persists, run the script outside the proxy.
- **Fake text.** Words like "cover" or "poster" make the model add titles and publisher logos. Leave them out, or add "no text".
- **Anachronisms.** The model fills gaps with modern habits: two-person restaurant tables in an ancient tavern, ruins in front of an intact city ("National Geographic" means ruins to it). Name the period-correct arrangement and say "nothing ruined, everything in use".

## Templates

Starting points, not recipes. Replace the scene and keep the structure.

**Cinematic, observational:**

```text
<Scene with vantage point and action>. Cinematic still, Roger Deakins cinematography, eye-level observational camera, foreground figures blurred by shallow depth of field, main subject sharp. Light is uneven and physical: one low natural source, bounce light off stone, rim light on hair and shoulders. The camera exposes for the subject and the rest is a compromise: large parts of the frame fall into shadow where figures read as silhouettes, the brightest sky and sunlit stone clip to white, the background is not fully legible. Slight chromatic aberration, halation around highlights, fine film grain, casual off-centre framing. No HDR, no local-contrast boost, no sharpening, no even fill light.
```

**Romantic painting, sublime scale:**

```text
<Scene with a familiar object for scale>, epic romantic oil painting in the manner of John Martin and Ivan Aivazovsky, sublime scale, chiaroscuro. Painted in a few broad tones with loose brushwork; the city half dissolved in glowing haze, its details only suggested, never itemised; large calm areas of sky and water.
```

**Quick oil sketch, calm surfaces:**

```text
<Scene>. Focal area: <one thing>. A quick oil sketch, an unfinished study by an 18th- or 19th-century Romantic painter. Loose, fast brushwork; edges blocked in or left as bare toned ground; restrained earthy palette.
Paint in large flat planes of colour, like a gouache or oil sketch done in a few minutes. Walls, fog, sky and paving are simple, nearly flat tones with a few broad strokes. No fine texture, no grime, no cracks, no speckle, no wisps or swirls; detail only on the one focal object.
```

**Aerial view, cinematic (generation, no reference image):**

```text
Aerial photograph from a helicopter about 60 metres above the ground, the camera tilted 45 to 60 degrees down so the ground fills most of the frame and only a strip of sky shows. Subject: <place and activity>. Geometry: one block planned as a whole, every building on the same continuous ground plane, streets and walls parallel or at real angles, roofs and courtyards line up, the horizon straight, the far city at the same scale and level; one place, not separate pictures joined together. People small but readable, busy with their work. Cinematic aerial film still, documentary realism. Nothing in the foreground: no rooftop, no railing, no onlookers. One low sun raking across the roofs, long shadows, whole streets in deep shadow, sunlit tiles clipping to white, haze over the far city. Slight chromatic aberration, halation, fine film grain. No HDR, no local-contrast boost, no sharpening, no even fill light.
```

A game screenshot passed as a camera reference matched the angle but pulled the image back to the default game-render look; describe the camera in words instead.

**Style from the user's references:**

```text
Images 1 and 2 are style references only: copy their photographic look, colour grade, softness, lens character and light, not their content. A single exposure with natural dynamic range, soft mid-tones, no HDR, no sharpening. New image: <scene>.
```
