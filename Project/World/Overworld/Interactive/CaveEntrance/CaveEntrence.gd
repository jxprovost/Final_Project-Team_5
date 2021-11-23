extends StaticBody2D

func _on_Area2D_body_entered(_body):
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World/World.tscn")
