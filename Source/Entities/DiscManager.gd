class_name DiscManager
extends Node
static var disc_list:Dictionary[int,Disc]={
	DiscID.UNREADABLE: UNREADABLE.new(),
	DiscID.OurLife: OurLife.new(),
	DiscID.OurGuardian: OurGuardian.new(),
	DiscID.OurTruth: OurTruth.new(),
	DiscID.OurBounty: OurBounty.new(),
}
var cd_player_timer:Timer = Timer.new()
var stored_discs:Dictionary[Disc,int]
var cd:Dictionary[Disc,int]
var temporary_cd:Dictionary[Disc,int]
var destroyed_hymns:Dictionary[Disc,int]
var hymn_delay = 30
var amount_til_evilcard = 4
const EVILCARD_WAIT_COUNT = 4

func start_cd_player():
	load_disc()
	cd_player_timer = Timer.new()
	cd_player_timer.wait_time = hymn_delay
	cd_player_timer.timeout.connect(play_random)
	add_child(cd_player_timer)
	cd_player_timer.start()

func stop_cd_player():
	cd_player_timer.queue_free()
	unload_disc()

func load_disc():
	temporary_cd = cd.duplicate_deep()
func unload_disc():
	for hymn:Disc in destroyed_hymns.keys():
		cd[hymn] = cd.get(hymn,0) - destroyed_hymns.get(hymn,0)
		if cd.get(hymn,0) <= 0:
			cd.erase(hymn)
	temporary_cd.clear()
	destroyed_hymns.clear()

func play_random() -> Disc:
	amount_til_evilcard -= 1
	if amount_til_evilcard == 0:
		var unr_disc = disc_list.get(DiscID.UNREADABLE)
		temporary_cd[unr_disc] = temporary_cd.get(unr_disc,0) + 1
		amount_til_evilcard = EVILCARD_WAIT_COUNT
	if cd_player_timer: cd_player_timer.start()
	if temporary_cd.is_empty(): return null
	var total = randi() % get_temp_cd_total()
	for hymn:Disc in temporary_cd.keys():
		total -= temporary_cd.get(hymn,0)
		if total < 0:
			var will_destroy:bool = randi() % 100 < 5
			hymn.on_play(will_destroy)
			temporary_cd[hymn] = temporary_cd.get(hymn,0) - 1
			if will_destroy:
				print(hymn.disc_name + " has been destroyed!")
				destroyed_hymns[hymn] = destroyed_hymns.get(hymn,0) + 1
			if temporary_cd.get(hymn,0) <= 0:
				temporary_cd.erase(hymn)
			return hymn
	return null

func add_cd_to_storage(disc:Disc):
	stored_discs[disc] = stored_discs.get(disc,0) + 1

func get_random_disc():
	return disc_list[randi() % 4]

func burn_to_cd(disc:Disc,amount):
	cd[disc] = cd.get(disc,0) + 1

func get_cd_total() -> int:
	var total = 0
	for hymn in cd.values():
		total += hymn
	return total

func get_temp_cd_total() -> int:
	var total = 0
	for hymn in temporary_cd.values():
		total += hymn
	return total
