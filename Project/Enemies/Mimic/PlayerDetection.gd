extends Area2D

var player = null


func _on_PlayerDetection_body_entered(body):
	player = body


func _on_PlayerDetection_body_exited(_body):
	player = null
	
func mimic_see_player():
	return player != null