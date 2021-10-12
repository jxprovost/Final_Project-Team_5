extends KinematicBody2D

const _ACCELERATION = 10
const _FRICTION = 400
const _MAX_SPEED = 50

var _velocity = Vector2.ZERO


func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		_velocity += input_vector * _ACCELERATION * delta
		_velocity = _velocity.clamped(_MAX_SPEED * delta)
	else:
		_velocity = _velocity.move_toward(Vector2.ZERO, _FRICTION * delta)
	
	print(_velocity)
	return move_and_collide(_velocity)
