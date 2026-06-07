extends Interactable
class_name NeroFire
func _init(pos) -> void:
	super._init(pos,Rect2(4,0,24,16))
	draw_offset = Vector2(-4,-4)
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
	super()	
	draw_from_dict(spr_dict,Vector2.ZERO,0)
	var sprite = Utils.blink(75,76,blinkdelay)
	Main.spr(Main.GameAtlas,self,-draw_offset - Vector2(0,7),sprite)
	if touching:
		Main.draw_text(self, "NERO_HOVERTEXT", Vector2(0,-40),Main.colors[7],Main.colors[0],false,true)
