
-- Table to store main character general information
CREATE TABLE MainCharacters (
    CharacterID SERIAL PRIMARY KEY,
    PlayerID INT,
    Name VARCHAR(255),
    Level INT,
    Health INT,
    Experience INT,
    Strength INT,
    Intelligence INT,
    Stamina INT,
    Currency INT,
    Inventory JSON,
    FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID)  
);

-- Table to create AI Companion
CREATE TABLE AICompanion (
    CompanionID SERIAL PRIMARY KEY,
    CharacterID INT,
    Type VARCHAR(255),
    Health INT,
    AttackPower INT,
    Defense INT,
    SpecialAbilities JSON,
    FOREIGN KEY (CharacterID) REFERENCES MainCharacters(CharacterID)
);

-- Table to create and store enemy information
CREATE TABLE Enemies (
    EnemyID SERIAL PRIMARY KEY,
    Name VARCHAR(255),
    Type VARCHAR(100),
    Health INT,
    Damage INT,
    Defense INT,
    LootDrop INT REFERENCES Items(ItemID),
);

-- Table to create and store items 
CREATE TABLE Items (
    ItemID SERIAL PRIMARY KEY,
    Name VARCHAR(255),
    Type VARCHAR(100),
    Description TEXT,
    Damage INT,
    HealthRestore INT,
    Rarity VARCHAR(50),
    UseEffect TEXT
);

-- Table to create and store main characters abilities
CREATE TABLE Abilities (
    CharacterID int,
);

CREATE TABLE Enemy_Abilities (
    EnemyID int,
);