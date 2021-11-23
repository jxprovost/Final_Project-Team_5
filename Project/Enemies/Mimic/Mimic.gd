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
const _MAX_SPEED := 20
const _FRICTION := 200
const _KNOCKBACK_FORCE := 100

var _mimic_awareness := "sleeping"
var _velocity := Vector2.ZERO
var _knockback := Vector2.ZERO
var _state = State.INACTIVE


func _ready():
	$AnimatedSprite.play("chest")


func _physics_process(delta):
	_knockback = _knockback.move_toward(Vector2.ZERO, _FRICTION * delta)
	_knockback = move_and_slide(_knockback)
	
	if _mimic_awareness != "sleeping":
		match _state:
			State.ACTIVE: 
				$PlayerDetectionZone/CollisionShape2D.scale.x = 2
				$PlayerDetectionZone/CollisionShape2D.scale.y = 2
				
				if $AnimatedSprite.animation == "chest":
					$AnimatedSprite.play("awaken")
				else:
					$AnimatedSprite.animation = "blink"
					
				var player = $PlayerDetectionZone.player
				if player != null:
					var direction = (player.global_position - global_position).normalized()
					_velocity = _velocity.move_toward(direction * _MAX_SPEED, _ACCELERATION * delta)
				else:
					_state = State.INACTIVE

				$AnimatedSprite.flip_h = _velocity.x > 0
				
			State.ATTACK:
				$Hurtbox/CollisionShape2D.scale.x = 2
				$Hurtbox/CollisionShape2D.scale.y = 2
				$AnimatedSprite.animation = "attack" 
				if $AnimatedSprite.frame == 9:
					_state = State.ACTIVE
					$Hurtbox/CollisionShape2D.scale.x = 1
					$Hurtbox/CollisionShape2D.scale.y = 1
					
			State.HIT:
				$AnimatedSprite.animation = "takeHit"
				if $AnimatedSprite.animation == "takeHit" and $AnimatedSprite.frame == 12:
					_state = State.ACTIVE
				
			State.INACTIVE:
				if $AnimatedSprite.animation != "chest":
					$AnimatedSprite.animation = "hide"
					
				if $AnimatedSprite.animation == "hide" and $AnimatedSprite.frame == 8:
					$AnimatedSprite.animation = "chest"
					
				$PlayerDetectionZone/CollisionShape2D.scale.x = 0.75
				$PlayerDetectionZone/CollisionShape2D.scale.y = 0.75
				_velocity = _velocity.move_toward(Vector2.ZERO, _FRICTION * delta)
				seek_player()
		_velocity = move_and_slide(_velocity)
		
		
func seek_player(): 
	if $PlayerDetectionZone.can_see_player():
		_state = State.ACTIVE
		
		
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
