extends Sprite


export var fadeDampen := 3


var baseBrightness := 0.5
var time := 0.0
var energy := 0.0
func _process(delta):
	time += delta
	energy = baseBrightness + abs(sin(time) / fadeDampen)
	$Light2D.energy = energy
