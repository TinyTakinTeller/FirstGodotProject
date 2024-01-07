## First Godot Project

First project to learn the Godot 4 Engine.

List of features:

*Comming Soon*



## Releases

*Comming Soon*

Chapter 2 screenshot:

![image](https://github.com/TinyTakinTeller/FirstGodotProject/assets/155020210/4d3e6cce-b525-4001-8508-13cf4a8f916c)



## Development Log

Following Udemy course **Create a Complete 2D Survivors Style Game in Godot 4** (with personal tweaks).

TLDR configuration settings from all chapters are below.
<details>

```
TLDR CONFIGURATION:
- compatibility renderer
- 2d profile with unchecked 3D editor
- panels on left side; top:[FileSystem,History][Scene,Import], bot:[][Inspector,Node]
- disable folding (on)
- default texture filter: nearest
- input map: arrow keys and w,a,s,d and left_click
- viewport: 640 x 360, stretch mode: viewport, window override: 1920 x 1080
- name 2D physic layers 1,2,3,4,5 (for Mask/Layer), e.g. Terrain, Player, Enemy, EnemyCollision, Pickup 
- snap 2D Transforms to Pixels: (chapter 1: on -> chapter 2: off)
- autoload configuration: game_events.tscn
- project custom theme resource: theme.tres
- configure and enable Format on Save plugin
- turn on Warn for Untyped Declaration in Debug
```

</details>

Personal Notes for **Chapter 1** of the course are below. - **The basic project: movable player character.**
<details>

```
LEARN GODOT 2024

LINK TO VIDEO MATERIAL: https://www.udemy.com/course/create-a-complete-2d-arena-survival-roguelike-game-in-godot-4/

TEXT MATERIAL:


Chapter 1. Starting Out



video 1 - New Project

CLICK New project > Compatibility renderer
CLICK Editor > Manage Editor Features... > Create profile > "2d" > Main Features > (uncheck) "3D Editor"
CLICK FileSystem && History (panel) > (3 dot menu) > (top left cell, left side)
CLICK Inspector && Node (panel) > (3 dot menu) > (bottom right cell, left side)

TIP: we can drag & drop res:// file into Inspector (into some property)
TIP: hold middle mouse (or space + left mouse) to move around 2D scene view, scroll wheel (or buttons) to zoom
TIP: key F will center the node or the scene (if selected)

Editor > Editor Settings > Interface > Inspector > Disable Folding (on) // will show all Node properties at all times



video 2 - Player Scene

TIP: kenney.nl // free assets for any use

DOWNLOAD kenney.nl/assets/tiny-dungeon 
. > Tilemap > tilemap.png
. > Tiles > (any).png > (drag & drop into) "res://" (create "assets.player" directory) > rename to "player.png"

TIP: A "Scene" is any collection of Nodes (or other Scenes) saved together (in a file)

CLICK + Other Node > CharacterBody2D
RIGHT CLICK CharacterBody2D > Add Child Node > Sprite2D
SELECT CharacterBody 2D > Ctrl + S (save scene) > player.tscn ("assets.player" directory)
RIGHT CLICK CharacterBody2D > Rename > "Player" > Ctrl + S (save scene)
RIGHT CLICK "assets" (folder) > Rename > "scenes"

SELECT Sprite2D (below Player) > (drag & drop into) "player.png" into Texture property
ZOOM IN (mouse wheel)
CLICK Project > Project Settings... > Rendering > Textures > Default Texture Filter: Nearest // for pixel art project
CLICK Sprite2D (2D view) > Offset property > y = -8 // such that sprite feet is at origin

RIGHT CLICK Player (root scene node) > Add Child Node > CollisionShape2D > Shape property > CircleShape2D
SELECT CircleShape2D > Radius property > 5 px // such that it is inside sprite by a thick margin
SELECT CollisionShape2D > Transform > Position property > y = -5 // such that it touches the feet (collision ends on feet end)



video 3 - Player Script and Main Scene

CLICK Player (root scene node) > Attach Script ("scroll with green +" button in Scene panel) > Node: Default > Create
CLICK Project > Project Settings... > Input Map (tab) > Show Built-In Actions (toggle ON then OFF) > Add New Action
. > move_left 	> Add Event > + > Filter By Event... > PRESS <key> (left arrow && A) 
. > move_right	> Add Event > + > Filter By Event... > PRESS <key> (right arrow && D)
. > move_up 	> Add Event > + > Filter By Event... > PRESS <key> (up arrow && W)
. > move_down 	> Add Event > + > Filter By Event... > PRESS <key> (down arrow && S)

OPEN Script view (player.gd) > *write movement script* (with BONUS: use optional typing and "self" keyword)
"""
extends CharacterBody2D

const MAX_SPEED: float = 200


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.velocity = get_direction() * MAX_SPEED
	self.move_and_slide()

func get_direction() -> Vector2:
	# right is X+ axis and down is Y+ axis
	var x_movement: float = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement: float = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	return Vector2(x_movement, y_movement).normalized()

"""

TIP: F1 opens documentation

CLICK Scene > New Scene > + Other Node > Node (base object) > rename "Main" > save "scenes.main.main.tscn"
RIGHT CLICK Main (Scene tab) > Instantiate Child Scene > player.tscn

TIP: Changes in player scene are reflected in player instance(s)



video 4 - TileMap

CLICK Project > Project Settings... > General (tab) > Display > Window // optimize viewport for "16 x 16 pixel sprites"
. > Viewport Width: 640
. > Viewport Height: 360
. > Stretch Mode: viewport
. > Window Width Override: 1920
. > Window Height Override: 1080

RIGHT CLICK Main > Add Child Node... > Add TileMap > (drag it above Player) // draw order is top down in node tree
RIGHT CLICK res:// > Create New > resources (folder) > tileset.tres (TileSet resource)
(drag & drop) tilemap_packed.png into "res://assets/enviroment" folder (from chapter 2 DOWNLOAD)
(drag & drop) tilemap_packed.png into tileset.tres (Tiles panel) > click "No" then select 3 floor tiles for now **1

CLICK Inspector (panel) > Terrain Sets > + Add Element > Mode: Match Corners and Sides > + Add Element "Floor"
CLICK Tiles (panel) > Paint > Paint Property: Terrains > Painting:
. > Terrain Set: Terrain Set 0
. > Terrain: Floor
. > (fill in all 3 selected floor tiles **1) // Tiles bitmask filled: tile shows (is valid) only if it is surrounded by tiles
CLICK Tiles (panel) > Paint > Paint Property: Probability > Painting:
. > (paint all 3 selected floor tiles **1 with probabilities: 20, 5, 1)

SELECT TileMap (node under Main) > (drag & drop) tileset.tres > Tile Set property
CLICK TileMap (bottom tool track) // close TileMap editor pane
CLICK TileMap (node under Main) // open TileMap editor pane
CLICK Terrains (panel) > Floor > (paint on screen main scene with HOLD LEFT CLICK) // select rect tool next to bucket



video 5 - Camera and Hotkeys and Groups

CTRL + N (Hotkey: create new Scene)
CTRL + A (Hotkey: add new Node)
. > Camera2D > "GameCamera" > scenes/game_camera/game_camera.tscn > game_camera.gd > *write camera script* (with BONUS)
"""
extends Camera2D

var target_position: Vector2 = Vector2.ZERO 


# Called when the node enters the scene tree for the first time.
func _ready():
	self.make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.acquire_target()
	self.global_position = global_position.lerp(self.target_position, 1.0 - exp(-delta * 10))

func acquire_target():
	var player_nodes: Array[Node] = self.get_tree().get_nodes_in_group("player")
	if player_nodes.size() > 0:
		var player: Node2D = player_nodes[0] as Node2D
		self.target_position = player.global_position

"""
CTRL + SHIFT + O (Hotkey: quick open scene)
. > player.tscn > Player (scene root node) > Node (panel) > Groups (tab) > Manage Groups > add Player node to "player" group
ADD game_camera scene to main scene



video 6 - Epilogue

See Chapter 2.



BONUS

DOWNLOAD Godot Git Plugin (4.1+) from GODOT ASSET LIBRARY (CLICK AssetLib inside editor)
VISIT https://github.com/godotengine/godot-git-plugin/wiki
UPLOAD THIS PROJECT AND THESE NOTES TO GITHUB.
```

</details>

Personal Notes for **Chapter 2** of the course are below. - **The basic game loop: player, enemies, upgrades.**
<details>

```
Chapter 2. Building the Foundation


video 1 - Rat enemy

CREATE BasicEnemy scene (CharacterBody2D > Sprite2D with Texture > CollisionShape2D with Circle) > basic_enemy.gd
ADD BasicEnemy scene to Main scene
CONFIGURE Player scene > Collision > Layer 1 (toggle off)
CONFIGURE BasicEnemy scene > Collision > Layer 1 (toggle off)


video 2 - Sword spawner

CREATE SwordAbility scene (Node2D > Sprite2D with Texture > CollisionShape2D with Circle)
CONFIGURE SwordAbility scene > Offset > y = -4 // pivot point on handle, for better sprite rotation

CREATE SwordAbilityController scene > sword_ability_controller.gd
. > """ @export var sword_ability: PackedScene """ > (drag & drop) sword_ability.tscn into this export (Inspector panel)
. > ADD Timer node > Autostart (on) > One Shot (off) > Wait Time (1.5 s) // connect to timer SIGNAL

CREATE Node AbilityManager inside Player scene
. > ADD SwordAbilityController scene below it (in node tree)


video 3 - AnimationPlayer

ADD AnimationPlayer node to SwordAbility scene > Animation (Animation panel) > create new animation "swing"
. > (top right, animation panel) set animation length to 0.3 (clock icon) // zoom using scrollbar (bottom right, animation panel)
. > CLICK (key icon) in Sprite2D property *Rotation* (Inspector panel) to create new animation key frames track
	.. > Interpolation = cubic (far right of key frames track)
	.. > at 0.2 seconds, create new animation key frame (right click animation track > Insert Key) // hold shift for snapping
		... > value = 180 (Inspector panel, select the new key frame)
. > CLICK (key icon) in Sprite2D property *Scale* (Inspector panel) to create new animation key frames track
	.. > Interpolation = cubic (far right of key frames track)
	.. > at 0.15 seconds, create new animation key frame
		... > value = 2
	.. > at 0.25 seconds, create new animation key frame
		... > value = 1
EXTEND ANIMATION LENGTH to 0.5
CHANGE Snap to 0.05 (bottom right) > select and move all key frames forward to the end (0.5)
. SELECT Scale frames track
	.. > at 0.0 seconds, create new animation key frame ... > value = 0
	.. > at 0.1 seconds, create new animation key frame ... > value = 1.25
EXTEND ANIMATION LENGTH to 0.7
. SELECT Rotation frames track
	.. > at 0.7 seconds, create new animation key frame ... > value = 0
	.. > edit at 0.4, set Easing curve to 1.68
	.. > at 0.0 seconds, create new animation key frame ... > value = 0
	.. > edit at 0.2 ... value = -10
. SELECT Scale frames track
	.. > at 0.7 seconds, create new animation key frame ... > value = 0
	.. > edit second to last key frame, set Easing curve to 5.65
// etc play with random values and frames

CLICK "Autoplay on Load" (toggle on) next to "Edit" on Animation panel

CLICK "+ Add Track" on Animation panel > Call Method Track > SwordAbility root node
. > RIGHT CLICK > Insert Key > "queue_free" at 0.7 seconds // can be called from code, or here for "self-cleaning"

// TIP: Scene panel has Remote/Local views (switch to see SwordAbility spawning and despawning properly)


video 4 - Targeting Enemies

ADD BasicEnemy to "enemy" GROUP
EDIT sword_ability_controller.gd 
. > filter enemies by max distance
. > select closest enemy
TIP: squaring is faster than square root
TIP: prefix _ means variable is unused or function is private


video 5 - Killing Enemies

ADD to BasicEnemy > Area2D with child CollisionShape2D with circle // radius 12
Area2D > toggle Mask 3 (on) else (off)

CONFIGURE Project > Project Settings... > Layer Names > 2D Physics > L1 "Terrain" L2 "Player" L3 "Enemy"

TIP: move Area2D above other children (rendered first)
TIP: Mask "I want to check if I am colliding with you" && Layer "I am on this layer so you can collide with me"

ADD to SwordAbility > Area2D with child CollisionShape2D with rectangle // x 30 y 30, align left side to sword center (right side is our attack direction)
Area2D > toggle Layer 3 (on) else (off)

EDIT AnimationPlayer > add CollisionsShape2D Disabled property key frames track // disable at 0, enable at 0.15, disable at 0.4

EDIT basic_enemy.gd
. > BasicEnemy.Area2D > Node panel (Signals) > area_entered(area: Area2D)

EDIT sword_ability_controller.gd
. > point in direction, i.e. spawned sword towards target enemy
// TIP: subtract global_position POINT_AT - POINT_FROM then set rotation to result angle
// TIP: add random offset in a radius to sword spawning coords

TIP: Debug > Visible Collision Shapes (toggle on)

RENAME Area2D's to Hitbox


video 6 - Configure integral coordinates for 2D nodes to be less jittery

CLICK Project > Project Settings... > Rendering > 2D > Snap 2D Transforms to Pixels // TIP: toggle advanced settings on


video 7 - Spawning Enemies Automatically

NEW SCENE EnemyManager (default Node) > enemy_manager.gd
. > Timer // Wait Time 1 s // Autostart on


video 8 - Improving the game feel

// camera smoothing 10 -> 20
// Player > ACCELERATION_SMOOTHING = 25, i.e. velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
// MAX_SPEED 200 -> 125
// basic enemy MAX_SPEED 75 -> 40
NAME Layer 4 "EnemyCollision" > BasicEnemy > toggle on Layer 4 and Mask 4
EDIT Player (Inspector panel) > Motion Mode: Grounded (// TIP: for 2D platformers) -> Floating (// TIP: better for 2D topdown)
UNDO CONFIGURATION Snap 2D Transforms to Pixels on -> off // newly added smoothing acceleration works better without it

* BONUS: refactor spawner functions to utility class


video 9 - Creating the game loop foundation (first UI element)

ADD ArenaTimeManager (Node) . Timer > arena_time_manager.gd
ADD ArenaTimeUI (CanvasLayer) > arena_time_ui.gd
. > MarginContainer [Presets > Full Rect, Theme Overrides > Margin Top: 8, Mouse.Filter: Ignore // do not intercept mouse clicks]
.. > Label [Layout > Container Sizing > Horizontal: Shrink Center, Vertical: Shrink Begin, Text: "Time"]


video 10 - Experience drops

REFACTOR PACKAGES
CONFIG Layer 5 "Pickup"
ADD ExperienceVial (Node2D) . Sprite2D, Area2D.CollisionShape2D (16 circle) // Layer off Mask 5 on Hitbox (Area2D)
. > experience_vial.gd
ADD Hitbox (Area2D) . CollisionShape2D (32 circle) to Player // Layer 5 Mask off on Hitbox (Area2D)


video 11 - Experience tracking

ADD ExperienceManager (Node) > experience_manager.gd
CREATE global singleton GameEvents (autoload) 
. > emit custom experience signal > autoload configure the game_events.tscn > game_events.gd // add signal
BONUS spawn ExperienceVial on BasicEnemy queue_free()


video 12 - Creating a health component

TIP: Ctrl + D = rename
TIP: use class_name to export (casta-ble) type
TIP: use if-null-return to make mandatory @export null-safe ## this is fallback for not-yet-merged: https://github.com/godotengine/godot/pull/68420

ADD HealthComponent (Node) > health_component.gd // emit signal died
ADD VialDropComponent (Node) > vial_drop_component.gd // on signal died
ADD *above components to BasicEnemy
>> use .call_deferred() to avoid checking collisions on the same frame as free-ing the object (calls function on next idle frame)
BONUS modulate color to indicate damage


video 13 - Implementing damage (hitbox and hurtbox component's)

TIP: RIGHT CLICK node inside scene > Save branch as scene
Hitbox (Area2D) -> HitboxComponent, HurtboxComponent // new scenes from sword & enemy old scenes // return CollisionShape2D to old scenes
sword_ability.gd // @onready $HitboxComponent
hitbox_component.gd // var damage = 0
hurtbox_component.gd // @export var health_component, BONUS: hurt signal
sword_ability_controller.gd


video 14 - Creating an Experience Bar UI

ADD ExperienceBarUI (CanvasLayer) . MarginContainer (Preset > full rect | Mouse.Filter: ignore)
. > ProgressBar (Container Sizing; Horizontal: Fill, Vertical: Shrink End | Mouse.Filter: ignore)
.. Show Percentage: off
.. Range: Min Value 0, Max Value 1, Step 0.01, value 0.5
.. Layout . Custom Minimum Size . y = 8 px
experience_bar_ui.gd // @export experience_manager
experience_manager.gd // var current_level, var target_experience // signal experience_updated(current, target)


video 15 - Using Custom Resources for Upgrades

ADD resources.upgrades.sword_rate.tres > ability_upgrade.gd extends Resource {id, name, description} // class_name
. > add .gd into .tres "Script" property
ADD UpgradeManager > upgrade_manager.gd // @export upgrade_pool: Array[AbilityUpgrade], @export experience_manager
experience_manager.gd // signla level_up



video 16 - Upgrade UI Groundwork

ADD UpgradeScreenUI (CanvasLayer) > Process.Mode = Always
	. MarginContainer (Preset > full rect) 
		. HBoxContainer ("CardContainer") > Container Sizing: Horizontal (Shrink center), Vertical (Shrink center)
			. PanelContainer ("AbilityUpgradeCard") > Custom Minimum Size (x 120 y 150) --> save branch as scene
				. VBoxContainer
					. Label ("NameLabel")
					. Label ("DescriptionLabel") > Autowrap Mode: Word
ability_upgrade_card.gd // func set_ability_upgrade(ability_upgrade: AbilityUpgrade)
upgrade_screen_ui.gd // _ready(): game_tree().paused = true
upgrade_manager.gd // @export var upgrade_screen_ui_scene: PackedScene


video 17 - Enabling Upgrade Selection

CONFIGURE Input Map > left_click > Mouse Buttons . Left Mouse Button
ability_upgrade_card.gd // signal gui_input, signal selected
upgrade_screen_ui.gd // bind selected signal
TIP: DEBUG: use add_child() to add instance first (modify it after), to avoid 'Nil' exceptions


video 18 - Making the Upgrade Functional

game_events.gd // signal ability_upgrade_added
upgrade_manager.gd // emit ability_upgrade_added
sword_ability_controller.gd // connect ability_upgrade_added


video 19 - Improving the Scene Tree Structure (refactor Main node, private functions)

REFACTOR Main node 
. > Entities (Ordering . Y Sort Enabled: on) > "entities_layer" group
. > Foreground > "foreground_layer" group
BONUS: add "_" prefix to private methods


video 20 - Adding Player Health

Player scene
. > rename Area2D to PickupArea2D
. > add HealthComponent
. > add Area2D ("HurtboxArea2D") > CollisionShape2D . Circle . radius = 7 px // Layer off Mask 4 (BasicEnemy Layer 4)
. > add Timer ("DamageIntervalTimer") // 0.5, one-shot
player.gd 
. > connect signal body_entered, body_exited
. > BONUS modulate sprite redness to indicate damage


video 21 - Player Health Bar

Player scene
. > add ProgressBar // show percentage: off, min value 0, max value 1, custom minimum x 32 y 6, transform.size (reset button)
	.. transform . pivot offset x 16 y 3 -> x center it, y above it player
	.. Theme Overrides . Styles . Fill: StyleBoxFlat > BG Color: green (PRO TIP: pick hexcode from tileset) // 43e1b3
		... Border Width: 2 2 2 2 // 3f2631
health_component.gd // signal health_changed
player.gd // connect health_changed signal


video 22 - Creating the Victory Screen

ADD CanvasLayer ("VictoryScreenUI")
	. MarginContainer > preset
		. PanelContainer > Container Sizing . H&V : Shrink Center
			. MarginContainer > Constants 8 8 8 8, Layour . Custom Minimum Size . x 180
				. VBoxContainer
					. Label > Text: Victory, Container Sizing . H&V Aligment: Shrink Center, Font Size: 24 px
					. Label > Text: You won, Container Sizing . H&V Aligment: Shrink Center, Font Size: 24 px
					. Button > Text: Restart -> right click and mark as unique name // use %
					. Button > Text: Quit -> right click and mark as unique name // use %
. > Process . Mode = Always
victory_screen_ui.gd // signal pressed
arena_time_manager.gd // spawn VictoryScreenUI


video 23 - Creating the Defeat Screen

RENAME VictoryScreenUI to EndScreenUI
end_screen.gd // set_defeat, set_victory
main.gd // %Player, connect died signal


```

</details>

Personal Notes for **Chapter 3** of the course are below. - **Juicing up: animations, themes, particles, content,...**

<details>

```
Chapter 3. Gameplay and Visual Improvements


video 1. Increase Difficulty Over Time

arena_time_manager.gd > const DIFFICULTY_INTERVAL, signal difficulty_increased
enemy_manager.gd > connect difficulty_increased // increase spawn rate


video 2. Improving the TileMap

TileMap (scene) > Tiles
. > TileSet (tab) > (Setup) select wall tiles > configure wall tiles (Terrains)
. > Tile Set (property) > add physics layer: Layer 1, Mask none > TileSet (tab) (Paint physics layer 0)
TileMap (scene) > Terrain
. > paint arena walls


video 3. Preventing Invalid Spawning

enemy_manager.gd i.e. spawner_utils.gd // raycast check if enemy is inside arena walls
TIP: use "1 << x" to reference value of bit x // bit shift operator


video 4. Creating an Axe Ability

AxeAbilityController > ... > axe_ability_controller.gd
AxeAbility > ... > axe_ability.gd
TIP: using tweens over AnimationPlayer is an alternate way to animate // create_tween()


video 5. Enabling Acquisition of Axe Ability

ADD axe_unlock upgrade resource
BONUS: use shuffle + resize instead of filter, to pick random sub-array
BONUS: add max_quantity to upgrade resources


video 6. Prevent Abilities from Being Chosen Twice

SKIP (handled in previous chaper as BONUS)


video 7. Animating the Player

ADD AnimationPlayer to Player scene > "walk" animation > add key frames for properties: position, rotation, scale
TIP: use "rec" (record) button (top right) to record key frames instead of manually adding them 
TIP: node transforms inherit parent transforms


video 8. Animating the Enemy

ADD AnimationPlayer to BasicEnemy scene > "walk" animation > add key frames for properties: position, rotation, scale


video 9. Animating Enemy Death

ADD DeathComponent to BasicEnemy
TIP: use particle generators as reusable animations


video 10. Adding a Wizard Enemy

ADD VelocityComponent to BasicEnemy // refactor movement logic
ADD WizardEnemy // duplicate BasicEnemy and change: name, health, max_speed, acceleration


video 11. Using a Weighted Table for Enemy Spawning

TIP: class_name scripts do not need to extend anything (not even base node), can be instantiated with .new()


video 12. Animating the Wizard

TIP: functions can be called as key frames


video 13. Animating the Experience Vial Pickups

TIP: tween curves: https://easings.net/en
TIP: backslash \ breaks lines into new lines
TIP: up rotation is -90 deg (default is right at 0 deg)


video 14. Adding a Custom Font

TIP: free pixel fonts: https://nimblebeastscollective.itch.io/nb-pixel-font-bundle
DOUBLE CLICK .ttf file > Antialiasing: None, Hinting: None, Subpixel Positioning: Disabled // pixel art optimizations
PROJECT > PROJECT SETTINGS... > Theme > Custom > theme.tres 
theme.tres > scale 16 px
ArenaTimeUI > Outline Size: 10, Font Outline Color: #3f2631 // TIP: Swatches - save color hex to palette


video 15. Adding Floating Damage Text

FloatingText (node2d)
HurtboxComponent > preload floating_text_scene // QUESTION: WHY NOT USE @export over preload ?
BONUS: add FloatingText to player too (refactor spawning to static function)


bewteen videos 15-16: refactor:

> refactored packages and installed format_on_save addon (addons are git ignored)


video 16. Implementing a Flash on Enemy Hit (hit flash shader)

HitFlashComponent scene
ShaderMaterial resource
TIP: resource is a singleton (one instance is shared), excpet when Resource . Local to Scene : On
TIP: QUESTION: shaders vs particle node ?


video 17. Adding Ability Damage Upgrades

TIP: ctrl + D to duplicate file


video 18. Introduction to UI Theming

theme.tres > style PanelContainer > panel: StyleBoxTexture (ui.png)


video 19. Finalizing Upgrade Card Theme

theme.tres > (custom) style AlternatePanelContainer > Base Type: PanelContainer > panel: StyleBoxTexture (ui.png)
[Theme . Type Variation -> can now be used on PanelContainer node's]


video 20. Animating the Upgrade Card

// await keyword is used for async stuff


video 21. Improving the Upgrade Selection Screen

// modulate property alpha channel is neat


video 22. Applying a Style to the Experience Bar

TIP: use back and front arrow in Inspector


video 23. Animating Victory and Defeat Screens

TIP: set pivot_offset to size / 2 to center the scale and rotation transformations


video 24. Applying Styles to the Buttons

theme.tres


video 25. Creating a Player Move Speed Upgrade

TIP: drag & drop node from scene editor into .gd editor (hold CTRL before release) to create a @onready var line


video 26. Adding a Vignette (shader)

TIP: godotshaders.com


```

</details>

Personal Notes for **Chapter 4** are TBA.

Personal Notes for **Chapter 5** are TBA.

Personal Notes for **Chapter 6** are TBA.

Personal Notes for **Personal Extensions** are TBA.


Godot Engine QOL improvements wishlist is below.

<details>

```
- Member variable hightlight: https://github.com/godotengine/godot/pull/74393 (TODO: refactor the project to not use 'self' as a workaround for this.)
- Mandatory export flag: https://github.com/godotengine/godot/pull/68420 (TODO: refactor this project to use this feature.)
```

</details>



## Documentation

Code style conventions:
- Use statically typed variables and functions
- Use `self` keyword to force syntax highlight on member variables and when calling member functions
- Use "Format on Save" addon from AssetLib with: https://github.com/Scony/godot-gdscript-toolkit
- Do not use multi-line lambda's, as it is not supported in the mentioned addon (workaround: use `;`)
- Mostly follow: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html

*Code Documentation Comming Soon*

