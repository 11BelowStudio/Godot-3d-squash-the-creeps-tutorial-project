class_name Main
extends Node3D
## This class is used for the spawn mechanism.


## The scene containing the mobs.
@export var mob_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass; # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass;


## Invoked by the MobTimer whenever it times out (every 0.5s)
## This spawns in a new mob, and initializes it.
func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var mob: Mob = mob_scene.instantiate();
	
	# Choose a random location on the SpawnPath.
	# We store the reference to the SpawnLocation node.
	# (nb: this implementation finds the node + its child node
	# every time this is called)
	var mob_spawn_location: PathFollow3D = get_node("SpawnPath/SpawnLocation");
	# and then we give it a random offset (position on the path)
	mob_spawn_location.progress_ratio = randf();
	
	# obtain player position
	var player_position: Vector3 = $Player.position;
	
	# then we initialize the mob
	mob.initialize(mob_spawn_location.position, player_position);
	
	# and finally add the mob to the Main scene
	add_child(mob);
	pass;


## Called by the player's "hit" signal
## (emitted by player once the player has been hit (and dies))
## Stops the mob timer, and generally starts the game over logic.
func _on_player_hit() -> void:
	$MobTimer.stop();
	pass;

