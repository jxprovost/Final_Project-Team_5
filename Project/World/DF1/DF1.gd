extends Node2D

var mimic_defeated := false
var mimic_quest_completed := false

func _process(_delta):
	if Input.is_action_pressed("reset"):
		reset_level()
		
	elif Input.is_action_pressed("quit"):
		quit_level()
		
	if mimic_defeated:
		if mimic_quest_completed == false:
			complete_mimic_quest()


func reset_level():
	var _reset = get_tree().change_scene("res://World/Overworld/Overworld.tscn")


func quit_level():
	var _quit = get_tree().change_scene("res://UI/Menu/Menu.tscn")


func complete_mimic_quest():
	mimic_quest_completed = true
	$YSort/Player.queue_free()
	$Camera2D/Control/Win.visible = true
	$Camera2D/Control/Menu.visible = true


func _on_Player_tree_exited():
	if mimic_defeated == false:
		$Camera2D/Control/Loss.visible = true
		$Camera2D/Control/Menu.visible = true


func _on_Mimic_defeated():
	mimic_defeated = true


func _on_Menu_pressed():
	var _ignored := get_tree().change_scene("res://UI/Menu/Menu.tscn")
