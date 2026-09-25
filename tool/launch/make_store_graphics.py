#!/usr/bin/env python3
"""Builds the Google Play graphics from rendered app screens.

1. Render the screens (all listing languages):
     SHOT_LANGS=en,srLatn,hr,bs,sl,mk,bg,ro flutter test --update-goldens \\
       --run-skipped --tags screenshots test/screenshots
2. python3 tool/launch/make_store_graphics.py

Writes, per listing language:
  docs/launch/assets/screenshots/<lang>/NN_<screen>.png   1080 x 1920 phone screenshots
  docs/launch/assets/feature_graphic_<lang>.png           1024 x 500 feature graphic
Section labels come from the app's own translations (lib/l10n/app_*.arb).
"""
import json, os, sys
from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
SHOTS = os.path.join(ROOT, 'test', 'screenshots', 'out')
OUT = os.path.join(ROOT, 'docs', 'launch', 'assets')
FONTS = os.path.join(ROOT, 'assets', 'fonts')

PAPER = (243, 240, 232)
SURFACE = (251, 249, 244)
INK = (22, 33, 28)
INK3 = (98, 109, 103)
LINE = (217, 211, 198)
GREEN = (14, 90, 67)
BRASS = (217, 185, 110)

# Listing language -> (app language folder, ARB file).
LANGS = {
    'en': ('en', 'app_en.arb'),
    'sr': ('srLatn', 'app_sr_Latn.arb'),
    'hr': ('hr', 'app_hr.arb'),
    'bs': ('bs', 'app_bs.arb'),
    'sl': ('sl', 'app_sl.arb'),
    'mk': ('mk', 'app_mk.arb'),
    'bg': ('bg', 'app_bg.arb'),
    'ro': ('ro', 'app_ro.arb'),
}

# Screens in store order. Serbian-market listings lead with the invoice QR
# and paušal tracker; the others with local payroll and loans.
SERBIAN = [('02_pay', 'pay'), ('09_invoice_qr', 'invoiceQr'), ('10_pausal', 'pausal'), ('03_pay_breakdown', 'breakdown'),
           ('04_loan', 'loan'), ('06_rates', 'rates'), ('11_team', 'team'), ('12_compare', 'compare')]
REGIONAL = [('02_pay', 'pay'), ('03_pay_breakdown', 'breakdown'), ('04_loan', 'loan'), ('06_rates', 'rates'),
            ('08_invoice', 'invoice'), ('11_team', 'team'), ('12_compare', 'compare'), ('01_home', 'home')]
ORDER = {'en': SERBIAN, 'sr': SERBIAN}

# ARB key for each screen's section label.
SECTION = {
    'pay': 'navPayroll', 'breakdown': 'payBreakdown', 'loan': 'toolLoan', 'rates': 'navFx', 'invoiceQr': 'bizInvoices',
    'invoice': 'bizInvoices', 'pausal': 'toolPausal', 'team': 'toolTeam', 'compare': 'toolCompare', 'home': 'appName',
}

