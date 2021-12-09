extends KinematicBody2D

signal mimic_defeated

enum State {
	INACTIVE,
	ACTIVE,
	SEEK,
	ATTACK,
	HIT,
	}

const EnemyDeathEffect := preload("res://Effects/EnemyDeathEffect.tscn")

const _ACCELERATION := 100
const _MAX_SPEED := 30
const _FRICTION := 500
const _KNOCKBACK_FORCE := 20

var _mimic_awareness := "sleeping"
var _velocity := Vector2.ZERO
var _knockback := Vector2.ZERO
var _state = State.INACTIVE
var _size = 1


func _ready():
	$AnimatedSprite.play("chest")
	$Hitbox/CollisionShape2D.disabled = true
	scale.x = 1
	scale.y = 1
	
	
func _physics_process(delta):
	_knockback = _knockback.move_toward(Vector2.ZERO, _FRICTION * delta)
	_knockback = move_and_slide(_knockback)
	
	if _mimic_awareness != "sleeping":
		match _state:
			State.ACTIVE: 
				
				if (_size == 1):
					$SizeChange.play("SizeIncrease")
					_size = 2
					
				$PlayerDetectionZone/CollisionShape2D.scale.x = 2
				$PlayerDetectionZone/CollisionShape2D.scale.y = 2
				if $AnimatedSprite.animation == "chest":
					$AnimatedSprite.play("awaken")
					$Hitbox.monitoring = true
					
				else:
					$AnimatedSprite.animation = "blink"
					$Hitbox/CollisionShape2D.disabled = false
					
				var player = $PlayerDetectionZone.player
				var player2 = $AttackArea.player
				if player != null:
					var direction = (player.global_position - global_position).normalized()
					_velocity = _velocity.move_toward(direction * _MAX_SPEED, _ACCELERATION * delta)
				else:
					_state = State.INACTIVE
					
				if player2 != null:
					_state = State.ATTACK
					
				$AnimatedSprite.flip_h = _velocity.x > 0
				
			State.ATTACK:
				var player = $PlayerDetectionZone.player
				var player2 = $AttackArea.player
				if player != null and player2 != null:
					var direction = (player.global_position - global_position).normalized()
					_velocity = _velocity.move_toward(direction * _MAX_SPEED, _ACCELERATION * delta * 2)
							
				if $AnimatedSprite.animation != "attack":
					$AnimatedSprite.animation = "attack" 
					
				if $AnimatedSprite.frame == 9:
					_state = State.ACTIVE
# warning-ignore:return_value_discarded
				move_and_slide(_velocity)  
					
			State.HIT:
				$AnimatedSprite.animation = "takeHit"
				if $AnimatedSprite.animation == "takeHit" and $AnimatedSprite.frame == 12:
					_state = State.ACTIVE
				
			State.INACTIVE:
				$Hitbox/CollisionShape2D.disabled = true
				_velocity = Vector2.ZERO
				if (_size == 2):
					$SizeChange.play("SizeDecrease")
					_size = 1
					
				if $AnimatedSprite.animation != "chest":
					$AnimatedSprite.animation = "hide"
					
				if $AnimatedSprite.animation == "hide" and $AnimatedSprite.frame == 8:
					$AnimatedSprite.animation = "chest"
					
				$PlayerDetectionZone/CollisionShape2D.scale.x = 0.75
				$PlayerDetectionZone/CollisionShape2D.scale.y = 0.75

		_velocity = move_and_slide(_velocity)
		
		
func _on_Hurtbox_area_entered(hitbox):
	$Stats.health -= hitbox.damage
	_knockback = hitbox.knockback_vector * _KNOCKBACK_FORCE
	$Hurtbox.create_hit_effect(hitbox)
	if _mimic_awareness == "sleeping":
		$PlayerDetectionZone/CollisionShape2D.scale.x = 2
		$PlayerDetectionZone/CollisionShape2D.scale.y = 2
		_mimic_awareness = "pretending"
	else: 
		_state = State.HIT
		
		
func _on_Stats_no_health(): 
	emit_signal("mimic_defeated")
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	
	
func _on_AttackArea_body_entered(_body):
	_state = State.ATTACK


func _on_Timer_timeout():
	$AttackArea/CollisionShape2D.disabled = true
	$Timer2.start()


func _on_Timer2_timeout():
	$AttackArea/CollisionShape2D.disabled = false
