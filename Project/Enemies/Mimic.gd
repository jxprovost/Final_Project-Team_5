extends KinematicBody2D

enum State {
	INACTIVE,
	ACTIVE,
	ATTACK
	}
	
	

func _ready():
	$AnimatedSprite.animation = "chest"
	pass # Replace with function body.

func _physics_process(_delta):
	pass
	# mimic activates once it has been interacted with 
