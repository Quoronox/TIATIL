extends Area3D

@export var trauma_amount := 0.1
@export var use_custom_trauma_amount : bool = false

func cause_trauma(custom_trauma_amount: float = 0.0):
#	print(self.get_parent())
	#print("trauma activated")
	var trauma_areas := get_overlapping_areas()
	for area in trauma_areas:
		#print(area)
		if area.get_parent().has_method("add_trauma"):
			#print("started add trauma")
#			print(area)
			if use_custom_trauma_amount:
				area.get_parent().add_trauma(custom_trauma_amount)
			else:
				area.get_parent().add_trauma(trauma_amount)
