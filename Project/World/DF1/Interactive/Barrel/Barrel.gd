extends StaticBody2D

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
