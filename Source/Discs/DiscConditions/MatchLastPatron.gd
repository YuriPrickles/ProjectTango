class_name MatchLastPatron
extends DiscCondition

func evaluate_condition(disc:Disc) -> bool:
	return disc.patron == Main.main.disc_manager.last_hymn_patron
