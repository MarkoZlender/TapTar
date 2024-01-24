extends TileMap

@onready var aStar:AStar2D

@onready var non_walkable_tiles = Array()
@onready var size = self.get_used_rect().size


# Called when the node enters the scene tree for the first time.
func _ready():
	get_non_walkable_tiles()
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

	var HEX_NEIGHBORS_EVEN = [
        Vector2i(0, -1), Vector2i(1, 0), Vector2i(1, 1),
        Vector2i(0, 1), Vector2i(-1, 1), Vector2i(-1, 0)
    ]

	var HEX_NEIGHBORS_ODD = [
        Vector2i(0, -1), Vector2i(1, -1), Vector2i(1, 0),
        Vector2i(0, 1), Vector2i(-1, 0), Vector2i(-1, -1)
    ]
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
				for neighbor in range(6):
					var neighbor_offset = Vector2i()
					if j % 2 == 0:
						neighbor_offset = Vector2i(i + HEX_NEIGHBORS_EVEN[neighbor].x, j + HEX_NEIGHBORS_EVEN[neighbor].y)
					else:
						neighbor_offset = Vector2i(i + HEX_NEIGHBORS_ODD[neighbor].x, j + HEX_NEIGHBORS_ODD[neighbor].y)
					var idx_neighbor = getAStarCellId(neighbor_offset)
					if aStar.has_point(idx_neighbor) and not neighbor_offset in non_walkable_tiles:
						aStar.connect_points(idx, idx_neighbor, false) # bidirectional = false

func occupyAStarCell(vGlobalPosition:Vector2i)->void:
	var idx:int = aStar.get_closest_point(vGlobalPosition, true)

	if aStar.has_point(idx):aStar.set_point_disabled(idx, true)
	
func freeAStarCell(vGlobalPosition:Vector2i)->void:
	var idx:int = aStar.get_closest_point(vGlobalPosition, true)

	if aStar.has_point(idx):aStar.set_point_disabled(idx, false)

func getAStarPath(vStartPosition:Vector2i,vTargetPosition:Vector2i)->Array:
	var vCellStart = local_to_map(vStartPosition)
	var idxStart = getAStarCellId(vCellStart)
	var vCellTarget = local_to_map(vTargetPosition)
	var idxTarget = getAStarCellId(vCellTarget)

	# Just a small check to see if both points are in the grid
	if aStar.has_point(idxStart) and aStar.has_point(idxTarget):
		return Array(aStar.get_point_path(idxStart, idxTarget))
	return Array()
