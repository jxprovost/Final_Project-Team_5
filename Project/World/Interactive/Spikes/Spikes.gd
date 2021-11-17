extends Node2D



func _on_TrapArea2D_area_entered(_area):
	if $CooldownTimer.time_left <= 0:
		$AnimationPlayer.play("Popup")


func _on_TrapArea2D_area_exited(_area):
	$CooldownTimer.start()


func _on_CooldownTimer_timeout():
	$AnimationPlayer.play("Down")
