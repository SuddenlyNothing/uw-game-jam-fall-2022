extends Node

# Used for input remapping and control displays
var user_keys := PoolStringArray(["pause", "melee", "shoot", "continue", "up", "left", "down", "right"])

# Used for formatting strings to display the correct key.
var input_format := {}

var rng := RandomNumberGenerator.new()
