from __future__ import annotations

from pathlib import Path


def write_new_text_file(
    path: Path,
    content: str,
    *,
    encoding: str = "utf-8",
) -> None:
    """Create one text output atomically with respect to existing paths."""

    path.parent.mkdir(parents=True, exist_ok=True)
    try:
        with path.open("x", encoding=encoding) as target:
            target.write(content)
    except FileExistsError as error:
        raise FileExistsError(
            f"Refusing to overwrite existing annotation output: {path}"
        ) from error
