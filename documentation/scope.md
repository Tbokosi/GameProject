Project Specification
1. Technical specs
Item	Decision
Title	Everspace-style 3D space shooter (working name: Starfall)
Engine / language	Godot 4.7.2 (as the spec requires) / GDScript only
Platform	Android (real device), landscape, touch only
Renderer	Mobile or Compatibility (to decide once I know your phone)
Resolution	1920x1080 base, stretch canvas_items, aspect expand
Plugins allowed	GDQuest Steering AI Framework, plus godot_flight_navigation_3d (the spec requires it, so confirm with your tutor)
Assets	Only the provided COM415 resources, with licences kept
Deliverables	Godot project, APK, 3-minute MP4 from a real device, all zipped as FirstName_RegNo
Deadline	13 Nov 2026
2. Functional features

Game flow (15)

Main menu with sub-menus: Start, Ship Select, Level Select
Level complete screen showing total time, with Replay or Main Menu
Game over screen when health reaches 0, with Continue (restart level) or Quit (main menu)
Flow: Main Menu > Ship Select > Level Select > Level > Complete / Game Over

Player (15)

3 ships with different max speed and acceleration (plus turn speed and health)
Stats shown on the ship select screen
Health attribute that drops when hit by enemy lasers
Laser shooting, with a fire rate and cooldown

Input (5)

Touch navigation for all menus
Virtual joystick for steering
On-screen fire button

Camera (5)

Perspective chase camera behind and above the ship, with smooth lag and FOV or tilt changes when turning, similar to Everspace 2

HUD (10)

Health bar
On-screen touch guides for the joystick and fire button
Objective counter (kills remaining, then “go to the zone”)
Level timer
Crosshair

Game world (5)

2 levels: Level 1 in space (asteroids, debris, nebula or skybox), Level 2 on a planet surface (terrain, rocks, structures)
Obstacles that both the player and the AI must avoid
Distinct lighting and environment per level
Objective: destroy N enemies, then a goal zone activates, and entering it completes the level

AI and enemies (25)

2 enemy types using the provided flying models (for example a fast, light interceptor and a slow, heavy gunship). Confirm with your tutor that two flying variants is acceptable.
Enemy lasers that damage the player, and player lasers that damage enemies
Enemy health, death and explosion
Off-screen and on-screen icon markers so enemies are identifiable from a distance
Finite State Machine with Wander, Chase and Attack states
At least 3 steering behaviours: path following, wander, and obstacle avoidance (or separation)
Pathfinding through godot_flight_navigation_3d

Aesthetics (5)

Laser trails, engine glow, hit sparks and explosions with particles
Lighting, glow and fog

Audio (5)

Music for the menu and for each level
SFX for lasers, hits, explosions, UI clicks, and level complete / game over

Code (5)

Godot GDScript style guide, typed variables, doc comments
Citations in comments for any outside code
3. Full folder structure

I haven’t seen the filenames inside Environment and Space Ships, so the asset folders list categories rather than exact files. Paste me those two folder listings and I’ll fill them in.