CAPTIONS = {
    'en': {
        'pay': 'Gross to net for 9 tax systems', 'breakdown': 'Every contribution, line by line',
        'loan': 'The real cost of a loan', 'rates': 'Official NBS and ECB rates',
        'invoiceQr': 'Invoices your client pays by QR code', 'invoice': 'Professional invoices in a minute',
        'pausal': 'Paušal limits, always in view', 'team': "Your whole team's cost",
        'compare': 'The same pay in 9 countries', 'home': 'Every finance calculator in one place',
    },
    'sr': {
        'pay': 'Bruto u neto za 9 poreskih sistema', 'breakdown': 'Svaki doprinos, stavka po stavka',
        'loan': 'Prava cena kredita', 'rates': 'Zvanični kurs NBS i ECB',
        'invoiceQr': 'Faktura koju klijent plaća QR kodom', 'invoice': 'Profesionalna faktura za minut',
        'pausal': 'Paušalni limiti uvek na oku', 'team': 'Trošak cele ekipe',
        'compare': 'Ista plata u 9 zemalja', 'home': 'Svi finansijski kalkulatori na jednom mestu',
    },
    'hr': {
        'pay': 'Bruto u neto za 9 poreznih sustava', 'breakdown': 'Svaki doprinos, stavku po stavku',
        'loan': 'Prava cijena kredita', 'rates': 'Službeni tečajevi ECB-a i NBS-a',
        'invoice': 'Profesionalan račun za minutu', 'team': 'Trošak cijelog tima',
        'compare': 'Ista plaća u 9 zemalja', 'home': 'Svi financijski kalkulatori na jednom mjestu',
    },
    'bs': {
        'pay': 'Bruto u neto za FBiH, RS i još 7 sistema', 'breakdown': 'Svaki doprinos, stavka po stavka',
        'loan': 'Prava cijena kredita', 'rates': 'Zvanični kursevi ECB i NBS',
        'invoice': 'Profesionalna faktura za minut', 'team': 'Trošak cijelog tima',
        'compare': 'Ista plata u 9 zemalja', 'home': 'Svi finansijski kalkulatori na jednom mjestu',
    },
    'sl': {
        'pay': 'Iz bruto v neto za 9 davčnih sistemov', 'breakdown': 'Vsak prispevek posebej',
        'loan': 'Prava cena kredita', 'rates': 'Uradni tečaji ECB in NBS',
        'invoice': 'Profesionalen račun v minuti', 'team': 'Strošek celotne ekipe',
        'compare': 'Ista plača v 9 državah', 'home': 'Vsi finančni kalkulatorji na enem mestu',
    },
    'mk': {
        'pay': 'Од бруто во нето за 9 даночни системи', 'breakdown': 'Секој придонес, ставка по ставка',
        'loan': 'Вистинската цена на кредитот', 'rates': 'Официјални курсеви на ЕЦБ и НБС',
        'invoice': 'Професионална фактура за една минута', 'team': 'Трошокот за целиот тим',
        'compare': 'Истата плата во 9 држави', 'home': 'Сите финансиски калкулатори на едно место',
    },
    'bg': {
        'pay': 'От бруто към нето по 9 данъчни системи', 'breakdown': 'Всяка вноска поотделно',
        'loan': 'Истинската цена на кредита', 'rates': 'Официални курсове на ЕЦБ и НБС',
        'invoice': 'Професионална фактура за минута', 'team': 'Разходите за целия екип',
        'compare': 'Една и съща заплата в 9 държави', 'home': 'Всички финансови калкулатори на едно място',
    },
    'ro': {
        'pay': 'Din brut în net pentru 9 sisteme fiscale', 'breakdown': 'Fiecare contribuție, rând cu rând',
        'loan': 'Costul real al unui credit', 'rates': 'Cursuri oficiale BCE și BNS',
        'invoice': 'Factură profesională într-un minut', 'team': 'Costul întregii echipe',
        'compare': 'Același salariu în 9 țări', 'home': 'Toate calculatoarele financiare într-un loc',
    },
}

ROMAN = ['I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII']


def font(name, size):
    return ImageFont.truetype(os.path.join(FONTS, name), size)


SERIF = 'SourceSerif4-SemiBold.ttf'
SERIF_ITALIC = 'SourceSerif4-Italic.ttf'
SANS = 'IBMPlexSans-Medium.ttf'


def check_glyphs(text, font_file):
    from fontTools.ttLib import TTFont
    cmap = TTFont(os.path.join(FONTS, font_file)).getBestCmap()
    missing = {c for c in text if ord(c) not in cmap and not c.isspace()}
    if missing:
        sys.exit(f'{font_file} lacks glyphs for: {"".join(sorted(missing))}')


def wrap(draw, text, f, width):
    lines, line = [], ''
    for word in text.split():
        trial = f'{line} {word}'.strip()
        if draw.textlength(trial, font=f) <= width or not line:
            line = trial
        else:
            lines.append(line)
            line = word
    lines.append(line)
    return lines


def spaced(draw, xy, text, f, fill, tracking):
    x, y = xy
    for ch in text:
        draw.text((x, y), ch, font=f, fill=fill)
        x += draw.textlength(ch, font=f) + tracking


def rounded(img, radius):
    mask = Image.new('L', img.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, img.width - 1, img.height - 1), radius=radius, fill=255)
    out = Image.new('RGBA', img.size)
    out.paste(img, (0, 0), mask)
    return out


