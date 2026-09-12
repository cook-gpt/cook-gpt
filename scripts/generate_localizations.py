#!/usr/bin/env python3
"""Generate Localizable.xcstrings and InfoPlist.xcstrings from translations data."""

import json
from pathlib import Path

LOCALES = ["es", "ca", "fr", "nl", "de", "zh-Hans", "ja", "it", "pt", "ru"]

ROOT = Path(__file__).resolve().parent.parent
OUTPUT = ROOT / "src" / "CookGPT" / "Localizable.xcstrings"
INFO_OUTPUT = ROOT / "src" / "CookGPT" / "InfoPlist.xcstrings"


def load_translations() -> dict[str, dict[str, str]]:
    from translation_data import TRANSLATIONS

    return TRANSLATIONS


def make_string_entry(english: str, translations: dict[str, str]) -> dict:
    localizations = {
        "en": {
            "stringUnit": {
                "state": "translated",
                "value": english,
            }
        }
    }
    for locale in LOCALES:
        value = translations.get(locale, english)
        localizations[locale] = {
            "stringUnit": {
                "state": "translated",
                "value": value,
            }
        }
    return {"localizations": localizations}


def build_catalog(translations: dict[str, dict[str, str]]) -> dict:
    strings = {}
    for english, locale_values in sorted(translations.items()):
        strings[english] = make_string_entry(english, locale_values)
    return {
        "sourceLanguage": "en",
        "strings": strings,
        "version": "1.0",
    }


def build_info_plist_catalog() -> dict:
    display_name = {
        locale: {"stringUnit": {"state": "translated", "value": "CookGPT"}}
        for locale in ["en"] + LOCALES
    }
    return {
        "sourceLanguage": "en",
        "strings": {
            "CFBundleDisplayName": {"localizations": display_name},
            "CFBundleName": {"localizations": display_name},
        },
        "version": "1.0",
    }


def main() -> None:
    translations = load_translations()
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text(
        json.dumps(build_catalog(translations), ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    INFO_OUTPUT.write_text(
        json.dumps(build_info_plist_catalog(), ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(f"Wrote {len(translations)} strings to {OUTPUT}")
    print(f"Wrote InfoPlist catalog to {INFO_OUTPUT}")


if __name__ == "__main__":
    main()
