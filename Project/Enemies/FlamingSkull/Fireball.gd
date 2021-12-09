extends KinematicBody2D

enum State {
	INACTIVE,
	FORMING,
	PREPARING,
	LAUNCH
	}
	
const EnemyDeathEffect := preload("res://Effects/EnemyDeathEffect.tscn")

var _state = State.INACTIVE
var _fireball := "active"
var _form := false
var _prep := false
var _launch := false
var _direction := 0
var _velocity := Vector2.ZERO


func _ready():
	$AnimatedSprite.play("default")
	$Timer.start()


func _process(delta):
	if $Timer.time_left >= 4:
		_state = State.FORMING
	elif $Timer.time_left >= 1:
		_state = State.PREPARING
	elif $Timer.time_left < 1:
		_state = State.LAUNCH
		
	match _state:
		State.FORMING: 
			if _form == false:
				$AnimationPlayer.play("FormingProjectile")
				_form = true

		State.PREPARING:
			if _prep == false:
				$AnimationPlayer.play("PrepareLaunch")
				_prep = true
		
		State.LAUNCH:
			if $Timer.time_left != 0:
				var player = $PlayerDetectionZone.player
				if player != null:
					var direction : Vector2 = (player.global_position - global_position).normalized()
					_velocity = _velocity.move_toward(direction * 200, 500 * delta)
				else:
					_state = State.INACTIVE
				
	_velocity = move_and_slide(_velocity)


func _on_Timer_timeout():
	_trigger_explosion()


func _on_Hitbox_area_entered(_area):
	_trigger_explosion()


func _on_Fireball_tree_exited():
	queue_free()


func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	enemyDeathEffect.scale.x = 100
	enemyDeathEffect.scale.y = 100
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	enemyDeathEffect.position.y += 600


func _trigger_explosion():
	$Hitbox.scale.x = 50
	$Hitbox.scale.y = 50
	$Stats.health -= 1
