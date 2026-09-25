#!/usr/bin/env python3
"""Generates Serbian Cyrillic (tool/l10n/sr) from Serbian Latin
(tool/l10n/sr_Latn). Serbian is fully biscriptal, so the Cyrillic strings
are a mechanical transliteration, except for:
  * ICU syntax and {placeholders} (never touched),
  * brand, product and standard names kept in Latin (see KEEP),
  * ISO currency codes and other all-caps Latin tokens listed in KEEP.
Run after editing sr_Latn:  python3 tool/l10n/transliterate.py
"""
import json, os, re, glob, collections

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
SRC = os.path.join(ROOT, 'tool', 'l10n', 'sr_Latn')
DST = os.path.join(ROOT, 'tool', 'l10n', 'sr')

# Words that stay in Latin script in Serbian Cyrillic text.
KEEP = [
    'Bilans Pro', 'Bilans', 'Google Play', 'Play', 'Pro', 'PRO', 'PDF', 'QR', 'IBAN', 'SWIFT/BIC', 'SWIFT', 'BIC',
    'kurs.resenje.org', 'Frankfurter', 'VAT', 'CAS', 'CASS', 'CAM', 'UPF', 'OIB', 'JIB', 'NPV', 'IRR',
    'Android', 'English', 'RS35',
]
CURRENCIES = ['EUR', 'USD', 'CHF', 'GBP', 'RSD', 'BAM', 'MKD', 'RON', 'HUF', 'CZK', 'PLN', 'SEK', 'NOK', 'DKK', 'JPY',
              'CNY', 'CAD', 'AUD', 'TRY', 'RUB', 'BGN']

DIGRAPHS = {'Lj': 'Љ', 'LJ': 'Љ', 'lj': 'љ', 'Nj': 'Њ', 'NJ': 'Њ', 'nj': 'њ', 'Dž': 'Џ', 'DŽ': 'Џ', 'dž': 'џ'}
SINGLE = dict(zip(
    'ABCČĆDĐEFGHIJKLMNOPRSŠTUVZŽabcčćdđefghijklmnoprsštuvzž',
    'АБЦЧЋДЂЕФГХИЈКЛМНОПРСШТУВЗЖабцчћдђефгхијклмнопрсштувзж',
))

TOKEN = re.compile(
    r'(\{[^{}]*\}|' + '|'.join(re.escape(k) for k in sorted(KEEP, key=len, reverse=True)) +
    r'|\b(?:' + '|'.join(CURRENCIES) + r')\b|https?://\S+)'
)


def cyr_text(s):
    out = []
    i = 0
    while i < len(s):
        two = s[i:i + 2]
        if two in DIGRAPHS:
            out.append(DIGRAPHS[two])
            i += 2
            continue
        out.append(SINGLE.get(s[i], s[i]))
        i += 1
    return ''.join(out)


def cyr_plain(s):
    """Transliterates text that contains no ICU structure."""
    parts = TOKEN.split(s)
    return ''.join(p if TOKEN.fullmatch(p or '') else cyr_text(p) for p in parts)


def cyr_icu(msg):
    """Walks an ICU message, transliterating only literal text."""
    out = []
    i = 0
    n = len(msg)
    while i < n:
        c = msg[i]
        if c == '{':
            # Argument: {name} or {name, plural, case{...} ...}
            m = re.match(r'\{\s*(\w+)\s*(,\s*(plural|select)\s*,)?', msg[i:])
            if m and m.group(2):
                out.append(m.group(0))
                i += m.end()
                # Cases until the matching close brace.
                while i < n and msg[i] != '}':
                    mm = re.match(r'\s*(=\d+|\w+)\s*\{', msg[i:])
                    if not mm:
                        out.append(msg[i])
                        i += 1
                        continue
                    out.append(mm.group(0))
                    i += mm.end()
                    depth = 1
                    start = i
                    while i < n and depth:
                        if msg[i] == '{':
                            depth += 1
                        elif msg[i] == '}':
                            depth -= 1
                        i += 1
                    out.append(cyr_icu(msg[start:i - 1]))
                    out.append('}')
                out.append('}')
                i += 1
            else:
                j = msg.index('}', i)
                out.append(msg[i:j + 1])
                i = j + 1
        else:
            j = msg.find('{', i)
            if j < 0:
                j = n
            out.append(cyr_plain(msg[i:j]))
            i = j
    return ''.join(out)


def main():
    os.makedirs(DST, exist_ok=True)
    for f in sorted(glob.glob(os.path.join(SRC, '*.json'))):
        with open(f, encoding='utf-8') as fh:
            data = json.load(fh, object_pairs_hook=collections.OrderedDict)
        out = collections.OrderedDict((k, cyr_icu(v) if isinstance(v, str) else v) for k, v in data.items())
        path = os.path.join(DST, os.path.basename(f))
        lines = [f'  {json.dumps(k, ensure_ascii=False)}: {json.dumps(v, ensure_ascii=False)}' for k, v in out.items()]
        with open(path, 'w', encoding='utf-8') as fh:
            fh.write('{\n' + ',\n'.join(lines) + '\n}\n')
        print('wrote', os.path.relpath(path, ROOT))


if __name__ == '__main__':
    main()
