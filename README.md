# FiveM Weapon Draw Animation

A lightweight resource that plays a configurable draw animation when a player equips a weapon.

## Usage

1. Copy the `fivem_weapon_draw` folder into your FiveM server's `resources` directory.
2. Add `ensure fivem_weapon_draw` to your `server.cfg` to start the resource.
3. The default animation uses the `reaction@intimidation@cop@unarmed` dictionary with the `intro` clip.

## Configuration

Adjust the `Config` table in `client.lua` to change the animation dictionary, clip name, duration, and cooldown between plays.
