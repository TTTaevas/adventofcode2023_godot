extends "res://me.gd"

var limits
var old_position = Vector2(8, 8)
var ids = []
var powers = []
var part2

signal portal_taken(me)

func go_back_to_portal():
	if 8 * 9 != position.x:
		await move("right") if 8 * 9 > position.x else await move("left")
		go_back_to_portal()
	elif 8 * 9 != position.y:
		await move("down") if 8 * 9 > position.y else await move("up")
		go_back_to_portal()
	else:
		portal_taken.emit(self)
		go_to_unchecked()

func go_to_unchecked():
	var elements = get_parent().get_children()
	var unchecked = elements.filter(func(e):
		if not e.get("checked") == null:
			return e.checked == false
		else:
			return false
	)
	unchecked.sort_custom(func(a, b):
		var difference_a = Vector2(abs(a.position.x - position.x), abs(a.position.y - position.y))
		var difference_b = Vector2(abs(b.position.x - position.x), abs(b.position.y - position.y))
		return difference_a.x + difference_a.y < difference_b.x + difference_b.y
	)
	
	if len(unchecked):
		var place_to_check = unchecked[0]
		if place_to_check.position.x != position.x:
			await move("right") if place_to_check.position.x > position.x else await move("left")
			go_to_unchecked()
		elif place_to_check.position.y != position.y:
			await move("down") if place_to_check.position.y > position.y else await move("up")
			go_to_unchecked()
		else:
			var possible = place_to_check.check(self, part2)
			if not possible:
				await go_back_to_portal()
			else:
				go_to_unchecked()
	else:
		if not get_parent().get("id") == null:
			if not part2:
				ids.append(get_parent().id)
			else:
				var maximum = get_parent().maximum.values()
				var current_game_power = maximum.reduce(func(a, b): return a * b)
				powers.append(current_game_power)
			
			go_back_to_portal()
		else:
			if not part2:
				print(str(ids.reduce(func(a, b): return a + b)))
			else:
				$Label.text = str(powers.reduce(func(a, b): return a + b))

func _ready():
	part2 = get_parent().get_parent().part2
	go_to_unchecked()

func _process(_delta):
	if not part2:
		$Label.text = str(ids.reduce(func(a, b): return a + b))
	else:
		$Label.text = str(powers.reduce(func(a, b): return a + b))
