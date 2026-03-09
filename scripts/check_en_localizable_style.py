#!/usr/bin/env python3
from __future__ import annotations

import re
import sys
from dataclasses import dataclass
from pathlib import Path


ENTRY_RE = re.compile(r'^"(?P<key>[^"]+)" = "(?P<value>.*)";$')
CHINESE_RE = re.compile(r"[\u4e00-\u9fff]")

BEST_PRACTICE_PREFIXES = (
    "Use ",
    "Ask ",
    "Provide ",
    "Start ",
    "Choose ",
    "Run ",
    "Keep ",
    "Define ",
    "Generate ",
    "Explore ",
    "Fine-tune ",
    "Set ",
    "Upload ",
    "Pair ",
    "Paste ",
    "Specify ",
    "Cross-check ",
    "Focus ",
    "Clear ",
    "Break ",
    "Guide ",
    "Review ",
    "Include ",
    "Document ",
    "Have ",
    "Extend ",
    "Publish ",
    "Practice ",
    "Prefer ",
    "Describe ",
    "Pass ",
    "Iterate ",
    "Establish ",
    "Switch ",
)

STRENGTH_PREFIXES = (
    "Strong ",
    "Fast ",
    "Rich ",
    "Accurate ",
    "Convenient ",
    "Great ",
    "Professional ",
    "Easy ",
    "Excellent ",
    "Stable ",
    "High ",
    "Open-source ",
    "Multi-platform ",
    "Natural ",
    "Generous ",
    "Deeply ",
    "Leading ",
    "Complete ",
    "Low ",
    "Distinctive ",
    "Realistic ",
    "Industry-leading ",
    "Source ",
    "Traceable ",
    "Optimized ",
    "Clear ",
    "Integrated ",
    "Built-in ",
    "All-in-one ",
    "Active ",
    "Automatic ",
    "Search ",
    "Tight ",
    "Zero-code ",
    "No-code ",
    "Low-code ",
    "Well-balanced ",
    "Fits ",
    "A ",
    "Layout ",
    "Multiple ",
    "Targeted ",
    "Socratic ",
    "Ultra-long ",
    "No ",
    "Well ",
    "Visually ",
    "Broad ",
    "High-quality ",
)

LIMITATION_PREFIXES = (
    "Limited ",
    "Chinese ",
    "Some ",
    "Deep ",
    "Performance ",
    "Advanced ",
    "Complex ",
    "Depth ",
    "Requires ",
    "Not ",
    "Export ",
    "Real-time ",
    "Incorrect ",
    "Engineers ",
    "Relatively ",
    "Availability ",
    "Generated ",
    "Creative ",
    "Mainly ",
    "Source ",
    "Video ",
    "Generation ",
    "High ",
    "Commercial-use ",
    "Commercial ",
    "Locked ",
    "Cross-source ",
    "Support ",
    "Capability ",
    "Photorealistic ",
    "AI ",
    "Strongly ",
    "Avatar ",
    "Weaker ",
)

DISALLOWED_SUBSTRINGS = (
    "global tech company",
    "AI research company",
    "make good use of",
    "experience the power of",
    "top-tier",
    "extraordinarily productive",
    "best way",
    "generationgeneration",
    "templatetemplate",
    "codestandout",
    "citationsstrong",
    "Cloudlarge",
    "ByteDancelaunched",
)

TERM_AVOIDANCE = {
    "multi-modal": "multimodal",
    "multi mode": "multimodal",
    "long text": "long-context",
    "long window": "long-context",
    "voice copy": "voice cloning",
    "knowledge库": "knowledge base",
    " hot topics": "real-time topics",
    " trending events": "real-time topics",
    "PPT tool": "presentation tool",
    "code helper": "coding assistant",
    "AI helper": "AI assistant",
}


@dataclass
class Issue:
    key: str
    message: str


def load_entries(path: Path) -> list[tuple[str, str]]:
    entries: list[tuple[str, str]] = []
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        match = ENTRY_RE.match(line)
        if not match:
            continue
        entries.append((match.group("key"), match.group("value")))
    return entries


def matches_seed_scope(key: str) -> bool:
    return key.startswith(("tool.", "learning.", "category."))


def check_general(key: str, value: str) -> list[Issue]:
    issues: list[Issue] = []

    if CHINESE_RE.search(value):
        issues.append(Issue(key, "contains Chinese characters"))

    for fragment in DISALLOWED_SUBSTRINGS:
        if fragment in value:
            issues.append(Issue(key, f'contains disallowed phrase "{fragment}"'))

    lower = value.lower()
    for bad, preferred in TERM_AVOIDANCE.items():
        if bad.lower() in lower:
            issues.append(Issue(key, f'uses "{bad.strip()}", prefer "{preferred}"'))

    if key.endswith((".intro", ".summary")):
        if len(re.findall(r"[.!?]", value)) > 1:
            issues.append(Issue(key, "should usually be a single sentence"))

    if key.endswith(".prompt") or ".prompt." in key:
        if "  " in value:
            issues.append(Issue(key, "contains repeated spacing"))

    return issues


def check_key_shape(key: str, value: str) -> list[Issue]:
    issues: list[Issue] = []

    if ".best_practice." in key and not value.startswith(BEST_PRACTICE_PREFIXES):
        issues.append(Issue(key, "best_practice should use an imperative action sentence"))

    if ".strength." in key and not value.startswith(STRENGTH_PREFIXES):
        issues.append(Issue(key, "strength should use a concise capability phrase"))

    if ".limitation." in key and not value.startswith(LIMITATION_PREFIXES):
        issues.append(Issue(key, "limitation should use a concise constraint or risk phrase"))

    if key.endswith(".intro") and not value.endswith("."):
        issues.append(Issue(key, "intro should end with a period"))

    if key.endswith(".summary") and not value.endswith("."):
        issues.append(Issue(key, "summary should end with a period"))

    if ".prompt." in key and key.endswith(".title") and "template" not in value.lower():
        issues.append(Issue(key, 'prompt title should usually include "template"'))

    if ".prompt." in key and key.endswith(".body"):
        first_word = value.split(" ", 1)[0] if value else ""
        if first_word not in {
            "Summarize",
            "Rewrite",
            "Compare",
            "Write",
            "Review",
            "Read",
            "Create",
            "Based",
            "Refactor",
            "Scan",
            "Turn",
        }:
            issues.append(Issue(key, "prompt body should start with a direct action verb or instruction"))

    return issues


def main() -> int:
    default_path = Path("ios/AIWiki/Resources/en.lproj/Localizable.strings")
    path = Path(sys.argv[1]) if len(sys.argv) > 1 else default_path

    if not path.exists():
        print(f"file not found: {path}")
        return 2

    issues: list[Issue] = []
    for key, value in load_entries(path):
        if not matches_seed_scope(key):
            continue
        issues.extend(check_general(key, value))
        issues.extend(check_key_shape(key, value))

    if issues:
        print(f"style check failed: {len(issues)} issue(s)")
        for issue in issues:
            print(f"- {issue.key}: {issue.message}")
        return 1

    print(f"style check passed: {path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
