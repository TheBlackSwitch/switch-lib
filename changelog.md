
This file contains the most recent changes to the library. It's more for myself to keep track but feel free to read it :P

# Changelog

## Small Features
- Added new events: 
    - block_placed => when an item is used on a block
    - init_player => runs once when the player joins the game or when the library updates
    - inventory_changed => runs every time the inventory data changes or a player opens a chest

## Bug fixes
- Fixed a critical issue with the player ID system that would generate a new player ID every new switch lib update. Luckly I've fixed this right in time so this should have no consequences
- Fixed an issue with overlays where the data isn't initialized correctly causing all uninitialized player to get all overlays from other players