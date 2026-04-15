class_name IsMirrara
extends DiscCondition

func evaluate_condition(disc:Disc) -> bool:
	return disc.patron == Disc.Patron.Mirrara
