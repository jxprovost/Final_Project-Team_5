extends KinematicBody2D

enum State {
	IDLE,
	WANDER,
	CHASE,
}

const _ACCELERATION := 300
const _MAX_SPEED := 50
const _FRICTION := 200
const _KNOCKBACK_FORCE := 110

const EnemyDeathEffect := preload("res://Effects/EnemyDeathEffect.tscn")

var _velocity := Vector2.ZERO
var _knockback := Vector2.ZERO

var _state = State.IDLE

onready var _sprite := $AnimatedSprite
onready var _stats := $Stats
onready var _playerDetectionZone := $PlayerDetectionZone
onready var _hurtbox := $Hurtbox


func _ready():
	print(_stats.max_health)
	print(_stats.health)


func _physics_process(delta):
	_knockback = _knockback.move_toward(Vector2.ZERO, _FRICTION * delta)
	_knockback = move_and_slide(_knockback)
	
	match _state:
		State.IDLE:
			_velocity = _velocity.move_toward(Vector2.ZERO, _FRICTION * delta)
			seek_player()
		
		State.WANDER:
			pass
		
		State.CHASE:
			var player = _playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				_velocity = _velocity.move_toward(direction * _MAX_SPEED, _ACCELERATION * delta)
			else:
				_state = State.IDLE
			_sprite.flip_h = _velocity.x < 0
	
	_velocity = move_and_slide(_velocity)


func seek_player():
	if _playerDetectionZone.can_see_player():
		_state = State.CHASE


func _on_Hurtbox_area_entered(hitbox):
	_stats.health -= hitbox.damage
	_knockback = hitbox.knockback_vector * _KNOCKBACK_FORCE
	_hurtbox.create_hit_effect(hitbox)


func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
