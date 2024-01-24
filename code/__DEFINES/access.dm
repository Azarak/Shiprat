// Access category defines
#define ACCESS_CATEGORY_LAST_LOADED "LASTLOADED"
#define ACCESS_CATEGORY_DEFAULT "DEFAULT"
#define ACCESS_CATEGORY_STATION "Station"

// Security equipment, security records, gulag item storage, secbots
#define ACCESS_SECURITY 1
/// Brig cells+timers, permabrig, gulag+gulag shuttle, prisoner management console
#define ACCESS_BRIG 2
/// Armory, gulag teleporter, execution chamber
#define ACCESS_ARMORY 3
///Detective's office, forensics lockers, security+medical records
#define ACCESS_FORENSICS_LOCKERS 4
/// Medical general access
#define ACCESS_MEDICAL 5
/// Morgue access
#define ACCESS_MORGUE 6
/// R&D department and R&D console
#define ACCESS_RND 7
/// Toxins lab and burn chamber
#define ACCESS_TOXINS 8
/// Genetics access
#define ACCESS_GENETICS 9
/// Engineering area, power monitor, power flow control console
#define ACCESS_ENGINE 10
///APCs, EngiVend/YouTool, engineering equipment lockers
#define ACCESS_ENGINE_EQUIP 11
#define ACCESS_MAINT_TUNNELS 12
#define ACCESS_EXTERNAL_AIRLOCKS 13
#define ACCESS_CHANGE_IDS 15
#define ACCESS_AI_UPLOAD 16
#define ACCESS_TELEPORTER 17
#define ACCESS_EVA 18
/// Bridge, EVA storage windoors, gateway shutters, AI integrity restorer, comms console
#define ACCESS_HEADS 19
#define ACCESS_CAPTAIN 20
#define ACCESS_ALL_PERSONAL_LOCKERS 21
#define ACCESS_CHAPEL_OFFICE 22
#define ACCESS_TECH_STORAGE 23
#define ACCESS_ATMOSPHERICS 24
#define ACCESS_BAR 25
#define ACCESS_JANITOR 26
#define ACCESS_CREMATORIUM 27
#define ACCESS_KITCHEN 28
#define ACCESS_ROBOTICS 29
#define ACCESS_RD 30
#define ACCESS_CARGO 31
#define ACCESS_CONSTRUCTION 32
///Allows access to chemistry factory areas on compatible maps
#define ACCESS_CHEMISTRY 33
#define ACCESS_HYDROPONICS 35
#define ACCESS_LIBRARY 37
#define ACCESS_LAWYER 38
#define ACCESS_VIROLOGY 39
#define ACCESS_CMO 40
#define ACCESS_QM 41
#define ACCESS_COURT 42
#define ACCESS_SURGERY 45
#define ACCESS_THEATRE 46
#define ACCESS_RESEARCH 47
#define ACCESS_MINING 48
#define ACCESS_MAILSORTING 50
#define ACCESS_VAULT 53
#define ACCESS_MINING_STATION 54
#define ACCESS_XENOBIOLOGY 55
#define ACCESS_CE 56
#define ACCESS_HOP 57
#define ACCESS_HOS 58
/// Request console announcements
#define ACCESS_RC_ANNOUNCE 59
/// Used for events which require at least two people to confirm them
#define ACCESS_KEYCARD_AUTH 60
/// has access to the entire telecomms satellite / machinery
#define ACCESS_TCOMSAT 61
#define ACCESS_GATEWAY 62
/// Outer brig doors, department security posts
#define ACCESS_SEC_DOORS 63
/// For releasing minerals from the ORM
#define ACCESS_MINERAL_STOREROOM 64
#define ACCESS_MINISAT 65
/// Weapon authorization for secbots
#define ACCESS_WEAPONS 66
/// NTnet diagnostics/monitoring software
#define ACCESS_NETWORK 67
/// Pharmacy access (Chemistry room in Medbay)
#define ACCESS_PHARMACY 69 ///Nice.
#define ACCESS_PSYCHOLOGY 70
/// Toxins tank storage room access
#define ACCESS_TOXINS_STORAGE 71
/// Room and launching.
#define ACCESS_AUX_BASE 72


#define ALL_STATION_ACCESSES list( \
	ACCESS_SECURITY, \
	ACCESS_BRIG, \
	ACCESS_ARMORY, \
	ACCESS_FORENSICS_LOCKERS, \
	ACCESS_MEDICAL, \
	ACCESS_MORGUE, \
	ACCESS_RND, \
	ACCESS_TOXINS, \
	ACCESS_GENETICS, \
	ACCESS_ENGINE, \
	ACCESS_ENGINE_EQUIP, \
	ACCESS_MAINT_TUNNELS, \
	ACCESS_EXTERNAL_AIRLOCKS, \
	ACCESS_CHANGE_IDS, \
	ACCESS_AI_UPLOAD, \
	ACCESS_TELEPORTER, \
	ACCESS_EVA, \
	ACCESS_HEADS, \
	ACCESS_CAPTAIN, \
	ACCESS_ALL_PERSONAL_LOCKERS, \
	ACCESS_CHAPEL_OFFICE, \
	ACCESS_TECH_STORAGE, \
	ACCESS_ATMOSPHERICS, \
	ACCESS_BAR, \
	ACCESS_JANITOR, \
	ACCESS_CREMATORIUM, \
	ACCESS_KITCHEN, \
	ACCESS_ROBOTICS, \
	ACCESS_RD, \
	ACCESS_CARGO, \
	ACCESS_CONSTRUCTION, \
	ACCESS_CHEMISTRY, \
	ACCESS_HYDROPONICS, \
	ACCESS_LIBRARY, \
	ACCESS_LAWYER, \
	ACCESS_VIROLOGY, \
	ACCESS_CMO, \
	ACCESS_QM, \
	ACCESS_COURT, \
	ACCESS_SURGERY, \
	ACCESS_THEATRE, \
	ACCESS_RESEARCH, \
	ACCESS_MINING, \
	ACCESS_MAILSORTING, \
	ACCESS_VAULT, \
	ACCESS_MINING_STATION, \
	ACCESS_XENOBIOLOGY, \
	ACCESS_CE, \
	ACCESS_HOP, \
	ACCESS_HOS, \
	ACCESS_RC_ANNOUNCE, \
	ACCESS_KEYCARD_AUTH, \
	ACCESS_TCOMSAT, \
	ACCESS_GATEWAY, \
	ACCESS_SEC_DOORS, \
	ACCESS_MINERAL_STOREROOM, \
	ACCESS_MINISAT, \
	ACCESS_WEAPONS, \
	ACCESS_NETWORK, \
	ACCESS_PHARMACY, \
	ACCESS_PSYCHOLOGY, \
	ACCESS_TOXINS_STORAGE, \
	ACCESS_AUX_BASE, \
)

// Remove this at earliest convinience
// Mech Access, allows maintanenace of internal components and altering keycard requirements.
#define ACCESS_MECH_MINING 300
#define ACCESS_MECH_MEDICAL 301
#define ACCESS_MECH_SECURITY 302
#define ACCESS_MECH_SCIENCE 303
#define ACCESS_MECH_ENGINE 304
