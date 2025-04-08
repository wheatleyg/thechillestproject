extends Resource

# config file for each enemy. be careful messing with these variables because the game will stop working without them

class_name enemy_resource

@export var speed : int #speed for each enemy
@export var sprite : Texture2D #the sprite for the enemy	
@export var width: int #spacing between each enemy
@export var crystals: int #how many crystals/points each enemy rewards
@export var animation_name: String #the animation the enemy uses 
