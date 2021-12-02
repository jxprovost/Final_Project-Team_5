extends StaticBody2D


func initialize(crystal_color):
	$Crystal.modulate = crystal_color
	$Crystal/Light2D.color = crystal_color
