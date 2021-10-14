extends KinematicBody2D

const _FRICTION = 200
const _KNOCKBACK_FORCE = 110

var knockback = Vector2.ZERO

onready var stats = $Stats


func _ready():
	print(stats.max_health)
	print(stats.health)


func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, _FRICTION * delta)
	knockback = move_and_slide(knockback)


func _on_Hurtbox_area_entered(hitbox):
	stats.health -= hitbox.damage
	knockback = hitbox.knockback_vector * _KNOCKBACK_FORCE


func _on_Stats_no_health():
	queue_free()
