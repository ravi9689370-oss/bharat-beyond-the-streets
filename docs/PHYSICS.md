# Physics — BHARAT: BEYOND THE STREETS

## Physics Engine
Godot 4.x built-in physics (RigidBody3D / CharacterBody3D / StaticBody3D).

## Player Physics (CharacterBody3D)
- Acceleration/deceleration, momentum, friction
- Gravity, ground detection, jump velocity, air control
- Slope handling, collision, animation blending
- Fixed physics timestep (60 Hz), decoupled from rendering

## Vehicle Physics (RigidBody3D)
- Mass (1200 kg), center of mass, inertia
- Engine force, braking, reverse, steering (yaw torque)
- Tire grip / surface-dependent traction
- Suspension-like damping, weight transfer, skid/drift behavior
- Rollover behavior, collision response, speed-dependent steering

## Surfaces
Behavior varies by surface: asphalt, concrete, dirt, gravel, sand, grass, mud, wet road.

## Architecture
Physics simulation / rendering / input / animation / camera are separate.
Fixed timestep, no frame-rate-dependent physics. Collision layers/masks used consistently.