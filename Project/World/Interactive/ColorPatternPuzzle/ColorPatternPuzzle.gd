extends Node2D


signal solved

#var colorPatternButtonSpawn = get_tree().get_root().get_node("World").get_node("ColorPatternButtonSpawn")
#var colorPatternPodiumSpawn = get_tree().get_root().get_node("World").get_node("ColorPatternPodiumSpawn")

const _button_colors := [Color.red, Color.green, Color.blue, Color.yellow]

var _base_combination = []
var _input_combination = []
var _solved = false

func _ready():
	$Buttons/RedButton.initialize(_button_colors[0])
	$Buttons/GreenButton.initialize(_button_colors[1])
	$Buttons/BlueButton.initialize(_button_colors[2])
	$Buttons/YellowButton.initialize(_button_colors[3])
	randomizeCombination()
	$Podiums/ColoredCrystalPodium0.initialize(_base_combination[0])
	$Podiums/ColoredCrystalPodium1.initialize(_base_combination[1])
	$Podiums/ColoredCrystalPodium2.initialize(_base_combination[2])
	$Podiums/ColoredCrystalPodium3.initialize(_base_combination[3])

func randomizeCombination():
	var _rng = RandomNumberGenerator.new()
	_rng.randomize()
	for _i in range(0, 4):
		var chosenColor = _rng.randi_range(0, 3)
		_base_combination.push_back(_button_colors[chosenColor])


func _on_Button_pressed(rgb):
	_input_combination.push_back(rgb)
	if _input_combination.size() >= 4:
		if _is_combination_successful():
			_success()
		else:
			_fail()
	$Timeout.start()


func _is_combination_successful():
	if _input_combination == _base_combination:
		return true


func _on_Timeout_timeout():
	if _solved == false:
		_fail()


func _fail():
	_input_combination = []
	$Buttons/RedButton.fail()
	$Buttons/GreenButton.fail()
	$Buttons/BlueButton.fail()
	$Buttons/YellowButton.fail()
	$FailSoundPlayer.play()
	$Timeout.stop()


func _success():
	emit_signal("solved")
	$Buttons/RedButton.lock()
	$Buttons/GreenButton.lock()
	$Buttons/BlueButton.lock()
	$Buttons/YellowButton.lock()
	$Timeout.stop()
	_solved = true
	print("PUZZLE SOLVED!")