starfall/
├── project.godot
├── export_presets.cfg
├── icon.svg
├── README.md                              # credits, licences, build notes
│
├── addons/
│   ├── godot_steering_ai_framework/       # GDQuest framework (as provided)
│   └── godot_flight_navigation_3d/        # required nav plugin
│
├── assets/
│   ├── audio/
│   │   ├── music/                         # menu, level 1, level 2 tracks
│   │   └── sfx/                           # lasers, impacts, explosions, UI
│   ├── ships/                             # player ship + enemy models/textures
│   ├── environment/                       # asteroids, rocks, terrain, skyboxes
│   ├── ui/                                # kenney UI, crosshair, cursor, icons
│   └── vfx/                               # particle textures (spark, smoke, glow)
│
├── resources/
│   ├── ship_data/
│   │   ├── ship_scout.tres
│   │   ├── ship_fighter.tres
│   │   └── ship_cruiser.tres
│   ├── enemy_data/
│   │   ├── enemy_interceptor.tres
│   │   └── enemy_gunship.tres
│   ├── level_data/
│   │   ├── level_space.tres
│   │   └── level_planet.tres
│   ├── environments/
│   │   ├── env_space.tres                 # WorldEnvironment settings
│   │   └── env_planet.tres
│   ├── materials/
│   │   ├── laser_player_mat.tres
│   │   └── laser_enemy_mat.tres
│   └── themes/
│       └── ui_theme.tres
│
├── scenes/
│   ├── menus/
│   │   ├── main_menu.tscn
│   │   ├── ship_select.tscn
│   │   └── level_select.tscn
│   ├── levels/
│   │   ├── level_base.tscn                # shared: player spawn, HUD, objectives
│   │   ├── level_space.tscn
│   │   └── level_planet.tscn
│   ├── ships/
│   │   ├── player_ship.tscn               # body, weapons, camera rig, health
│   │   ├── ship_model_scout.tscn
│   │   ├── ship_model_fighter.tscn
│   │   └── ship_model_cruiser.tscn
│   ├── enemies/
│   │   ├── enemy_base.tscn                # body, FSM, steering, health, weapon
│   │   ├── enemy_interceptor.tscn
│   │   └── enemy_gunship.tscn
│   ├── projectiles/
│   │   ├── laser_player.tscn
│   │   └── laser_enemy.tscn
│   ├── world/
│   │   ├── goal_zone.tscn
│   │   ├── obstacle_asteroid.tscn
│   │   ├── obstacle_rock.tscn
│   │   ├── flight_nav_region.tscn         # nav data holder for each level
│   │   └── enemy_spawn_point.tscn
│   ├── vfx/
│   │   ├── explosion.tscn
│   │   ├── hit_spark.tscn
│   │   ├── engine_trail.tscn
│   │   └── laser_trail.tscn
│   └── ui/
│       ├── hud.tscn
│       ├── virtual_joystick.tscn
│       ├── fire_button.tscn
│       ├── enemy_marker.tscn
│       ├── game_over.tscn
│       └── level_complete.tscn
│
├── scripts/
│   ├── autoload/
│   │   ├── game_state.gd                  # selection, timer, scene flow
│   │   ├── audio_manager.gd               # music + SFX playback
│   │   └── scene_manager.gd               # scene changes / fades
│   ├── resources/
│   │   ├── ship_data.gd
│   │   ├── enemy_data.gd
│   │   └── level_data.gd
│   ├── components/
│   │   ├── health_component.gd            # shared by player and enemies
│   │   └── weapon_component.gd            # fire rate, muzzle points, spawn lasers
│   ├── player/
│   │   ├── player_ship.gd                 # movement using ShipData stats
│   │   ├── ship_controller.gd             # joystick + fire input to ship
│   │   └── chase_camera.gd
│   ├── enemies/
│   │   ├── enemy_base.gd
│   │   ├── enemy_steering.gd              # wraps steering behaviours
│   │   ├── enemy_navigation.gd            # wraps flight navigation plugin
│   │   └── fsm/
│   │       ├── state.gd                   # base class
│   │       ├── state_machine.gd
│   │       ├── state_wander.gd
│   │       ├── state_chase.gd
│   │       └── state_attack.gd
│   ├── projectiles/
│   │   └── laser.gd
│   ├── levels/
│   │   ├── level_base.gd                  # start, win, lose, restart
│   │   ├── objective_manager.gd           # kill count + goal unlock
│   │   ├── goal_zone.gd
│   │   └── enemy_spawner.gd
│   ├── vfx/
│   │   └── auto_free_vfx.gd               # frees particles when done
│   └── ui/
│       ├── main_menu.gd
│       ├── ship_select.gd
│       ├── level_select.gd
│       ├── hud.gd
│       ├── virtual_joystick.gd
│       ├── fire_button.gd
│       ├── enemy_marker.gd
│       ├── enemy_marker_manager.gd
│       ├── game_over.gd
│       └── level_complete.gd
│
└── docs/
	├── credits.md
	└── test_checklist.md                  # device test notes for the video
