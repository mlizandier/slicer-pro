# Slicer Pro

A Godot 4.6 demo that lets you slice sprites in half with a mouse drag. Click and drag across a sprite to define a cut line — the two halves separate with physics-based impulses and torque.

## How It Works

1. **Shader-based slicing** — A custom fragment shader ([slice.gdshader](slice.gdshader)) determines which side of the cut line each pixel falls on using a cross-product test, then discards pixels on one side by setting alpha to 0.
2. **Two overlapping copies** — The scene uses two instances of a [sliceable](entities/sliceable/sliceable.tscn) `RigidBody2D`. Each gets the same shader with a flipped `reverse` uniform so one shows the "top" half and the other the "bottom" half.
3. **Physics response** — On slice, gravity is enabled and impulses/torque are applied so the halves tumble apart.

## Controls

| Input        | Action                               |
| ------------ | ------------------------------------ |
| Click + drag | Define the slice line (entry → exit) |
| R            | Reset the scene                      |

## Project Structure

```
slice.gdshader          # Fragment shader that masks one side of the cut
slice_sprite.gd         # Main script: handles input, computes UV-space cut, triggers physics
slice_sprite.tscn       # Main scene with two sliceable instances and a camera
entities/sliceable/     # Reusable RigidBody2D scene with sprite + collision shape
```

## Next steps :

- [ ] Block user input when objects are falling
- [x] Add a force gauge
  - [ ] Too much force vs some objects will fail
  - [ ] Too little force vs some others will also fail
  - [ ] Indicate needed force
- [ ] Add places where the cut is supposed to happen
- [ ] Indicate when user is slicing
- [ ] Create a nice environment
- [ ] Multiple stuff to cut through
- [ ] Sound effects
- [ ] Find a cool name
- [ ]

### Score system :

I'm thinking of implementing a score system and leaderboard but I'm not sure yet.

Mayber an endless mode where there are tons of

### Other minigame :

- [ ] Clean your katana
- [ ] Customize katana particles and stuff

## Story :

You're a bored retired samurai. Can you slice through retirement?
