extends Node2D

var bats_defeated := 0

func _process(_delta):
	if Input.is_action_pressed("reset"):
		reset_level()
		
	elif Input.is_action_pressed("quit"):
		quit_level()
		
	if bats_defeated == 8:
		complete_bat_quest()


func reset_level():
	var _reset = get_tree().change_scene("res://World/World.tscn")


func quit_level():
	var _quit = get_tree().change_scene("res://World/Menu.tscn")


func complete_bat_quest():
	$Camera2D/Control/Win.visible = true
	$Camera2D/Control/Menu.visible = true


func _on_Player_tree_exited():
	$Camera2D/Control/Loss.visible = true
	$Camera2D/Control/Menu.visible = true


func _on_Bat_bat_defeated():
	bats_defeated += 1


func _on_Bat2_bat_defeated():
	bats_defeated += 1


func _on_Bat3_bat_defeated():
	bats_defeated += 1


func _on_Bat4_bat_defeated():
	bats_defeated += 1


func _on_Bat5_bat_defeated():
	bats_defeated += 1


func _on_Bat6_bat_defeated():
	bats_defeated += 1


func _on_Bat7_bat_defeated():
	bats_defeated += 1


func _on_Bat8_bat_defeated():
	bats_defeated += 1


func _on_Menu_pressed():
	var _ignored := get_tree().change_scene("res://World/Menu.tscn")
