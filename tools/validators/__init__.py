"""Validators for frozen raid-definition data."""

__all__ = ["validate_raid"]


def __getattr__(name):
    if name == "validate_raid":
        from .raid import validate_raid

        return validate_raid
    raise AttributeError(name)
