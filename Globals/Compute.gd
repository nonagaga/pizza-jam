extends Node

func roll_int(input: float) -> int:
	var base = floor(input)
	var rem = input - base
	
	if randf() <= rem:
		base += 1
	
	return base
