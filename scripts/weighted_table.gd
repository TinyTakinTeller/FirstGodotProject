class_name WeightedTable

var items: Array[Dictionary] = []
var weight_sum: int = 0


func add_item(scene: PackedScene, weight: int) -> void:
	self.items.append({"scene": scene, "weight": weight})
	self.weight_sum += weight


func remove_item(scene: PackedScene, weight: int) -> void:
	self.items = self.items.filter(func (item): return item["scene"] != scene)
	self.weight_sum -= weight


func pick_item() -> PackedScene:
	var chosen_weight = randi_range(1, self.weight_sum)
	var iteration_sum: int = 0
	for item in self.items:
		iteration_sum += item["weight"]
		if chosen_weight <= iteration_sum:
			return item["scene"]
	return null

