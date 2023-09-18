# Everything after "#" is a comment.
# A file is a class!


# (optional) class definition:
class_name Player

# inheritance
extends CharacterBody3D
## Class for the player object in this game (nb: doc line 1 = brief desc)
##
## (detailed desc after brief + newline) - doesn't show in inspector
## This class moves the player object
## based on current inputs from Input object
## (sets velocity and then calls the physics within
## the _physics_process(delta) function).
## Child of the CharacterBody3D class.
##
## In C#, needs 'using Godot;' and must be declared as
## 'public partial class Player: CharacterBody3D { /* ... */ }'
## 
## This doc comment is very overkill
## - but just trying to force myself to get used
## to how GDscript works and doc comments within it.
## Also anything with name starting with _ is private (otherwise public)
##
## @Tutorial(the project tutorial): https://docs.godotengine.org/en/stable/getting_started/first_3d_game/03.player_movement_code.html
## @Tutorial(GDscript): https://docs.godotengine.org/en/latest/tutorials/scripting/gdscript/index.html


# double-hashtag comments = gdscript documentation comments.
# need to go before functions/properties to document them.
# but needs to go under the extends at the top of the file.

## Speed in metres per second.
## float (basically same as double in gdscript).
##  @export (or c# [Export] - works with properties) -> Editable via inspector.
@export var speed: float = 14;

## The downward acceleration when in the air, in meters per second squared.
## Editable via inspector due to @export.
## float (basically same as double in gdscript)
@export var fall_acceleration: float = 75;

## The character's target velocity.
## Declared as a property because we want to reuse it between frames.
## Not editable via inspector due to no @export on it.
var target_velocity: Vector3 = Vector3.ZERO;

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass;

## This is Godot's version of the Update method.
func _process(_delta: float) -> void:
	pass;

## This is Godot's version of the FixedUpdate method.
func _physics_process(delta: float) -> void:
	# we start by calculating input direction vector
	# from global Input object in this function
	
	# We create a local variable to store the input direction.
	var direction: Vector3 = Vector3.ZERO;
	
	# We check for each move input and update the direction accordingly
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1;
	if Input.is_action_pressed("move_back"):
		direction.z += 1;
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1;
	
	# if the direction isn't zero (there's an input)
	if direction != Vector3.ZERO:
		# we normalize it
		direction = direction.normalized();
		# then we make the character look in that direction
		$Pivot.look_at(position + direction, Vector3.UP);
	
	# Now we update velocity.
	# need to calculate ground vel and fall vel seperately.
	
	# Ground Velocity
	target_velocity.x = direction.x * speed;
	target_velocity.z = direction.z * speed;
	
	# Vertical Velocity
	# CharacterBody3D.is_on_floor()
	# returns true if body collided with floor this frame.
	if not is_on_floor():
		# If in air, fall towards floor.
		# Literally gravity.
		target_velocity.y = target_velocity.y - (fall_acceleration * delta);
	
	# Moving the Character
	# set character velocity to new target velocity
	velocity = target_velocity;
	# then we call CharacterBody3D.move_and_slide()
	# to smoothly move it with that velocity.
	move_and_slide();
	pass;
