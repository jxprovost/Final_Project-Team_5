extends Node2D


func _process(_delta):
	if Input.is_action_pressed("reset"):
		reset_level()
	elif Input.is_action_pressed("quit"):
		quit_level()


func reset_level():
	var _reset = get_tree().change_scene("res://World/World.tscn")


func quit_level():
	var _quit = get_tree().change_scene("res://World/Menu.tscn")
