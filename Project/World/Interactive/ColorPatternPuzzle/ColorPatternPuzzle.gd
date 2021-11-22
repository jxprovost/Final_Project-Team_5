extends Node2D


signal solved

#var crystal_0 = get_tree().get_nodes_in_group("ColoredCrystalPodium0")
#var crystal_1 = get_tree().get_root().get_node("World").get_node("YSort").get_node("ColoredCrystalPodium1")
#var crystal_2 = get_tree().get_root().get_node("World").get_node("YSort").get_node("ColoredCrystalPodium2")
#var crystal_3 = get_tree().get_root().get_node("World").get_node("YSort").get_node("ColoredCrystalPodium3")

const _button_colors := [Color.red, Color.green, Color.blue, Color.yellow]

var _base_combination = []
var _input_combination = []


func _ready():
	$RedButton.initialize(_button_colors[0])
	$GreenButton.initialize(_button_colors[1])
	$BlueButton.initialize(_button_colors[2])
	$YellowButton.initialize(_button_colors[3])
	randomizeCombination()
	#crystal_0.initialize(_base_combination[0])
	#crystal_1.initialize(_base_combination[1])
	#crystal_2.initialize(_base_combination[2])
	#crystal_3.initialize(_base_combination[3])

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
	_fail()


func _fail():
	_input_combination = []
	$RedButton.fail()
	$GreenButton.fail()
	$BlueButton.fail()
	$YellowButton.fail()
	$FailSoundPlayer.play()
	$Timeout.stop()


func _success():
	emit_signal("solved")
	$RedButton.lock()
	$GreenButton.lock()
	$BlueButton.lock()
	$YellowButton.lock()
	$Timeout.stop()
	print("PUZZLE SOLVED!")
