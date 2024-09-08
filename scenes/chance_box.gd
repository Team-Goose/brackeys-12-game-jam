class_name ChanceBox extends Node2D

var rng = RandomNumberGenerator.new()

const NORMAL_ATLAS_REGIONS := [
	Rect2(0, 0, 32, 32),
	Rect2(32, 0, 32, 32),
	Rect2(0, 32, 32, 32),
	Rect2(160, 32, 32, 32),
]
const DECENT_HOLD_ATLAS_REGION := Rect2(192, 0, 32, 32)
const GREAT_HOLD_ATLAS_REGION := Rect2(192, 32, 32, 32)

var hold_strength := 0.0
var normal_atlas_region_weights := PackedFloat32Array([1.0, 0.1, 0.1, 0.1])

func get_rect() -> Rect2:
	return $BaseTreeSprite.get_rect()

func set_atlas_regions(atlas: Texture2D) -> void:
	var base_atlas_region := AtlasTexture.new()
	base_atlas_region.atlas = atlas
	base_atlas_region.region = NORMAL_ATLAS_REGIONS[rng.rand_weighted(normal_atlas_region_weights)]
	$BaseTreeSprite.texture = base_atlas_region
	
	var hold_atlas_region := AtlasTexture.new()
	hold_atlas_region.atlas = atlas
	if hold_strength >= 9:
		hold_atlas_region.region = GREAT_HOLD_ATLAS_REGION
	elif hold_strength >= 7:
		hold_atlas_region.region = DECENT_HOLD_ATLAS_REGION
	else:
		$HoldSprite.visible = false
	$HoldSprite.texture = hold_atlas_region
