# SPDX-FileCopyrightText: 2023 Mark Liffiton <liffiton@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-only

from dataclasses import dataclass, field

from flask import current_app, render_template
from gened.auth import get_auth
from gened.class_config import get_class_config as gened_get_config
from gened.class_config import register_class_config, register_extra_handler
from gened.db import get_db
from typing_extensions import Self
from werkzeug.datastructures import ImmutableMultiDict


def _default_langs() -> list[str]:
    return current_app.config['DEFAULT_LANGUAGES']


@dataclass(frozen=True)
class ClassConfig:
    languages: list[str] = field(default_factory=_default_langs)
    default_lang: str | None = None
    avoid: str = ''

    @classmethod
    def from_request_form(cls, form: ImmutableMultiDict[str, str]) -> Self:
        return cls(
            languages=form.getlist('languages[]'),
            default_lang=form.get('default_lang', None),
            avoid=form['avoid'],
        )


def get_class_config() -> ClassConfig:
    return gened_get_config(ClassConfig)


def assignment_config_form() -> str:
    db = get_db()
    auth = get_auth()
    assignments = db.execute("SELECT * from assignments WHERE assignments.class_id=? AND is_deleted = FALSE ORDER BY id", [auth['class_id']]).fetchall()
    return render_template("config_form_assignments.html", assignments=assignments)


def register_with_gened() -> None:
    register_class_config(ClassConfig)
    register_extra_handler(assignment_config_form)
