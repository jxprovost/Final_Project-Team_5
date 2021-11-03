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


func _on_Bats_defeated():
	var enemyList = get_tree().get_nodes_in_group("enemy")
	if enemyList.size() == 0:
		complete_bat_quest()


func _on_Menu_pressed():
	var _ignored := get_tree().change_scene("res://World/Menu.tscn")


export (PackedScene) var Bat

func spawn_Bat():
	var bat = Bat.instance()
	$YSort/Enemies.add_child(bat)
	bat.position = Vector2.ZERO
	var _ignored = bat.connect("bat_defeated", self, "_on_Bats_defeated")


func _on_Button_pressed():
	spawn_Bat()
