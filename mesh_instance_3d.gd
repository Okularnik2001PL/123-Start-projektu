extends MeshInstance3D
var viewport
var viewport_texture
var material
func _ready():
	# Uzyskujemy dostęp do Viewport
	viewport = $MeshInstance3D  # Zakładamy, że MyViewport to twój Viewport
	
	# Uzyskujemy ViewportTexture z Viewport
	viewport_texture = viewport.get_texture()
	
	# Tworzymy nowy materiał SpatialMaterial
	material = StandardMaterial3D.new()
	
	# Przypisujemy ViewportTexture jako Albedo Texture
	material.albedo_texture = viewport_texture
	
	# Przypisujemy nowy materiał do MeshInstance
	self.set_surface_override_material(0, material)
func _process(delta: float) -> void:
	viewport_texture = viewport.get_texture()
	# Przypisujemy ViewportTexture jako Albedo Texture
	material.albedo_texture = viewport_texture
	# Przypisujemy nowy materiał do MeshInstance
	self.set_surface_override_material(0, material)
	print("wykonane")
