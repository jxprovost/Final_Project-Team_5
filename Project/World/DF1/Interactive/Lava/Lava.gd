extends Area2D


const particlesPerUnit := 0.1


func _ready():
	var lava_size_x : int = $LavaShape.shape.extents.x
	var lava_size_y : int = $LavaShape.shape.extents.y
	var area : int = lava_size_x * lava_size_y
	var particleAmount := area * particlesPerUnit
	$CPUParticles2D.amount = particleAmount
	$CPUParticles2D.emission_rect_extents = Vector2(lava_size_x - 1, lava_size_y - 1)
	$Hitbox/CollisionShape2D.shape.extents = Vector2(lava_size_x, lava_size_y)


func _on_Lava_body_entered(body):
	togglePlayerBurningParticles(body)


func _on_Lava_body_exited(body):
	togglePlayerBurningParticles(body)


func togglePlayerBurningParticles(body):
	if body.name == "Player":
		var burningParticles : CPUParticles2D = body.get_node("BurningParticles")
		var burningSound : AudioStreamPlayer2D = body.get_node("BurningSound")
		burningParticles.emitting = not burningParticles.emitting
		burningSound.playing = not burningSound.playing
