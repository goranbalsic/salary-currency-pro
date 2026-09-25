# PROMPT-003A: Stage A Closure — Consent Flow + App Icon

Status: Active. Closes the two open Stage A items from PROMPT-003. All
existing rules apply (PROJECT_RULES.md, l10n lockstep, real tests,
`flutter analyze` clean, honest reporting). Record in PROMPTS.md.

## Item 1 — GDPR ad consent (implement fully, your judgment)

Implement Google's User Messaging Platform (UMP) consent flow, approved
end-to-end:

- Add the UMP SDK (`google_mobile_ads` already bundles ConsentInformation
  / ConsentForm APIs — use those; do not add a third-party consent lib).
- On app start, request consent info update and show the consent form
  when required (EEA/UK users) BEFORE initializing MobileAds or loading
  any ad. Non-EEA users must see no popup and no added startup delay.
- Ads must respect the consent result: if the user declines personalized
  ads, serve non-personalized ads; if consent status blocks ads entirely,
  the app simply shows no ads — never nag, never block features.
- Add a "Privacy & ad preferences" entry in Settings that lets EEA users
  reopen the consent form later (required by Google policy).
- The whole flow must degrade gracefully offline: no network → skip
  silently, retry on next launch, never block app startup. Startup must
  never wait more than a moment on this — fail open to "no ads" rather
  than delaying the user.
- Keep test ad-unit IDs as before. Document the consent architecture in
  DECISIONS.md and update the data-safety-form notes in store_listing/
  to reflect the consent implementation.
- Localize any in-app strings you add (the Google form itself is
  Google-localized — don't translate it yourself).

## Item 2 — App icon (design it yourself, to this spec)

Create the real app icon as original vector artwork (SVG source committed
to /branding/, exported via flutter_launcher_icons to all densities plus
a proper Android adaptive icon with separate foreground and background
layers, and monochrome layer for Android 13+ themed icons).

Design direction — elegant, professional, instantly readable at 48px:

- ONE simple glyph, no text, no letters, no gradients with more than two
  stops, no clipart coins/dollar bills/piggy banks, and no "$" — this is
  a multi-currency Balkan app, a dollar sign is wrong.
- Concept to execute: two smooth semicircular exchange arrows forming a
  broken circle, with the upper arrow's head rising slightly above the
  circle — reading as both "currency exchange" and "growth" in one mark.
  Geometry must be constructed (consistent stroke width, optically
  centered), not freehand.
- Colors: deep navy background (#0F2A43 or similar richness) with the
  glyph in a warm metallic gold (#E8B54D range) — high contrast, premium,
  reads well in both light and dark launchers. Foreground layer = glyph
  only; background layer = flat or very subtle radial navy.
- Safe zone: keep the glyph within the adaptive-icon safe circle (66% of
  canvas) so no launcher shape crops it.
- Also produce a 512×512 Play Store icon PNG from the same source, and
  update the notification/small icon if one exists (must be flat white
  silhouette per Android spec).
- Show me the result by describing exactly what was generated and where
  the files live; commit the SVG sources so the icon can be iterated
  later.

## Verification

- `flutter analyze` clean, all tests passing, l10n lockstep preserved.
- A real release build succeeds and the new icon appears correctly
  (regular, round, and themed/monochrome variants).
- Consent flow verified with UMP debug/test geography settings for EEA
  (document how it was tested — do not claim untested behavior works).
- Report per the standard format, then STOP: Stage A is then complete;
  do not start Stage B until I say so.
