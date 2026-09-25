#!/usr/bin/env python3
"""Checks docs/launch/store_listing/*.md against Google Play's limits:
title <= 30, short description <= 80, full description <= 4000 characters.
Exit status 1 on any violation."""
import glob, os, re, sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
LIMITS = {'Title': 30, 'Short description': 80, 'Full description': 4000}


def sections(path):
    text = open(path, encoding='utf-8').read()
    parts = re.split(r'^## (.+)$', text, flags=re.M)
    return {parts[i].strip(): parts[i + 1].strip() for i in range(1, len(parts), 2)}


def main():
    bad = 0
    for path in sorted(glob.glob(os.path.join(ROOT, 'docs', 'launch', 'store_listing', '*.md'))):
        s = sections(path)
        row = []
        for name, limit in LIMITS.items():
            value = s.get(name)
            if value is None:
                row.append(f'{name}: MISSING')
                bad += 1
                continue
            n = len(value)
            flag = '' if n <= limit else '  <-- over'
            bad += n > limit
            row.append(f'{name.split()[0].lower()} {n}/{limit}{flag}')
        print(f'{os.path.basename(path):8}', ' | '.join(row))
    sys.exit(1 if bad else 0)


if __name__ == '__main__':
    main()
