/**
 *	Functions.
 */
ConVar TF2_DeathClass[10];

ConVar TF2_SentryKill;
ConVar TF2_MiniSentryKill;

ConVar TF2_PointCaptured;
ConVar TF2_PointBlocked;

ConVar TF2_FlagEvent[6];
ConVar TF2_FlagStolen;

/**
 *	Initializes includes for this game.
 */
#include	"xstats/game/tf/database.sp"
#include	"xstats/game/tf/events.sp"
#include	"xstats/game/tf/callbacks.sp"

/**
 *	Initialize: Team Fortress 2.
 */
void PrepareGame_TF2()	{
	//Weapon cvars
	Weapon[0]	= CreateConVar("xstats_weapon_bat",					"10",	"xStats: TF2 - Points given when killing with Bat.", _, true, 0.0);
	Weapon[1]	= CreateConVar("xstats_weapon_bottle",				"10",	"xStats: TF2 - Points given when killing with Bottle.", _, true, 0.0);
	Weapon[2]	= CreateConVar("xstats_weapon_fireaxe",				"10",	"xStats: TF2 - Points given when killing with Fire Axe.", _, true, 0.0);
	Weapon[3]	= CreateConVar("xstats_weapon_kukri",				"10",	"xStats: TF2 - Points given when killing with Kukri.", _, true, 0.0);
	Weapon[4]	= CreateConVar("xstats_weapon_knife",				"10",	"xStats: TF2 - Points given when killing with Knife.", _, true, 0.0);
	Weapon[5]	= CreateConVar("xstats_weapon_fists",				"10",	"xStats: TF2 - Points given when killing with Fists", _, true, 0.0);
	Weapon[6]	= CreateConVar("xstats_weapon_shovel",				"10",	"xStats: TF2 - Points given when killing with Shovel.", _, true, 0.0);
	Weapon[7]	= CreateConVar("xstats_weapon_wrench",				"10",	"xStats: TF2 - Points given when killing with Wrench.", _, true, 0.0);
	Weapon[8]	= CreateConVar("xstats_weapon_bonesaw",				"10",	"xStats: TF2 - Points given when killing with Bonesaw.", _, true, 0.0);
	Weapon[9]	= CreateConVar("xstats_weapon_shotgun",				"10",	"xStats: TF2 - Points given when killing with Shotgun.", _, true, 0.0);
	Weapon[10]	= Weapon[9];	//Same Shotgun, different TFClass type.
	Weapon[11]	= Weapon[9];	//Same Shotgun, different TFClass type.
	Weapon[12]	= Weapon[9];	//Same Shotgun, different TFClass type.
	Weapon[13]	= CreateConVar("xstats_weapon_scattergun",			"10",	"xStats: TF2 - Points given when killing with Scattergun.", _, true, 0.0);
	Weapon[14]	= CreateConVar("xstats_weapon_sniperrifle",			"10",	"xStats: TF2 - Points given when killing with Sniper Rifle.", _, true, 0.0);
	Weapon[15]	= CreateConVar("xstats_weapon_minigun",				"10",	"xStats: TF2 - Points given when killing with Minigun.", _, true, 0.0);
	Weapon[16]	= CreateConVar("xstats_weapon_smg",					"10",	"xStats: TF2 - Points given when killing with SMG.", _, true, 0.0);
	Weapon[17]	= CreateConVar("xstats_weapon_syringegun",			"10",	"xStats: TF2 - Points given when killing with Syringe Gun.", _, true, 0.0);
	Weapon[18]	= CreateConVar("xstats_weapon_rocketlauncher",		"10",	"xStats: TF2 - Points given when killing with Rocket Launcher.", _, true, 0.0);
	Weapon[19]	= CreateConVar("xstats_weapon_grenadelauncher",		"10",	"xStats: TF2 - Points given when killing with Grenade Launcher.", _, true, 0.0);
	Weapon[20]	= CreateConVar("xstats_weapon_stickybomblauncher",	"10",	"xStats: TF2 - Points given when killing with StickyBomb Launcher", _, true, 0.0);
	Weapon[21]	= CreateConVar("xstats_weapon_flamethrower",		"10",	"xStats: TF2 - Points given when killing with Flamethrower.", _, true, 0.0);
	Weapon[22]	= CreateConVar("xstats_weapon_pistol",				"10",	"xStats: TF2 - Points given when killing with Pistol.", _, true, 0.0);
	Weapon[23]	= Weapon[22];	//Same Pistol, different TFClass type.
	Weapon[24]	= CreateConVar("xstats_weapon_revolver",			"10",	"xStats: TF2 - Points given when killing with Revolver.", _, true, 0.0);
	Weapon[36]	= CreateConVar("xstats_weapon_blutsauger",			"10",	"xStats: TF2 - Points given when killing with Blutsauger.", _, true, 0.0);
	Weapon[37]	= CreateConVar("xstats_weapon_ubersaw",				"10",	"xStats: TF2 - Points given when killing with Ubersaw.", _, true, 0.0);
	Weapon[38]	= CreateConVar("xstats_weapon_axtinguisher",		"10",	"xStats: TF2 - Points given when killing with Axtinguisher.", _, true, 0.0);
	Weapon[39]	= CreateConVar("xstats_weapon_flaregun",			"10",	"xStats: TF2 - Points given when killing with Flaregun.", _, true, 0.0);
	Weapon[40]	= CreateConVar("xstats_weapon_backburner",			"10",	"xStats: TF2 - Points given when killing with Backburner.", _, true, 0.0);
	Weapon[41]	= CreateConVar("xstats_weapon_natascha",			"10",	"xStats: TF2 - Points given when killing with Natascha.", _, true, 0.0);
	Weapon[43]	= CreateConVar("xstats_weapon_killerglovesofboxing","10",	"xStats: TF2 - Points given when killing with Killer Gloves Of Boxing", _, true, 0.0);
	Weapon[44]	= CreateConVar("xstats_weapon_sandman",				"10",	"xStats: TF2 - Points given when killing with Sandman.", _, true, 0.0);
	Weapon[45]	= CreateConVar("xstats_weapon_forceanature",		"10",	"xStats: TF2 - Points given when killing with Force-A-Nature", _, true, 0.0);
	Weapon[56]	= CreateConVar("xstats_weapon_huntsman",			"10",	"xStats: TF2 - Points given when killing with Huntsman.", _, true, 0.0);
	Weapon[61]	= CreateConVar("xstats_weapon_ambassador",			"10",	"xStats: TF2 - Points given when killing with Ambassador.", _, true, 0.0);
	Weapon[127]	= CreateConVar("xstats_weapon_directhit",			"10",	"xStats: TF2 - Points given when killing with Direct-Hit.", _, true, 0.0);
	Weapon[128]	= CreateConVar("xstats_weapon_equalizer",			"10",	"xStats: TF2 - Points given when killing with Equalizer.", _, true, 0.0);
	Weapon[130]	= CreateConVar("xstats_weapon_scottishresistance",	"10",	"xStats: TF2 - Points given when killing with Scottish Resistance.", _, true, 0.0);
	Weapon[131]	= CreateConVar("xstats_weapon_chargentarge",		"10",	"xStats: TF2 - Points given when killing with Charge n' Targe", _, true, 0.0);
	Weapon[132]	= CreateConVar("xstats_weapon_eyelander",			"10",	"xStats: TF2 - Points given when killing with Eyelander.", _, true, 0.0);
	Weapon[140]	= CreateConVar("xstats_weapon_wrangler",			"10",	"xStats: TF2 - Points given when killing with Wrangler.", _, true, 0.0);
	Weapon[141]	= CreateConVar("xstats_weapon_frontierjustice",		"10",	"xStats: TF2 - Points given when killing with Frontier Justice.", _, true, 0.0);
	Weapon[142]	= CreateConVar("xstats_weapon_gunslinger",			"10",	"xStats: TF2 - Points given when killing with gunslinger.", _, true, 0.0);
	Weapon[153]	= CreateConVar("xstats_weapon_homewrecker",			"10",	"xStats: TF2 - Points given when killing with homewrecker.", _, true, 0.0);
	Weapon[154]	= CreateConVar("xstats_weapon_paintrain",			"10",	"xStats: TF2 - Points given when killing with pain train.", _, true, 0.0);
	Weapon[155]	= CreateConVar("xstats_weapon_southernhospitality",	"10",	"xStats: TF2 - Points given when killing with southern hospitality.", _, true, 0.0);
	Weapon[160]	= CreateConVar("xstats_weapon_lugermorph",			"10",	"xStats: TF2 - Points given when killing with lugermorph", _, true, 0.0);
	Weapon[161]	= CreateConVar("xstats_weapon_bigkill",				"10",	"xStats: TF2 - Points given when killing with big kill.", _, true, 0.0);
	Weapon[169]	= CreateConVar("xstats_weapon_wrench",				"10",	"xStats: TF2 - Points given when killing with wrench.", _, true, 0.0);
	Weapon[171]	= CreateConVar("xstats_weapon_tribalmansshiv",		"10",	"xStats: TF2 - Points given when killing with tribalman's shiv.", _, true, 0.0);
	Weapon[172]	= CreateConVar("xstats_weapon_scotsmansskullcutter","10",	"xStats: TF2 - Points given when killing with scotsman's skullcutter.", _, true, 0.0);
	Weapon[173]	= CreateConVar("xstats_weapon_vitasaw",				"10",	"xStats: TF2 - Points given when killing with vita saw.", _, true, 0.0);
	Weapon[190]	= Weapon[0];	//Same as default Bat, used for strange, renamed & skinned versions.
	Weapon[191]	= Weapon[1];	//Same as default Bottle, used for strange, renamed & skinned versions.
	Weapon[192]	= Weapon[2];	//Same as default Fire Axe, used for strange, renamed & skinned versions.
	Weapon[193]	= Weapon[3];	//Same as default Kukri, used for strange, renamed & skinned versions.
	Weapon[194]	= Weapon[4];	//Same as default Knife, used for australium, strange, renamed & skinned versions.
	Weapon[195]	= Weapon[5];	//Same as default Fists, used for strange & renamed version.
	Weapon[196]	= Weapon[6];	//Same as default Shovel, used for strange, renamed & skinned versions.
	Weapon[197]	= Weapon[7];	//Same as default Wrench, used for australium, strange, renamed & skinned versions.
	Weapon[198]	= Weapon[8];	//Same as default Bonesaw, used for strange, renamed & skinned versions.
	Weapon[199]	= Weapon[9];	//Same as default Shotgun, used for strange, renamed & skinned versions.
	Weapon[200]	= Weapon[13];	//Same as default Scattergun, used for australium, strange, renamed & skinned versions.
	Weapon[201]	= Weapon[14];	//Same as default Sniper Rifle, used for australium, strange, renamed & skinned versions.
	Weapon[202]	= Weapon[15];	//Same as default Minigun, used for australium, strange, renamed & skinned versions.
	Weapon[203]	= Weapon[16];	//Same as default SMG, used for australium, strange, renamed & skinned versions.
	Weapon[204]	= Weapon[17];	//Same as default Syringe gun, used for strange, renamed & skinned versions.
	Weapon[205]	= Weapon[18];	//Same as default Rocket Launcher, used for australium, strange, renamed & skinned versions.
	Weapon[206]	= Weapon[19];	//Same as default Grenade Launcher, used for australium, strange, renamed & skinned versions.
	Weapon[207]	= Weapon[20];	//Same as default Stickybomb Launcher, used for australium, strange, renamed & skinned versions.
	Weapon[208]	= Weapon[21];	//Same as default Flamethrower, used for australium, strange, renamed & skinned versions.
	Weapon[209]	= Weapon[22];	//Same as default Pistol, used for strange, renamed & skinned versions.
	Weapon[210]	= Weapon[24];	//Same as default Revolver, used for strange, renamed & skinned versions.
	Weapon[214]	= CreateConVar("xstats_weapon_powerjack",			"10",	"xStats: TF2 - Points given when killing with Power Jack.", _, true, 0.0);
	Weapon[215]	= CreateConVar("xstats_weapon_degreaser",			"10",	"xStats: TF2 - Points given when killing with Degreaser.", _, true, 0.0);
	Weapon[220]	= CreateConVar("xstats_weapon_shortstop",			"10",	"xStats: TF2 - Points given when killing with Shortstop", _, true, 0.0);
	Weapon[221]	= CreateConVar("xstats_weapon_holymackerel",		"10",	"xStats: TF2 - Points given when killing with Holy Mackerel.", _, true, 0.0);
	Weapon[224]	= CreateConVar("xstats_weapon_letranger",			"10",	"xStats: TF2 - Points given when killing with L'etranger.", _, true, 0.0);
	Weapon[225]	= CreateConVar("xstats_weapon_eternalreward",		"10",	"xStats: TF2 - Points given when killing with Eternal Reward.", _, true, 0.0);
	Weapon[228]	= CreateConVar("xstats_weapon_blackbox",			"10",	"xStats: TF2 - Points given when killing with Black Box.", _, true, 0.0);
	Weapon[230]	= CreateConVar("xstats_weapon_sydneysleeper",		"10",	"xStats: TF2 - Points given when killing with Sydney Sleeper.", _, true, 0.0);
	Weapon[232]	= CreateConVar("xstats_weapon_bushwacka",			"10",	"xStats: TF2 - Points given when killing with Bushwacka.", _, true, 0.0);
	Weapon[237]	= Weapon[18];	//Rocket Jumper.
	Weapon[239]	= CreateConVar("xstats_weapon_goru",				"10",	"xStats: TF2 - Points given when killing with Gloves of Running Urgently.", _, true, 0.0);
	Weapon[264]	= CreateConVar("xstats_weapon_fryingpan",			"10",	"xStats: TF2 - Points given when killing with Frying Pan.", _, true, 0.0);
	Weapon[265]	= Weapon[20];	//Sticky Jumper.
	Weapon[266]	= CreateConVar("xstats_weapon_hhhh",				"10",	"xStats: TF2 - Points given when killing with Horseless Headless Horsemann's Headtaker", _, true, 0.0);
	Weapon[294]	= Weapon[160];	//Same Lugermorph, different TFClass type.
	Weapon[298]	= CreateConVar("xstats_weapon_ironcurtain",			"10",	"xStats: TF2 - Points given when killing with Iron Curtain.", _, true, 0.0);
	Weapon[304]	= CreateConVar("xstats_weapon_amputator",			"10",	"xStats: TF2 - Points given when killing with Amputator.", _, true, 0.0);
	Weapon[305]	= CreateConVar("xstats_weapon_crusaderscrossbow",	"10",	"xStats: TF2 - Points given when killing with Crusader's Crossbow.", _, true, 0.0);
	Weapon[307]	= CreateConVar("xstats_weapon_ullapoolcaber",		"10",	"xStats: TF2 - Points given when killing with Ullapool Caber.", _, true, 0.0);
	Weapon[308]	= CreateConVar("xstats_weapon_lochnload",			"10",	"xStats: TF2 - Points given when killing with Loch-n-Load.", _, true, 0.0);
	Weapon[310]	= CreateConVar("xstats_weapon_warriorsspirit",		"10",	"xStats: TF2 - Points given when killing with Warrior's Spirit.", _, true, 0.0);
	Weapon[312]	= CreateConVar("xstats_weapon_brassbeast",			"10",	"xStats: TF2 - Points given when killing with Brass Beast.", _, true, 0.0);
	Weapon[317]	= CreateConVar("xstats_weapon_candycane",			"10",	"xStats: TF2 - Points given when killing with Candy Cane.", _, true, 0.0);
	Weapon[325]	= CreateConVar("xstats_weapon_bostonbasher",		"10",	"xStats: TF2 - Points given when killing with Boston Basher.", _, true, 0.0);
	Weapon[326]	= CreateConVar("xstats_weapon_backscratcher",		"10",	"xStats: TF2 - Points given when killing with Back Scratcher.", _, true, 0.0);
	Weapon[327]	= CreateConVar("xstats_weapon_claidheamhmor",		"10",	"xStats: TF2 - Points given when killing with Claidheamh Mór.", _, true, 0.0);
	Weapon[329]	= CreateConVar("xstats_weapon_jag",					"10",	"xStats: TF2 - Points given when killing with Jag.", _, true, 0.0);
	Weapon[331]	= CreateConVar("xstats_weapon_fistsofsteel",		"10",	"xStats: TF2 - Points given when killing with Fists Of Steel.", _, true, 0.0);
	Weapon[348]	= CreateConVar("xstats_weapon_sharpenedvolcanofragment",	"10",	"xStats: TF2 - Points given when killing with Sharpened Volcano Fragment.", _, true, 0.0);
	Weapon[349]	= CreateConVar("xstats_weapon_sunonastick",			"10",	"xStats: TF2 - Points given when killing with Sun-On-A-Stick.", _, true, 0.0);
	Weapon[351]	= CreateConVar("xstats_weapon_detonator",			"10",	"xStats: TF2 - Points given when killing with Detonator.", _, true, 0.0);
	Weapon[355]	= CreateConVar("xstats_weapon_fanowar",				"10",	"xStats: TF2 - Points given when killing with Fan O' War.", _, true, 0.0);
	Weapon[356]	= CreateConVar("xstats_weapon_conniverskunai",		"10",	"xStats: TF2 - Points given when killing with Conniver's Kunai.", _, true, 0.0);
	Weapon[357]	= CreateConVar("xstats_weapon_halfzatoichi",		"10",	"xStats: TF2 - Points given when killing with Half-Zatoichi.", _, true, 0.0);
	Weapon[401]	= CreateConVar("xstats_weapon_shahanshah",			"10",	"xStats: TF2 - Points given when killing with Shahanshah.", _, true, 0.0);
	Weapon[402]	= CreateConVar("xstats_weapon_bazaarbargain",		"10",	"xStats: TF2 - Points given when killing with Bazaar Bargain.", _, true, 0.0);
	Weapon[404]	= CreateConVar("xstats_weapon_persainpersuader",	"10",	"xStats: TF2 - Points given when killing with Persain Pursuader.", _, true, 0.0);
	Weapon[406]	= CreateConVar("xstats_weapon_splendidscreen",		"10",	"xStats: TF2 - Points given when killing with Splendid Screen.", _, true, 0.0);
	Weapon[412]	= CreateConVar("xstats_weapon_overdose",			"10",	"xStats: TF2 - Points given when killing with Overdose.", _, true, 0.0);
	Weapon[413]	= CreateConVar("xstats_weapon_solemnvow",			"10",	"xStats: TF2 - Points given when killing with Solmen Wov.", _, true, 0.0);
	Weapon[414]	= CreateConVar("xstats_weapon_libertylauncher",		"10",	"xStats: TF2 - Points given when killing with Liberty Launcher.", _, true, 0.0);
	Weapon[415]	= CreateConVar("xstats_weapon_reserveshooter",		"10",	"xStats: TF2 - Points given when killing with Reserve Shooter.", _, true, 0.0);
	Weapon[416]	= CreateConVar("xstats_weapon_marketgardener",		"10",	"xStats: TF2 - Points given when killing with Market Gardener.", _, true, 0.0);
	Weapon[423]	= CreateConVar("xstats_weapon_saxxy",				"10",	"xStats: TF2 - Points given when killing with Saxxy.", _, true, 0.0);
	Weapon[424]	= CreateConVar("xstats_weapon_tomislav",			"10",	"xStats: TF2 - Points given when killing with Tomislav.", _, true, 0.0);
	Weapon[425]	= CreateConVar("xstats_weapon_familybusiness",		"10",	"xStats: TF2 - Points given when killing with Family Business.", _, true, 0.0);
	Weapon[426]	= CreateConVar("xstats_weapon_evictionnotice",		"10",	"xStats: TF2 - Points given when killing with Eviction Notice.", _, true, 0.0);
	Weapon[441]	= CreateConVar("xstats_weapon_cowmangler5000",		"10",	"xStats: TF2 - Points given when killing with Cow Mangler 5000", _, true, 0.0);
	Weapon[442]	= CreateConVar("xstats_weapon_righteousbison",		"10",	"xStats: TF2 - Points given when killing with Righteous Bison.", _, true, 0.0);
	Weapon[444]	= CreateConVar("xstats_weapon_mantreads",			"10",	"xStats: TF2 - Points given when killing with Mantreads.", _, true, 0.0);
	Weapon[447]	= CreateConVar("xstats_weapon_disciplinaryaction",	"10",	"xStats: TF2 - Points given when killing with Disciplinary Action.", _, true, 0.0);
	Weapon[448]	= CreateConVar("xstats_weapon_sodapopper",			"10",	"xStats: TF2 - Points given when killing with Soda Popper.", _, true, 0.0);
	Weapon[449]	= CreateConVar("xstats_weapon_winger",				"10",	"xStats: TF2 - Points given when killing with Winger.", _, true, 0.0);
	Weapon[450]	= CreateConVar("xstats_weapon_atomizer",			"10",	"xStats: TF2 - Points given when killing with Atomizer.", _, true, 0.0);
	Weapon[452]	= CreateConVar("xstats_weapon_threeruneblade",		"10",	"xStats: TF2 - Points given when killing with Three Rune Blade.", _, true, 0.0);
	Weapon[457]	= CreateConVar("xstats_weapon_postalpummeler",		"10",	"xStats: TF2 - Points given when killing with Postal Pummeler.", _, true, 0.0);
	Weapon[460]	= CreateConVar("xstats_weapon_enforcer",			"10",	"xStats: TF2 - Points given when killing with Enforcer.", _, true, 0.0);
	Weapon[461]	= CreateConVar("xstats_weapon_bigearner",			"10",	"xStats: TF2 - Points given when killing with Big Earner.", _, true, 0.0);
	Weapon[466]	= CreateConVar("xstats_weapon_maul",				"10",	"xStats: TF2 - Points given when killing with Maul.", _, true, 0.0);
	Weapon[474]	= CreateConVar("xstats_weapon_conscentiousobjector","10",	"xStats: TF2 - Points given when killing with Conscentious Objector.", _, true, 0.0);
	Weapon[482]	= CreateConVar("xstats_weapon_nessiesnineiron",		"10",	"xStats: TF2 - Points given when killing with Nessie's Nine-Iron.", _, true, 0.0);
	Weapon[513]	= CreateConVar("xstats_weapon_original",			"10",	"xStats: TF2 - Points given when killing with Original.", _, true, 0.0);
	Weapon[525]	= CreateConVar("xstats_weapon_diamondback",			"10",	"xStats: TF2 - Points given when killing with Diamondback.", _, true, 0.0);
	Weapon[526]	= CreateConVar("xstats_weapon_machina",				"10",	"xStats: TF2 - Points given when killing with Machina.", _, true, 0.0);
	Weapon[527]	= CreateConVar("xstats_weapon_widowmaker",			"10",	"xStats: TF2 - Points given when killing with Widowmaker.", _, true, 0.0);
	Weapon[528]	= CreateConVar("xstats_weapon_shortcircuit",		"10",	"xStats: TF2 - Points given when killing with Short Circuit.", _, true, 0.0);
	Weapon[572]	= CreateConVar("xstats_weapon_unarmedcombat",		"10",	"xStats: TF2 - Points given when killing with Unarmed Combat.", _, true, 0.0);
	Weapon[574]	= CreateConVar("xstats_weapon_wangaprick",			"10",	"xStats: TF2 - Points given when killing with Wanga Prick.", _, true, 0.0);
	Weapon[587]	= CreateConVar("xstats_weapon_apocofists",			"10",	"xStats: TF2 - Points given when killing with Apoco Fists.", _, true, 0.0);
	Weapon[588]	= CreateConVar("xstats_weapon_pomson6000",			"10",	"xStats: TF2 - Points given when killing with Pomson 6000.", _, true, 0.0);
	Weapon[589]	= CreateConVar("xstats_weapon_eurekaeffect",		"10",	"xStats: TF2 - Points given when killing with Eureka Effect.", _, true, 0.0);
	Weapon[593]	= CreateConVar("xstats_weapon_thirddegree",			"10",	"xStats: TF2 - Points given when killing with Third Degree", _, true, 0.0);
	Weapon[594]	= CreateConVar("xstats_weapon_phlogistinator",		"10",	"xStats: TF2 - Points given when killing with Phlogistinator.", _, true, 0.0);
	Weapon[595]	= CreateConVar("xstats_weapon_manmelter",			"10",	"xStats: TF2 - Points given when killing with Man Melter.", _, true, 0.0);
	Weapon[609]	= CreateConVar("xstats_weapon_scottishhandshake",	"10",	"xStats: TF2 - Points given when killing with Scottish Handshake.", _, true, 0.0);
	Weapon[638]	= CreateConVar("xstats_weapon_sharpdresser",		"10",	"xStats: TF2 - Points given when killing with Sharp Dresser.", _, true, 0.0);
	Weapon[648]	= CreateConVar("xstats_weapon_wrapassassin",		"10",	"xStats: TF2 - Points given when killing with Wrap Assassin.", _, true, 0.0);
	Weapon[649]	= CreateConVar("xstats_weapon_spycicle",			"10",	"xStats: TF2 - Points given when killing with Spycicle.", _, true, 0.0);
	Weapon[654]	= Weapon[15];	//Festive Minigun.
	Weapon[656]	= CreateConVar("xstats_weapon_holidaypunch",		"10",	"xStats: TF2 - Points given when killing with Holiday Punch.", _, true, 0.0);
	Weapon[658]	= Weapon[18];	//Festive Rocket Launcher.
	Weapon[659]	= Weapon[21];	//Festive Flamethrower.
	Weapon[660]	= Weapon[0];	//Festive Bat.
	Weapon[661]	= Weapon[20];	//Festive StickyBomb Launcher.
	Weapon[662]	= Weapon[7];	//Festive Wrench.
	Weapon[664]	= Weapon[14];	//Festive Sniper Rifle.
	Weapon[665]	= Weapon[4];	//Festive Knife.
	Weapon[669]	= Weapon[13];	//Festive Scattergun.
	Weapon[727]	= CreateConVar("xstats_weapon_blackrose",				"10",	"xStats: TF2 - Points given when killing with Blackrose.", _, true, 0.0);
	Weapon[739]	= CreateConVar("xstats_weapon_lollichop",				"10",	"xStats: TF2 - Points given when killing with Lollichop.", _, true, 0.0);
	Weapon[740]	= CreateConVar("xstats_weapon_scorchshot",				"10",	"xStats: TF2 - Points given when killing with Scorch Shot.", _, true, 0.0);
	Weapon[741]	= CreateConVar("xstats_weapon_rainblower",				"10",	"xStats: TF2 - Points given when killing with Rainblower.", _, true, 0.0);
	Weapon[751]	= CreateConVar("xstats_weapon_cleanerscarbine",			"10",	"xStats: TF2 - Points given when killing with Cleaner's Carbine.", _, true, 0.0);
	Weapon[752]	= CreateConVar("xstats_weapon_hitmansheatmaker",		"10",	"xStats: TF2 - Points given when killing with Hitman's Heatmaker.", _, true, 0.0);
	Weapon[772]	= CreateConVar("xstats_weapon_babyfacesblaster",		"10",	"xStats: TF2 - Points given when killing with Baby Face's Blaster.", _, true, 0.0);
	Weapon[773]	= CreateConVar("xstats_weapon_prettyboyspocketpistol",	"10",	"xStats: TF2 - Points given when killing with Pretty Boy's Pocket Pistol.", _, true, 0.0);
	Weapon[775]	= CreateConVar("xstats_weapon_escapeplan",				"10",	"xStats: TF2 - Points given when killing with Escape Plan.", _, true, 0.0);
	Weapon[792]	= Weapon[14];	//Default Sniper Rifle.			Silver Botkiller Mk. I.
	Weapon[793]	= Weapon[15];	//Default Minigun.				Silver Botkiller Mk. I.
	Weapon[795]	= Weapon[7];	//Default Wrench.				Silver Botkiller Mk. I.
	Weapon[797]	= Weapon[20];	//Default Stickybomb Launcher.	Silver Botkiller Mk. I.
	Weapon[798]	= Weapon[21];	//Default Flamethrower.			Silver Botkiller Mk. I.
	Weapon[799]	= Weapon[13];	//Default Scattergun.			Silver Botkiller Mk. I.
	Weapon[800]	= Weapon[18];	//Default Rocket Launcher.		Silver Botkiller Mk. I.
	Weapon[801]	= Weapon[14];	//Default Sniper Rifle.			Gold Botkiller Mk. I.
	Weapon[802]	= Weapon[15];	//Default Minigun.				Gold Botkiller Mk. I.
	Weapon[804]	= Weapon[7];	//Default Wrench.				Gold Botkiller Mk. I.
	Weapon[806]	= Weapon[20];	//Default Stickybomb Launcher.	Gold Botkiller Mk. I.
	Weapon[807]	= Weapon[21];	//Default Flamethrower.			Gold Botkiller Mk. I.
	Weapon[808]	= Weapon[13];	//Default Scattergun.			Gold Botkiller Mk. I.
	Weapon[809]	= Weapon[18];	//Default Rocket Launcher.		Gold Botkiller Mk. I.
	Weapon[811]	= CreateConVar("xstats_weapon_huolongheater",		"10",	"xStats: TF2 - Points given when killing with Huo-Long Heater.", _, true, 0.0);
	Weapon[812]	= CreateConVar("xstats_weapon_flyingguillotine",	"10",	"xStats: TF2 - Points given when killing with Flying Guillotine", _, true, 0.0);
	Weapon[813]	= CreateConVar("xstats_weapon_neonannihilator",		"10",	"xStats: TF2 - Points given when killing with Neon Annihilator.", _, true, 0.0);
	Weapon[832]	= Weapon[811];	//Genuine Huo-Long Heater.
	Weapon[833]	= Weapon[812];	//Genuine Flying Guillotine.
	Weapon[834]	= Weapon[813];	//Genuine Neon Annihilator.
	Weapon[850]	= Weapon[15];	//Deflector (MvM Minigun used by Giant Deflector Heavies.)
	Weapon[851]	= CreateConVar("xstats_weapon_awperhand",			"10",	"xStats: TF2 - Points given when killing with AWPer Hand.", _, true, 0.0);
	Weapon[880]	= CreateConVar("xstats_weapon_freedomstaff",		"10",	"xStats: TF2 - Points given when killing with Freedom Staff.", _, true, 0.0);
	Weapon[881]	= Weapon[14];	//Default Sniper Rifle.			Rust Botkiller Mk. I.
	Weapon[882]	= Weapon[15];	//Default Minigun.				Rust Botkiller Mk. I.
	Weapon[884]	= Weapon[7];	//Default Wrench.				Rust Botkiller Mk. I.
	Weapon[886]	= Weapon[20];	//Default Stickybomb Launcher.	Rust Botkiller Mk. I.
	Weapon[887]	= Weapon[21];	//Default Flamethrower.			Rust Botkiller Mk. I.
	Weapon[888]	= Weapon[13];	//Default Scattergun.			Rust Botkiller Mk. I.
	Weapon[889]	= Weapon[18];	//Default Rocket Launcher.		Rust Botkiller Mk. I.
	Weapon[890]	= Weapon[14];	//Default Sniper Rifle.			Blood Botkiller Mk. I.
	Weapon[891]	= Weapon[15];	//Default Minigun.				Blood Botkiller Mk. I.
	Weapon[893]	= Weapon[7];	//Default Wrench.				Blood Botkiller Mk. I.
	Weapon[895]	= Weapon[20];	//Default Stickybomb Launcher.	Blood Botkiller Mk. I.
	Weapon[896]	= Weapon[21];	//Default Flamethrower.			Blood Botkiller Mk. I.
	Weapon[897]	= Weapon[13];	//Default Scattergun.			Blood Botkiller Mk. I.
	Weapon[898]	= Weapon[18];	//Default Rocket Launcher.		Blood Botkiller Mk. I.
	Weapon[899]	= Weapon[14];	//Default Sniper Rifle.			Carbonado Botkiller Mk. I.
	Weapon[900]	= Weapon[15];	//Default Minigun.				Carbonado Botkiller Mk. I.
	Weapon[902]	= Weapon[7];	//Default Wrench.				Carbonado Botkiller Mk. I.
	Weapon[904]	= Weapon[20];	//Default Stickybomb Launcher.	Carbonado Botkiller Mk. I.
	Weapon[905]	= Weapon[21];	//Default Flamethrower.			Carbonado Botkiller Mk. I.
	Weapon[906]	= Weapon[13];	//Default Scattergun.			Carbonado Botkiller Mk. I.
	Weapon[907]	= Weapon[18];	//Default Rocket Launcher.		Carbonado Botkiller Mk. I.
	Weapon[908]	= Weapon[14];	//Default Sniper Rifle.			Diamond Botkiller Mk. I.
	Weapon[909]	= Weapon[15];	//Default Minigun.				Diamond Botkiller Mk. I.
	Weapon[911]	= Weapon[7];	//Default Wrench.				Diamond Botkiller Mk. I.
	Weapon[913]	= Weapon[20];	//Default Stickybomb Launcher.	Diamond Botkiller Mk. I.
	Weapon[914]	= Weapon[21];	//Default Flamethrower.			Diamond Botkiller Mk. I.
	Weapon[915]	= Weapon[13];	//Default Scattergun.			Diamond Botkiller Mk. I.
	Weapon[916]	= Weapon[18];	//Default Rocket Launcher.		Diamond Botkiller Mk. I.
	Weapon[939]	= CreateConVar("xstats_weapon_batouttahell",	"10",	"xStats: TF2 - Points given when killing with Bat Outta Hell.", _, true, 0.0);
	Weapon[954]	= CreateConVar("xstats_weapon_memorymaker",		"10",	"xStats: TF2 - Points given when killing with Memory Maker.", _, true, 0.0);
	Weapon[957]	= Weapon[14];	//Default Sniper Rifle.			Silver Botkiller Mk. II.
	Weapon[958]	= Weapon[15];	//Default Minigun.				Silver Botkiller Mk. II.
	Weapon[960]	= Weapon[7];	//Default Wrench.				Silver Botkiller Mk. II.
	Weapon[962]	= Weapon[20];	//Default Stickybomb Launcher.	Silver Botkiller Mk. II.
	Weapon[963]	= Weapon[21];	//Default Flamethrower.			Silver Botkiller Mk. II.
	Weapon[964]	= Weapon[13];	//Default Scattergun.			Silver Botkiller Mk. II.
	Weapon[965]	= Weapon[18];	//Default Rocket Launcher.		Silver Botkiller Mk. II.
	Weapon[966]	= Weapon[14];	//Default Sniper Rifle.			Gold Botkiller Mk. II.
	Weapon[967]	= Weapon[15];	//Default Minigun.				Gold Botkiller Mk. II.
	Weapon[969]	= Weapon[7];	//Default Wrench.				Gold Botkiller Mk. II.
	Weapon[971]	= Weapon[20];	//Default Stickybomb Launcher.	Gold Botkiller Mk. II.
	Weapon[972]	= Weapon[21];	//Default Flamethrower.			Gold Botkiller Mk. II.
	Weapon[973]	= Weapon[13];	//Default Scattergun.			Gold Botkiller Mk. II.
	Weapon[974]	= Weapon[18];	//Default Rocket Launcher.		Gold Botkiller Mk. II.
	Weapon[996]	= CreateConVar("xstats_weapon_loosecannon",		"10",	"xStats: TF2 - Points given when killing with Loose Cannon.", _, true, 0.0);
	Weapon[997]	= CreateConVar("xstats_weapon_rescueranger",	"10",	"xStats: TF2 - Points given when killing with Rescue Ranger.", _, true, 0.0);
	Weapon[999]	= Weapon[221];	//Festive Holy Mackerel.
	Weapon[1000]	= Weapon[38];	//Festive Axtinguisher.
	Weapon[1003]	= Weapon[37];	//Festive Ubersaw.
	Weapon[1004]	= Weapon[141];//Festive Frontier Justice.
	Weapon[1005]	= Weapon[56];	//Festive Huntsman.
	Weapon[1006]	= Weapon[61];	//Festive Ambassador.
	Weapon[1007]	= Weapon[19];	//Festive Grenade Launcher.
	Weapon[1013]	= CreateConVar("xstats_weapon_hamshank",	"10",	"xStats: TF2 - Points given when killing with Ham Shank.", _, true, 0.0);
	Weapon[1071]	= Weapon[264];//Golden Frying Pan.
	Weapon[1078]	= Weapon[45];	//Festive Force-A-Nature.
	Weapon[1079]	= Weapon[305];//Festive Crusader's Crossbow.
	Weapon[1081]	= Weapon[39];	//Festive Flare Gun.
	Weapon[1082]	= Weapon[132];//Festive Eyelander.
	Weapon[1084]	= Weapon[239];//Festive Gloves of Running Urgently.
	Weapon[1085]	= Weapon[228];//Festive Black Box.
	Weapon[1092]	= CreateConVar("xstats_weapon_fortifiedcompound",	"10",	"xStats: TF2 - Points given when killing with Fortified Compound.", _, true, 0.0);
	Weapon[1098]	= CreateConVar("xstats_weapon_classic",				"10",	"xStats: TF2 - Points given when killing with Classic.", _, true, 0.0);
	Weapon[1099]	= CreateConVar("xstats_weapon_tideturner",			"10",	"xStats: TF2 - Points given when killing with Tide Turner.", _, true, 0.0);
	Weapon[1100]	= CreateConVar("xstats_weapon_breadbite",			"10",	"xStats: TF2 - Points given when killing with Bread Bite.", _, true, 0.0);
	Weapon[1103]	= CreateConVar("xstats_weapon_backscatter",			"10",	"xStats: TF2 - Points given when killing with Back Scatter.", _, true, 0.0);
	Weapon[1104]	= CreateConVar("xstats_weapon_airstrike",			"10",	"xStats: TF2 - Points given when killing with Air Strike.", _, true, 0.0);
	Weapon[1123]	= CreateConVar("xstats_weapon_necrosmasher",		"10",	"xStats: TF2 - Points given when killing with Necro Smasher.", _, true, 0.0);
	Weapon[1127]	= CreateConVar("xstats_weapon_crossingguard",		"10",	"xStats: TF2 - Points given when killing with Crossing Guard.", _, true, 0.0);
	Weapon[1141]	= Weapon[9];	//Festive Shotgun.
	Weapon[1142]	= Weapon[24];	//Festive Revolver.
	Weapon[1144]	= Weapon[131];//Festive Chargin' Targe.
	Weapon[1146]	= Weapon[40];	//Festive Backburner.
	Weapon[1149]	= Weapon[16];	//Festive SMG.
	Weapon[1150]	= CreateConVar("xstats_weapon_quickebomblauncher",	"10",	"xStats: TF2 - Points given when killing with Quickiebomb Launcher.", _, true, 0.0);
	Weapon[1151]	= CreateConVar("xstats_weapon_ironbomber",			"10",	"xStats: TF2 - Points given when killing with Iron Bomber.", _, true, 0.0);
	Weapon[1153]	= CreateConVar("xstats_weapon_panicattack",			"10",	"xStats: TF2 - Points given when killing with Panic Attack.", _, true, 0.0);
	Weapon[1178]	= CreateConVar("xstats_weapon_dragonsfury",			"10",	"xStats: TF2 - Points given when killing with Dragon's Fury.", _, true, 0.0);
	Weapon[1179]	= CreateConVar("xstats_weapon_thermalthruster",		"10",	"xStats: TF2 - Points given when killing with Thermal Thruster.", _, true, 0.0);
	Weapon[1181]	= CreateConVar("xstats_weapon_hothand",				"10",	"xStats: TF2 - Points given when killing with Hot Hand.", _, true, 0.0);
	Weapon[1184]	= Weapon[239];	//Gloves of Running Urgently. (Used by MvM Robots.)
	Weapon[15000]	= Weapon[14];	//Skinned Sniper Rifle.			Night Owl.
	Weapon[15001]	= Weapon[16];	//Skinned SMG.					Woodsy Widowmaker.
	Weapon[15002]	= Weapon[13];	//Skinned Scattergun.			Night Terror.
	Weapon[15003]	= Weapon[9];	//Skinned Shotgun.				Backwoods Boomstick.
	Weapon[15004]	= Weapon[15];	//Skinned Minigun.				King of The Jungle.
	Weapon[15005]	= Weapon[21];	//Skinned Flame Thrower.		Forest Fire.
	Weapon[15006]	= Weapon[18];	//Skinned Rocket Launcher.		Woodland Warrior.
	Weapon[15007]	= Weapon[14];	//Skinned Sniper Rifle.			Purple Range.
	Weapon[15009]	= Weapon[20];	//Skinned Stickybomb Launcher.	Sudden Flurry.
	Weapon[15011]	= Weapon[24];	//Skinned Revolver.				Psychedeic Slugger.
	Weapon[15012]	= Weapon[20];	//Skinned Stickybomb Launcher.	Carpet Bomber.
	Weapon[15013]	= Weapon[22];	//Skinned Pistol.				Red Rock Roscoe.
	Weapon[15014]	= Weapon[18];	//Skinned Rocket Launcher.		Sand Cannon.
	Weapon[15015]	= Weapon[13];	//Skinned Scattergun.			Tartan Torpedo.
	Weapon[15016]	= Weapon[9];	//Skinned Shotgun.				Rustic Ruiner.
	Weapon[15017]	= Weapon[21];	//Skinned Flame Thrower.		Barn Burner.
	Weapon[15018]	= Weapon[22];	//Skinned Pistol.				Homemade Heater.
	Weapon[15019]	= Weapon[14];	//Skinned Sniper Rifle.			Lumber From Down Under.
	Weapon[15020]	= Weapon[15];	//Skinned Minigun.				Iron Wood.
	Weapon[15021]	= Weapon[13];	//Skinned Scattergun.			Country Crusher.
	Weapon[15022]	= Weapon[16];	//Skinned SMG.					Plaid Potshotter.
	Weapon[15023]	= Weapon[14];	//Skinned Sniper Rifle.			Shot In The Dark.
	Weapon[15024]	= Weapon[20];	//Skinned Grenade Launcher.		Blasted Bombardier.
	Weapon[15026]	= Weapon[15];	//Skinned Minigun.				Antique Annihilator.
	Weapon[15027]	= Weapon[24];	//Skinned Revolver.				Old Country.
	Weapon[15028]	= Weapon[18];	//Skinned Rocket Launcher.		American Pastoral.
	Weapon[15029]	= Weapon[13];	//Skinned Scattergun.			Backcountry Blaster.
	Weapon[15030]	= Weapon[21];	//Skinned Flame Thrower.		Bovine Blazemaker.
	Weapon[15031]	= Weapon[15];	//Skinned Minigun.				War Room.
	Weapon[15032]	= Weapon[16];	//Skinned SMG.					Treadplate Tormenter.
	Weapon[15033]	= Weapon[14];	//Skinned Sniper Rifle.			Bogtrotter.
	Weapon[15034]	= Weapon[21];	//Skinned Flame Thrower.		Earth, Sky and Fire.
	Weapon[15035]	= Weapon[22];	//Skinned Pistol.				Hickory Holepuncher.
	Weapon[15036]	= Weapon[13];	//Skinned Scattergun.			Spruce Deuce.
	Weapon[15037]	= Weapon[16];	//Skinned SMG.					Team Sprayer.
	Weapon[15038]	= Weapon[20];	//Skinned Grenade Launcher.		Rooftop Wrangler.
	Weapon[15040]	= Weapon[15];	//Skinned Minigun.				Citizen Pain.
	Weapon[15041]	= Weapon[22];	//Skinned Pistol.				Local Hero.
	Weapon[15042]	= Weapon[24];	//Skinned Revolver.				Mayor.
	Weapon[15043]	= Weapon[18];	//Skinned Rocket Launcher.		Smalltown Bringdown.
	Weapon[15044]	= Weapon[9];	//Skinned Shotgun.				Civic Duty.
	Weapon[15045]	= Weapon[20];	//Skinned Stickybomb Launcher.	Liquid Asset.
	Weapon[15046]	= Weapon[22];	//Skinned Pistol.				Black Dahlia.
	Weapon[15047]	= Weapon[9];	//Skinned Shotgun.				Lightning Rod.
	Weapon[15048]	= Weapon[20];	//Skinned Stickybomb Launcher.	Pink Elephant.
	Weapon[15049]	= Weapon[21];	//Skinned Flame Thrower.		Flash Fryer.
	Weapon[15051]	= Weapon[24];	//Skinned Revolver.				Dead Reckoner.
	Weapon[15052]	= Weapon[18];	//Skinned Rocket Launcher.		Shell Shocker.
	Weapon[15053]	= Weapon[13];	//Skinned Scattergun.			Current Event.
	Weapon[15054]	= Weapon[21];	//Skinned Flame Thrower.		Turbine Torcher.
	Weapon[15055]	= Weapon[15];	//Skinned Minigun.				Brick House.
	Weapon[15056]	= Weapon[22];	//Skinned Pistol.				Sandstone Special.
	Weapon[15057]	= Weapon[18];	//Skinned Rocket Launcher.		Aqua Marine.
	Weapon[15058]	= Weapon[16];	//Skinned SMG.					Low Profile.
	Weapon[15059]	= Weapon[14];	//Skinned Sniper Rifle.			Thunderbolt.
	Weapon[15060]	= Weapon[22];	//Skinned Pistol.				Macabre Web.
	Weapon[15061]	= Weapon[22];	//Skinned Pistol.				Nutcracker.
	Weapon[15062]	= Weapon[24];	//Skinned Revolver.				Boneyard.
	Weapon[15063]	= Weapon[24];	//Skinned Revolver.				Wildwood.
	Weapon[15064]	= Weapon[24];	//Skinned Revolver.				Macabre Web.
	Weapon[15065]	= Weapon[13];	//Skinned Scattergun.			Macabre Web.
	Weapon[15066]	= Weapon[21];	//Skinned Flame Thrower.		Autumn.
	Weapon[15067]	= Weapon[21];	//Skinned Flame Thrower.		Pumpkin Patch.
	Weapon[15068]	= Weapon[21];	//Skinned Flame Thrower.		Nutcracker.
	Weapon[15069]	= Weapon[13];	//Skinned Scattergun.			Nutcracker.
	Weapon[15070]	= Weapon[14];	//Skinned Sniper Rifle.			Pumpkin Patch.
	Weapon[15071]	= Weapon[14];	//Skinned Sniper Rifle.			Boneyard.
	Weapon[15072]	= Weapon[14];	//Skinned Sniper Rifle.			Wildwood.
	Weapon[15073]	= Weapon[7];	//Skinned Wrench.				Nutcracker.
	Weapon[15074]	= Weapon[7];	//Skinned Wrench.				Autumn.
	Weapon[15075]	= Weapon[7];	//Skinned Wrench.				Boneyard.
	Weapon[15076]	= Weapon[16];	//Skinned SMG.					Wildwood.
	Weapon[15077]	= Weapon[19];	//Skinned Grenade Launcher.		Autumn.
	Weapon[15079]	= Weapon[19];	//Skinned Grenade Launcher.		Macabre Web.
	Weapon[15081]	= Weapon[18];	//Skinned Rocket Launcher.		Autumn.
	Weapon[15082]	= Weapon[20];	//Skinned Stickybomb Launcher.	Autumn.
	Weapon[15083]	= Weapon[20];	//Skinned Stickybomb Launcher.	Pumpkin Patch.
	Weapon[15084]	= Weapon[20];	//Skinned Stickybomb Launcher.	Macabre Web.
	Weapon[15085]	= Weapon[9];	//Skinned Shotgun.				Autumn.
	Weapon[15086]	= Weapon[15];	//Skinned Minigun.				Macabre Web.
	Weapon[15087]	= Weapon[15];	//Skinned Minigun.				Pumpkin Patch.
	Weapon[15088]	= Weapon[15];	//Skinned Minigun.				Nutcracker.
	Weapon[15089]	= Weapon[21];	//Skinned Flame Thrower.		Balloonicorn.
	Weapon[15090]	= Weapon[21];	//Skinned Flame Thrower.		Rainbow.
	Weapon[15091]	= Weapon[19];	//Skinned Grenade Launcher.		Rainbow.
	Weapon[15092]	= Weapon[19];	//Skinned Grenade Launcher.		Sweet Dreams.
	Weapon[15094]	= Weapon[4];	//Skinned Knife.				Blue Mew.
	Weapon[15095]	= Weapon[4];	//Skinned Knife.				Brain Candy.
	Weapon[15096]	= Weapon[4];	//Skinned Knife.				Stabbed To Hell.
	Weapon[15098]	= Weapon[15];	//Skinned Minigun.				Brain Candy.
	Weapon[15099]	= Weapon[15];	//Skinned Minigun.				Mister Cuddles.
	Weapon[15100]	= Weapon[22];	//Skinned Pistol.				Blue Mew.
	Weapon[15101]	= Weapon[22];	//Skinned Pistol.				Brain Candy.
	Weapon[15102]	= Weapon[22];	//Skinned Pistol.				Shot To Hell.
	Weapon[15103]	= Weapon[24];	//Skinned Revolver.				Flower Power.
	Weapon[15104]	= Weapon[18];	//Skinned Rocket Launcher.		Blue Mew.
	Weapon[15105]	= Weapon[18];	//Skinned Rocket Launcher.		Brain Candy.
	Weapon[15106]	= Weapon[13];	//Skinned Scattergun.			Bluw Mew.
	Weapon[15107]	= Weapon[13];	//Skinned Scattergun.			Flower Power.
	Weapon[15108]	= Weapon[13];	//Skinned Scattergun.			Shot to Hell.
	Weapon[15109]	= Weapon[9];	//Skinned Shotgun.				Flower Power.
	Weapon[15110]	= Weapon[15];	//Skinned SMG.					Blue Mew.
	Weapon[15111]	= Weapon[14];	//Skinned Sniper Rifle.			Balloonicorn.
	Weapon[15112]	= Weapon[14];	//Skinned Sniper Rifle.			Rainbow.
	Weapon[15113]	= Weapon[20];	//Skinned Stickybomb Launcher.	Sweet Dreams.
	Weapon[15114]	= Weapon[7];	//Skinned Wrench.				Torqued To Hell.
	Weapon[15115]	= Weapon[21];	//Skinned Flame Thrower.		Coffin Nail.
	Weapon[15116]	= Weapon[19];	//Skinned Grenade Launcher.		Coffin Nail.
	Weapon[15117]	= Weapon[19];	//Skinned Grenade Launcher.		Top Shelf.
	Weapon[15118]	= Weapon[4];	//Skinned Knife.				Dressed To Kill.
	Weapon[15119]	= Weapon[4];	//Skinned Knife.				Top Shelf.
	Weapon[15123]	= Weapon[15];	//Skinned Minigun.				Coffin Nail.
	Weapon[15124]	= Weapon[15];	//Skinned Minigun.				Dressed To Kill.
	Weapon[15125]	= Weapon[15];	//Skinned Minigun.				Top Shelf.
	Weapon[15126]	= Weapon[22];	//Skinned Pistol.				Dressed To Kill.
	Weapon[15127]	= Weapon[24];	//Skinned Revolver.				Top Shelf.
	Weapon[15128]	= Weapon[24];	//Skinned Revolver.				Top Shelf.
	Weapon[15129]	= Weapon[18];	//Skinned Rocket Launcher.		Coffin Nail.
	Weapon[15130]	= Weapon[18];	//Skinned Rocket Launcher.		High Roller's.
	Weapon[15131]	= Weapon[13];	//Skinned Scattergun.			Coffin Nail.
	Weapon[15132]	= Weapon[9];	//Skinned Shotgun.				Coffin Nail.
	Weapon[15133]	= Weapon[9];	//Skinned Shotgun.				Dressed To Kill.
	Weapon[15134]	= Weapon[16];	//Skinned SMG.					High Roller's.
	Weapon[15135]	= Weapon[14];	//Skinned Sniper Rifle.			Coffin Nail.
	Weapon[15136]	= Weapon[14];	//Skinned Sniper Rifle.			Dressed To Kill.
	Weapon[15137]	= Weapon[20];	//Skinned Stickybomb Launcher.	Coffin Nail.
	Weapon[15138]	= Weapon[20];	//Skinned Stickybomb Launcher.	Dressed To Kill.
	Weapon[15139]	= Weapon[7];	//Skinned Wrench.				Dressed To Kill.
	Weapon[15140]	= Weapon[7];	//Skinned Wrench.				Top Shelf.
	Weapon[15141]	= Weapon[21];	//Skinned Flame Thrower.		Warhawk.
	Weapon[15142]	= Weapon[19];	//Skinned Grenade Launcher.		Warhawk.
	Weapon[15143]	= Weapon[4];	//Skinned Knife.				Blitzkrieg.
	Weapon[15144]	= Weapon[4];	//Skinned Knife.				Airwolf.
	Weapon[15147]	= Weapon[15];	//Skinned Minigun.				Butcher Bird.
	Weapon[15148]	= Weapon[22];	//Skinned Pistol.				Blitzkrieg.
	Weapon[15149]	= Weapon[24];	//Skinned Revolver.				Blitzkrieg.
	Weapon[15050]	= Weapon[18];	//Skinned Rocket Launcher.		Warhawk.
	Weapon[15151]	= Weapon[13];	//Skinned Scattergun.			Killer Bee.
	Weapon[15152]	= Weapon[9];	//Skinned Shotgun.				Red Bear.
	Weapon[15153]	= Weapon[16];	//Skinned SMG.					Blitzkrieg.
	Weapon[15154]	= Weapon[14];	//Skinned Sniper Rifle.			Airwolf.
	Weapon[15155]	= Weapon[20];	//Skinned Stickybomb Launcher.	Blitzkrieg.
	Weapon[15156]	= Weapon[7];	//Skinned Wrench.				Airwolf.
	Weapon[15157]	= Weapon[13];	//Skinned Scattergun.			Corsair.
	Weapon[15158]	= Weapon[19];	//Skinned Grenade Launcher.		Butcher Bird.
	Weapon[19010]	= Weapon[18];	//TF2Items Give Weapon: Beta Pocket Rocket Launcher Variant 1.
	Weapon[19011]	= Weapon[9];	//TF2Items Give Weapon: Beta Pocket Shotgun.
	Weapon[19012]	= Weapon[129];	//TF2Items Give Weapon: Beta Split Equalizer 1.
	Weapon[19013]	= Weapon[129];	//TF2Items Give Weapon: Beta Split Equalizer 2.
	Weapon[19015]	= Weapon[14];	//TF2Items Give Weapon: Beta Sniper Rifle 1.
	Weapon[19016]	= Weapon[18];	//TF2Items Give Weapon: Beta Pocket Rocket Launcher Variant 2.
	Weapon[19017]	= Weapon[18];	//TF2Items Give Weapon: Beta Pocket Rocket Launcher Variant 3.
	Weapon[30474]	= CreateConVar("xstats_weapon_nostromonapalmer","10",	"xStats: TF2 - Points given when killing with Nostromo Napalmer.", _, true, 0.0);
	Weapon[30665]	= CreateConVar("xstats_weapon_shootingstar",	"10",	"xStats: TF2 - Points given when killing with Shooting star.", _, true, 0.0);
	Weapon[30666]	= CreateConVar("xstats_weapon_capper",			"10",	"xStats: TF2 - Points given when killing with C.A.P.P.E.R.", _, true, 0.0);
	Weapon[30667]	= CreateConVar("xstats_weapon_batsaber",		"10",	"xStats: TF2 - Points given when killing with Batsaber.", _, true, 0.0);
	Weapon[30668]	= CreateConVar("xstats_weapon_gigarcounter",	"10",	"xStats: TF2 - Points given when killing with Gigar Counter.", _, true, 0.0);
	Weapon[30758]	= CreateConVar("xstats_weapon_prinnymachete",	"10",	"xStats: TF2 - Points given when killing with Prinny Machete.", _, true, 0.0);
	
	TF2_SentryKill		= CreateConVar("xstats_points_sentrykill",		"5",	"xStats: TF2 - Points given when killing with Sentry gun.", _, true, 0.0);
	TF2_MiniSentryKill	= CreateConVar("xstats_points_minisentrykill",	"5",	"xStats: TF2 - Points given when killing with Mini-Sentry gun.", _, true, 0.0);
	
	TF2_PointCaptured	= CreateConVar("xstats_points_point_captured",	"5",	"xStats: TF2 - Points given when capturing a point.", _, true, 0.0);
	TF2_PointBlocked	= CreateConVar("xstats_points_point_blocked",	"5",	"xStats: TF2 - Points given when blocking a point from being captured.", _, true, 0.0);
	
	TF2_FlagEvent[1]	= CreateConVar("xstats_points_flag_pickedup",	"5",	"xStats: TF2 - Points given when picking up the flag.", _, true, 0.0);
	TF2_FlagEvent[2]	= CreateConVar("xstats_points_flag_captured",	"5",	"xStats: TF2 - Points given when capturing the flag.", _, true, 0.0);
	TF2_FlagEvent[3]	= CreateConVar("xstats_points_flag_defended",	"5",	"xStats: TF2 - Points given when defending the flag.", _, true, 0.0);
	TF2_FlagEvent[4]	= CreateConVar("xstats_points_flag_dropping",	"5",	"xStats: TF2 - Points taken when dropping the flag.", _, true, 0.0);
	TF2_FlagStolen		= CreateConVar("xstats_points_flag_stealing",	"5",	"xStats: TF2 - Points given when stealing the flag. Paired with picking up.", _, true, 0.0);
	
	/* Classes */
	TF2_DeathClass[1]	= CreateConVar("xstats_points_death_scout",		"5",	"xStats: TF2 - Points taken when dying as Scout.", _, true, 0.0);
	TF2_DeathClass[2]	= CreateConVar("xstats_points_death_sniper",	"5",	"xStats: TF2 - Points taken when dying as Sniper.", _, true, 0.0);
	TF2_DeathClass[3]	= CreateConVar("xstats_points_death_soldier",	"5",	"Xstats: TF2 - Points taken when dying as Soldier.", _, true, 0.0);
	
	/* Events */
	HookEventEx(EVENT_PLAYER_DEATH,				Player_Death_TF2,			EventHookMode_Pre);
	HookEventEx(EVENT_TEAMPLAY_POINT_CAPTURED,	Teamplay_Point_Captured,	EventHookMode_Pre);
	HookEventEx(EVENT_TEAMPLAY_CAPTURE_BLOCKED,	Teamplay_Capture_Blocked,	EventHookMode_Pre);
	HookEventEx(EVENT_TEAMPLAY_FLAG_EVENT,		Teamplay_Flag_Event,		EventHookMode_Pre);
	
	/* Rounds */
	HookEventEx(EVENT_TEAMPLAY_ROUND_ACTIVE,	Event_TF2Rounds, EventHookMode_Pre);
	HookEventEx(EVENT_TEAMPLAY_ROUND_WIN,		Event_TF2Rounds, EventHookMode_Pre);
	
	AutoExecConfig(true, "xstats.tf.cfg");
}

stock void Event_TF2Rounds(Event event, const char[] event_name, bool dontBroadcast)	{
	StrEqual(event_name, EVENT_TEAMPLAY_ROUND_ACTIVE) ? RoundStarted() : RoundEnded();
}

public void TF2_OnWaitingForPlayersStart()	{
	WarmupActive = false;
}

public void TF2_OnWaitingForPlayersEnd()	{
	WarmupActive = true;
}