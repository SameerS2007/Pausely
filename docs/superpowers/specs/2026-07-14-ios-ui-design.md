# Pausely iOS UI Design

Date: 2026-07-14

## Goal

SwiftUI iOS shell for Pausely: Alarmy-inspired accountability UI with mock local state. Windows companion wiring left as clear TODOs for the owner.

## Approach

Single SwiftUI Xcode project under `ios/`. One `AppState` observable store with fake sessions/settings. No SQLite, no networking in this phase.

## Visual direction

- Background: deep purple with a soft vertical gradient
- Brand: yellow “popping” 3D wordmark `PAUSELY`; the **A** is a pause-button glyph (two bars) with a small extra flourish
- Alarmy cues: oversized timer digits, full-bleed urgent violation screen, high-contrast primary CTAs, intentional friction on override

## Screens

1. **Home** — logo, idle/active/blocked status chip, Start Session CTA, settings entry
2. **Start Session** — game name, duration picker, start
3. **Active Session** — large countdown, remaining label, end-early / override path
4. **Violation / Nag** — full-screen alarm state until mock “I closed it” verify
5. **Override Confirm** — short intentional delay before confirming override
6. **Settings** — allowed hours, default session length, notification toggles (local mock only)

## Out of scope

- Real Windows agent / WebSocket connection
- Computer vision verify
- Persistence beyond in-memory mock
- App Store polish / widgets

## Extension points

`AppState` methods (`startSession`, `triggerViolation`, `confirmClosed`, `requestOverride`) are the seams for later Windows integration.
