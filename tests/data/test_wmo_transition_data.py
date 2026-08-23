#!/usr/bin/env python3
"""Validate pinned WMO group and portal data used for floor transitions."""

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCES = (
    ROOT / "tools/ac/fixtures/transitions/black-temple-wmo.json",
    ROOT / "tools/ac/fixtures/transitions/karazhan-wmo.json",
)


def main() -> None:
    for source in SOURCES:
        data = json.loads(source.read_text(encoding="utf-8"))
        assert data["metadata"]["coordinateSpace"] == "wmo-local"
        if source.name == "black-temple-wmo.json":
            assert data["placement"]["uniqueId"] == 1075600
            assert data["placement"]["wmoFileDataID"] == data["fileDataID"]
        assert len(data["groupInfo"]) == data["groupCount"]
        assert len(data["portalInfo"]) == data["portalCount"]
        assert all(len(vertex) == 3 for vertex in data["portalVertices"])
        for portal in data["portalInfo"]:
            assert portal["startVertex"] + portal["count"] <= len(data["portalVertices"])
        for reference in data["portalReferences"]:
            assert 0 <= reference["portalIndex"] < data["portalCount"]
            assert 0 <= reference["groupIndex"] < data["groupCount"]
        for group in data["groupInfo"]:
            assert all(a <= b for a, b in zip(group["boundingBox1"], group["boundingBox2"]))
        print(f"WMO transition data valid: {source.name}")


if __name__ == "__main__":
    main()
