/**
 *	Prepare database.
 */
void PrepareDB_TF2()	{
	char query[16177];
	int len = 0;
	
	len += Format(query[len], sizeof(query)-len, "create table if not exists `playerlist_tf2`");
	len += Format(query[len], sizeof(query)-len, "(");
	len += Format(query[len], sizeof(query)-len, "`ServerID`					int(16)			not null default '1' comment 'Servers unique ID',");
	len += Format(query[len], sizeof(query)-len, "`Points`						int(32)			not null default '1000',");
	len += Format(query[len], sizeof(query)-len, "`PlayTime`					int(32)			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Playername`					varchar(64)		not null default '',");
	len += Format(query[len], sizeof(query)-len, "`SteamID`						varchar(64)		not null default '',");
	len	+= Format(query[len], sizeof(query)-len, "`IPAddress`					varchar(64)		not null default '127.0.0.1',");
	len += Format(query[len], sizeof(query)-len, "`Headshots`					int(32)			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Backstabs`					int(32)			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills`						int(32)			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`CritKills`					int(32)			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`TauntKills`					int(32)			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Deaths`						int(32)			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Suicides`					int(32)			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Assists`						int(32)			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Noscopes`					int(32)			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Dominations`					int(32)			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Revenges`					int(32)			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`TeleFrags`					int(32)			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`MiniSentryKills`				int(32)			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`SentryKills`					int(32)			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`SentryLVL1Kills`				int(32)			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`SentryLVL2Kills`				int(32)			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`SentryLVL3Kills`				int(32)			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`MiniSentriesBuilt`			int(32)			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`SentriesBuilt`				int(32)			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`DispensersBuilt`				int(32)			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`TeleporterExitsBuilt`		int(32)			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`TeleporterEntrancesBuilt`	int(32)			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`PointsCaptured`				int(32)			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`PointsDefended`				int(32)			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`FlagsPickedUp`				int(32)			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`FlagsStolen`					int(32)			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`FlagsDefended`				int(32)			not null default '0',");
	
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_bat`					int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_bottle`					int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_fireaxe`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_kukri`					int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_knife`					int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_fists`					int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_shovel`					int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_wrench`					int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_bonesaw`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_shotgun`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_scattergun`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_sniperrifle`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_minigun`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_smg`					int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_syringegun`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_rocketlauncher`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_grenadelauncher`		int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_stickybomblauncher`		int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_flamethrower`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_pistol`					int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_revolver`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_blutsauger`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_ubersaw`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_axtinguisher`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_flaregun`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_backburner`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_natascha`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_kgob`					int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_sandman`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_forceanature`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_huntsman`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_ambassador`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_directhit`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_equalizer`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_scottishresistance`		int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_chargentarge`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_eyelander`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_wrangler`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_frontierjustice`		int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_gunslinger`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_homewrecker`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_paintrain`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_southernhospitality`	int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_tribalmansshiv`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_scotmansskullcutter`	int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_vitasaw`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_powerjack`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_degreaser`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_shortstop`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_holymackerel`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_letranger`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_eternalreward`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_blackbox`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_sydneysleeper`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_bushwacka`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_goru`					int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_fryingpan`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_hhhh`					int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_lugermorph`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_ironcurtain`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_amputator`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_crusaderscrossbow`		int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_ullapoolcaber`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_lochnload`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_warriorsspirit`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_brassbeast`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_candycane`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_bostonbasher`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_backscratcher`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_claidheamhmor`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_jag`					int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_fistsofsteel`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_sharpenedvolcanofragment`	int(32) not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_sunonastick`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_detonator`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_fanowar`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_conniverskunai`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_halfzatoichi`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_shahanshah`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_bazaarbargain`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_persainpersuader`		int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_splendidscreen`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_overdose`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_solemnvow`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_libertylauncher`		int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_reserveshooter`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_marketgardener`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_saxxy`					int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_tomislav`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_familybusiness`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_evictionnotice`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_cowmangler5000`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_righteousbison`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_mantreads`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_disciplinaryaction`		int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_sodapopper`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_winger`					int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_atomizer`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_threeruneblade`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_postalpummeler`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_enforcer`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_bigearner`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_maul`					int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_concentiousobjector`	int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_nessiesnineiron`		int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_original`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_diamondback`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_machina`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_widowmaker`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_shortcircuit`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_unarmedcombat`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_wangaprick`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_apocofists`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_pomson6000`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_eurekaeffect`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_thirddegree`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_phlogistinator`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_manmelter`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_scottishhandshake`		int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_sharpdresser`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_wrapassassin`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_spycicle`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_holidaypunch`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_blackrose`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_lollipop`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_scorchshot`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_rainblower`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_cleanerscarbine`		int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_hitmansheatmaker`		int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_babyfacesblaster`		int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_prettyboyspocketpistol`	int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_escapeplan`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_huolongheater`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_flyingguillotine`		int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_neonannihilator`		int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_awperhand`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_freedomstaff`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_batouttahell`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_memorymaker`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_hamshank`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_goldenfryingpan`		int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_fortifiedcompount`		int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_classic`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_tideturner`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_breadbite`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_backscatter`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_airstrike`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_necrosmasher`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_crossingguard`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_quickiebomblauncher`	int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_ironbomber`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_panicattack`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_dragonsfury`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_thermalthruster`		int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_hothand`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_nostromonapalmer`		int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_shootingstar`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_capper`					int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_batsaber`				int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_gigarcounter`			int(32)	not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Kills_weapon_prinnymachete`			int(32)	not null default '0',");
	
	len += Format(query[len], sizeof(query)-len, "primary key (`SteamID`)");
	len += Format(query[len], sizeof(query)-len, ")");
	db.Query(DBQuery_DB, query, 1);
	
	//Reset for new query.
	query = "";
	len = 0;
	
	len += Format(query[len], sizeof(query)-len, "create table if not exists `kill_log_tf2`");
	len += Format(query[len], sizeof(query)-len, "(");
	len += Format(query[len], sizeof(query)-len, "`ID`							int(32)			not null auto_increment,");
	len += Format(query[len], sizeof(query)-len, "`Playername`					varchar(64)		not null default '',");
	len += Format(query[len], sizeof(query)-len, "`SteamID`						varchar(64)		not null default '',");
	len += Format(query[len], sizeof(query)-len, "`Victim_Playername`			varchar(64)		not null default '',");
	len += Format(query[len], sizeof(query)-len, "`Victim_SteamID`				varchar(64)		not null default '',");
	len += Format(query[len], sizeof(query)-len, "`Assister_Playername`			varchar(64)		not null default '',");
	len += Format(query[len], sizeof(query)-len, "`Assister_SteamID`			varchar(64)		not null default '',");
	len += Format(query[len], sizeof(query)-len, "`Timestamp`					timestamp		not null default current_timestamp,");
	len += Format(query[len], sizeof(query)-len, "`Weapon`						varchar(64)		not null default '',");
	len += Format(query[len], sizeof(query)-len, "`Headshot`					bool			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`Noscope`						bool			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`MidAir`						bool			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "`CritType`					int(2)			not null default '0',");
	len += Format(query[len], sizeof(query)-len, "primary key (`ID`)");
	len += Format(query[len], sizeof(query)-len, ")");
	db.Query(DBQuery_DB, query, 2);
}