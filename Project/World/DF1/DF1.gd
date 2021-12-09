extends Node2D

signal complete_barrel_puzzle

var skull_quest_completed := false
var skull_defeated := false
var barrel_quest_complete := false
var _barrels_destroyed := 0



func _ready():	
	var numberOfBarrels := 30
	for n in range(1,numberOfBarrels):
		var barrel = get_node("YSort/Environment/Barrels/Barrel" + str(n))
		barrel.connect("barrel_destroyed", self, "_barrel_destroyed") 
		
		
func _process(_delta):
	if Input.is_action_pressed("reset"):
		reset_level()
		
	if Input.is_action_pressed("quit"):
		quit_level()
		
	if skull_defeated:
		if skull_quest_completed == false:
			complete_mimic_quest()
	
	if _barrels_destroyed >= 20:
		if barrel_quest_complete == false:
		
			emit_signal("complete_barrel_puzzle")
			barrel_quest_complete = true


func reset_level():
	var _reset = get_tree().change_scene("res://World/Overworld/Overworld.tscn")


func quit_level():
	var _quit = get_tree().change_scene("res://UI/Menu/Menu.tscn")


func complete_mimic_quest():
	skull_quest_completed = true
	$YSort/Player.queue_free()
	$Camera2D/Control/Win.visible = true
	$Camera2D/Control/Menu.visible = true


func _on_Player_tree_exited():
	if skull_defeated == false:
		$Camera2D/Control/Loss.visible = true
		$Camera2D/Control/Menu.visible = true


func _on_Menu_pressed():
	var _ignored := get_tree().change_scene("res://UI/Menu/Menu.tscn")


func _barrel_destroyed():
	_barrels_destroyed += 1


func _on_FlamingSkull_skull_defeated():
	skull_defeated = true
