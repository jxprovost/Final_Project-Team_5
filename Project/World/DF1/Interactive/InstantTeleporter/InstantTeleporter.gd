extends Area2D

var world : Node2D = null
var camera : Camera2D = null


func _ready():
	world = get_tree().get_root().get_node("World")
	camera = world.get_node("Camera2D")


func _on_InstantTeleporter_body_entered(body):
	if body.name == "Player":
		body.position = Vector2($TeleportPosition.global_position.x, body.position.y)
		camera.position = body.position
