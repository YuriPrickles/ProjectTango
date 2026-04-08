extends Interactable
class_name NeroFire
func _init(pos) -> void:
	super._init(pos,Rect2(-28,-18,24,16))
	y_sort_offset = -4
	touching = false
	spr_dict={
		91: Vector2(0,0),
		92: Vector2(1,0),
	}
	queue_redraw()

var blinkdelay = 58
func _process(delta: float) -> void:
	super._process(delta)
	queue_redraw()

func _input(event: InputEvent) -> void:
	if touching and event.is_action_pressed("accept") and not Main.main.loaded_fullscreen:
		var plr = Main.main.get_player()
		plr.no_control = true
		Main.main.change_fullscreen(NeroScreen.new())
func _draw() -> void:
	draw_from_dict(spr_dict,-offset/2,0)
	var sprite = Utils.blink(75,76,blinkdelay)
	Main.spr(Main.GameAtlas,self,Vector2(-8,-11),sprite)
	if touching:
		Main.draw_text_centered(self, "[enter]", Vector2(0,-40),Main.colors[7],Main.colors[0])
		Main.draw_text_centered(self, "nero the fire spirit", Vector2(0,-34),Main.colors[7],Main.colors[0])
		Main.draw_text_centered(self, "burns hymns onto cd", Vector2(0,-28),Main.colors[5],Main.colors[0])
