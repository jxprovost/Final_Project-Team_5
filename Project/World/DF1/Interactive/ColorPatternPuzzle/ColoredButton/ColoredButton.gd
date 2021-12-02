extends Area2D


signal pressed


const _fail_color := Color(1, 0, 0)
var _button_color := Color(0, 0, 0)
var _locked := false


func initialize(rgb):
	_button_color = rgb
	$Button.modulate = _button_color
	$ActivationLight.color = _button_color


func _on_ColoredButton_body_entered(_body):
	if $PressedTimer.is_stopped() and _locked == false:
		$Button.play("pressed")
		$PressAudioPlayer.play()
		$PressedTimer.start()
		$ActivationLight.enabled = true
		emit_signal("pressed", _button_color)


func _on_PressedTimer_timeout():
	$Button.play("default")
	$ActivationLight.enabled = false
	$Button.modulate = _button_color
	$ActivationLight.color = _button_color


func fail():
	$Button.modulate = _fail_color
	$ActivationLight.color = _fail_color
	$ActivationLight.enabled = true
	$PressedTimer.start()


func lock():
	$ActivationLight.enabled = true
	_locked = true
