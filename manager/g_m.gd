extends Node

##################################################
enum TILE_STATE {
	EMPTY,
	MOUSE_OVER,
	START,
	END,
	OBSTACLE,
	PATH
}
# 타일 상태 값 열겨형 변수

var is_dragging: bool = false
# 마우스 드래그 중인지 여부 변수

##################################################
func get_is_dragging() -> bool:
	return is_dragging

##################################################
func set_is_dragging(is_dragging_value: bool) -> void:
	is_dragging = is_dragging_value
