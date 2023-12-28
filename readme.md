## Personal Project To Learn Basics of Godot 4

Following Udemy course: **Create a Complete 2D Survivors Style Game in Godot 4**

Personal Notes for **Chapter 1** of the course are below.


```
LEARN GODOT 2024 (Godot Stable 4.2.1)

LINK TO VIDEO MATERIAL: https://www.udemy.com/course/create-a-complete-2d-arena-survival-roguelike-game-in-godot-4/

TEXT MATERIAL:


Chapter 1. Starting Out


TLDR CONFIGURATION:
- compatibility renderer
- 2d profile with unchecked 3D editor
- panels on left side; top:[FileSystem,History][Scene,Import], bot:[][Inspector,Node]
- disable folding (on)
- default texture filter: nearest
- input map: arrow keys and w,a,s,d
- viewport: 640 x 360, stretch mode: viewport, window override: 1920 x 1080



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


Personal Notes for **Chapter 2** of the course are below.


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


video 4 - TBA



```
