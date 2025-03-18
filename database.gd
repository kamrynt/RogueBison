extends Node

var connection = null
var connected = false

# Database configuration
const DB_HOST = "localhost"
const DB_PORT = 5432
const DB_NAME = "roguebison"
const DB_USER = "postgres"
const DB_PASSWORD = "lola"  # Change this to your actual password

func _ready():
	connect_to_database()

func connect_to_database():
	# Create a new connection
	connection = PostgreSQL.new()
	
	# Connect to the database
	var result = connection.connect_to_host(DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD)
	
	if result == OK:
		connected = true
		print("Successfully connected to PostgreSQL database")
	else:
		print("Failed to connect to PostgreSQL database")

# MainCharacter table operations
func create_new_character(player_id: String, name: String) -> bool:
	if not connected:
		return false
		
	# Base stats similar to Binding of Isaac
	var base_stats = {
		"level": 1,
		"health": 6,  # Similar to Isaac's 6 hearts
		"experience": 0,
		"strength": 5,  # Base damage stat
		"intelligence": 5,  # Base magic/ability stat
		"stamina": 5,  # Base speed/movement stat
		"currency": 0,  # Starting with 0 coins
		"inventory": "[]"  # Empty inventory as JSON string
	}
	
	var query = """
	INSERT INTO MainCharacter (PlayerID, Name, Level, Health, Experience, Strength, Intelligence, Stamina, Currency, Inventory)
	VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
	"""
	
	var params = [
		player_id,
		name,
		base_stats.level,
		base_stats.health,
		base_stats.experience,
		base_stats.strength,
		base_stats.intelligence,
		base_stats.stamina,
		base_stats.currency,
		base_stats.inventory
	]
	
	var result = connection.query(query, params)
	return result == OK

func get_character(character_id: int) -> Dictionary:
	if not connected:
		return {}
		
	var query = """
	SELECT * FROM MainCharacter WHERE CharacterID = $1
	"""
	
	var params = [character_id]
	var result = connection.query(query, params)
	
	if result == OK:
		var data = connection.get_result()
		if data.size() > 0:
			return data[0]
	return {}

func update_character_stats(character_id: int, stats: Dictionary) -> bool:
	if not connected:
		return false
		
	var query = """
	UPDATE MainCharacter 
	SET Level = $1, Health = $2, Experience = $3, Strength = $4, 
		Intelligence = $5, Stamina = $6, Currency = $7, Inventory = $8
	WHERE CharacterID = $9
	"""
	
	var params = [
		stats.get("level", 1),
		stats.get("health", 6),
		stats.get("experience", 0),
		stats.get("strength", 5),
		stats.get("intelligence", 5),
		stats.get("stamina", 5),
		stats.get("currency", 0),
		stats.get("inventory", "[]"),
		character_id
	]
	
	var result = connection.query(query, params)
	return result == OK

func get_player_characters(player_id: String) -> Array:
	if not connected:
		return []
		
	var query = """
	SELECT * FROM MainCharacter WHERE PlayerID = $1
	"""
	
	var params = [player_id]
	var result = connection.query(query, params)
	
	if result == OK:
		return connection.get_result()
	return []

func delete_character(character_id: int) -> bool:
	if not connected:
		return false
		
	var query = """
	DELETE FROM MainCharacter WHERE CharacterID = $1
	"""
	
	var params = [character_id]
	var result = connection.query(query, params)
	
	return result == OK

func _exit_tree():
	if connection:
		connection.close() 