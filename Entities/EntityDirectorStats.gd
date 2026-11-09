class_name EntityDirectorStats extends Resource

## When this enemy is spawned, how many of it should be created?
@export var population_mult = 1.0 as float
## Additive population mult per difficulty.
@export var population_mult_diff = 0.0 as float

## Probability that this enemy will be spawned as an elite.
## When spawned with multiple in a group, each one rolls this separately.
@export var elite_prob = 0.0 as float
## Additive elite probability per difficulty.
@export var elite_prob_diff = 0.0 as float
