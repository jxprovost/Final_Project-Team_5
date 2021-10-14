extends KinematicBody2D

enum {
	MOVE,
	ROLL,
	ATTACK,
}

const _ACCELERATION = 400
const _FRICTION = 400
const _MAX_SPEED = 100

var _state = MOVE
var _velocity = Vector2.ZERO

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")


func _ready():
	animation_tree.active = true


func _physics_process(delta):
	match _state:
		MOVE:
			move_state(delta)
			
		ROLL:
			pass
			
		ATTACK:
			attack_state(delta)


func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		animation_state.travel("Run")
		_velocity = _velocity.move_toward(input_vector * _MAX_SPEED, _ACCELERATION * delta)
	else:
		animation_state.travel("Idle")
		_velocity = _velocity.move_toward(Vector2.ZERO, _FRICTION * delta)
	
	_velocity = move_and_slide(_velocity)
	
	if Input.is_action_just_pressed("attack"):
		_state = ATTACK


func attack_state(_delta):
	_velocity = Vector2.ZERO
	animation_state.travel("Attack")


func attack_animation_finished():
	_state = MOVE
