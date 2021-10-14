extends KinematicBody2D

enum State {
	MOVE,
	ROLL,
	ATTACK,
}

const _ACCELERATION := 400
const _FRICTION := 400
const _MAX_SPEED := 100


var _state = State.MOVE
var _knockback_vector := Vector2.DOWN
var _velocity := Vector2.ZERO
var _stats = PlayerStats

onready var swordHitbox := $HitboxPivot/SwordHitbox
onready var animationPlayer := $AnimationPlayer
onready var animationTree := $AnimationTree
onready var animationState = animationTree.get("parameters/playback")


func _ready():
	animationTree.active = true
	swordHitbox.knockback_vector = _knockback_vector


func _physics_process(delta):
	match _state:
		State.MOVE:
			move_state(delta)
			
		State.ATTACK:
			attack_state(delta)


func move_state(delta):
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Run")
		_velocity = _velocity.move_toward(input_vector * _MAX_SPEED, _ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		_velocity = _velocity.move_toward(Vector2.ZERO, _FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("attack"):
		_state = State.ATTACK


func move():
	_velocity = move_and_slide(_velocity)	


func attack_state(_delta):
	_velocity = Vector2.ZERO
	animationState.travel("Attack")


func attack_animation_finished():
	_state = State.MOVE
