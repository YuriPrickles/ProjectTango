class_name Terminal
extends Node2D

var terminal_arr:Array[String]
var is_overlay:bool = false
var current_line:String=""
var disable_input:bool = false
var yn_mode:bool = false
var state = TerminalState.Normal
var special_commands = false

enum TerminalState {
	Normal,
	NoType,
	YN,
	JustUnpaused
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	echo("                                                                                  ")
	echo(" [[[[[[[[]                                  [[[[[]]]]]                            ")
	echo(" []     []                                [     []                                ")
	echo(" []     []                                []    []                                ")
	echo(" []     []                              [[[]]]  []                                ")
	echo(" [[[[[[[[]             []                 []    []                                ")
	echo(" []                         [][]    [][]  []    []                                ")
	echo(" []    [  [][]  [][]   []  [    ]  [      []    []  [][]    [  []]   []]   [][]   ")
	echo(" []    [ []    []  []  []  [][][]  [      []    [] [   []   [ []  ] [   ] []  []  ")
	echo(" []    [[      []  []  []  [       [      []    [] [  [] ]  [[    ] [   ] []  []  ")
	echo(" []    [        [][]   []   [][]    [][]  []    []  []   ]  [     ]  [][]  [][]   ")
	echo("                      []                                                ]         ")
	echo("                   [][]                                             [][]          ")
	echo()
	echo()
	await pause()
	state = TerminalState.NoType
	for i in range(40):
		await get_tree().create_timer(0.02).timeout
		echo()
	clear()
	state = TerminalState.Normal
	echo("TERMINAL_STARTUP")
	echo()
	if SaveLoad.check_save_exists():
		echo("SAVE_EXISTS", str(get_local_datetime(FileAccess.get_modified_time(SaveLoad.base_path))))
	else:
		echo("NO_SAVE")
static func get_local_datetime(unix_time: int) -> String:
	var bias: int = Time.get_time_zone_from_system().bias
	var t := unix_time + bias * 60
	return Time.get_datetime_string_from_unix_time(t, true)
func clear():
	terminal_arr.clear()
	echo()

func giveup():
	if Main.game_state == Main.GameState.IN_RUN:
		echo("TERMINAL_GIVEUP")
		await get_tree().create_timer(1.7).timeout
		hide()
		Main.main.get_player().hurt_hurter_freed(99999,"unreality implosion")
	else:
		echo("TERMINAL_GIVEUP_FAIL")
func keys():
	echo()
	echo("TERMINAL_KEYS")

func help(type=""):
	if type=="dat":
		clear()
		echo("TERMINAL_HELP_SPECIAL")
		return
	echo("TERMINAL_HELP_1")
	if type=="debug":
		echo()
		await pause()
		clear()
		echo("TERMINAL_HELP_2")

func tutorial():
	clear()
	echo()
	echo("TERMINAL_TUTORIAL")

func nexthymn():
	if Main.main.disc_manager.hymn_buffer and Main.main.disc_manager.hymn_buffer[0] and Main.main.game_state == Main.GameState.IN_RUN:
		echo("playing %s" % Main.main.disc_manager.hymn_buffer[0])
		Main.main.disc_manager.play_random()
	else:
		echo("TERMINAL_NEXTHYMN_FAIL")

func garble(length:int):
	var string:String=""
	for i in range(length):
		string += Main.fontmap[randi() % Main.fontmap.length() - 1]
	return string

func play():
	if not is_overlay and Main.game_state == Main.GameState.MAINMENU:
		is_overlay = true
		if await load_game():
			if Main.main.savescummed:
				state = TerminalState.NoType
				var text_size = 150
				while text_size > -80:
					echo(garble(text_size))
					await get_tree().create_timer(0.02).timeout
					text_size -= 3
				state = TerminalState.JustUnpaused
				Main.main.change_fullscreen(Git.new(),false)
			Main.main.reset_run()
			Main.main.load_level(LevelID.Above)
			hide()
	else:
		echo("TERMINAL_PLAY_FAIL")

func save_game():
	if Main.game_state == Main.GameState.OUT_OF_RUN:
		if SaveLoad.save_game() != OK:
			echo("TERMINAL_SAVE_ERROR")
		else:
			echo("TERMINAL_SAVE_SUCCESS")
	else:
		echo("TERMINAL_SAVE_FAIL")
		


func load_game() -> bool:
	if Main.game_state == Main.GameState.OUT_OF_RUN or Main.game_state == Main.GameState.MAINMENU:
		var load_result:bool = SaveLoad.load_game()
		if not load_result:
			if SaveLoad.check_save_exists():
				echo("TERMINAL_LOAD_FUCKEDUP")
				echo("TERMINAL_YN")
				yn_mode = true
				var result = await y_n_result
				if not result:
					exit()
					return false
				return false
			else:
				echo("TERMINAL_LOAD_NEW")
				Main.main.new_save_file()
		
