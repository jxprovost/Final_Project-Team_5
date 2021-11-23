extends StaticBody2D

var extended := false

func _ready():
	$CooldownTime.start()
	

func _on_CooldownTime_timeout():
	if extended == false:
		extended = true
		$AnimationPlayer.play("Extend")
	else:
		extended = false
		$AnimationPlayer.play("Unextend")
