extends Node2D

var enabled = true

@onready var point_light_2d_sp = $PointLight2D_sp
@onready var point_light_2d_sp_3 = $PointLight2D_sp3
@onready var point_light_2d_sp_4 = $PointLight2D_sp4
@onready var point_light_2d_sp_2 = $PointLight2D_sp2

func _physics_process(delta):
	point_light_2d_sp.enabled = enabled
	point_light_2d_sp_3.enabled = enabled
	point_light_2d_sp_4.enabled = enabled
	point_light_2d_sp_2.enabled = enabled
