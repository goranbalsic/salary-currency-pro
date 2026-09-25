#!/usr/bin/env python3
"""Merges per-feature string fragments into lib/l10n/app_<lang>.arb.

Fragments live in tool/l10n/<lang>/*.json (plain JSON objects, same shape as
ARB). English is the template; every other language must provide exactly
the same message keys (checked by test/l10n_parity_test.dart).
"""
import json, os, sys, glob, collections

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
SRC = os.path.join(ROOT, 'tool', 'l10n')
OUT = os.path.join(ROOT, 'lib', 'l10n')

LOCALE_TAGS = {'en': 'en', 'sr_Latn': 'sr_Latn', 'sr': 'sr', 'hr': 'hr', 'bs': 'bs', 'sl': 'sl', 'mk': 'mk', 'bg': 'bg', 'ro': 'ro'}

def load_lang(lang):
    merged = collections.OrderedDict()
    files = sorted(glob.glob(os.path.join(SRC, lang, '*.json')))
    for f in files:
        with open(f, encoding='utf-8') as fh:
            data = json.load(fh, object_pairs_hook=collections.OrderedDict)
        for k, v in data.items():
            if k in merged and not k.startswith('@'):
                sys.exit(f'duplicate key {k} in {f}')
            merged[k] = v
    return merged

def main():
    langs = [d for d in os.listdir(SRC) if os.path.isdir(os.path.join(SRC, d))]
    en = load_lang('en')
    en_keys = [k for k in en if not k.startswith('@')]
    for lang in sorted(langs):
        data = load_lang(lang)
        out = collections.OrderedDict()
        out['@@locale'] = LOCALE_TAGS.get(lang, lang)
        if lang == 'en':
            out.update(data)
        else:
            missing = [k for k in en_keys if k not in data]
            extra = [k for k in data if not k.startswith('@') and k not in en]
            if missing or extra:
                print(f'{lang}: missing {len(missing)} {missing[:8]} extra {extra[:8]}')
            for k in en_keys:
                if k in data:
                    out[k] = data[k]
        path = os.path.join(OUT, f'app_{lang}.arb')
        with open(path, 'w', encoding='utf-8') as fh:
            json.dump(out, fh, ensure_ascii=False, indent=2)
            fh.write('\n')
        print(f'wrote {path} ({len([k for k in out if not k.startswith("@")])} messages)')

if __name__ == '__main__':
    main()
