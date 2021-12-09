extends PathFollow2D

export var flySpeed := 50

func _process(delta):
	set_offset(get_offset() + flySpeed * delta)
