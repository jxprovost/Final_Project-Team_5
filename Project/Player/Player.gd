extends KinematicBody2D

const _ACCELERATION = 400
const _FRICTION = 400
const _MAX_SPEED = 100

var _velocity = Vector2.ZERO

onready var animation_player = $AnimationPlayer


func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		if input_vector.x > 0:
			animation_player.play("RunRight")
		elif input_vector.x < 0:
			animation_player.play("RunLeft")
		elif input_vector.y > 0:
			animation_player.play("RunDown")
		elif input_vector.y < 0:
			animation_player.play("RunUp")
		_velocity = _velocity.move_toward(input_vector * _MAX_SPEED, _ACCELERATION * delta)
	else:
		animation_player.play("Idle")
		_velocity = _velocity.move_toward(Vector2.ZERO, _FRICTION * delta)
	
	print(_velocity)
	_velocity = move_and_slide(_velocity)
