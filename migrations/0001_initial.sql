-- Migration: 0001_initial
-- Creates four core tables for Career OS:
--   person         (singleton profile — one row ever)
--   employer       (companies you have worked at)
--   role           (positions held, linked to an employer)
--   activity_event (append-only log of notable work events)

CREATE TABLE IF NOT EXISTS person (
    id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    name        text        NOT NULL,
    email       text,
    location    text,
    summary     text,
    created_at  timestamptz NOT NULL DEFAULT now(),
    updated_at  timestamptz NOT NULL DEFAULT now(),
    deleted_at  timestamptz
);

CREATE TABLE IF NOT EXISTS employer (
    id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    name        text        NOT NULL,
    industry    text,
    size_range  text,
    location    text,
    summary     text,
    created_at  timestamptz NOT NULL DEFAULT now(),
    updated_at  timestamptz NOT NULL DEFAULT now(),
    deleted_at  timestamptz
);

CREATE TABLE IF NOT EXISTS role (
    id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    employer_id uuid        NOT NULL REFERENCES employer(id) ON DELETE RESTRICT,
    title       text        NOT NULL,
    level       text,
    started_at  date,
    ended_at    date,
    summary     text,
    created_at  timestamptz NOT NULL DEFAULT now(),
    updated_at  timestamptz NOT NULL DEFAULT now(),
    deleted_at  timestamptz
);

-- activity_event is append-only: no updated_at, no deleted_at.
-- Events are immutable facts; corrections are new rows, never edits.
CREATE TABLE IF NOT EXISTS activity_event (
    id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    occurred_at timestamptz NOT NULL DEFAULT now(),
    kind        text        NOT NULL,
    summary     text        NOT NULL,
    payload     jsonb,
    tags        text[],
    created_at  timestamptz NOT NULL DEFAULT now()
);
