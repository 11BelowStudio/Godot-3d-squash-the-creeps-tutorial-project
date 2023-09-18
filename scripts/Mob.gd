class_name Mob
extends CharacterBody3D
## Class that represents enemies.
##
## They move somewhat towards the player at a random speed, and can be squashed


## This signal is emitted when the player jumped on the mob.
signal squashed


## Minimum speed of the mob in meters per second.
@export var min_speed: int = 10


## Maximum speed of the mob in meters per second.
@export var max_speed: int = 18


## Similarly to the player,
## we move the mob every frame by calling
## CharacterBody3D.move_and_slide().
## This time, we don't update the velocity every frame;
## we want the monster to move at a constant speed and
## leave the screen, even if it were to hit an obstacle.
func _physics_process(_delta: float) -> void:
	move_and_slide();
	pass;


## This function will be called from the Main scene.
## This will initialize the direction and velocity of the mob.
func initialize(start_position: Vector3, player_position: Vector3) -> void:
	# make sure player_position.y matches start_position.y, avoids misalignment
	player_position.y = start_position.y;
	
	# We position the mob by placing it at start_position
	# and rotate it towards player_position, so it looks at the player.
	look_at_from_position(start_position, player_position, Vector3.UP);
	# Rotate this mob randomly within range of -90 and +90 degrees,
	# so that it doesn't move directly towards the player.
	rotate_y(randf_range(-PI / 4, PI / 4));
	
	# now we need a random speed, within the min/max speed range
	# we then use it to multiply our velocity.
	# then, we rotate that velocity towards the player.
	
	# step 1: random speed (int) using randi_range
	var rand_speed: int = randi_range(min_speed, max_speed);
	# step 2: calculate a forward velocity based on that speed
	velocity = Vector3.FORWARD * rand_speed;
	# step 3: rotate velocity vector to match mob direction vector
	# by using the mob's rotation.y value
	# so the mob moves in the direction it's looking in
	velocity = velocity.rotated(Vector3.UP, rotation.y);
	pass;


## Connected the 'screen_exited()' signal from our VisibleOnScreenNotifier3D
## to the Mob script, generating this function.
## This will be called whenever the mob exits the visible area.
## This function calls the `queue_free()` function - destroying this object.
func _on_visibility_notifier_screen_exited() -> void:
	queue_free(); # this mob instance is gonna get destroyed
	pass;


## Will be called when squashed by player.
## Emits the 'squashed' signal, and destroys this mob instance.
func squash() -> void:
	squashed.emit();
	queue_free();
	pass;
