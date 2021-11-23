extends KinematicBody2D

enum State {
	MOVE,
	ROLL,
	ATTACK,
}

const _ACCELERATION := 400
const _FRICTION := 400
const _MAX_SPEED := 100

var stats = PlayerStats
var _state = State.MOVE
var _knockback_vector := Vector2.DOWN
var _velocity := Vector2.ZERO
var footsteps_playing = false

onready var _swordHitbox := $HitboxPivot/SwordHitbox
onready var _animationPlayer := $AnimationPlayer
onready var _animationTree := $AnimationTree
onready var _hurtbox := $Hurtbox
onready var _animationState = _animationTree.get("parameters/playback")


func _ready():
	stats.set_health(stats.max_health)
	stats.connect("no_health", self, "queue_free")
	_animationTree.active = true
	_swordHitbox.knockback_vector = _knockback_vector


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
		if footsteps_playing == false:
			$Footsteps.playing = true
			footsteps_playing = true
		_swordHitbox.knockback_vector = input_vector
		_animationTree.set("parameters/Idle/blend_position", input_vector)
		_animationTree.set("parameters/Run/blend_position", input_vector)
		_animationTree.set("parameters/Attack/blend_position", input_vector)
		_animationState.travel("Run")
		_velocity = _velocity.move_toward(input_vector * _MAX_SPEED, _ACCELERATION * delta)
	else:
		if footsteps_playing == true:
			$Footsteps.playing = false
			footsteps_playing = false
		_animationState.travel("Idle")
		_velocity = _velocity.move_toward(Vector2.ZERO, _FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("attack"):
		$SwordSwoosh.play()
		_state = State.ATTACK


func move():
	_velocity = move_and_slide(_velocity)	


func attack_state(_delta):
	_velocity = Vector2.ZERO
	_animationState.travel("Attack")


func attack_animation_finished():
	_state = State.MOVE


func _on_Hurtbox_area_entered(area):
	$Hit.play()
	stats.health -= 1
	_hurtbox.start_invincibility(1)
	_hurtbox.create_hit_effect(area)
