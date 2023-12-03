extends Area2D

var looking_in_direction = "right"

func move(direction: String):	
	var animation_name = look(direction)
	await get_tree().create_timer(0.01).timeout
	var new_frame = 0
	if $Animation.sprite_frames.get_frame_count(animation_name) - 1 != $Animation.get_frame():
		new_frame = $Animation.get_frame() + 1
	$Animation.set_frame(new_frame)
	
	var movement = Vector2(0, 0)
	if (direction == "up"):
		movement = Vector2(0, -16)
	elif (direction == "right"):
		movement = Vector2(16, 0)
	elif (direction == "down"):
		movement = Vector2(0, 16)
	elif (direction == "left"):
		movement = Vector2(-16, 0)
	self.set_position(self.get_position() + movement)

func look(direction: String):
	var new_animation = "walk_" + direction
	var frame = $Animation.get_frame()
	$Animation.set_animation(new_animation)
	$Animation.set_frame(frame)
	looking_in_direction = direction
	return new_animation
