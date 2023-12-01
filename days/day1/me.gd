extends "res://me.gd"

var numbers_spelled_with_letters = [
	{"text": "one", "value": "1"}, {"text": "two", "value": "2"}, {"text": "three", "value": "3"}, 
	{"text": "four", "value": "4"}, {"text": "five", "value": "5"}, {"text": "six", "value": "6"}, 
	{"text": "seven", "value": "7"}, {"text": "eight", "value": "8"}, {"text": "nine", "value": "9"}
]

var numbers = []
var current_text = ""

var pieces = []

func look_for_document_piece(line: int):
	var piece = pieces[line - 1]
	
	while piece.position.x != position.x:
		await move("right") if piece.position.x > position.x else await move("left")
	while piece.position.y != position.y:
		await move("down") if piece.position.y > position.y else await move("up")
	
	return piece

func interpret_text(text: String) -> int:
	var n = []
	if not get_parent().count_spelled_with_letters:
		for c in text:
			if c.is_valid_int():
				n.append(c)
	else:
		while text != "":
			for possibility in numbers_spelled_with_letters:
				if text.begins_with(possibility.text):
					n.append(possibility.value)
					break
				elif text.begins_with(possibility.value):
					n.append(possibility.value)
					break
			text = text.erase(0, 1)
	return int("%s%s" % [n[0], n[-1]])

func _ready():
	position = Vector2(120, 120)
	var elements = get_parent().get_children()
	pieces = elements.filter(func(e): return "Piece" in e.name)
	
	for i in 1000:
		$Label.text = str(i)
		var piece = await look_for_document_piece(i + 1)
		current_text = piece.read_text()
		var number = interpret_text(current_text)
		numbers.append(number)
		$CanvasLayer/Label.text = str(numbers.reduce(func(a, b): return a + b))
