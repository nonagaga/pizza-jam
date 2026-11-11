class_name EntityDirectorStats extends Resource

## Entities on the same team cannot damage each other and will not
## pathfind towards each other.
## [br][br]
## Team 0: Enemies. [br]
## Team 1: Player.
@export var team = 0 as int

## When this enemy is spawned, how many of it should be created?
@export var population_mult = 1.0 as float
## Additive population mult per difficulty.
@export var population_mult_diff = 0.0 as float

## Probability that this enemy will be spawned as an elite.
## When spawned with multiple in a group, each one rolls this separately.
@export var elite_prob = 0.0 as float
## Additive elite probability per difficulty.
@export var elite_prob_diff = 0.0 as float

## Chance that the entity will drop a boon (tiny permanent buff).
@export var boon_drop_chance = 0.0 as float
## Chance that the entity will drop a stim (large temporary buff).
@export var stim_drop_chance = 0.0 as float
