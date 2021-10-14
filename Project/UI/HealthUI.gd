extends Control

var _hearts = 4 setget set_hearts
var _max_hearts = 4 setget set_max_hearts

onready var _heartUIFull := $HeartUIFull
onready var _heartUIEmpty := $HeartUIEmpty


func _ready():
	self._max_hearts = PlayerStats.max_health
	self._hearts = PlayerStats.health
# warning-ignore:return_value_discarded
	PlayerStats.connect("health_changed", self, "set_hearts")
# warning-ignore:return_value_discarded
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")


func set_hearts(value):
	_hearts = clamp(value, 0, _max_hearts)
	if _heartUIFull != null:
		_heartUIFull.rect_size.x = _hearts * 16


func set_max_hearts(value):
	_max_hearts = max(value, 1)
	self._hearts = min(_hearts, _max_hearts)
	if _heartUIEmpty != null:
		_heartUIEmpty.rect_size.x = _max_hearts * 16
