extends Sprite


export var fadeDampen := 3


var _baseBrightness := 0.5
var _time := 0.0
var _energy := 0.0


func _process(delta):
	_time += delta
	_energy = _baseBrightness + abs(sin(_time) / fadeDampen)
	$Light2D.energy = _energy
