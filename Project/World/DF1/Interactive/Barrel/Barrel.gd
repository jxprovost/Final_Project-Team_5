extends StaticBody2D

signal barrel_destroyed

var destroyed := false


func _on_Hitbox_area_entered(_area):
	destroy()


func destroy():
	if not destroyed:
		destroyed = true
		$Sprite.frame = 1
		$DestroyedParticles.emitting = true
		$DestroyedTopParticle.emitting = true
		$BreakSoundPlayer.play()
		$Timer.start()


func _on_Timer_timeout():
	$AnimationPlayer.play("FadeAway")


func _on_AnimationPlayer_animation_finished(_anim_name):
	emit_signal("barrel_destroyed")
	queue_free()
