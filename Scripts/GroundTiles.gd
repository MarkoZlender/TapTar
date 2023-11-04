extends TileMap

@onready var aStar:AStar2D

@onready var non_walkable_tiles = Array()
@onready var size = self.get_used_rect().size
@onready var legion_neighbours =  Array()

# Called when the node enters the scene tree for the first time.
func _ready():
	#size = self.get_used_rect().size
	get_non_walkable_tiles()
	print(non_walkable_tiles)
	aStarStart()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func getAStarCellId(vCell:Vector2i)->int:
	return int(vCell.y + vCell.x * self.get_used_rect().size.y)

func get_non_walkable_tiles():
	# get all used cells on layer 0
	var all_cells = get_used_cells(0)

	for cell in all_cells:
		var cell_pos = map_to_local(cell)
		var tile_data: TileData = self.get_cell_tile_data(0, cell)
		var tile_wakable: bool = tile_data.get_custom_data("walkable")
		if not tile_wakable:
			non_walkable_tiles.append(local_to_map(cell_pos))

	return non_walkable_tiles

func aStarStart()->void:
	size = self.get_used_rect().size
	aStar = AStar2D.new()
	aStar.reserve_space(size.x * size.y)
	# Creates AStar grid
	for i in size.x:
		for j in size.y:
			var idx=getAStarCellId(Vector2i(i,j))
			aStar.add_point(idx, map_to_local(Vector2i(i,j)))
	# Fills AStar grid with info about valid tiles
	for i in size.x:
		for j in size.y:
			if get_cell_source_id(0, Vector2i(i,j)) != -1:
				var idx=getAStarCellId(Vector2i(i,j))
				for vNeighborCell in [Vector2i(i,j-1),Vector2i(i,j+1),Vector2i(i-1,j),Vector2i(i+1,j),Vector2i(i-1,j-1),Vector2i(i+1,j-1),Vector2i(i-1,j+1),Vector2i(i+1,j+1)]:
					var idxNeighbor = getAStarCellId(vNeighborCell)
					if aStar.has_point(idxNeighbor) and not vNeighborCell in non_walkable_tiles:
						aStar.connect_points(idx, idxNeighbor, false)

func occupyAStarCell(vGlobalPosition:Vector2i)->void:
	var vCell := self.local_to_map(vGlobalPosition)
	var idx := getAStarCellId(vCell)

	if aStar.has_point(idx):
		aStar.set_point_disabled(idx, true)
	
func freeAStarCell(vGlobalPosition:Vector2i)->void:
	var vCell := self.map_to_local(vGlobalPosition)
	var idx := getAStarCellId(vCell)

	if aStar.has_point(idx):
		aStar.set_point_disabled(idx, false)

func getAStarPath(vStartPosition:Vector2i,vTargetPosition:Vector2i)->Array:
	var vCellStart = local_to_map(vStartPosition)
	var idxStart = getAStarCellId(vCellStart)
	var vCellTarget = local_to_map(vTargetPosition)
	var idxTarget = getAStarCellId(vCellTarget)

	print("vCellStart: ",vCellStart, " idxStart: ",idxStart, " vCellTarget: ",vCellTarget, " idxTarget: ",idxTarget)

	# Just a small check to see if both points are in the grid
	if aStar.has_point(idxStart) and aStar.has_point(idxTarget):
		return Array(aStar.get_point_path(idxStart, idxTarget))
	return Array()
