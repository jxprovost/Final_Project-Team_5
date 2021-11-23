extends Area2D

var player : KinematicBody2D = null

func _on_AttackZone_body_entered(body):
	player = body


func _on_AttackZone_body_exited(_body):
	player = null


func mimic_can_attack_player():
	return player != null
