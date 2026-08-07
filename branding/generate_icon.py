"""Generates the Salary & Currency Pro app icon: the SVG sources in this
directory, and the 1024x1024 PNG sources under source/ that
flutter_launcher_icons reads (configured in pubspec.yaml).

Requires Pillow (`pip install pillow`). Run from anywhere; paths below are
relative to this script's own directory.

Regenerate after changing any parameter below, then re-run
`dart run flutter_launcher_icons` from the repo root to update every
platform's actual icon files. See DECISIONS.md D-015 for the design spec
this implements and why each parameter was chosen.
"""

import math
import os

from PIL import Image, ImageDraw

HERE = os.path.dirname(os.path.abspath(__file__))
SOURCE_DIR = os.path.join(HERE, "source")
os.makedirs(SOURCE_DIR, exist_ok=True)

SIZE = 1024
CX, CY = SIZE / 2, SIZE / 2
NAVY = "#0F2A43"
GOLD = "#E8B54D"
NAVY_RGBA = (15, 42, 67, 255)
GOLD_RGBA = (232, 181, 77, 255)
WHITE_RGBA = (255, 255, 255, 255)

# Two ~130deg arcs, 180deg-rotationally symmetric, forming a broken ring.
# Screen-space angle convention: 0=east, increasing clockwise (90=south).
TOP_START, TOP_END = 205, 335
BOT_START, BOT_END = 25, 155

FULL_R, FULL_W = 290, 90          # full-bleed square icon (legacy + Play Store)
ADAPT_SCALE = 0.72                # shrink so the glyph fits the ~66% adaptive safe zone
ADAPT_R, ADAPT_W = FULL_R * ADAPT_SCALE, FULL_W * ADAPT_SCALE


# ---------------------------------------------------------------- geometry --

def polar(r, deg):
    rad = math.radians(deg)
    return (CX + r * math.cos(rad), CY + r * math.sin(rad))


def radial(deg):
    rad = math.radians(deg)
    return (math.cos(rad), math.sin(rad))


def norm(v):
    m = math.hypot(*v)
    return (v[0] / m, v[1] / m)


def arrow_points(r, deg, width, length, tip_dir=None):
    rx, ry = radial(deg)
    base_x, base_y = polar(r, deg)
    if tip_dir is None:
        tip_dir = (-ry, rx)  # natural clockwise tangent
    tip_dir = norm(tip_dir)
    # Back edge deliberately runs along the RADIAL direction (not
    # perpendicular to tip_dir) so it exactly matches the ring stroke's own
    # cross-section at this angle -- a seamless join regardless of tip_dir.
    p1 = (base_x + rx * width / 2, base_y + ry * width / 2)
    p2 = (base_x - rx * width / 2, base_y - ry * width / 2)
    tip = (base_x + tip_dir[0] * length, base_y + tip_dir[1] * length)
    return p1, p2, tip


# ------------------------------------------------------------------- PNG --

def draw_round_cap(draw, r, deg, width, color):
    x, y = polar(r, deg)
    draw.ellipse([x - width / 2, y - width / 2, x + width / 2, y + width / 2], fill=color)


def draw_glyph_png(draw, color, r, w):
    top_len, bot_len = w * 1.9, w * 2.1
    wi = max(1, round(w))
    for (s, e) in ((TOP_START, TOP_END), (BOT_START, BOT_END)):
        draw.arc([CX - r, CY - r, CX + r, CY + r], s, e, fill=color, width=wi)
        draw_round_cap(draw, r, s, w, color)
    for (deg, length, tip_dir) in ((TOP_END, top_len, (0, -1)), (BOT_END, bot_len, None)):
        p1, p2, tip = arrow_points(r, deg, w, length, tip_dir)
        draw.polygon([p1, p2, tip], fill=color)


def blank(bg=None):
    img = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    if bg:
        ImageDraw.Draw(img).rectangle([0, 0, SIZE, SIZE], fill=bg)
    return img


