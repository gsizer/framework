extends Node3D

###
# arrays for description generation and Markdown in visible text
###
static var Colors = ["Grey", "Green", "Blue", "Purple", "Red", "Orange", "Yellow", "Magenta"]
enum { Grey=0xcccccc, Green=0x00cc00, Blue=0x0000cc, Purple=0xcc00cc, Red=0xcc0000, Orange=0xff9900, Yellow=0xcccc00, Magneta=0xff00ff }

static var RarityName = ["Common", "Uncommon", "Rare", "Epic", "Legendary", "Artifact", "Celestial" ]
enum { Common=0, Uncommon=1, Rare=2, Epic=3, Legendary=4, Artifact=5, Celestial=6, DevOp=7 }

static var CategoryType = ["Armor", "Food", "Storage", "Tool", "Weapon", "System" ]
enum { Armor=0, Food=1, Storage=2, Tool=3, Weapon=4, System=5 }

static var DamageType = ["Blunt", "Energy", "Piercing", "Slashing" ]
enum { Blunt=0, Energy=1, Piercing=2, Slashing=3 }

static var InventorySlot = ["Head", "Arms", "Torso", "Primary", "OffHand", "Legs", "Feet", "Back", "Pockets" ]
enum { Head=0, Arms=1, Torso=2, Primary=3, Offhand=4, Legs=5, Feet=6, Back=7, Pockets=8 }

###
# dictionaries for items by itemtype
###
var Armors : Dictionary = {}
var Foods : Dictionary = {}
var Inventories : Dictionary = {}
var Storages : Dictionary = {}
var Systems : Dictionary = {}
var Tools : Dictionary = {}
var Weapons : Dictionary = {}

###
# Template GameItem Dictionary
###
var ItemBase : Dictionary = {
	"Name":"",
	"Rarity":RarityName[0],
	"CategoryType":CategoryType[0],
	"DamageType":DamageType[0],
	"Damage":0,
	"Defense":0,
	"InventorySlot":InventorySlot[0],
	"Description":""
}

###
# Player Inventory and Equipment
###
var PlayerInventory : Dictionary = {}

###
# Destructively sets PlayerInventory to empty slots
###
func ClearInventory()->void:
	PlayerInventory.clear()
	PlayerInventory.get_or_add("Head", null)
	PlayerInventory.get_or_add("Arms", null)
	PlayerInventory.get_or_add("Torso", null)
	PlayerInventory.get_or_add("Primary", null)
	PlayerInventory.get_or_add("Offhand", null)
	PlayerInventory.get_or_add("Legs", null)
	PlayerInventory.get_or_add("Feet", null)
	PlayerInventory.get_or_add("Back", null)
	PlayerInventory.get_or_add("Pockets", null)

###
# equip the given item and return the replaced item
###
func Equip(newItem:Dictionary)->Dictionary:
	var slot = newItem.get("InventorySlot")
	var replacedItem = PlayerInventory.get(slot)
	PlayerInventory.erase(slot)
	PlayerInventory.get_or_add(slot, newItem)
	return replacedItem

func _ready() -> void:
	ClearInventory()
