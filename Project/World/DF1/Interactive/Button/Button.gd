extends AnimatedSprite


signal pressed


func _ready():
	play("unpressed")


func _on_Area2D_body_entered(_body):
	play("pressed")
	emit_signal("pressed")
