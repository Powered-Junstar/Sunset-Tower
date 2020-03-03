extends MarginContainer


signal canMove
signal cantMove

var item1
var item2
var item3
var item4
var itemMaxValue : int = 0

export var item_wait_time = 0

var itemNum
var itemState : int = 0
var itemMax

func _ready():
	item1 = $VSplitContainer/inventory/item1
	item2 = $VSplitContainer/inventory/item2
	item3 = $VSplitContainer/inventory/item3
	item4 = $VSplitContainer/inventory/item4
	itemMaxValue = $VSplitContainer/inventory/item1.max_value

	itemMax = $VSplitContainer/inventory.get_child_count() * itemMaxValue - 1
	itemState = itemMax

	$Timer.wait_time = item_wait_time


# warning-ignore:unused_argument
func _process(delta):
	itemNum = floor(itemState/itemMaxValue)
	#debug()


func debug():
	$debug.text = str(itemState)

func fill_item():
	itemState = itemMax
	item1.set_value(itemMaxValue)
	item2.set_value(itemMaxValue)
	item3.set_value(itemMaxValue)
	item4.set_value(itemMaxValue)


func _on_Actor_isMoving():
	if itemState >= 0:
		var items = [item1,item2,item3,item4]
		var i = itemState % itemMaxValue
		items[itemNum].set_value(i)
		
		emit_signal("canMove")
		itemState -= 1
		
		if itemState == 0:
			$Timer.start()
	
	else:
		emit_signal("cantMove")
		$Timer.start()
		print("started")
		


func _on_Timer_timeout_item():
	fill_item()
	emit_signal("canMove")
	$Timer.stop()
	$Timer.wait_time = item_wait_time