		echo("TERMINAL_LOAD_SUCCESS")
		return true
	else:
		echo("TERMINAL_LOAD_FAIL")
		return false

signal any_input
func pause():
	echo("TERMINAL_PAUSEINPUT")
	state = TerminalState.NoType
	await any_input
	state = TerminalState.JustUnpaused

func exit():
	disable_input = true
	if Main.main.game_state == Main.GameState.IN_RUN:
		echo("TERMINAL_EXIT_ERROR")
		disable_input = false
		return
	await Main.main.screenwipe.screen_wipe_in()
	await get_tree().create_timer(0.5).timeout
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func reset():
	if SaveLoad.check_save_exists():
		echo()
		echo("TERMINAL_RESET_ASK")
		echo("TERMINAL_YN")
		echo()
		yn_mode = true
		state = TerminalState.YN
		var result = await y_n_result
		state = TerminalState.Normal
		if result:
			echo("TERMINAL_RESET_DONE")
			SaveLoad.kill_save()
		else:
			echo("TERMINAL_RESET_CANCEL")
	else:
		echo("TERMINAL_RESET_EMPTY")

func _input(event: InputEvent) -> void:
	z_index = Main.Depths.Terminal
	if event is InputEventKey and not event.is_released() and not disable_input and visible:
		any_input.emit()
		event = event as InputEventKey
		event.alt_pressed = false
		event.shift_pressed = false
		event.meta_pressed = false
		event.ctrl_pressed = false
		if state == TerminalState.JustUnpaused:
			state = TerminalState.Normal
			return
		if event.keycode == KEY_BACKSPACE and current_line.length() > 0:
			current_line = current_line.erase(current_line.length() - 1)
			return
		elif event.keycode == KEY_ESCAPE and not is_overlay: echo("TERMINAL_CLOSE_FAIL")
		elif event.keycode == KEY_ENTER: parse_command()
		elif event.keycode == KEY_SPACE: current_line += " "
		elif state != TerminalState.NoType and event.unicode != 0:
			for k:String in Main.fontmap:
				
				if char(event.unicode) == k:
					current_line += k
					return
func _process(delta: float) -> void:
	queue_redraw()

func summon():
	echo("TERMINAL_BOSS_SUMMONED")
	var lvl = Main.main.get_level()
	lvl.enemies.add_child(Verdano.new(lvl.terminal_pos))

signal y_n_result(value:bool)
func parse_command():
	match state:
		TerminalState.YN:
			match current_line.to_lower():
				"y":
					y_n_result.emit(true)
				"n":
					y_n_result.emit(false)
				_:
					current_line = ""
			current_line = ""
			return
		TerminalState.Normal:
			if current_line.is_empty():
				echo()
				return
			match current_line.to_lower():
				"summon":
					summon()
				"help":
					echo()
					help()
				"tutorial":
					tutorial()
				"keys":
					keys()
				"help debug":
					echo()
					help("debug")
				"help dat":
					if special_commands:
						echo()
						help("dat")
					else:
						echo("¬8unrecognized command \"%s\"." % current_line)
				"t":
					test_dialog()
				"testdialog":
					test_dialog()
				"clear":
					clear()
				"play":
					play()
				"giveup":
					giveup()
				"exit":
					exit()
				"save":
					save_game()
				"reset":
					reset()
				"nexthymn":
					nexthymn()
				"reloadlang":
					reload_lang()
				"options":
					display_options()
				"options -s": boolean_option(Options.OptionNames.SIMPLE_DESC)
				"options -a": boolean_option(Options.OptionNames.AUTOSAVE_ENTRY)
				"options -e": boolean_option(Options.OptionNames.AUTOSAVE_EXIT)
				"options -f":
					current_line = ""
					await boolean_option(Options.OptionNames.FULLSCREEN)
					Main.main.change_windowsize()
				_:
					echo("¬8unrecognized command \"%s\"." % current_line)
	current_line = ""

func display_options():
	echo("TERMINAL_OPTIONS_DISPLAY")
	echo()
	for i in range(Options.OptionNames.size()):
		echo("TERMINAL_OPTIONS_%s" % i,str("¬8",Main.main.options.option_list.get(i)))

func boolean_option(option_index):
	echo()
	echo("TERMINAL_BOOL_OPTION", str("¬8",Main.main_lang.get_dialog(Options.OptionNames.find_key(option_index))))
	echo("TERMINAL_YN")
	echo()
	yn_mode = true
	state = TerminalState.YN
	var result = await y_n_result
	state = TerminalState.Normal
	Main.main.options.option_list[option_index] = result
	SaveLoad.save_options()
	echo("TERMINAL_BOOL_OPTION_SET_%s" % str(result).to_upper())
	return result

func reload_lang():
	Main.main_lang = Language.from_txt("res://Dialog/English.txt")

func test_dialog():
	echo("test dialog loaded")
	Main.main.say("TEST_DIALOG", Vector2(30,30),Vector2(24,10))
	pass

func echo(string=" ",extra_string:String=""):
	var echostring = Main.main_lang.get_dialog(string)
	if echostring is Array:
		for line in echostring:
			echo(line,extra_string)
		return
	elif not extra_string.is_empty():
		echostring += extra_string
	terminal_arr.append(echostring)

func _draw() -> void:
	draw_rect(Rect2(0,0,320,180),Main.colors[0]* 0.8)
	if terminal_arr.size() < 1: return
	for i in range(terminal_arr.size()):
		Main.draw_text(self,terminal_arr[i],Vector2(1,180 - (8 * (terminal_arr.size()-i + 2))))
	Main.draw_text(self,"> " + current_line + Utils.blink("","_",40),Vector2(1,180-8))
