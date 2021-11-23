extends Area2D


func _ready():
	var lava_size_x = $Sprite.region_rect.size.x / 2
	var lava_size_y = $Sprite.region_rect.size.y / 2
	$CPUParticles2D.emission_rect_extents = Vector2(lava_size_x, lava_size_y)
	$Hitbox/CollisionShape2D.shape.extents = Vector2(lava_size_x, lava_size_y)
	$CollisionShape2D.shape.extents = Vector2(lava_size_x, lava_size_y)


func _on_Lava_body_entered(body):
	togglePlayerBurningParticles(body)


func _on_Lava_body_exited(body):
	togglePlayerBurningParticles(body)


func togglePlayerBurningParticles(body):
	if body.name == "Player":
		var burningParticles = body.get_node("BurningParticles")
		var burningSound = body.get_node("BurningSound")
		burningParticles.emitting = not burningParticles.emitting
		burningSound.playing = not burningSound.playing
