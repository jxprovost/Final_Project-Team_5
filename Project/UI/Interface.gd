extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

onready var _heartUIFull := $HeartUIFull
onready var _heartUIEmpty := $HeartUIEmpty

#For later testing on nested status bars
#signal health_changed(health)
#signal max_health_changed(max_health)


func _ready():
	_heartUIFull.rect_size.x = hearts * 16
	_heartUIEmpty.rect_size.x = max_hearts * 16

func _on_Player_health_changed(health):
	set_hearts(health)
	#emit_signal("health_changed", health)


func _on_Player_max_health_changed(max_health):
	set_max_hearts(max_health)
	#emit_signal("max_health_changed", max_health)


#on health changed
func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if _heartUIFull != null:
		_heartUIFull.rect_size.x = hearts * 16


#on max health changed
func set_max_hearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	if _heartUIEmpty != null:
		_heartUIEmpty.rect_size.x = max_hearts * 16
