extends Node


func _ready():
	pass
	

func wait(s,target):
	var t = Timer.new()
	t.set_wait_time(s)
	t.set_one_shot(true)
	target.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
