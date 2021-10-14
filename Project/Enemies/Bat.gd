extends KinematicBody2D

const _FRICTION = 200
const _KNOCKBACK_FORCE = 110

var knockback = Vector2.ZERO


func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, _FRICTION * delta)
	knockback = move_and_slide(knockback)


func _on_Hurtbox_area_entered(area):
	knockback = area.knockback_vector * _KNOCKBACK_FORCE
