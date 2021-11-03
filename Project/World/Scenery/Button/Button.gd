extends AnimatedSprite


func _ready():
	play("unpressed")


func _on_Area2D_body_entered(_body):
	play("pressed")
