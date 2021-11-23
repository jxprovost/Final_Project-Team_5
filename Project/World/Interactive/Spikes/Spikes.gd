extends Node2D


export var automatic := false
export var automaticTime := 1.0


var _activated := false


func _ready():
	$AutomaticTimer.wait_time = automaticTime
	if automatic == true:
		$AutomaticTimer.start()


func _on_AutomaticTimer_timeout():
	if _activated == false:
		_spike()
	else:
		_unspike()


func _on_TriggerArea2D_body_entered(_body):
	if automatic == false and _activated == false:
		_spike()


func _on_TriggerArea2D_body_exited(_body):
	if automatic == false and _activated == true:
		_unspike()


func _spike():
	$AnimationPlayer.play("Spike")
	$SpikeSound.pitch_scale = 1
	$SpikeSound.play()
	_activated = true


func _unspike():
	$AnimationPlayer.play("Unspike")
	$SpikeSound.pitch_scale = 1.2
	$SpikeSound.play()
	_activated = false
