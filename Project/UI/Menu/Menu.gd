extends Node2D


func _on_PlayButton_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World/Overworld/Overworld.tscn")


func _on_Button2_pressed():
	$ColorRect.show()


func _on_Escape_pressed():
	$ColorRect.hide()
