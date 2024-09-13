class_name TreeCell extends Node2D

var rng = RandomNumberGenerator.new()

signal cell_l_clicked(cell: TreeCell)
signal cell_r_clicked(cell: TreeCell)

const NORMAL_ATLAS_REGIONS := [
	Rect2(0, 0, 32, 32), # normal wood
	Rect2(32, 0, 32, 32), # flowers
	Rect2(0, 32, 32, 32), # holes
	Rect2(160, 32, 32, 32), # moss
]
const DECENT_HOLD_ATLAS_REGION := Rect2(192, 0, 32, 32)
const GREAT_HOLD_ATLAS_REGION := Rect2(192, 32, 32, 32)
const LEFT_NORMAL_ATLAS_REGION := Rect2(128, 0, 32, 32)
const LEFT_FLOWER_ATLAS_REGION := Rect2(96, 32, 32, 32)
const RIGHT_NORMAL_ATLAS_REGION := Rect2(128, 32, 32, 32)
const RIGHT_FLOWER_ATLAS_REGION := Rect2(160, 0, 32, 32)
const GREAT_HOLD_THRESHOLD := 9
const DECENT_HOLD_THRESHOLD := 7
const SIDE_FLOWER_CHANCE := 0.1

# effectively a const but const doesn't get along with PackedFloat32Array for some reason
var normal_atlas_region_weights := PackedFloat32Array([1.0, 0.1, 0.1, 0.1])

var hold_strength := 0
var cell_x := 0
var cell_y := 0

func _on_cell_l_clicked() -> void:
	cell_l_clicked.emit($".")

func _on_cell_r_clicked() -> void:
	cell_r_clicked.emit($".")

func get_rect() -> Rect2:
	return $BaseTreeSprite.get_rect()

func set_atlas_regions(atlas: Texture2D) -> void:
	var base_atlas_region := AtlasTexture.new()
	base_atlas_region.atlas = atlas
	base_atlas_region.region = NORMAL_ATLAS_REGIONS[rng.rand_weighted(normal_atlas_region_weights)]
	$BaseTreeSprite.texture = base_atlas_region
	
	var hold_atlas_region := AtlasTexture.new()
	hold_atlas_region.atlas = atlas
	if hold_strength >= GREAT_HOLD_THRESHOLD:
		hold_atlas_region.region = GREAT_HOLD_ATLAS_REGION
	elif hold_strength >= DECENT_HOLD_THRESHOLD:
		hold_atlas_region.region = DECENT_HOLD_ATLAS_REGION
	else:
		$HoldSprite.visible = false
	$HoldSprite.texture = hold_atlas_region

func set_side_sprite(atlas: Texture2D, side: String) -> void:
	var flower_chance := randf()
	var atlas_region := AtlasTexture.new()
	atlas_region.atlas = atlas
	if flower_chance <= SIDE_FLOWER_CHANCE:
		if side == "left":
			atlas_region.region = LEFT_FLOWER_ATLAS_REGION
		else:
			atlas_region.region = RIGHT_FLOWER_ATLAS_REGION
	else:
		if side == "left":
			atlas_region.region = LEFT_NORMAL_ATLAS_REGION
		else:
			atlas_region.region = RIGHT_NORMAL_ATLAS_REGION
	$BaseTreeSprite.texture = atlas_region
	$HoldSprite.visible = false
	hold_strength = 0
