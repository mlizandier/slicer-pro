# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Slicer Pro is a Godot 4.6 sprite-slicing game (GDScript, Mobile renderer, D3D12 on Windows). The player drags the mouse across a sprite to define a cut line — the two halves separate with physics impulses and torque.

## Running

Open in Godot 4.6 editor and press F5. Main scene: `slice_sprite.tscn`. Press R to reset.

## Architecture

The slicing uses **shader-based pixel masking**, not mesh cutting:

1. **Two overlapping RigidBody2D instances** (`Top` and `Bottom` in `slice_sprite.tscn`) both render the same sprite. Each gets a `reverse` uniform (`-1.0` or `1.0`) so one shows pixels above the cut line and the other below.

2. **`slice.gdshader`** — Canvas item fragment shader. Takes `entry_point` and `exit_point` in UV space (0-1). Uses a 2D cross-product to determine which side of the line each pixel falls on, then sets `alpha` to 0 or 1 via `step(0.0, scalar * reverse)`.

3. **`slice_sprite.gd`** — Main controller on the root Node2D. On mouse release, converts screen-space click positions to UV coordinates (`(click_pos - sprite_top_left) / sprite_size`), sets shader parameters on both materials, enables gravity, and applies impulses/torque. **Critical**: the `Top` material is duplicated in `_ready()` so the two instances don't share shader uniforms.

4. **`entities/sliceable/sliceable.tscn`** — Reusable RigidBody2D scene (Sprite2D with slice shader + CollisionShape2D). Collision layers/masks are 0 (halves don't collide with each other).

## Input Map (project.godot)

- `click` — Left mouse button (drag to define cut line)
- `reset` — R key (reloads scene)

## Key Technical Details

- Gravity is toggled via `gravity_scale` (0.0 = frozen, 1.0 = falling) rather than enabling/disabling the body
- Mouse-to-UV conversion: `sprite_top_left = global_position - size/2`, then `uv = (mouse_global - top_left) / size`
- For successive cuts (slicing already-cut pieces), the current shader approach would need to be replaced with polygon clipping (Sutherland-Hodgman)

## Conventions

- GDScript with static typing (`:=`, `-> void`)
- Shader uniforms use snake_case
- Scene composition over inheritance — sliceable is a reusable packed scene instanced in the main scene
