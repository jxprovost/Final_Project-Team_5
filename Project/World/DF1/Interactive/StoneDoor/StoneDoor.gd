extends StaticBody2D


func open_door():
	$AnimationPlayer.play("Open")
	$AudioStreamPlayer2D.play()
