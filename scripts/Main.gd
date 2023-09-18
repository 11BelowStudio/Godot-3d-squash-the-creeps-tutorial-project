class_name Main
extends Node3D
## This class is used for the spawn mechanism.


## The scene containing the mobs.
@export var mob_scene: PackedScene


## Called when the node enters the scene tree for the first time.
## Hides the retry overlay at the start of the game.
func _ready() -> void:
	$UserInterface/Retry.hide();
	pass;


## Called every frame. 'delta' is the elapsed time since the previous frame.
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
	
	# and then add the mob to the Main scene
	add_child(mob);
	
	# finally, we connect the mob to the score label,
	# to update our score whenever a mob gets squashed
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind());
	pass;


## Called by the player's "hit" signal
## (emitted by player once the player has been hit (and dies))
## Stops the mob timer, and generally starts the game over logic.
func _on_player_hit() -> void:
	# no more mobs will spawn
	$MobTimer.stop();
	# show the retry overlay
	$UserInterface/Retry.show();
	pass;


## This callback function gets invoked whenever an 'unhandled input' happens.
## In this case, if Enter ("ui_accept") is pressed
## whilst the retry overlay is visible, the current scene is reloaded,
## allowing the game to restart.
func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_accept") && $UserInterface/Retry.visible):
		# reload (restart) current scene
		get_tree().reload_current_scene();
	pass;
