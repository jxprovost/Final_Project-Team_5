extends Area2D


func _on_HealHeart_body_entered(_body):
	self.queue_free()
