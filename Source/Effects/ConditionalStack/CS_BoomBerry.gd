class_name CS_BoomBerry
extends ConditionalStackEffect

func _init(st:int) -> void:
	effect_name = "Boom Berry"
	icon_atlas = Main.GameAtlas
	icon_index = 116
	reduce_on_hymn = true
	super._init(st)

func process_event(event:Event):
	if event is PickupLandEvent:
		if event.pickup.item.item_name == "ITEM_REDBERRIES":
			var plr = Main.main.get_player()
			var proj = StunBlast.new(event.pickup,event.pickup.position,Vector2.ZERO,2)
			proj.starting_pos = plr.Center
			proj.ending_pos = proj.position
			event.pickup.queue_free()
	super(event)
