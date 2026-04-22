class_name DiscManager
extends Resource
static var disc_list:Dictionary[int,Disc]={
	DiscID.UNREADABLE: UNREADABLE.new(),
	DiscID.OurLife: OurLife.new(),
	DiscID.OurGuardian: OurGuardian.new(),
	DiscID.OurTruth: OurTruth.new(),
	DiscID.OurBounty: OurBounty.new(),
	DiscID.Protect: Protect.new(),
	DiscID.Regrowth: Regrowth.new(),
	DiscID.Search: Search.new(),
	DiscID.Heist: Heist.new(),
}
func get_random_disc():
	return disc_list.get(randi() % 8)
var cd_player_timer:Timer = Timer.new()
@export var stored_discs:Dictionary[Disc,int]
@export var cd:Dictionary[Disc,int]
var temporary_cd:Dictionary[Disc,int]
var destroyed_hymns:Dictionary[Disc,int]
var hymn_delay = 25
var amount_til_evilcard = 4
const EVILCARD_WAIT_COUNT = 4
const MAX_HYMNS = 70

var hymn_buffer:Array[Disc]
var last_hymn_patron

func start_cd_player():
	load_disc()
	for i in range(5): add_hymn_to_buffer()
	cd_player_timer = Timer.new()
	cd_player_timer.wait_time = hymn_delay
	cd_player_timer.process_mode = Node.PROCESS_MODE_PAUSABLE
	cd_player_timer.timeout.connect(play_random)
	Main.main.add_child(cd_player_timer)
	cd_player_timer.start()

func stop_cd_player():
	cd_player_timer.queue_free()
	unload_disc()

func add_hymn_to_buffer():
	if temporary_cd.is_empty(): return
	var total = randi() % get_temp_cd_total()
	for hymn:Disc in temporary_cd.keys():
		total -= temporary_cd.get(hymn,0)
		if total < 0:
			temporary_cd[hymn] = temporary_cd.get(hymn,0) - 1
			hymn_buffer.append(hymn)
			if temporary_cd.get(hymn,0) <= 0:
				temporary_cd.erase(hymn)

func load_disc():
	temporary_cd = cd.duplicate_deep()
func unload_disc():
	for hymn:Disc in destroyed_hymns.keys():
		cd[hymn] = cd.get(hymn,0) - destroyed_hymns.get(hymn,0)
		if cd.get(hymn,0) <= 0:
			cd.erase(hymn)
	temporary_cd.clear()
	destroyed_hymns.clear()

##By default searches a random disc to queue next.[br]
##Honestly, not that useful. Please always add a DiscCondition.
func cut_queue_hymn(cond:DiscCondition):
	var chosen_disc:Disc = cond.find_disc(temporary_cd)
	if chosen_disc:
		temporary_cd[chosen_disc] = temporary_cd.get(chosen_disc,0) - 1
		hymn_buffer.insert(0,chosen_disc)
		if temporary_cd.get(chosen_disc,0) <= 0:
			temporary_cd.erase(chosen_disc)
	
func skip_next() -> Disc:
	if cd_player_timer: cd_player_timer.start()
	if hymn_buffer.is_empty() or hymn_buffer[0] is UNREADABLE: return null
	var skipped_disc:Disc = hymn_buffer.pop_front()
	skipped_disc.on_skip()
	if hymn_buffer.size() < 5: add_hymn_to_buffer()
	return skipped_disc

func play_random() -> Disc:
	amount_til_evilcard -= 1
	if amount_til_evilcard == 0:
		var unr_disc = disc_list.get(DiscID.UNREADABLE)
		temporary_cd[unr_disc] = temporary_cd.get(unr_disc,0) + 1
		amount_til_evilcard = EVILCARD_WAIT_COUNT
	if cd_player_timer: cd_player_timer.start()
	if hymn_buffer.is_empty(): return null
	var will_destroy:bool = randi() % 100 < 5
	var played_disc:Disc = hymn_buffer.pop_front()
	if played_disc:
		played_disc.on_play(will_destroy)
		
		print(Disc.Patron.find_key(played_disc.patron))
		if not played_disc.is_godless(): last_hymn_patron = played_disc.patron
		if will_destroy:
			print(played_disc.disc_name + " has been destroyed!")
			destroyed_hymns[played_disc] = destroyed_hymns.get(played_disc,0) + 1
	if hymn_buffer.size() < 5: add_hymn_to_buffer()
	return played_disc

func add_cd_to_storage(disc:Disc):
	stored_discs[disc] = stored_discs.get(disc,0) + 1


func burn_to_cd(disc:Disc,amount=1):
	var disc_check_callable:Callable = func(d:Disc): return d.disc_id == disc.disc_id
	var matching_disc_array:Array[Disc] = cd.keys().filter(disc_check_callable)
	if matching_disc_array.size() == 1:
		cd[matching_disc_array[0]] = cd.get(matching_disc_array[0],0) + amount
	else:
		cd[disc] = cd.get(disc,0) + amount

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