def shadowed(canvas, card, xy, radius, blur, alpha, offset=(0, 18)):
    shadow = Image.new('RGBA', canvas.size, (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle(
        (xy[0] + offset[0], xy[1] + offset[1], xy[0] + card.width + offset[0], xy[1] + card.height + offset[1]),
        radius=radius, fill=(10, 20, 15, alpha))
    canvas.alpha_composite(shadow.filter(ImageFilter.GaussianBlur(blur)))
    canvas.alpha_composite(card, xy)


def screenshot(lang, index, screen, key, labels):
    app_lang = LANGS[lang][0]
    src = Image.open(os.path.join(SHOTS, app_lang, 'light', f'{screen}.png')).convert('RGB')
    W, H = 1080, 1920
    canvas = Image.new('RGBA', (W, H), PAPER + (255,))
    draw = ImageDraw.Draw(canvas)
    margin = 96

    label = labels[SECTION[key]].upper()
    over = f'{ROMAN[index]}  ·  {label}'
    check_glyphs(over, SANS)
    spaced(draw, (margin, 118), over, font(SANS, 30), INK3, 4)

    caption = CAPTIONS[lang][key]
    check_glyphs(caption, SERIF)
    size = 88
    while True:
        f = font(SERIF, size)
        lines = wrap(draw, caption, f, W - 2 * margin)
        if len(lines) <= 2 or size <= 64:
            break
        size -= 4
    y = 176
    for line in lines:
        draw.text((margin, y), line, font=f, fill=INK)
        y += int(size * 1.14)

    top = max(y + 64, 420)
    shot_h = H - top - 110
    shot_w = int(src.width * shot_h / src.height)
    shot = src.resize((shot_w, shot_h), Image.LANCZOS)
    card = rounded(shot, 44)
    x = (W - shot_w) // 2
    shadowed(canvas, card, (x, top), 44, 28, 70)
    ImageDraw.Draw(canvas).rounded_rectangle((x, top, x + shot_w - 1, top + shot_h - 1), radius=44, outline=LINE, width=2)
    return canvas.convert('RGB')


def feature_graphic(lang, labels):
    app_lang = LANGS[lang][0]
    W, H = 1024, 500
    canvas = Image.new('RGBA', (W, H), GREEN + (255,))
    draw = ImageDraw.Draw(canvas)

    tagline = labels['appTagline'].upper()
    check_glyphs(tagline, SANS)
    spaced(draw, (64, 92), tagline, font(SANS, 20), BRASS, 4)
    draw.text((60, 124), 'Bilans', font=font(SERIF, 120), fill=PAPER)
    # The ledger rule under the name. Drawn on its own layer: ImageDraw
    # replaces RGBA pixels rather than blending, so alpha needs compositing.
    rule = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(rule).line((64, 286, 560, 286), fill=PAPER + (150,), width=2)
    canvas.alpha_composite(rule)
    headline = labels['onbHeadline']
    check_glyphs(headline, SERIF)
    size = 40
    while True:
        f = font(SERIF, size)
        lines = wrap(draw, headline, f, 520)
        if len(lines) <= 2 or size <= 28:
            break
        size -= 2
    y = 306
    for line in lines:
        draw.text((64, y), line, font=f, fill=PAPER)
        y += int(size * 1.2)

    src = Image.open(os.path.join(SHOTS, app_lang, 'light', '02_pay.png')).convert('RGB')
    shot_w = 300
    shot = src.resize((shot_w, int(src.height * shot_w / src.width)), Image.LANCZOS)
    card = rounded(shot, 26)
    shadowed(canvas, card, (650, 56), 26, 22, 120, offset=(0, 14))
    return canvas.convert('RGB')


def main():
    for lang, (app_lang, arb) in LANGS.items():
        if not os.path.isdir(os.path.join(SHOTS, app_lang)):
            print(f'{lang}: no rendered screens in {SHOTS}/{app_lang} — skipped')
            continue
        labels = json.load(open(os.path.join(ROOT, 'lib', 'l10n', arb), encoding='utf-8'))
        out_dir = os.path.join(OUT, 'screenshots', lang)
        os.makedirs(out_dir, exist_ok=True)
        for old in os.listdir(out_dir):
            os.remove(os.path.join(out_dir, old))
        for i, (screen, key) in enumerate(ORDER.get(lang, REGIONAL)):
            screenshot(lang, i, screen, key, labels).save(os.path.join(out_dir, f'{i + 1:02d}_{key}.png'), optimize=True)
        feature_graphic(lang, labels).save(os.path.join(OUT, f'feature_graphic_{lang}.png'), optimize=True)
        print(f'{lang}: {len(ORDER.get(lang, REGIONAL))} screenshots + feature graphic')


if __name__ == '__main__':
    main()
