extends StaticBody2D

var _extended := false

func _ready():
	$CooldownTime.start()
	

func _on_CooldownTime_timeout():
	if _extended == false:
		_extended = true
		$AnimationPlayer.play("Extend")
	else:
		_extended = false
		$AnimationPlayer.play("Unextend")
