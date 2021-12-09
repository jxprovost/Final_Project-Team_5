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

	if $Timer.time_left >= 6:
		_state = State.FORMING
	elif $Timer.time_left >= 3:
		_state = State.PREPARING
	elif $Timer.time_left < 3:
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
					var direction = (player.global_position - global_position).normalized()
					_velocity = _velocity.move_toward(direction * 1000, 500 * delta)
				else:
					_state = State.INACTIVE
				
				_velocity = move_and_slide(_velocity)
				
			
			
			
func _on_Timer_timeout():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	enemyDeathEffect.scale.x = 200
	enemyDeathEffect.scale.y = 200
	$Hitbox.scale.x = 20
	$Hitbox.scale.y = 20
	
	$Position2D.add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
