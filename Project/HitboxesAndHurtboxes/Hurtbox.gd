extends Area2D

signal invincibility_started
signal invincibility_ended

const HitEffect := preload("res://Effects/HitEffect.tscn")

var invincible := false #setget set_invincible

onready var timer := $Timer


#func set_invincible(value):
#	invincible = value
#	if invincible == true:
#		emit_signal("invincibility_started")
#	else:
#		emit_signal("invincibility_ended")


func start_invincibility(duration):
	emit_signal("invincibility_started")
	self.invincible = true
	timer.start(duration)


func create_hit_effect(_area):
	var effect := HitEffect.instance()
	var main := get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position


func _on_Timer_timeout():
	emit_signal("invincibility_ended")
	self.invincible = false


func _on_Hurtbox_invincibility_started():
	set_deferred("monitorable", false)


func _on_Hurtbox_invincibility_ended():
	monitorable = true
