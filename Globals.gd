extends Node

signal change_rooms(dir)

func _init() -> void:
	seed("Howard Bison Madness".hash())


const N = 1
const S = 2
const E = 4
const W = 8
const IN = 0x10
const DX = {E: 1, W: -1, N: 0, S: 0}
const DY = {E: 0, W: 0, N: -1, S: 1}
const OPPOSITE = {E: W, W: E, N: S, S: N}
const DIRECTIONS = [N,E,S,W]
#ProjectSettings.get_setting("display/window/size/viewport_width")
#ProjectSettings.get_setting("display/window/size/viewport_height")
const TILE_SIZE = 48
const ROOM_W_TILES = 20
const ROOM_H_TILES = 15
const ROOM_W = ROOM_W_TILES * TILE_SIZE
const ROOM_H = ROOM_H_TILES * TILE_SIZE
