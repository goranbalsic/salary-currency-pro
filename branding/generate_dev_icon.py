"""Generates the `dev` flavor's launcher icon: the same brand icon as
`generate_icon.py` produces, with a red diagonal "DEV" ribbon overlaid so
a dev build can never be mistaken for production on a phone's home
screen (PROMPT-003J checkpoint 1's "unmistakable dev branding"
requirement).

Deliberately a separate script from `generate_icon.py`, not a parameter
added to it: this badges the *already-rendered* per-density PNGs
`flutter_launcher_icons` wrote under `android/app/src/main/res/`, rather
than re-deriving the badge from the vector icon design — the brand icon
itself is unchanged, only a badge is composited on top for one flavor.

Requires Pillow (`pip install pillow`). Run from anywhere; paths below are
relative to this script's own directory. Writes into
`android/app/src/dev/res/...`, which Android's flavor resource merging
automatically prefers over `src/main/res/...` for `dev` builds only —
`prod` builds are completely unaffected (`src/main` is untouched).

Re-run this after `dart run flutter_launcher_icons` regenerates the main
icon, so the dev badge stays composited on the current brand icon.
"""

import math
import os

from PIL import Image, ImageDraw, ImageFont

HERE = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.dirname(HERE)
MAIN_RES = os.path.join(REPO_ROOT, "android", "app", "src", "main", "res")
DEV_RES = os.path.join(REPO_ROOT, "android", "app", "src", "dev", "res")

RIBBON_RED = (200, 30, 30, 255)
RIBBON_TEXT = (255, 255, 255, 255)

# (source-relative path under res/, badge corner length as a fraction of
# image width) — badges the adaptive-icon foreground (what's actually
# visible day to day) and the legacy flat icon (pre-Android-8 fallback).
TARGETS = [
    "drawable-mdpi/ic_launcher_foreground.png",
    "drawable-hdpi/ic_launcher_foreground.png",
    "drawable-xhdpi/ic_launcher_foreground.png",
    "drawable-xxhdpi/ic_launcher_foreground.png",
    "drawable-xxxhdpi/ic_launcher_foreground.png",
    "mipmap-mdpi/ic_launcher.png",
    "mipmap-hdpi/ic_launcher.png",
    "mipmap-xhdpi/ic_launcher.png",
    "mipmap-xxhdpi/ic_launcher.png",
    "mipmap-xxxhdpi/ic_launcher.png",
]


def add_dev_ribbon(src_path: str, dst_path: str) -> None:
    base = Image.open(src_path).convert("RGBA")
    w, h = base.size
    ribbon_len = int(w * 0.62)
    ribbon_h = max(int(h * 0.14), 18)

    ribbon = Image.new("RGBA", (ribbon_len, ribbon_h), (0, 0, 0, 0))
    draw = ImageDraw.Draw(ribbon)
    draw.rectangle([0, 0, ribbon_len, ribbon_h], fill=RIBBON_RED)

    try:
        font = ImageFont.truetype("arialbd.ttf", int(ribbon_h * 0.62))
    except OSError:
        font = ImageFont.load_default()
    text = "DEV"
    bbox = draw.textbbox((0, 0), text, font=font)
    text_w, text_h = bbox[2] - bbox[0], bbox[3] - bbox[1]
    draw.text(
        ((ribbon_len - text_w) / 2, (ribbon_h - text_h) / 2 - bbox[1]),
        text,
        font=font,
        fill=RIBBON_TEXT,
    )

    rotated = ribbon.rotate(-45, expand=True, resample=Image.BICUBIC)
    # Anchor the ribbon's center near the icon's top-right corner, same
    # placement convention as most "beta/dev/staging" badge overlays.
    anchor_x = w - int(w * 0.20)
    anchor_y = int(h * 0.20)
    paste_x = anchor_x - rotated.width // 2
    paste_y = anchor_y - rotated.height // 2

    out = base.copy()
    out.alpha_composite(rotated, (paste_x, paste_y))
    os.makedirs(os.path.dirname(dst_path), exist_ok=True)
    out.save(dst_path)


def main():
    for rel_path in TARGETS:
        src = os.path.join(MAIN_RES, rel_path)
        dst = os.path.join(DEV_RES, rel_path)
        if not os.path.exists(src):
            print(f"skip (not found): {rel_path}")
            continue
        add_dev_ribbon(src, dst)
        print(f"wrote {os.path.relpath(dst, REPO_ROOT)}")


if __name__ == "__main__":
    main()
