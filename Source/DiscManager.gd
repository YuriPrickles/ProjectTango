class_name DiscManager
extends Resource
static var disc_list:Dictionary[int,Disc]={
}
func _init() -> void:
	disc_list={
		DiscID.UNREADABLE: UNREADABLE.new(),
		DiscID.OurLife: OurLife.new(),
		DiscID.OurGuardian: OurGuardian.new(),
		DiscID.OurTruth: OurTruth.new(),
		DiscID.OurBounty: OurBounty.new(),
		DiscID.Protect: Protect.new(),
		DiscID.Regrowth: Regrowth.new(),
		DiscID.Search: Search.new(),
		DiscID.Heist: Heist.new(),
		DiscID.DivineDoctor: DivineDoctor.new(),
		DiscID.Sacrifice: Sacrifice.new(),
		DiscID.BlessOurSouls: BlessOurSouls.new(),
		DiscID.PrayerToChlanke: PrayerToChlanke.new(),
		DiscID.SilentSavior: SilentSavior.new(),
		DiscID.TheHarvest: TheHarvest.new(),
		DiscID.NewCreation: NewCreation.new(),
		DiscID.ChildrenOfTheTree: ChildrenOfTheTree.new(),
		DiscID.PrayerToEuceleph: PrayerToEuceleph.new(),
		DiscID.BlessingOfLife: BlessingOfLife.new(),
		DiscID.PrayerToMirrara: PrayerToMirrara.new(),
		DiscID.TruthSeeker: TruthSeeker.new(),
		DiscID.UnyieldingJustice: UnyieldingJustice.new(),
		DiscID.Serenity: Serenity.new(),
		DiscID.Eavesdropper: Eavesdropper.new(),
		DiscID.TheBoyWhoBrokeDoors: TheBoyWhoBrokeDoors.new(),
		DiscID.TheSheriffsGaze: TheSheriffsGaze.new(),
		DiscID.GammonsMerryBallad: GammonsMerryBallad.new(),
		DiscID.PrayerToGammon: PrayerToGammon.new(),
		DiscID.RecklessCharge: RecklessCharge.new(),
	}
func get_random_disc() -> Disc:
	return disc_list.get(randi() % (disc_list.size() - 1))
func get_of_rarity(rarity:Disc.Rarity) -> Disc:
	var disc:Disc = disc_list.get(DiscID.UNREADABLE)
	var max_tries = 100
	while disc.rarity != rarity and max_tries>0:
		disc = get_random_disc()
		max_tries -= 1
	return disc
var cd_player_timer:Timer = Timer.new()
@export var stored_discs:Dictionary[Disc,int]
@export var cd:Dictionary[Disc,int]
var temporary_cd:Dictionary[Disc,int]
var destroyed_hymns:Dictionary[Disc,int]
const HYMN_DELAY = 25
var amount_til_evilcard = 4
const EVILCARD_WAIT_COUNT = 4
const MAX_HYMNS = 70

var hymn_buffer:Array[Disc]
var last_hymn_patron

func start_cd_player():
	load_disc()
	for i in range(5): add_hymn_to_buffer()
	cd_player_timer = Timer.new()
	cd_player_timer.wait_time = HYMN_DELAY
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
	temporary_cd = cd.duplicate()
func unload_disc():
	for hymn:Disc in destroyed_hymns.keys():
		print(destroyed_hymns.get(hymn,0))
		print(cd.get(hymn,0))
		cd[hymn] = cd.get(hymn,0) - destroyed_hymns.get(hymn,0)
		print(cd.get(hymn,0))
		if cd.get(hymn,0) <= 0:
			cd.erase(hymn)
	temporary_cd.clear()
	destroyed_hymns.clear()

##By default searches a random disc to queue next.[br]
##Honestly, not that useful. Please always add a DiscCondition.
func cut_queue_hymn(cond:DiscCondition):
	if not cond: return
	var chosen_disc:Disc = cond.find_disc(temporary_cd)
	if chosen_disc:
		temporary_cd[chosen_disc] = temporary_cd.get(chosen_disc,0) - 1
		hymn_buffer.insert(0,chosen_disc)
		print("%s is cutting the queue!" % chosen_disc.disc_name)
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
	if hymn_buffer.is_empty(): return null
	var will_destroy:bool = randi() % 100 < 5
	var played_disc:Disc = hymn_buffer.pop_front()
	var hymnevent:HymnPlayEvent = HymnPlayEvent.new(played_disc)
	if played_disc:
		hymnevent.hymn.on_play(will_destroy)
		
		print(Disc.Patron.find_key(hymnevent.hymn.patron))
		if not hymnevent.hymn.is_godless(): last_hymn_patron = hymnevent.hymn.patron
		if hymnevent.hymn.replayable:
			temporary_cd[played_disc] = temporary_cd.get(played_disc,0) + 1
		if will_destroy and not hymnevent.hymn.protected:
			print(played_disc.disc_name + " has been destroyed!")
			destroyed_hymns[played_disc] = destroyed_hymns.get(played_disc,0) + 1
	if hymn_buffer.size() < 5: add_hymn_to_buffer()
	if cd_player_timer: cd_player_timer.start(hymnevent.next_hymn_delay)
	return played_disc

func add_cd_to_storage(disc:Disc):
	for hymn:Disc in stored_discs.keys():
		if disc.disc_id == hymn.disc_id:
			stored_discs[hymn] = stored_discs.get(hymn,0) + 1
			return
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
