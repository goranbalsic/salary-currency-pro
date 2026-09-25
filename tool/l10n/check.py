#!/usr/bin/env python3
"""Validates every translation against the English template.

For each language in tool/l10n/<lang>/ it checks that
  * exactly the English message keys are present,
  * each message uses the same {placeholders} as English,
  * plural messages are well-formed ICU with an `other` case and use the
    plural categories that language actually has,
  * braces balance,
  * a percent sign after a number follows the language's CLDR convention
    (no-break space before it in hr/sl/mk/ro, none elsewhere), matching
    Formats.percentSign in the app.
Exit status 1 on any problem, so CI and the parity test can rely on it.
"""
import json, os, re, sys, glob, collections

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
SRC = os.path.join(ROOT, 'tool', 'l10n')

# CLDR cardinal plural categories per language (integers).
CATEGORIES = {
    'en': {'one', 'other'},
    'sr_Latn': {'one', 'few', 'other'},
    'sr': {'one', 'few', 'other'},
    'hr': {'one', 'few', 'other'},
    'bs': {'one', 'few', 'other'},
    'sl': {'one', 'two', 'few', 'other'},
    'mk': {'one', 'other'},
    'bg': {'one', 'other'},
    'ro': {'one', 'few', 'other'},
}

# Languages that write "20 %" (with a no-break space) rather than "20%".
PERCENT_SPACE = {'hr', 'sl', 'mk', 'ro'}
PERCENT = re.compile(r'([0-9}])([ \u00a0]?)%')


def load(lang):
    out = collections.OrderedDict()
    for f in sorted(glob.glob(os.path.join(SRC, lang, '*.json'))):
        with open(f, encoding='utf-8') as fh:
            data = json.load(fh, object_pairs_hook=collections.OrderedDict)
        for k, v in data.items():
            if not k.startswith('@'):
                out[k] = v
    return out


def placeholders(msg):
    """Top-level {name} and {name, plural, ...} argument names."""
    names = set()
    depth = 0
    i = 0
    while i < len(msg):
        c = msg[i]
        if c == '{':
            if depth == 0 or True:
                m = re.match(r'\{\s*([A-Za-z_][A-Za-z0-9_]*)\s*([,}])', msg[i:])
                if m:
                    names.add(m.group(1))
            depth += 1
        elif c == '}':
            depth -= 1
        i += 1
    return names


def plural_cases(msg):
    m = re.match(r'^\{\s*\w+\s*,\s*plural\s*,(.*)\}$', msg.strip(), re.S)
    if not m:
        return None
    body = m.group(1)
    cases = []
    i = 0
    while i < len(body):
        mm = re.match(r'\s*(=\d+|zero|one|two|few|many|other)\s*\{', body[i:])
        if not mm:
            if body[i:].strip() == '':
                break
            return 'bad'
        cases.append(mm.group(1))
        i += mm.end()
        depth = 1
        while i < len(body) and depth:
            if body[i] == '{':
                depth += 1
            elif body[i] == '}':
                depth -= 1
            i += 1
    return cases


def main():
    en = load('en')
    problems = 0
    langs = sorted(d for d in os.listdir(SRC) if os.path.isdir(os.path.join(SRC, d)) and d != 'en')
    for lang in langs:
        data = load(lang)
        missing = [k for k in en if k not in data]
        extra = [k for k in data if k not in en]
        issues = []
        if missing:
            issues.append(f'missing {len(missing)}: {missing[:10]}')
        if extra:
            issues.append(f'extra {len(extra)}: {extra[:10]}')
        for k, msg in data.items():
            if k not in en:
                continue
            if not isinstance(msg, str) or not msg.strip():
                issues.append(f'{k}: empty')
                continue
            if msg.count('{') != msg.count('}'):
                issues.append(f'{k}: unbalanced braces')
                continue
            want = '\u00a0' if lang in PERCENT_SPACE else ''
            if any(m.group(2) != want for m in PERCENT.finditer(msg)):
                issues.append(f'{k}: percent sign spacing')
            if placeholders(msg) != placeholders(en[k]):
                issues.append(f'{k}: placeholders {sorted(placeholders(msg))} != {sorted(placeholders(en[k]))}')
            src_cases = plural_cases(en[k])
            cases = plural_cases(msg)
            if src_cases is not None:
                if cases is None or cases == 'bad':
                    issues.append(f'{k}: not a valid plural')
                else:
                    if 'other' not in cases:
                        issues.append(f'{k}: plural without other')
                    allowed = CATEGORIES.get(lang, set()) | {c for c in cases if c.startswith('=')}
                    wrong = [c for c in cases if c not in allowed]
                    if wrong:
                        issues.append(f'{k}: categories {wrong} not used by {lang}')
                    needed = CATEGORIES.get(lang, set()) - set(cases)
                    if needed:
                        issues.append(f'{k}: missing plural categories {sorted(needed)}')
        if issues:
            problems += len(issues)
            print(f'{lang}: {len(issues)} problem(s)')
            for i in issues[:40]:
                print('   ', i)
        else:
            print(f'{lang}: ok ({len(data)} messages)')
    sys.exit(1 if problems else 0)


if __name__ == '__main__':
    main()
