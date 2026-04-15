class_name DiscCondition
extends Object

func evaluate_condition(disc:Disc) -> bool:
	return true

func find_disc(disc_dict:Dictionary[Disc,int]) -> Disc:
	var final_disc_arr:Array[Disc] = []
	for disc:Disc in disc_dict.keys():
		if evaluate_condition(disc):
			final_disc_arr.append(disc)
	if not final_disc_arr.is_empty():
		return final_disc_arr.pick_random()
	return null
