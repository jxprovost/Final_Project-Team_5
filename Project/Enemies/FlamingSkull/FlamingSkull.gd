extends KinematicBody2D

signal skull_defeated

enum State {
	INACTIVE,
	CHASE,
	LAUNCH,
}

const _ACCELERATION := 20
const _MAX_SPEED := 60
const _FRICTION := 175
const _KNOCKBACK_FORCE := 200

const EnemyDeathEffect := preload("res://Effects/EnemyDeathEffect.tscn")

var _velocity := Vector2.ZERO
var _velocity_direct := Vector2.ZERO
var _knockback := Vector2.ZERO
var distancing := false
var _fire := false
var fireball : KinematicBody2D = null
var _state = State.INACTIVE


func _ready():
	$AnimatedSprite.play("default")


func _physics_process(delta):
	_knockback = _knockback.move_toward(Vector2.ZERO, _FRICTION * delta)
	_knockback = move_and_slide(_knockback)
	var play = $PlayerDetectionZone.player
	if play != null:
		var direction : Vector2 = (play.global_position - global_position).normalized()
		_velocity_direct = _velocity_direct.move_toward(direction * _MAX_SPEED, _ACCELERATION * delta)
			
	$AnimatedSprite.flip_h = _velocity_direct.x > 0
	if $AnimatedSprite.flip_h == true:
		$YSort/CPUParticles2D.rotation_degrees = -160
		$YSort/CPUParticles2D2.rotation_degrees = -160
		$YSort/CPUParticles2D3.rotation_degrees = -150
		$YSort/CPUParticles2D4.rotation_degrees = -150
		$YSort/CPUParticles2D5.rotation_degrees = -150
		$YSort/CPUParticles2D6.rotation_degrees = -160
	else:
		$YSort/CPUParticles2D.rotation_degrees = -20
		$YSort/CPUParticles2D2.rotation_degrees = -20
		$YSort/CPUParticles2D3.rotation_degrees = -30
		$YSort/CPUParticles2D4.rotation_degrees = -30
		$YSort/CPUParticles2D5.rotation_degrees = -30
		$YSort/CPUParticles2D6.rotation_degrees = -20
	
	
	match _state:
		State.INACTIVE:
			_velocity = Vector2.ZERO
			seek_player()
			
		State.CHASE:
			$AnimatedSprite.play("default")
			var player : KinematicBody2D = $PlayerDetectionZone.player
			var player2 : KinematicBody2D = $DistancingZone.player
			if player != null and player2 == null:
				var direction : Vector2 = (player.global_position - global_position).normalized()
				_velocity = _velocity.move_toward(direction * _MAX_SPEED, _ACCELERATION * delta)
				
			if player == null and player2 == null:
				_state = State.INACTIVE
				
			if player != null and player2 != null:
				_state = State.LAUNCH
				
			if $PlayerDetectionZone.player != null:
				var direction : Vector2 = (player.global_position - global_position).normalized()
				_velocity_direct = _velocity_direct.move_toward(direction * _MAX_SPEED, _ACCELERATION * delta)


		State.LAUNCH:
			var player : KinematicBody2D = $PlayerDetectionZone.player
			var player2 : KinematicBody2D = $DistancingZone.player
			if $AnimatedSprite.frame == 58 and _fire == false and player == null and player2 == null:
				_state = State.INACTIVE
			elif $AnimatedSprite.frame == 58 and _fire == false and player != null and player2 == null:
				_state = State.CHASE
			elif $AnimatedSprite.frame == 58 and _fire == false and player != null and player2 != null:
				_state = State.LAUNCH
				
			$AnimatedSprite.play("launchingProjectile")
			_velocity = Vector2.ZERO
			if $AnimatedSprite.frame == 5:
				if _fire == false:
					fireball = preload("res://Enemies/FlamingSkull/Fireball.tscn").instance()
					$Position2D.add_child(fireball)
					_fire = true
					
			if $AnimatedSprite.frame == 58:
				_fire = false
				_state = State.CHASE
# warning-ignore:return_value_discarded
	move_and_slide(_velocity)


func seek_player():
	if $PlayerDetectionZone.can_see_player():
		_state = State.CHASE


func _on_Hurtbox_area_entered(hitbox):
	$Stats.health -= hitbox.damage
	_knockback = hitbox.knockback_vector * _KNOCKBACK_FORCE
	$Hurtbox.create_hit_effect(hitbox)


func _on_Stats_no_health():
	emit_signal("skull_defeated")
	queue_free()
	var enemyDeathEffect : AnimatedSprite = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
