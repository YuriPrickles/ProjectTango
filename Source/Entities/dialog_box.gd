class_name DialogBox
extends Node2D

signal advance_dialog
var dialog_array:Array[String]=["hey gem, got any more pickles?"]
var current_string:String
var display_array:Array
var box_size:Vector2
var dialog_index:int=0
var dialog_index_max:int
var color:Color
var prev_state
func _init(arr:Array[String], pos:Vector2, size:Vector2,col:Color=Main.colors[0]) -> void:
	prev_state = Main.game_state
	Main.game_state = Main.GameState.CUTSCENE
	dialog_array = arr.duplicate()
	dialog_index_max = dialog_array.size()
	position = pos
	box_size = size
	if dialog_array:
		current_string = dialog_array[dialog_index]
	color = col
var is_writing = false
var word_arr:Array[String]
var grown_to_full = false
var start_typing = false
var cur_rect_size:Vector2
var textbox_speed = 360
	
func _process(delta: float) -> void:
	grown_to_full = current_rect.size == box_size * Vector2(Main.FONTCHAR_SIZE)
	start_typing = current_rect.size >= box_size * Vector2(Main.FONTCHAR_SIZE) / 2
	if not grown_to_full:
		cur_rect_size = cur_rect_size.move_toward(box_size * Vector2(Main.FONTCHAR_SIZE),delta * textbox_speed)
		current_rect = Rect2(Vector2.ZERO,cur_rect_size)
		queue_redraw()
	
	if display_array.is_empty() and word_arr.is_empty() and start_typing and dialog_index < dialog_index_max and not is_writing and current_string:
		current_string = dialog_array[dialog_index]
		var chr_counter = 0
		var word = ""
		is_writing = true
		var total_length = 0
		var temp_phrase = ""
		print(current_string)
		for chr in current_string:
			#print(chr)
			word += chr
			chr_counter += 1
			if chr == ' ' or chr_counter >= current_string.length():
				print(word)
				total_length += word.length()
				print(temp_phrase)
				#print(box_size.x - chr_counter, " [%s,%s] - %s (%s)" % [int(box_size.x),chr_counter,word,word.length()])
				if total_length > box_size.x or chr_counter >= current_string.length():
					if chr_counter >= current_string.length():
						if total_length > box_size.x:
							word_arr.append(temp_phrase)
							total_length = word.length()
							temp_phrase = ""
							temp_phrase += word
							word_arr.append(temp_phrase)
							break
						else:
							temp_phrase += word
					word_arr.append(temp_phrase)
					print(total_length - word.length())
					total_length = word.length()
					temp_phrase = ""
				temp_phrase += word
				word = ""
		print(word_arr)
		var index = 0
		display_array.resize(word_arr.size())
		display_array.fill("")
		for wr in word_arr:
			for chr in wr:
				if not is_writing:
					print("stoppp")
					break
				display_array[index] += chr
				await get_tree().create_timer(0.04).timeout
			index += 1
		is_writing = false
		await advance_dialog
		word_arr.clear()
		display_array.clear()
		dialog_index += 1
		if dialog_index >= dialog_index_max:
			await get_tree().create_timer(0.1).timeout
			queue_free()
			Main.game_state = prev_state
	queue_redraw()
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("accept"):
		if is_writing:
			display_array = word_arr.duplicate()
			word_arr.clear()
			is_writing = false
		else:
			advance_dialog.emit()

var current_rect:Rect2 = Rect2(Vector2.ZERO,Vector2(1,1))
func _draw() -> void:
	draw_rect(current_rect.grow(1),color)
	Main.draw_text(self,display_array,Vector2.ZERO)
