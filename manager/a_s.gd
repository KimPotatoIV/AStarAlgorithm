extends Node

##################################################
var g_score: int = 0
# Start부터 Current 노드까지 비용 변수
var h_score: int = INF
# Current부터 End 노드까지 비용 변수

var open_list: Array = []
# 열린(방문 가능한) 노드 배열 변수. 방문 가능한 이웃 노드
var closed_list: Array = []
# 닫힌(이미 방문한) 노드 배열 변수. 중복 방문을 피하기 위함

var current_node: Vector2i
# 현재 노드
var start_node: Vector2i
# 시작 노드
var end_node: Vector2i
# 종료 노드

##################################################
func find_path(board_value: Array, path_value: Array) -> bool:
# 경로를 찾고 연산 중인지 여부 반환하는 함수
	var generating_value = true
	# 연산 중인지 여부를 반환하기 위한 변수
	
	if path_value.is_empty():
	# path_value가 없다면(첫 연산이라면)
		generating_value = true
		# 연산 중 설정
		for i in range(board_value.size()):
			for j in range(board_value[i].size()):
		# board를 순회하며
				if board_value[i][j].state == GM.TILE_STATE.START:
					start_node = Vector2i(j, i)
				elif board_value[i][j].state == GM.TILE_STATE.END:
					end_node = Vector2i(j, i)
				# Start, End 노드 설정
		
		current_node = start_node
		# 현재 노드를 start_node로 설정
		path_value.append(current_node)
		# path_value에 추가
		closed_list.append(current_node)
		# 닫힌 노드 목록에 추가
	else:
	# 첫 연산이 아니라면
		if current_node == end_node:
		# 현재 노드가 종료 노드라면(길을 찾았다면)
			generating_value = false
			# 연산 종료
		else:
		# 아직 길을 못 찾았다면
			generating_value = true
			# 연산 중
			
			var neighbor_node: Vector2i
			# 네 방향의 이웃 노드 저장용 변수
			open_list.clear()
			# 열린 노드 배열 초기화
			
			neighbor_node = Vector2i(current_node.x, current_node.y - 1)
			# 현재 노드에서 위쪽
			if is_valid_neighbor_node(board_value, neighbor_node):
			# 유효한 노드인지 확인
				open_list.append(neighbor_node)
				# 유효하므로 열린 노드 배열에 추가
			
			neighbor_node = Vector2i(current_node.x, current_node.y + 1)
			# 현재 노드에서 아래쪽
			if is_valid_neighbor_node(board_value, neighbor_node):
			# 유효한 노드인지 확인
				open_list.append(neighbor_node)
				# 유효하므로 열린 노드 배열에 추가
			
			neighbor_node = Vector2i(current_node.x - 1, current_node.y)
			# 현재 노드에서 왼쪽
			if is_valid_neighbor_node(board_value, neighbor_node):
			# 유효한 노드인지 확인
				open_list.append(neighbor_node)
				# 유효하므로 열린 노드 배열에 추가
					
			neighbor_node = Vector2i(current_node.x + 1, current_node.y)
			# 현재 노드에서 오른쪽
			if is_valid_neighbor_node(board_value, neighbor_node):
			# 유효한 노드인지 확인
				open_list.append(neighbor_node)
				# 유효하므로 열린 노드 배열에 추가
			
			if open_list.is_empty():
			# 추가된 노드가 없다면(방문 가능한 이웃 노드가 없다면)
				path_value.pop_back()
				# path_value 마지막 인자 제거
				if not path_value.is_empty():
				# path_value가 비어있지 않다면(Start에서 더 찾지 못하는 상태가 아니라면)
					current_node = path_value.back()
					# current_node를 path_value의 마지막 인자로 설정
					g_score -= 1
					#g_score 1 감소
				else:
				# 더 이상 길을 찾지 못하는 상태라면
					generating_value = false
					return generating_value
					# 연산 종료 설정 후 반환
			else:
			# 방문 가능한 이웃 노드가 있다면
				var min_f_score_node = open_list.front()
				for node in open_list:
					if get_f_score(node) < get_f_score(min_f_score_node):
						min_f_score_node = node
				# f_score가 가장 낮은 노드를 찾음
				
				current_node = min_f_score_node
				# 찾은 노드를 현재 노드로 설정
				path_value.append(current_node)
				closed_list.append(current_node)
				g_score += 1
				# 각 변수 설정 및 g_score 1 증가
	
	return generating_value
	# 연산 중 여부 값 반환

##################################################
func is_valid_neighbor_node(board_value: Array, node_value: Vector2i) -> bool:
# 유효한 노드인지 확인하는 함수
	var return_value = false
	# 유효 여부 반환 변수
	
	if node_value.x >= 0 and node_value.y >= 0 and \
			node_value.x < board_value.size() and node_value.y < board_value.size():
	# 좌표가 화면 내에 있다면
				if not board_value[node_value.x][node_value.y].state == GM.TILE_STATE.OBSTACLE:
				# 장애물 상태가 아니라면
					if not closed_list.has(Vector2i(node_value.x, node_value.y)):
					# 닫힌 노드와 중복되지 않는다면
						return_value = true
						# 유효
	
	return return_value
	# 유효 여부 반환

##################################################
func get_f_score(current_node_value: Vector2i) -> float:
	h_score = \
	#abs(end_node.x - current_node_value.x) + abs(end_node.y - current_node_value.y)
	# 위는 맨해튼 거리 방식으로 연산
	sqrt(pow(end_node.x - current_node_value.x, 2) + pow(end_node.y - current_node_value.y, 2))
	# 위는 유클리드 거리 방식으로 연산
	
	return g_score + h_score
	# f_score 반환

##################################################
func reset() -> void:
# 초기화 함수
	g_score = 0
	h_score = INF
	open_list.clear()
	closed_list.clear()
	# 각 변수 초기화
