extends "pawn.gd"


signal isMoving

onready var grid = get_parent()
var spr_character = load("res://pawns/sprites/character.png")
var spr_characterTired = load("res://pawns/sprites/characterTired.png")

var canMove

func _ready():
	update_look_direction(Vector2.RIGHT)
	
	canMove = true


func _process(_delta):
	if canMove:
		var input_direction = get_input_direction()
		if not input_direction:
			return
		update_look_direction(input_direction)
	
		var target_position = grid.request_move(self, input_direction)
		if target_position:
			move_to(target_position)
		else:
			bump()


func get_input_direction():
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)


func update_look_direction(direction):
	$Pivot/Sprite.rotation = direction.angle()


func move_to(target_position):
	set_process(false)
	
	emit_signal("isMoving")
	
	$AnimationPlayer.play("walk")

	# Move the node to the target cell instantly,
	# and animate the sprite moving from the start to the target cell
	var move_direction = (target_position - position).normalized()
	$Tween.interpolate_property($Pivot, "position", - move_direction * 32, Vector2(), $AnimationPlayer.current_animation_length, Tween.TRANS_LINEAR, Tween.EASE_IN)
	position = target_position

	$Tween.start()

	# Stop the function execution until the animation finished
	yield($AnimationPlayer, "animation_finished")
	
	if canMove == false:
		$Pivot/Sprite.texture = spr_characterTired
	else:
		$Pivot/Sprite.texture = spr_character
	
	set_process(true)


func bump():
	set_process(false)
	$AnimationPlayer.play("bump")
	yield($AnimationPlayer, "animation_finished")
	set_process(true)


func _on_hud_canMove():
	canMove = true
	
func _on_hud_cantMove():
	canMove = false
