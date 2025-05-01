#!/usr/bin/env python3
import sys
import re
from pathlib import Path
from typing import Optional

title_regex = re.compile(r"([^#]*)(#+) +(.*[^} ]) *(?:\{ *#([^} ]+) *\})? *")


class Title:
    def __init__(self, title: str, id: str, level: int, prefix: str):
        self.title: str = title
        self.id: str = id
        self.level: int = level
        self.prefix: str = prefix

    @classmethod
    def from_line(cls, line: str) -> "Title":
        title_match = title_regex.fullmatch(line)
        assert title_match is not None, "Unsupported title format: " + line
        prefix, sharps, title, id = title_match.groups()
        return cls(
            title=title,
            id=id or cls.title_to_default_id(title),
            level=len(sharps),
            prefix=prefix,
        )

    def to_line(self) -> str:
        return f"{self.prefix}{'#'*self.level} {self.title} {{ #{self.id} }}"

    def __repr__(self) -> str:
        return f"Title(title = {self.title}, id = {self.id}, level = {self.level})"

    @staticmethod
    def title_to_default_id(title: str):
        # https://github.com/rust-lang/mdBook/blob/94e0a44e152d8d7c62620e83e0632160977b1dd5/src/utils/mod.rs#L30-L43
        return "".join(
            "-" if c.isspace() else c
            for c in title.lower()
            if c.isalpha() or c.isspace() or c in ("_", "-")
        )

    @staticmethod
    def is_title(title: str) -> bool:
        if title.startswith("/- "):
            title = title[len("/- ") :]
        return title.startswith("#") and title.lstrip("#").startswith(" ")


def sync_md_id(src_file: Path, dest_file: Path):
    print(f"from {src_file} to {dest_file}:")
    src_titles_reverse = [
        Title.from_line(line.rstrip("\n"))
        for line in open(src_file).readlines()[::-1]
        if Title.is_title(line)
    ]

    dest_lines = [line.rstrip("\n") for line in open(dest_file).readlines()]
    in_comment = False
    for n in range(len(dest_lines)):
        line = dest_lines[n]
        if line.strip().startswith("<!--"):
            in_comment = True
            continue
        if line.strip().startswith("-->"):
            in_comment = False
            continue
        if in_comment:
            continue
        if not Title.is_title(line):
            continue
        title = Title.from_line(line)
        assert (
            len(src_titles_reverse) != 0
        ), f"There are more titles in the destination, one of which is {title}"
        src_title = src_titles_reverse.pop()
        title.id = src_title.id
        assert (
            title.level == src_title.level
        ), f"Titles from source and destination have different level: {src_title} {title}"
        print(src_title, "->", title)
        dest_lines[n] = title.to_line()

    open(dest_file, "w").write("\n".join(dest_lines))

    assert (
        len(src_titles_reverse) == 0
    ), f"There are more titles in the source, which are {src_titles_reverse[::-1]}"
    print()


def main(src: Path, dest: Path, suffix: Optional[str]):
    if not src.is_dir():
        sync_md_id(src, dest)
        return
    assert suffix is not None
    for filename in Path(src).rglob("*." + suffix):
        sync_md_id(filename, dest / filename.relative_to(src))


if __name__ == "__main__":
    if len(sys.argv) < 3:
        usage = f"""Usage: {sys.argv[0]} upstream_directory translation_directory name_suffix
   or: {sys.argv[0]} upstream_file translation_file
Synchronize title IDs from upstream to translation, to make fragment identifier in urls work.

Example: {sys.argv[0]} ./upstream/lean/ ./lean/ lean"""
        print(usage, file=sys.stderr)
        exit(1)
    main(
        Path(sys.argv[1]), Path(sys.argv[2]), None if len(sys.argv) < 4 else sys.argv[3]
    )
