class_name ScoreLabel
extends Label
## Keeps track of + displays the score
##
## Probably should keep the functionality and display separate,
## but this is a tutorial project after all.


## The current score (should increment by 1 for every squashed mob)
var score: int = 0;

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_label();
	pass;


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass;



## Called whenever the 'squashed' signal gets emitted by a Mob.
## Increments score by 1 (and updates score label)
func _on_mob_squashed() -> void:
	score += 1;
	_update_label();
	pass;


## Updates the label text to match the current score
func _update_label() -> void:
	# using gdscript string formatting to produce the score text
	text = "Score: %s" % score;
	pass;
