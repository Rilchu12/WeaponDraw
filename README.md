# FiveM Weapon Draw Animation

A lightweight resource that plays a configurable draw animation when a player equips a weapon.

## Usage

1. Copy the `fivem_weapon_draw` folder into your FiveM server's `resources` directory.
2. Add `ensure fivem_weapon_draw` to your `server.cfg` to start the resource.
3. The default animation uses the `reaction@intimidation@cop@unarmed` dictionary with the `intro` clip.

### QBCore compatibility

The script is framework-agnostic and works on QBCore servers. If you are using a holster animation from `qb-weapons` or another QBCore resource, disable its draw animation to avoid conflicts. The optional `RequireQBLogin` flag in `client.lua` defers playing the animation until the player is logged in on QBCore (`LocalPlayer.state.isLoggedIn`).

## Configuration

Adjust the `Config` table in `client.lua` to change the animation dictionary, clip name, duration, and cooldown between plays.

### Category-specific animations

By default the script picks a different animation per weapon group (pistols, SMGs, rifles, shotguns, melee, etc.). Each entry in
`Config.Animations` uses the hash returned by `GetWeapontypeGroup`. Override or add entries to customize per-category animati
ons while the `DefaultAnimation` block covers any group you do not explicitly map.
