extends MarginContainer

signal canMove
signal cantMove

var itemNum
var itemState


func _ready():
	var itemCnt = $VSplitContainer/inventory.get_child_count() -1
	itemState = itemCnt * 3
	itemNum = itemCnt


# warning-ignore:unused_argument
func _process(delta):
	itemNum = floor(itemState/3)
	
	var item1 = $VSplitContainer/inventory/item1
	var item2 = $VSplitContainer/inventory/item2
	var item3 = $VSplitContainer/inventory/item3
	var item4 = $VSplitContainer/inventory/item4
	var fc = $VSplitContainer/inventory/for_code
	var items = [item1,item2,item3,item4,fc]
	var i = itemState % 3
	items[itemNum].set_value(i)
	
	if itemState > 0:
		emit_signal("canMove")
	else:
		emit_signal("cantMove")
		
	#debug()


func debug():
	$debug.text = str(itemState)


func _on_Actor_isMoving():
	if itemState > 0:
		itemState -= 1
	print(itemState)