def build_pngs():
    full = blank(NAVY_RGBA)
    draw_glyph_png(ImageDraw.Draw(full), GOLD_RGBA, FULL_R, FULL_W)
    full.save(os.path.join(SOURCE_DIR, "icon_full_1024.png"))

    foreground = blank()
    draw_glyph_png(ImageDraw.Draw(foreground), GOLD_RGBA, ADAPT_R, ADAPT_W)
    foreground.save(os.path.join(SOURCE_DIR, "icon_foreground_1024.png"))

    background = blank(NAVY_RGBA)
    background.save(os.path.join(SOURCE_DIR, "icon_background_1024.png"))

    monochrome = blank()
    draw_glyph_png(ImageDraw.Draw(monochrome), WHITE_RGBA, ADAPT_R, ADAPT_W)
    monochrome.save(os.path.join(SOURCE_DIR, "icon_monochrome_1024.png"))

    full.resize((512, 512), Image.LANCZOS).save(os.path.join(HERE, "playstore_512.png"))


# ------------------------------------------------------------------- SVG --

def stroke_ring_path(r, w, start, end):
    ro, ri = r + w / 2, r - w / 2
    sweep = (end - start) % 360
    large_arc = 1 if sweep > 180 else 0
    o_start, o_end = polar(ro, start), polar(ro, end)
    i_end, i_start = polar(ri, end), polar(ri, start)
    return (
        f"M {o_start[0]:.2f} {o_start[1]:.2f} "
        f"A {ro:.2f} {ro:.2f} 0 {large_arc} 1 {o_end[0]:.2f} {o_end[1]:.2f} "
        f"L {i_end[0]:.2f} {i_end[1]:.2f} "
        f"A {ri:.2f} {ri:.2f} 0 {large_arc} 0 {i_start[0]:.2f} {i_start[1]:.2f} "
        f"Z"
    )


def build_svg(r, w, glyph_color, background, title, out_path, comment):
    top_len, bot_len = w * 1.9, w * 2.1
    parts = [f"<!-- {comment} -->",
             f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {SIZE} {SIZE}">',
             f"<title>{title}</title>"]
    if background:
        parts.append(f'<rect width="{SIZE}" height="{SIZE}" fill="{background}"/>')
    for (s, e) in ((TOP_START, TOP_END), (BOT_START, BOT_END)):
        parts.append(f'<path d="{stroke_ring_path(r, w, s, e)}" fill="{glyph_color}"/>')
        x, y = polar(r, s)
        parts.append(f'<circle cx="{x:.2f}" cy="{y:.2f}" r="{w/2:.2f}" fill="{glyph_color}"/>')
    for (deg, length, tip_dir) in ((TOP_END, top_len, (0, -1)), (BOT_END, bot_len, None)):
        p1, p2, tip = arrow_points(r, deg, w, length, tip_dir)
        pts = f"{p1[0]:.2f},{p1[1]:.2f} {p2[0]:.2f},{p2[1]:.2f} {tip[0]:.2f},{tip[1]:.2f}"
        parts.append(f'<polygon points="{pts}" fill="{glyph_color}"/>')
    parts.append("</svg>")
    with open(out_path, "w", encoding="utf-8") as f:
        f.write("\n".join(parts))


def build_svgs():
    build_svg(FULL_R, FULL_W, GOLD, NAVY, "Salary &amp; Currency Pro icon",
              os.path.join(HERE, "app_icon.svg"),
              comment="Salary & Currency Pro app icon. Full-bleed square (legacy "
                      "launcher icon + Play Store listing icon source) -- see "
                      "DECISIONS.md D-015 and generate_icon.py for the source of "
                      "truth for this geometry.")
    build_svg(ADAPT_R, ADAPT_W, GOLD, None,
              "Salary &amp; Currency Pro icon -- adaptive foreground",
              os.path.join(HERE, "app_icon_foreground.svg"),
              comment="Android adaptive-icon foreground layer: glyph only, "
                      "transparent background, pre-scaled so it sits within the "
                      "adaptive-icon safe-zone circle without further inset -- "
                      "see DECISIONS.md D-015.")
    build_svg(ADAPT_R, ADAPT_W, "#FFFFFF", None,
              "Salary &amp; Currency Pro icon -- monochrome (Android 13+ themed)",
              os.path.join(HERE, "app_icon_monochrome.svg"),
              comment="Android 13+ themed-icon monochrome layer: same geometry as "
                      "the adaptive foreground, flat white silhouette (the OS "
                      "applies its own tint) -- see DECISIONS.md D-015.")


if __name__ == "__main__":
    build_pngs()
    build_svgs()
    print("Generated icon_full_1024.png, icon_foreground_1024.png, "
          "icon_background_1024.png, icon_monochrome_1024.png (in source/), "
          "playstore_512.png, and the three .svg files.")
