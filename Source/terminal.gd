class_name Terminal
extends Node2D

var terminal_arr:Array[String]
var is_overlay:bool = false
var current_line:String=""
var disable_input:bool = false
var yn_mode:bool = false
var state = TerminalState.Normal

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
	echo("Project tango v0.0.0.0")
	echo("welcome to the terminal!")
	echo()
	echo("during gameplay, press [esc] to make")
	echo("this pop up at any time.")
	echo()
	echo("to return to gameplay, press [esc] again.")
	echo()
	echo("enter '¬Ahelp¬¬' for a list of commands")
	echo()

func clear():
	terminal_arr.clear()
	echo()

func giveup():
	if Main.game_state == Main.GameState.IN_RUN:
		echo("you took off your mask...")
		await get_tree().create_timer(1.7).timeout
		hide()
		Main.main.get_player().hurt_hurter_freed(99999,"unreality implosion")
	else:
		echo("¬8cannot be used outside a run")

func help(debug=false):
	echo("--------COMMAND LIST--------")
	echo("¬6help - ¬6display this menu")
	echo("¬6clear¬¬ - ¬6clear the terminal")
	echo("¬6exit¬¬ - ¬6exit game. ¬8doesnt save!!¬¬")
	echo("¬6play¬¬ - ¬6enter the game. automatically loads the current save.")
	echo("¬6save¬¬ - ¬6save game. only outside of a run")
	echo("¬6giveup¬¬ - ¬8kill yourself¬6 during a run")
	echo("¬6reset¬¬ - ¬8reset your save file¬¬")
	if debug:
		echo()
		echo("page 1 of 2")
		await pause()
		clear()
		echo("--------DEBUG COMMAND LIST--------")
		echo("¬6nexthymn - plays the next hymn")
		echo("page 2 of 2")

func nexthymn():
	if Main.main.disc_manager.hymn_buffer and Main.main.disc_manager.hymn_buffer[0] and Main.main.game_state == Main.GameState.IN_RUN:
		echo("playing %s" % Main.main.disc_manager.hymn_buffer[0])
		Main.main.disc_manager.play_random()
	else:
		echo("¬8either outside of run or empty cd")

func play():
	if not is_overlay and Main.game_state == Main.GameState.MAINMENU:
		is_overlay = true
		if await load_game():
			Main.main.reset_run()
			Main.main.load_level(LevelID.Above)
			hide()
	else:
		echo("¬8there is nowhere further to go.")

func save_game():
	if Main.game_state == Main.GameState.OUT_OF_RUN:
		if SaveLoad.save_game() != OK:
			echo("¬8something went wrong while saving.")
		else:
			echo("¬Asuccessfully saved!")
	else:
		echo("¬8cannot save inside a run")
		


func load_game() -> bool:
	if Main.game_state == Main.GameState.OUT_OF_RUN or Main.game_state == Main.GameState.MAINMENU:
		var load_result:bool = SaveLoad.load_game()
		if not load_result:
			if SaveLoad.check_save_exists():
				echo("¬6save file ¬8might be broken/corrupt¬6. load it anyway?")
				echo("¬8(it is not recommended to run it.)")
				echo("[ y / n ]")
				yn_mode = true
				var result = await y_n_result
				if not result:
					exit()
					return false
				return false
			else:
				echo("¬6creating save file...")
				Main.main.new_save_file()
		
		echo("¬6save file loaded")
		return true
	else:
		echo("¬8cannot load inside a run")
		return false

signal any_input
func pause():
	echo("press any key to continue...")
	state = TerminalState.NoType
	await any_input
	state = TerminalState.JustUnpaused

func exit():
	disable_input = true
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func reset():
	if SaveLoad.check_save_exists():
		echo()
		echo("¬6are you ¬8really sure¬6 you want to ¬8reset?¬6")
		echo("¬6this action is ¬8irreversible¬6.")
		echo("[ y / n ]")
		echo()
		yn_mode = true
		state = TerminalState.YN
		var result = await y_n_result
		state = TerminalState.Normal
		if result:
			echo("¬6we have erased it.")
			SaveLoad.kill_save()
		else:
			echo("¬6your save file lives another day.")
	else:
		echo("¬8there is nothing to reset.")

func _input(event: InputEvent) -> void:
	z_index = Main.Depths.Terminal
	if event is InputEventKey and not event.is_released() and not disable_input and visible:
		any_input.emit()
		if state == TerminalState.JustUnpaused:
			state = TerminalState.Normal
			return
		if event.keycode == KEY_BACKSPACE and current_line.length() > 0:
			current_line = current_line.erase(current_line.length() - 1)
			return
		elif event.keycode == KEY_ESCAPE:
			if not is_overlay:
				echo("¬8no other gameplay loaded¬¬")
		elif event.keycode == KEY_ENTER:
			parse_command()
		elif event.keycode == KEY_SPACE:
			current_line += " "
		elif state != TerminalState.NoType:
			for k:String in Main.fontmap:
				if event.keycode == (OS.find_keycode_from_string(k)):
					current_line += k
					return
func _process(delta: float) -> void:
	queue_redraw()

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
				"help":
					echo()
					help()
				"help debug":
					echo()
					help(true)
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
				_:
					echo("¬8unrecognized command %s." % current_line)
	current_line = ""

func echo(string:String=" "):
	terminal_arr.append(string)

func _draw() -> void:
	draw_rect(Rect2(0,0,320,180),Main.colors[0]* 0.8)
	if terminal_arr.size() < 1: return
	for i in range(terminal_arr.size()):
		Main.draw_text(self,terminal_arr[i],Vector2(1,180 - (8 * (terminal_arr.size()-i + 2))))
	Main.draw_text(self,"> " + current_line + Utils.blink("","_",40),Vector2(1,180-8))
