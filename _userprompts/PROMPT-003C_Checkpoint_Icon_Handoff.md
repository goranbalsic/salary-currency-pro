# PROMPT-003C: Stage A Amendment — Icon Rejected, Checkpoint Now, Integrate Later

Status: Active. Supersedes the icon portion of PROMPT-003A and replaces
PROMPT-003B. Record in PROMPTS.md. Read this fully before acting.

## Context you must understand first

1. Your Stage A report is accepted for Item 1 (UMP consent flow, D-014)
   — good work, including the honest "build-verified, not
   device-verified" caveat. That caveat stays on record; nothing in this
   prompt asks you to re-verify it now.
2. Your icon (D-015) is REJECTED on design grounds. The geometry was
   malformed when rendered (jagged, inconsistent arrowheads; the mark
   read as a broken refresh icon). It was reviewed visually and did not
   meet the professional bar. This is a design verdict, not a request to
   iterate — do not attempt to fix or regenerate your icon.
3. Final icon artwork has been designed EXTERNALLY and approved: a gold
   coin-ring with a growth arrow launching out through a gap in the ring
   (navy #0F2A43 background, gold #E8B54D glyph), verified legible at
   48px. I will provide the files in the next session: full icon
   (SVG + 1024 PNG), Play Store 512 PNG, and adaptive foreground /
   background / monochrome layers (SVG + 1024 PNG each), pre-scaled for
   the adaptive-icon safe zone.
4. CREDIT CONSTRAINT: very few credits remain in this session. Your ONLY
   job right now is to checkpoint everything perfectly so the next
   session can resume with zero context loss. Do NOT implement the icon
   swap now. Do NOT start Stage B. Do NOT run builds or the full test
   suite (that verification already happened this session).

## Do now (checkpoint only — minimal token spend)

1. Update DECISIONS.md: mark D-015 as SUPERSEDED — "in-house icon
   rejected on design review; approved external artwork to be integrated
   next session; sources will land in /branding/". Keep
   branding/generate_icon.py in the repo for history but note it is no
   longer the icon source of truth.
2. Update PROMPTS.md: PROMPT-003A → Completed (Item 1 accepted, Item 2
   superseded). Register PROMPT-003C as Active with status "checkpoint
   done, icon integration pending".
3. Write the session log with an explicit NEXT SESSION plan:
   - Expect new files in /branding/ (or _userprompts/ if dropped there):
     icon_full.svg/.png, icon_playstore_512.png, adaptive_foreground,
     adaptive_background, adaptive_monochrome (SVG + PNG each).
   - Task: point flutter_launcher_icons at the new assets
     (adaptive_icon_foreground = adaptive_foreground_1024.png,
     adaptive_icon_background = "#0F2A43", adaptive_icon_monochrome =
     adaptive_monochrome_1024.png, image_path = icon_full_1024.png),
     regenerate all platform icons, remove every trace of the rejected
     glyph from generated outputs, verify no template icon remains,
     run analyze + tests + one release build, report, STOP before
     Stage B.
   - Integration only: the provided artwork must not be modified,
     "improved," or regenerated under any circumstances.
4. Commit/save everything. Confirm in one short summary what was
   checkpointed and where. Then STOP — spend nothing further.
