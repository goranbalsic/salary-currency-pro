#!/usr/bin/env python3
"""Renders the Bilans mark (serif B over a brass double rule) into every
raster the app and the store listing need. Run from the repo root:

    python3 tool/brand/make_brand.py

Outputs go to tool/brand/out/ (launcher icon sources, splash images) and
docs/launch/assets/ (Play Store icon). Then regenerate platform files with
`dart run flutter_launcher_icons` and `dart run flutter_native_splash:create`.
"""
import os
from PIL import Image, ImageDraw, ImageFont

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
OUT = os.path.join(ROOT, 'tool', 'brand', 'out')
STORE = os.path.join(ROOT, 'docs', 'launch', 'assets')
SERIF = os.path.join(ROOT, 'assets', 'fonts', 'SourceSerif4-SemiBold.ttf')

GREEN = (0x0E, 0x5A, 0x43)
PAPER = (0xF3, 0xF0, 0xE8)
BRASS = (0xD9, 0xB9, 0x6E)
DARK_BG = (0x1E, 0x29, 0x25)
DARK_FG = (0x6C, 0xC6, 0xA1)
SS = 4  # supersampling factor for smooth edges


def content(size, fg, rule=BRASS):
    """The B and the double rule on a transparent square, laid out on the
    108-unit grid used by the in-app BrandMark widget."""
    big = size * SS
    u = big / 108
    img = Image.new('RGBA', (big, big), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    font = ImageFont.truetype(SERIF, int(60 * u))
    # Centre the B's ink horizontally; place its cap top at 17 units.
    box = d.textbbox((0, 0), 'B', font=font)
    w = box[2] - box[0]
    x = (big - w) / 2 - box[0]
    y = 17 * u - box[1]
    d.text((x, y), 'B', font=font, fill=fg)
    for top in (80, 88):
        d.rounded_rectangle([31 * u, top * u, 77 * u, (top + 4) * u], radius=2 * u, fill=rule)
    return img


def fit(img, box_fraction):
    """Crops to the ink and scales it into a centred square occupying
    [box_fraction] of the canvas."""
    bbox = img.getbbox()
    ink = img.crop(bbox)
    side = img.size[0]
    target = side * box_fraction
    scale = target / max(ink.size)
    ink = ink.resize((max(1, int(ink.size[0] * scale)), max(1, int(ink.size[1] * scale))), Image.LANCZOS)
    out = Image.new('RGBA', img.size, (0, 0, 0, 0))
    out.paste(ink, ((side - ink.size[0]) // 2, (side - ink.size[1]) // 2), ink)
    return out


def rounded_square(size, bg, radius_units=26):
    big = size * SS
    img = Image.new('RGBA', (big, big), (0, 0, 0, 0))
    ImageDraw.Draw(img).rounded_rectangle([0, 0, big - 1, big - 1], radius=radius_units * big / 108, fill=bg)
    return img


def mark(size, bg, fg, square=False):
    """The full mark: background (rounded unless [square]) plus content."""
    big = size * SS
    base = Image.new('RGBA', (big, big), bg + (255,)) if square else rounded_square(size, bg)
    base.alpha_composite(content(size, fg))
    return base.resize((size, size), Image.LANCZOS)


def save(img, *parts):
    path = os.path.join(*parts)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    img.save(path, optimize=True)
    print('wrote', os.path.relpath(path, ROOT), img.size)


def on_canvas(img, canvas, scale):
    """Centres [img] scaled to [scale] of a transparent [canvas] square."""
    side = int(canvas * scale)
    small = img.resize((side, side), Image.LANCZOS)
    out = Image.new('RGBA', (canvas, canvas), (0, 0, 0, 0))
    out.paste(small, ((canvas - side) // 2, (canvas - side) // 2), small)
    return out


def main():
    # Legacy launcher icon and Play Store icon: full-bleed squares (the
    # launcher / Play apply their own mask).
    save(mark(1024, GREEN, PAPER, square=True), OUT, 'icon_full_1024.png')
    save(mark(512, GREEN, PAPER, square=True), STORE, 'play_icon_512.png')

    # Adaptive icon layers (108 dp canvas; keep ink inside the 66 dp safe
    # circle so round, squircle and teardrop masks never clip it).
    fg = fit(content(1024, PAPER), 0.46).resize((1024, 1024), Image.LANCZOS)
    save(fg, OUT, 'icon_foreground_1024.png')
    mono = fit(content(1024, (255, 255, 255), rule=(255, 255, 255)), 0.46).resize((1024, 1024), Image.LANCZOS)
    save(mono, OUT, 'icon_monochrome_1024.png')

    # Pre-Android-12 splash: the rounded mark, shown at 96 dp (xxxhdpi 4x).
    save(mark(384, GREEN, PAPER), OUT, 'splash_mark_light.png')
    save(mark(384, DARK_BG, DARK_FG), OUT, 'splash_mark_dark.png')

    # Android 12+ splash icon: 1152 px canvas, content inside the 768 px
    # circle — the rounded mark at 45% stays clear of the circular mask.
    save(on_canvas(mark(1024, GREEN, PAPER), 1152, 0.45), OUT, 'splash_icon_light.png')
    save(on_canvas(mark(1024, DARK_BG, DARK_FG), 1152, 0.45), OUT, 'splash_icon_dark.png')


if __name__ == '__main__':
    main()
