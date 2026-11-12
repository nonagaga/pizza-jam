class_name EntityDropTable extends Resource

## Chance that this drop table will be tried at all, as a float.
## If this chance is greater than 0, then it may be tried multiple times.
@export var try_chance = 0.0 as float

## Minimum amount of drops this can roll.
## When this drop table is rolled, it chooses a linearly random number between
## the min and max drops, then drops that many times.
@export var min_drops = 0.0 as float
## Maximum amount of drops this can roll.
@export var max_drops = 0.0 as float

@export var pickups := [] as Array[PackedScene]

func roll_pickups() -> Array[PackedScene]:
	var output = [] as Array[PackedScene]
	
	var try_amt = Compute.roll_int(try_chance)
	for try in range(try_amt):
		var drop_amt = Compute.roll_int(randf_range(min_drops, max_drops))
		for drop in range(drop_amt):
			output.append(pickups.pick_random())
	
	return output
