extends KinematicBody2D

signal skull_defeated

enum State {
	INACTIVE,
	CHASE,
	LAUNCH,
	}

const _ACCELERATION := 300
const _MAX_SPEED := 50
const _FRICTION := 200
const _KNOCKBACK_FORCE := 110

const EnemyDeathEffect := preload("res://Effects/EnemyDeathEffect.tscn")

var _velocity := Vector2.ZERO
var _knockback := Vector2.ZERO

var _state = State.IDLE

func _physics_process(delta):
	_knockback = _knockback.move_toward(Vector2.ZERO, _FRICTION * delta)
	_knockback = move_and_slide(_knockback)
	
	match _state:
			
		State.CHASE:
			var player = $PlayerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				_velocity = _velocity.move_toward(direction * _MAX_SPEED, _ACCELERATION * delta)
			else:
				_state = State.INACTIVE
				
			$AnimatedSprite.flip_h = _velocity.x > 0
			
			var player2 = $DistancingZone.player
			if player2 != null:
				_state = State.LAUNCH

		State.LAUNCH:
			_velocity = 0


#func seek_player():
#	if _playerDetectionZone.can_see_player():
#		_state = State.CHASE


func _on_Hurtbox_area_entered(hitbox):
	_stats.health -= hitbox.damage
	_knockback = hitbox.knockback_vector * _KNOCKBACK_FORCE
	_hurtbox.create_hit_effect(hitbox)


func _on_Stats_no_health():
	emit_signal("skull_defeated")
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	
