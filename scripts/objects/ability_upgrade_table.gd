class_name AbilityUpgradeTable

var items: Array[AbilityUpgrade] = []
var weight_sum: int = 0


func is_empty() -> bool:
	return items.is_empty()


func add_item(ability_upgrade: AbilityUpgrade) -> void:
	self.items.append(ability_upgrade)
	self.weight_sum += ability_upgrade.weight


func remove_item(ability_upgrade: AbilityUpgrade) -> void:
	self.items = self.items.filter(
		func(e: AbilityUpgrade) -> bool: return e.id != ability_upgrade.id
	)
	self.weight_sum -= ability_upgrade.weight


func pick_item(exclude: Array[AbilityUpgrade] = []) -> AbilityUpgrade:
	var adjusted_items: Array[AbilityUpgrade] = self.items
	var adjusted_weight_sum: int = self.weight_sum
	if exclude.size() > 0:
		adjusted_items = []
		adjusted_weight_sum = 0
		for item in items:
			if item in exclude:
				continue
			adjusted_items.append(item)
			adjusted_weight_sum += item.weight

	var chosen_weight: int = randi_range(1, adjusted_weight_sum)
	var iteration_sum: int = 0
	for ability_upgrade in adjusted_items:
		iteration_sum += ability_upgrade.weight
		if chosen_weight <= iteration_sum:
			return ability_upgrade
	return null


func pick_items(count: int) -> Array[AbilityUpgrade]:
	if count >= items.size():
		return items

	var picked: Array[AbilityUpgrade] = []
	for n in range(count):
		picked.append(self.pick_item(picked))
	return picked
