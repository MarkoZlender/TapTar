extends TileMap

@onready var aStar:AStar2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var size = self.get_used_rect().size
	aStar = AStar2D.new()
	aStar.reserve_space(size.x * size.y)
	aStarStart()

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func getAStarCellId(vCell:Vector2)->int:
	return int(vCell.y+vCell.x*self.get_used_rect().size.y)

func aStarStart()->void:
	pass
	# var size=self.get_used_rect().size
	# aStar=AStar2D.new()
	# aStar.reserve_space(size.x * size.y)
	# # Creates AStar grid
	# for i in size.x:
	# 	for j in size.y:
	# 		var idx=getAStarCellId(Vector2(i,j))
	# 		aStar.add_point(idx, map_to_local(Vector2(i,j)))
	# # Fills AStar grid with info about valid tiles
	# for i in size.x:
	# 	for j in size.y:
	# 		if get_cellv(Vector2(i,j))!=-1:
	# 			var idx=getAStarCellId(Vector2(i,j))
	# 			for vNeighborCell in [Vector2(i,j-1),Vector2(i,j+1),Vector2(i-1,j),Vector2(i+1,j)]:
	# 				var idxNeighbor=getAStarCellId(vNeighborCell)
	# 				if aStar.has_point(idxNeighbor) and not vNeighborCell in aSolidCells:
	# 					aStar.connect_points(idx, idxNeighbor, false)
