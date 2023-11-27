stock bool IsValidClient(int client, bool bIsFakeClient=true)
{
	if(client < 1 || client > MaxPlayers)
	{
		return false;
	}
	
	if(!IsClientConnected(client))
	{
		return false;
	}
	
	if(IsClientReplay(client))
	{
		return false;
	}
	
	if(IsClientSourceTV(client))
	{
		return false;
	}
	
	if(bIsFakeClient)
	{
		if(IsFakeClient(client))
		{
			return false;
		}
	}
	
	return true;
}

stock int GetPlayerWeaponSlotItemdef(int client, int slot)
{
	int weapon = GetPlayerWeaponSlot(client, slot);
	
	if(IsValidEntity(weapon))
	{
		return GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex");
	}
	
	return -1;
}

/* ============================================================== */

stock void PanelItem(Panel panel, const char[] text, any ...)
{
	char vformat[512];
	VFormat(vformat, sizeof(vformat), text, 3);
	
	panel.DrawItem(vformat);
}

stock void PanelText(Panel panel, const char[] text, any ...)
{
	char vformat[512];
	VFormat(vformat, sizeof(vformat), text, 3);
	
	panel.DrawText(vformat);
}

/* ============================================================== */

/**
 *	Returns the total player count in a database table.
 */
stock int GetTablePlayerCount()
{
	int players = 0;
	
	if(!!sql)
	{
		char query[256];
		Format(query, sizeof(query), "select * from `"...sql_table_playerlist..."` where `StatsID`='%i'", g_StatsID);
		
		SQL_LockDatabase(sql);
		DBResultSet results = SQL_Query(sql, query);
		SQL_UnlockDatabase(sql);
		
		switch(!!results)
		{
			case false:
			{
				char error[256];
				SQL_GetError(sql, error, sizeof(error));
				LogError("%s GetTablePlayerCount error: Failed getting playercount of sql table '"...sql_table_playerlist..."' (%s)", core_chattag, error);
			}
			case true: players = results.RowCount;
		}
		
		delete results;
	}
	
	return players;
}

/* ============================================================== */

stock int GetPlayerCount(bool count_bots=false)
{
	int count, player = 0;
	while((player = FindEntityByClassname(player, "player")) != -1)
	{
		if(IsValidClient(player, !count_bots))
		{
			count++;
		}
	}
	
	return count;
}

stock bool IsWarmupActive()
{
	switch(GetEngineVersion())
	{
		case Engine_CSGO:
		{
			return view_as<bool>(GameRules_GetProp("m_bWarmupPeriod"));
		}
		
		case Engine_TF2:
		{
			return view_as<bool>(GameRules_GetProp("m_bInWaitingForPlayers"));
		}
	}
	
	return false;
}

/* Called as soon the round has started. */
stock void OnRoundStarted(Event event, const char[] event_name, bool dontBroadcast)
{
	bRoundActive = true;
	_sm_stats_info_update_round_active(true);
	
	if((bWarmupActive = IsWarmupActive()) && !bAllowWarmup)
	{
		int player = 0;
		while((player = FindEntityByClassname(player, "player")) != -1)
		{
			if(IsValidClient(player))
			{
				CPrintToChat(player, "%s %T", g_ChatTag, "#SMStats_RoundStart_Warmup", player);
			}
		}
		return;
	}
	
	if(bDisableAfterRoundEnd)
	{
		int needed = g_MinPlayers;
		int players = GetPlayerCount(bAllowBots);
		
		if(needed <= players)
		{
			bStatsActive = true;
			
			int player = 0;
			while((player = FindEntityByClassname(player, "player")) != -1)
			{
				if(IsValidClient(player))
				{
					CPrintToChat(player, "%s %T", g_ChatTag, "#SMStats_RoundStart", player);
				}
			}
		}
	}
}

/* Called as soon as the round has ended. */
stock void OnRoundEnded(Event event, const char[] event_name, bool dontBroadcast)
{
	bRoundActive = false;
	_sm_stats_info_update_round_active(false);
	
	if((bWarmupActive = IsWarmupActive()) && !bAllowWarmup)
	{
		return;
	}
	
	if(bDisableAfterRoundEnd)
	{
		bStatsActive = false;
		
		int player = 0;
		while((player = FindEntityByClassname(player, "player")) != -1)
		{
			if(IsValidClient(player))
			{
				CPrintToChat(player, "%s %T", g_ChatTag, "#SMStats_RoundEnd", player);
			}
		}
	}
}

void CheckActivePlayers()
{
	int players = GetPlayerCount(bAllowBots);
	
	switch(bStatsActive)
	{
		case false:
		{
			if(players >= g_MinPlayers && bRoundActive)
			{
				bStatsActive = true;
				_sm_stats_info_update_stats_active(true);
				
				int player = 0;
				while((player = FindEntityByClassname(player, "player")) != -1)
				{
					if(IsValidClient(player))
					{
						CPrintToChat(player, "%s %T"
						, g_ChatTag
						, "#SMStats_EnoughPlayers", player
						, players
						, g_MinPlayers);
					}
				}
			}
		}
		
		case true:
		{
			if(players < g_MinPlayers)
			{
				bStatsActive = false;
				_sm_stats_info_update_stats_active(false);
				
				int player = 0;
				while((player = FindEntityByClassname(player, "player")) != -1)
				{
					if(IsValidClient(player))
					{
						CPrintToChat(player, "%s %T"
						, g_ChatTag
						, "#SMStats_NotEnoughPlayers", player
						, players
						, g_MinPlayers);
					}
				}
			}
		}
	}
	
	if(bDebug) PrintToServer("CheckActivePlayers() : %i players out of required %i"
	... "\n bStatsActive : %s"
	... "\n bRoundActive : %s"
	, players, g_MinPlayers
	, bStatsActive ? "true" : "false"
	, bRoundActive ? "true" : "false");
}

stock bool IsValidStats()
{
	if(!bLoaded)
	{
		if(bDebug) PrintToServer("IsValidStats() - bLoaded : false");
		return false;
	}
	else if(!bStatsActive)
	{
		if(bDebug) PrintToServer("IsValidStats() - bStatsActive : false");
		return false;
	}
	else if(!bRoundActive)
	{
		if(bDebug) PrintToServer("IsValidStats() - bRoundActive : false");
		return false;
	}
	else if(bWarmupActive)
	{
		if(!bAllowWarmup)
		{
			if(bDebug) PrintToServer("IsValidstats() - bWarmupActive : false (not allowed)");
			return false;
		}
	}
	
	return true;
}

/*
 *	Returns wheter abuse is active.
 *	Such as user using Noclip or sv_cheats is active during the event.
 */
stock bool IsValidAbuse(int client)
{
	if(bAllowAbuse)
	{
		return false;
	}
	
	ConVar cvar;
	
	if(!!(cvar = FindConVar("sv_cheats")))
	{
		if(cvar.BoolValue)
		{
			return true;
		}
	}
	else if(client > 0)
	{
		if(GetEntityMoveType(client) == MOVETYPE_NOCLIP)
		{
			return true;
		}
	}
	
	return false;
}

/* ============================================================== */

stock void GetMultipleTargets(int client, const int[] list, int counter, char[] dummy, int maxlen)
{
	if(counter == 1)
	{
		int userid = list[0];
		int target = GetClientOfUserId(userid);
		strcopy(dummy, maxlen, g_Player[target].name);
	}
	else if(counter == 2)
	{
		int userid1 = list[0];
		int target1 = GetClientOfUserId(userid1);
		
		int userid2 = list[1];
		int target2 = GetClientOfUserId(userid2);
		
		Format(dummy, maxlen, "%s%T%s", g_Player[target1].name, "#SMStats_And", client, g_Player[target2].name);
	}
	else if(counter == 3)
	{
		int userid1 = list[0];
		int target1 = GetClientOfUserId(userid1);
		
		int userid2 = list[1];
		int target2 = GetClientOfUserId(userid2);
		
		int userid3 = list[2];
		int target3 = GetClientOfUserId(userid3);
		
		Format(dummy, maxlen, "%s%T%s%T%s", g_Player[target1].name, "#SMStats_Comma", client, g_Player[target2].name2, "#SMStats_And", client, g_Player[target3].name);
	}
	else
	{
		Format(dummy, maxlen, "%T%T", "#SMStats_MultiplePlayers", client, "#SMStats_Counter", client, counter);
	}
}

/* ============================================================== */

/*
 ========================
 ========================
 ========================
 ========================
*/

/**
 *	Frag scenario | Used for translations.
 *	The kill events will be merged together automatically.
 *	Example: Headshot whilst Mid-Air or Headshot Through Smoke whilst Mid-Air, etc.. (You get it)
 */
enum
{
	Frag_MidAir = 0,
	Frag_ThroughSmoke = 1,
	Frag_NoscopeHS = 2,
	Frag_Headshot = 3,
	Frag_Noscope = 4,
	Frag_Backstab = 5,
	Frag_Airshot = 6,
	Frag_Deflect = 7,
	Frag_TeleFrag = 8,
	Frag_Taunt = 9,
	Frag_Sentry = 10,
	Frag_MiniSentry = 11,
	Frag_WrangledSentry = 12,
	Frag_WrangledMiniSentry = 13,
	Frag_PumpkinBomb = 14,
	Frag_Collateral = 15,
	Frag_Grenade = 16,
	Frag_Bomb = 17,
	Frag_Blinded = 18,
}
char Frag_Type[][] = {
/*0*/"#SMStats_FragEvent_Type0", //Mid-Air.
/*1*/"#SMStats_FragEvent_Type1", //Through Smoke.
/*2*/"#SMStats_FragEvent_Type2", //Noscope Headshot.
/*3*/"#SMStats_FragEvent_Type3", //Headshot.
/*4*/"#SMStats_FragEvent_Type4", //Noscope.
/*5*/"#SMStats_FragEvent_Type5", //Backstab.
/*6*/"#SMStats_FragEvent_Type6", //Airshot.
/*7*/"#SMStats_FragEvent_Type7", //Deflect frag.
/*8*/"#SMStats_FragEvent_Type8", //Telefrag.
/*9*/"#SMStats_FragEvent_Type9", //Taunt frag.
/*10*/"#SMStats_FragEvent_Type10", //Sentry Gun.
/*11*/"#SMStats_FragEvent_Type11", //Mini-Sentry Gun.
/*12*/"#SMStats_FragEvent_Type12", //Wrangled Sentry Gun.
/*13*/"#SMStats_FragEvent_Type13", //Wrangled Mini-Sentry Gun.
/*12*/"#SMStats_FragEvent_Type14", //Pumpkin Bomb frag.
/*13*/"#SMStats_FragEvent_Type15", //Collateral.
/*14*/"#SMStats_FragEvent_Type16", //Grenade frag.
/*15*/"#SMStats_FragEvent_Type17", //Bomb frag.
/*16*/"#SMStats_FragEvent_Type18", //Blinded frag.
};

/**
 *	Prepare the kill message.
 *
 *	@param	client	The client who killed.
 *	@param	victim	The victim who died.
 *	@param	points	The points the client was given
 */
stock void PrepareFragMessage(int client, const char[] victim, int points, int frags)
{
	if(bDebug) PrintToServer("%s PrepareFragMessage(client %i, victim '%s', points %i, frags %i)", core_chattag, client, victim, points, frags);
	char buffer[196];
	
	/* Le ol' messy code but has to be it. */
	
	/* Deflect kill */
	if(g_Player[client].fragmsg.Deflected)
	{
		/* Airshot deflect kill */
		if(g_Player[client].fragmsg.Airshot)
		{
			switch(g_Player[client].fragmsg.Headshot)
			{
				/* Headshot airshot deflect kill */
				case true:
				{
					Format(buffer, sizeof(buffer), "%T{default} %T{default} %T{default}"
					, Frag_Type[Frag_Deflect], client
					, Frag_Type[Frag_Headshot], client
					, Frag_Type[Frag_Airshot], client);
				}
				/* Airshot deflect kill */
				case false:
				{
					Format(buffer, sizeof(buffer), "%T{default} %T{default}"
					, Frag_Type[Frag_Deflect], client
					, Frag_Type[Frag_Airshot], client);
				}
			}
		}
		else
		{
			switch(g_Player[client].fragmsg.Headshot)
			{
				/* Headshot deflect kill */
				case true:
				{
					Format(buffer, sizeof(buffer), "%T{default} %T{default}"
					, Frag_Type[Frag_Deflect], client
					, Frag_Type[Frag_Headshot], client);
				}
				/* Deflect kill */
				case false:
				{
					Format(buffer, sizeof(buffer), "%T{default}"
					, Frag_Type[Frag_Deflect], client);
				}
			}
		}
	}
	/* Collateral */
	else if(g_Player[client].fragmsg.Collateral)
	{
		switch(g_Player[client].fragmsg.Headshot)
		{
			/* Headshot collateral kill */
			case true:
			{
				Format(buffer, sizeof(buffer), "%T{default} %T{default}"
				, Frag_Type[Frag_Headshot], client
				, Frag_Type[Frag_Collateral], client);
			}
			/* Colllateral kill */
			case false:
			{
				Format(buffer, sizeof(buffer), "%T{default}"
				, Frag_Type[Frag_Collateral], client);
			}
		}
	}
	/* Airshot kill */
	else if(g_Player[client].fragmsg.Airshot)
	{
		/* Mid air airshot kill */
		if(g_Player[client].fragmsg.MidAir)
		{
			switch(g_Player[client].fragmsg.Headshot)
			{
				/* Mid air airshot headshot kill */
				case true:
				{
					Format(buffer, sizeof(buffer), "%T{default} %T{default} %T{default}"
					, Frag_Type[Frag_Headshot], client
					, Frag_Type[Frag_Airshot], client
					, Frag_Type[Frag_MidAir], client);
				}
				/* Mid air airshot kill */
				case false:
				{
					Format(buffer, sizeof(buffer), "%T{default} %T{default}"
					, Frag_Type[Frag_Airshot], client
					, Frag_Type[Frag_MidAir], client);
				}
			}
		}
		/* Airshot kill */
		else
		{
			switch(g_Player[client].fragmsg.Headshot)
			{
				/* Airshot headshot kill */
				case true:
				{
					Format(buffer, sizeof(buffer), "%T{default}"
					, Frag_Type[Frag_Headshot], client
					, Frag_Type[Frag_Airshot], client);
				}
				/* Airshot kill */
				case false:
				{
					Format(buffer, sizeof(buffer), "%T{default}"
					, Frag_Type[Frag_Airshot], client);
				}
			}
		}
	}
	/* Backstab kill */
	else if(g_Player[client].fragmsg.Backstab)
	{
		switch(g_Player[client].fragmsg.MidAir)
		{
			/* Mid air backstab kill */
			case true:
			{
				Format(buffer, sizeof(buffer), "%T{default} %T{default}"
				, Frag_Type[Frag_Backstab], client
				, Frag_Type[Frag_MidAir], client);
			}
			/* backstab kill */
			case false:
			{
				Format(buffer, sizeof(buffer), "%T{default}"
				, Frag_Type[Frag_Backstab], client);
			}
		}
	}
	/* Noscope kill */
	else if(g_Player[client].fragmsg.Noscope)
	{
		/* Noscope headshot kill */
		if(g_Player[client].fragmsg.Headshot)
		{
			/* Noscope headshot kill through smoke */
			if(g_Player[client].fragmsg.ThroughSmoke)
			{
				/* Noscope headshot through smoke whilst blinded */
				if(g_Player[client].fragmsg.Blinded)
				{
					switch(g_Player[client].fragmsg.MidAir)
					{
						/* Mid air noscope headshot kill through smoke whilst blinded */
						case true:
						{
							Format(buffer, sizeof(buffer), "%T{default} %T{default} %T{default} %T{default}"
							, Frag_Type[Frag_NoscopeHS], client
							, Frag_Type[Frag_ThroughSmoke], client
							, Frag_Type[Frag_Blinded], client
							, Frag_Type[Frag_MidAir], client);
						}
						/* Noscope headshot through smoke whilst blinded */
						case false:
						{
							Format(buffer, sizeof(buffer), "%T{default} %T{default} %T{default}"
							, Frag_Type[Frag_NoscopeHS], client
							, Frag_Type[Frag_ThroughSmoke], client
							, Frag_Type[Frag_Blinded], client);
						}
					}
				}
				/* Noscope headshot kill through smoke */
				else
				{
					switch(g_Player[client].fragmsg.MidAir)
					{
						/* Mid air noscope headshot kill through smoke */
						case true:
						{
							Format(buffer, sizeof(buffer), "%T{default} %T{default} %T{default}"
							, Frag_Type[Frag_NoscopeHS], client
							, Frag_Type[Frag_ThroughSmoke], client
							, Frag_Type[Frag_MidAir], client);
						}
						/* Noscope headshot kill through smoke */
						case false:
						{
							Format(buffer, sizeof(buffer), "%T{default} %T{default}"
							, Frag_Type[Frag_NoscopeHS], client
							, Frag_Type[Frag_ThroughSmoke], client);
						}
					}
				}
			}
			/* Noscope headshot kill */
			else
			{
				switch(g_Player[client].fragmsg.MidAir)
				{
					/* Mid air noscope headshot */
					case true:
					{
						Format(buffer, sizeof(buffer), "%T{default} %T{default}"
						, Frag_Type[Frag_NoscopeHS], client
						, Frag_Type[Frag_MidAir], client);
					}
					/* Noscope headshot kill */
					case false:
					{
						Format(buffer, sizeof(buffer), "%T{default}"
						, Frag_Type[Frag_NoscopeHS], client);
					}
				}

			}
		}
		/* Mid air noscope kill */
		else if(g_Player[client].fragmsg.MidAir)
		{
			/* Mid air noscope kill through smoke */
			if(g_Player[client].fragmsg.ThroughSmoke)
			{
				switch(g_Player[client].fragmsg.Blinded)
				{
					/* Mid air noscope kill through smoke whilst blinded */
					case true:
					{
						Format(buffer, sizeof(buffer), "%T{default} %T{default} %T{default} %T{default}"
						, Frag_Type[Frag_Noscope], client
						, Frag_Type[Frag_ThroughSmoke], client
						, Frag_Type[Frag_Blinded], client
						, Frag_Type[Frag_MidAir], client);
					}
					/* Mid air noscope kill through smoke */
					case false:
					{
						Format(buffer, sizeof(buffer), "%T{default} %T{default} %T{default}"
						, Frag_Type[Frag_Noscope], client
						, Frag_Type[Frag_ThroughSmoke], client
						, Frag_Type[Frag_MidAir], client);
					}
				}
			}
			/* Mid air headshot kill */
			else
			{
				switch(g_Player[client].fragmsg.Blinded)
				{
					/* Mid air noscope headshot kill while blinded */
					case true:
					{
						Format(buffer, sizeof(buffer), "%T{default} %T{default} %T{default}"
						, Frag_Type[Frag_NoscopeHS], client
						, Frag_Type[Frag_Blinded], client
						, Frag_Type[Frag_MidAir], client);
					}
					/* Mid air noscope headshot kill */
					case false:
					{
						Format(buffer, sizeof(buffer), "%T{default} %T{default}"
						, Frag_Type[Frag_NoscopeHS], client
						, Frag_Type[Frag_MidAir], client);
					}
				}
			}
		}
		/* Noscope kill */
		else
		{
			/* Noscope kill through smoke */
			if(g_Player[client].fragmsg.ThroughSmoke)
			{
				switch(g_Player[client].fragmsg.Blinded)
				{
					/* Noscope kill through smoke while blinded */
					case true:
					{
						Format(buffer, sizeof(buffer), "%T{default} %T{default} %T{default}"
						, Frag_Type[Frag_Noscope], client
						, Frag_Type[Frag_ThroughSmoke], client
						, Frag_Type[Frag_Blinded], client);
					}
					/* Noscope kill through smoke */
					case false:
					{
						Format(buffer, sizeof(buffer), "%T{default} %T{default}"
						, Frag_Type[Frag_Noscope], client
						, Frag_Type[Frag_ThroughSmoke], client);
					}
				}
			}
			/* Noscope kill */
			else
			{
				switch(g_Player[client].fragmsg.Blinded)
				{
					/* Noscope kill whilst blinded */
					case true:
					{
						Format(buffer, sizeof(buffer), "%T{default} %T{default}"
						, Frag_Type[Frag_Noscope], client
						, Frag_Type[Frag_Blinded], client);
					}
					/* Noscope kill */
					case false:
					{
						Format(buffer, sizeof(buffer), "%T{default}"
						, Frag_Type[Frag_Noscope], client);
					}
				}
			}
		}
	}
	/* Headshot kill */
	else if(g_Player[client].fragmsg.Headshot)
	{
		/* Headshot kill through smoke */
		if(g_Player[client].fragmsg.ThroughSmoke)
		{
			/* Headshot through smoke whilst blinded */
			if(g_Player[client].fragmsg.Blinded)
			{
				switch(g_Player[client].fragmsg.MidAir)
				{
					/* Mid air headshot kill through smoke whilst blinded */
					case true:
					{
						Format(buffer, sizeof(buffer), "%T{default} %T{default} %T{default} %T{default}"
						, Frag_Type[Frag_Headshot], client
						, Frag_Type[Frag_ThroughSmoke], client
						, Frag_Type[Frag_Blinded], client
						, Frag_Type[Frag_MidAir], client);
					}
					/* Headshot through smoke whilst blinded */
					case false:
					{
						Format(buffer, sizeof(buffer), "%T{default} %T{default} %T{default}"
						, Frag_Type[Frag_Headshot], client
						, Frag_Type[Frag_ThroughSmoke], client
						, Frag_Type[Frag_Blinded], client);
					}
				}
			}
			/* Headshot kill through smoke */
			else
			{
				switch(g_Player[client].fragmsg.MidAir)
				{
					/* Mid air headshot kill through smoke */
					case true:
					{
						Format(buffer, sizeof(buffer), "%T{default} %T{default} %T{default}"
						, Frag_Type[Frag_Headshot], client
						, Frag_Type[Frag_ThroughSmoke], client
						, Frag_Type[Frag_MidAir], client);
					}
					/* Headshot kill through smoke */
					case false:
					{
						Format(buffer, sizeof(buffer), "%T{default} %T{default}"
						, Frag_Type[Frag_Headshot], client
						, Frag_Type[Frag_ThroughSmoke], client);
					}
				}
			}
		}
		/* Mid air headshot kill */
		else if(g_Player[client].fragmsg.MidAir)
		{
			/* Mid air headshot kill through smoke */
			if(g_Player[client].fragmsg.ThroughSmoke)
			{
				switch(g_Player[client].fragmsg.Blinded)
				{
					/* Mid air headshot kill through smoke whilst blinded */
					case true:
					{
						Format(buffer, sizeof(buffer), "%T{default} %T{default} %T{default} %T{default}"
						, Frag_Type[Frag_Headshot], client
						, Frag_Type[Frag_ThroughSmoke], client
						, Frag_Type[Frag_Blinded], client
						, Frag_Type[Frag_MidAir], client);
					}
					/* Mid air headshot kill through smoke */
					case false:
					{
						Format(buffer, sizeof(buffer), "%T{default} %T{default} %T{default}"
						, Frag_Type[Frag_Headshot], client
						, Frag_Type[Frag_ThroughSmoke], client
						, Frag_Type[Frag_MidAir], client);
					}
				}
			}
			/* Mid air headshot kill */
			else
			{
				switch(g_Player[client].fragmsg.Blinded)
				{
					/* Mid air headshot kill while blinded */
					case true:
					{
						Format(buffer, sizeof(buffer), "%T{default} %T{default} %T{default}"
						, Frag_Type[Frag_Headshot], client
						, Frag_Type[Frag_Blinded], client
						, Frag_Type[Frag_MidAir], client);
					}
					/* Mid air headshot kill */
					case false:
					{
						Format(buffer, sizeof(buffer), "%T{default} %T{default}"
						, Frag_Type[Frag_Headshot], client
						, Frag_Type[Frag_MidAir], client);
					}
				}
			}
		}
		/* Headshot kill */
		else
		{
			/* Headshot kill through smoke */
			if(g_Player[client].fragmsg.ThroughSmoke)
			{
				switch(g_Player[client].fragmsg.Blinded)
				{
					/* Headshot kill through smoke while blinded */
					case true:
					{
						Format(buffer, sizeof(buffer), "%T{default} %T{default} %T{default}"
						, Frag_Type[Frag_Headshot], client
						, Frag_Type[Frag_ThroughSmoke], client
						, Frag_Type[Frag_Blinded], client);
					}
					/* Headshot kill through smoke */
					case false:
					{
						Format(buffer, sizeof(buffer), "%T{default} %T{default}"
						, Frag_Type[Frag_Headshot], client
						, Frag_Type[Frag_ThroughSmoke], client);
					}
				}
			}
			/* Headshot kill */
			else
			{
				switch(g_Player[client].fragmsg.Blinded)
				{
					/* Headshot kill whilst blinded */
					case true:
					{
						Format(buffer, sizeof(buffer), "%T{default} %T{default}"
						, Frag_Type[Frag_Headshot], client
						, Frag_Type[Frag_Blinded], client);
					}
					/* Headshot kill */
					case false:
					{
						Format(buffer, sizeof(buffer), "%T{default}"
						, Frag_Type[Frag_Headshot], client);
					}
				}
			}
		}
	}
	/* Telefrag */
	else if(g_Player[client].fragmsg.TeleFrag)
	{
		Format(buffer, sizeof(buffer), "%T{default}"
		, Frag_Type[Frag_TeleFrag], client);
	}
	/* Taunt Frag */
	else if(g_Player[client].fragmsg.Taunt)
	{
		Format(buffer, sizeof(buffer), "%T{default}"
		, Frag_Type[Frag_Taunt], client);
	}
	/* Sentry Frag */
	else if(g_Player[client].fragmsg.Sentry)
	{
		Format(buffer, sizeof(buffer), "%T{default}"
		, Frag_Type[g_Player[client].fragmsg.Wrangled ? Frag_WrangledSentry:Frag_Sentry], client);
	}
	/* Mini-Sentry Frag */
	else if(g_Player[client].fragmsg.MiniSentry)
	{
		Format(buffer, sizeof(buffer), "%T{default}"
		, Frag_Type[g_Player[client].fragmsg.Wrangled ? Frag_WrangledMiniSentry:Frag_MiniSentry], client);
	}
	/* Pumpkin Bomb Frag */
	else if(g_Player[client].fragmsg.PumpkinBomb)
	{
		Format(buffer, sizeof(buffer), "%T{default}"
		, Frag_Type[Frag_PumpkinBomb], client);
	}
	/* Grenade Frag */
	else if(g_Player[client].fragmsg.Grenade)
	{
		Format(buffer, sizeof(buffer), "%T{default}"
		, Frag_Type[Frag_Grenade], client);
	}
	/* Bomb Kill */
	else if(g_Player[client].fragmsg.Bomb)
	{
		Format(buffer, sizeof(buffer), "%T{default}"
		, Frag_Type[Frag_Bomb], client);
	}
	/* Blinded Kill */
	else if(g_Player[client].fragmsg.Blinded)
	{
		switch(g_Player[client].fragmsg.MidAir)
		{
			/* Mid air blinded kill */
			case true:
			{
				Format(buffer, sizeof(buffer), "%T{default} %T{default}"
				, Frag_Type[Frag_Blinded], client
				, Frag_Type[Frag_MidAir], client);
			}
			/* Blinded kill */
			case false:
			{
				Format(buffer, sizeof(buffer), "%T{default}"
				, Frag_Type[Frag_Blinded], client);
			}
		}
	}
	/* Mid air kill */
	else if(g_Player[client].fragmsg.MidAir)
	{
		Format(buffer, sizeof(buffer), "%T{default}"
		, Frag_Type[Frag_MidAir], client);
	}
	
	char points_plural1[64], points_plural2[64];
	PointsFormat(client, g_Player[client].points-points, points_plural1, sizeof(points_plural1));
	PointsPluralSplitter(client, points, points_plural2, sizeof(points_plural2), PointSplit_Plus);
	
	switch(strlen(buffer) > 0)
	{
		case false:
		{
			char str_counter[12];
			if(frags > 4)
			{
				Format(str_counter, sizeof(str_counter), "%T", "#SMStats_Counter", client, frags);
			}
			
			CPrintToChat(client, "%s %T%s"
			, g_ChatTag
			, "#SMStats_FragEvent_Default", client
			, g_Player[client].name
			, points_plural1
			, points_plural2
			, victim
			, (frags > 4) ? str_counter : "");
		}
		case true:
		{
			if(frags >= 4)
			{
				Format(buffer, sizeof(buffer), "%s%T", buffer, "#SMStats_Counter", client, frags);
			}
			
			CPrintToChat(client, "%s %T"
			, g_ChatTag
			, "#SMStats_FragEvent_Special", client
			, g_Player[client].name
			, points_plural1
			, points_plural2
			, victim
			, buffer);
		}
	}
	
	g_Player[client].fragmsg.Reset();
}

stock void PointsPluralSplitter(int client, int points, char[] translation, int maxlen, PointsSplitType type=PointSplit_Off)
{
	char fmt_plural[64];
	Format(fmt_plural, sizeof(fmt_plural), "%T", "#SMStats_Points", client);
	switch(StrContains(fmt_plural, "#|#") != -1)
	{
		// this language defies the 'point' and 'points' with one word as both singular and plural.
		case false:
		{
			if(type >= PointSplit_On)
			{
				char fmt_points[64];
				PointsPrefix(client, points, fmt_points, sizeof(fmt_points), type);
				Format(translation, maxlen, "%s%s", fmt_points, fmt_plural);
			}
			else
			{
				char fmt_points[24];
				PointsFormat(client, points, fmt_points, sizeof(fmt_points));
				Format(translation, maxlen, "%s%s", fmt_points, fmt_plural);
			}
		}
		// this language defies the 'point' and 'points' with one word as inflection-based singular and plural.
		case true:
		{
			bool bPlural = (points < -1 || points > 1);
			char szPlural[2][16];
			if(ExplodeString(fmt_plural, "#|#", szPlural, sizeof(szPlural), 16) == 2)
			{
				ReplaceString(szPlural[0], sizeof(szPlural[]), "#|#", "");
			}
			
			if(type >= PointSplit_On)
			{
				char fmt_points[64];
				PointsPrefix(client, points, fmt_points, sizeof(fmt_points), type);
				Format(translation, maxlen, "%s%s", fmt_points, szPlural[view_as<int>(bPlural)]);
			}
			else
			{
				char fmt_points[24];
				PointsFormat(client, points, fmt_points, sizeof(fmt_points));
				Format(translation, maxlen, "%s%s", fmt_points, szPlural[view_as<int>(bPlural)]);
			}
		}
	}
}

stock void PointsPrefix(int client, int points, char[] output, int maxlen, PointsSplitType type)
{
	PointsFormat(client, points, output, maxlen);
	
	if((points <= -1 || type == PointSplit_Minus))
	{
		// remove minus of the points shown, because it'd be a double minus otherwise.
		if(StrContains(output, "-") != -1)
		{
			ReplaceString(output, maxlen, "-", "");
		}
		
		//
		
		Format(output, maxlen, "{red}-%s{default}", output);
	}
	else if((points >= 1 || type == PointSplit_Plus))
	{
		Format(output, maxlen, "{green}+%s{default}", output);
	}
}

stock void OnOffPluralSplitter(int client, bool OffOn, char[] translation, int maxlen)
{
	char fmt_onoff_plural[24]
	Format(fmt_onoff_plural, sizeof(fmt_onoff_plural), "%T", "#SMStats_OffOn", client);
	if(StrContains(fmt_onoff_plural, "#|#") != -1)
	{
		char onoff_plural[2][24];
		ExplodeString(fmt_onoff_plural, "#|#", onoff_plural, sizeof(onoff_plural), 24);
		ReplaceString(onoff_plural[0], sizeof(onoff_plural[]), "#|#", "");
		strcopy(translation, maxlen, onoff_plural[view_as<int>(OffOn)]);
	}
}

//

stock bool PointsFormat(int client, int points, char[] output, int maxlen, bool bShowMinus=true)
{
	char fmt_points[24];
	IntToString(points, fmt_points, sizeof(fmt_points));
	bool bValue = false;
	
	//PrintToServer("%i = %s points", client, fmt_points);
	
	//
	
	// 1M
	if(points >= 1000000 || points <= -1000000)
	{
		if(PointsFormatTypeValid(client, "1M"))
		{
			// 1.1M
			if(points >= 1100000 || points <= -1100000)
			{
				char text_1[6], text_2[6], text_3[6];
				switch(StrContains(fmt_points, "-") != -1)
				{
					case false:
					{
						strcopy(text_1, sizeof(text_1), fmt_points[0]);
						strcopy(text_2, sizeof(text_2), fmt_points[1]);
						strcopy(text_3, sizeof(text_3), fmt_points[2]);
					}
					case true:
					{
						Format(text_1, sizeof(text_1), "%s%s", bShowMinus ? "-":"", fmt_points[1]);
						strcopy(text_2, sizeof(text_2), fmt_points[2]);
						strcopy(text_3, sizeof(text_3), fmt_points[3]);
					}
				}
				
				//
				
				ReplaceString(text_1, sizeof(text_1), text_2, "");
				ReplaceString(text_2, sizeof(text_2), text_3, "");
				
				//
				
				FormatEx(fmt_points, sizeof(fmt_points), "%s.%s%T", text_1, text_2, "#SMStats_PointsFormat_1M", client);
			}
			// 1M
			else
			{
				FormatEx(fmt_points, sizeof(fmt_points), "%s%T", fmt_points, "#SMStats_PointsFormat_1M", client);
			}
			
			bValue = true;
		}
	}
	// 100K
	else if(points >= 100000 || points <= -100000)
	{
		if(PointsFormatTypeValid(client, "100K"))
		{
			// 101K
			if(points >= 101000 || points <= -101000)
			{
				char text_1[6], text_2[6], text_3[6];
				switch(StrContains(fmt_points, "-") != -1)
				{
					case false:
					{
						strcopy(text_1, sizeof(text_1), fmt_points[1]);
						strcopy(text_2, sizeof(text_2), fmt_points[2]);
						strcopy(text_3, sizeof(text_3), fmt_points[3]);
					}
					case true:
					{
						Format(text_1, sizeof(text_1), "%s%s", bShowMinus ? "-":"", fmt_points[2]);
						strcopy(text_2, sizeof(text_2), fmt_points[3]);
						strcopy(text_3, sizeof(text_3), fmt_points[4]);
					}
				}
				
				//
				
				ReplaceString(text_1, sizeof(text_1), text_2, "");
				ReplaceString(text_2, sizeof(text_2), text_3, "");
				
				//
				
				FormatEx(fmt_points, sizeof(fmt_points), "%s.%s%T", text_1, text_2, "#SMStats_PointsFormat_100K", client);
			}
			// 100K
			else
			{
				FormatEx(fmt_points, sizeof(fmt_points), "%s%T", fmt_points, "#SMStats_PointsFormat_100K", client);
			}
			
			bValue = true;
		}
	}
	// 10K
	else if(points >= 10000 || points <= -10000)
	{
		if(PointsFormatTypeValid(client, "10K"))
		{
			// 10.1K
			if(points >= 10100 || points <= -10100)
			{
				char text_1[6], text_2[6], text_3[6];
				switch(StrContains(fmt_points, "-") != -1)
				{
					case false:
					{
						strcopy(text_1, sizeof(text_1), fmt_points[0]);
						strcopy(text_2, sizeof(text_2), fmt_points[1]);
						strcopy(text_3, sizeof(text_3), fmt_points[2]);
					}
					case true:
					{
						FormatEx(text_1, sizeof(text_1), "%s%s", bShowMinus ? "-":"", fmt_points[1]);
						strcopy(text_2, sizeof(text_2), fmt_points[2]);
						strcopy(text_3, sizeof(text_3), fmt_points[3]);
					}
				}
				
				//
				
				ReplaceString(text_1, sizeof(text_1), text_2, "");
				ReplaceString(text_2, sizeof(text_2), text_3, "");
				
				//
				
				FormatEx(fmt_points, sizeof(fmt_points), "%s.%s%T", text_1, text_2, "#SMStats_PointsFormat_10K", client);
			}
			// 10K
			else
			{
				FormatEx(fmt_points, sizeof(fmt_points), "%s%T", fmt_points, "#SMStats_PointsFormat_10K", client);
			}
		}
		
		bValue = true;
	}
	// 1K
	else if(points >= 1000 || points <= -1000)
	{
		if(PointsFormatTypeValid(client, "1K"))
		{
			// 1.1K
			if(points >= 1100 || points <= -1100)
			{
				char text_1[6], text_2[6], text_3[6];
				switch(StrContains(fmt_points, "-") != -1)
				{
					case false:
					{
						strcopy(text_1, sizeof(text_1), fmt_points[0]);
						strcopy(text_2, sizeof(text_2), fmt_points[1]);
						strcopy(text_3, sizeof(text_3), fmt_points[2]);
					}
					case true:
					{
						FormatEx(text_1, sizeof(text_1), "%s%s", bShowMinus ? "-":"", fmt_points[1]);
						strcopy(text_2, sizeof(text_2), fmt_points[2]);
						strcopy(text_3, sizeof(text_3), fmt_points[3]);
					}
				}
				
				//
				
				ReplaceString(text_1, sizeof(text_1), text_2, "");
				ReplaceString(text_2, sizeof(text_2), text_3, "");
				
				//
				
				FormatEx(fmt_points, sizeof(fmt_points), "%s.%s%T", text_1, text_2, "#SMStats_PointsFormat_1K", client);
			}
			// 10K
			else
			{
				FormatEx(fmt_points, sizeof(fmt_points), "%s%T", fmt_points, "#SMStats_PointsFormat_1K", client);
			}
		}
		
		bValue = true;
	}
	
	strcopy(output, maxlen, fmt_points);
	return bValue;
}

stock bool PointsFormatTypeValid(int client, const char[] type)
{
	char lang[3];
	GetLanguageInfo(GetClientLanguage(client), lang, sizeof(lang));
	
	for(int i = 0; i < strlen(lang); i++)
	{
		lang[i] = CharToLower(lang[i]);
	}
	
	// temporary
	if(StrEqual(type, "1M"))
	{
		return (
			StrEqual(lang, "jp") ||StrEqual(lang, "en")
		);
	}
	else if(StrEqual(type, "100K"))
	{
		return (
			StrEqual(lang, "jp")
		);
	}
	else if(StrEqual(type, "10K"))
	{
		return (
			StrEqual(lang, "jp") ||
			StrEqual(lang, "en")
		);
	}
	else if(StrEqual(type, "1K"))
	{
		return (
			StrEqual(lang, "jp") ||
			StrEqual(lang, "en")
		);
	}
	
	return false;
}

//

/*
 * Same as CPrintToChatAll() but uses player entity while() loop instead of for() loop.
 * More efficient and faster.
 */
stock void CPrintToChatAll2(const char[] message, any ...)
{
	int maxlen = MAX_BUFFER_LENGTH;
	char[] msg = new char[maxlen];
	VFormat(msg, maxlen, message, 2);
	
	int player = 0;
	while((player = FindEntityByClassname(player, "player")) != -1)
	{
		if(!IsValidClient(player))
		{
			continue;
		}
		
		CPrintToChat(player, msg);
	}
}

//

stock void Send_Player_Connected(int client)
{
	char auth[28], ip[16], name[64];
	strcopy(auth, sizeof(auth), g_Player[client].auth);
	strcopy(ip, sizeof(ip), g_Player[client].ip);
	strcopy(name, sizeof(name), g_Player[client].name);
	int points = g_Player[client].points;
	
	char query[256];
	Format(query, sizeof(query), "select `SteamID` from `"...sql_table_playerlist..."` where `StatsID`='%i'", g_StatsID);
	DataPack pack = new DataPack();
	pack.WriteCell(GetClientUserId(client));
	pack.WriteCell(points);
	pack.WriteCell(strlen(auth)+1);
	pack.WriteString(auth);
	pack.WriteCell(strlen(ip)+1);
	pack.WriteString(ip);
	pack.WriteCell(strlen(name)+1);
	pack.WriteString(name);
	pack.Reset();
	sql.Query(DBQuery_Send_Player_Connected, query, pack);
}

stock void DBQuery_Send_Player_Connected(Database database, DBResultSet results, const char[] error, DataPack pack)
{
	int userid = pack.ReadCell();
	int points = pack.ReadCell();
	
	int maxlen1 = pack.ReadCell();
	char[] auth = new char[maxlen1];
	pack.ReadString(auth, maxlen1);
	
	int maxlen2 = pack.ReadCell();
	char[] ip = new char[maxlen2];
	pack.ReadString(ip, maxlen2);
	
	int maxlen3 = pack.ReadCell();
	char[] name = new char[maxlen3];
	pack.ReadString(name, maxlen3);
	
	delete pack;
	
	//
	
	if(results == null)
	{
		return;
	}
	
	int position = 0;
	while(results.FetchRow())
	{
		position++;
		
		char row_auth[28];
		results.FetchString(0, row_auth, sizeof(row_auth));
		
		if(StrEqual(row_auth, auth))
		{
			break;
		}
	}
	
	int client;
	if(IsValidClient((client = GetClientOfUserId(userid))))
	{
		g_Player[client].position = position;
	}
	
	int player = 0;
	while((player = FindEntityByClassname(player, "player")) != -1)
	{
		if(IsValidClient(player))
		{
			if(g_Player[player].bShowConMsg)
			{
				char country_name[64], points_plural[32];
				GeoipCountryName(player, ip, country_name, sizeof(country_name));
				PointsPluralSplitter(player, points, points_plural, sizeof(points_plural));
				
				CPrintToChat(player, "%s %T"
				, g_ChatTag
				, "#SMStats_Player_Connected", player
				, name
				, position
				, g_TotalTablePlayers
				, points_plural
				, country_name);
			}
		}
	}
}

stock void Send_Player_Connected_CheckTop10(int client)
{
	char auth[28], ip[16], name[64];
	strcopy(auth, sizeof(auth), g_Player[client].auth);
	strcopy(ip, sizeof(ip), g_Player[client].ip);
	strcopy(name, sizeof(name), g_Player[client].name);
	
	char query[256];
	Format(query, sizeof(query), "select `SteamID` from `"...sql_table_playerlist..."` where `StatsID`='%i' order by `Points` limit 10 desc", g_StatsID);
	DataPack pack = new DataPack();
	pack.WriteCell(GetClientUserId(client));
	pack.WriteCell(strlen(auth)+1);
	pack.WriteString(auth);
	pack.WriteCell(strlen(ip)+1);
	pack.WriteString(ip);
	pack.WriteCell(strlen(name)+1);
	pack.WriteString(name);
	pack.Reset();
	sql.Query(DBQuery_Send_Player_Connected_CheckTop10, query, pack);
}

void DBQuery_Send_Player_Connected_CheckTop10(Database database, DBResultSet results, const char[] error, DataPack pack)
{
	int userid = pack.ReadCell();
	
	int maxlen1 = pack.ReadCell();
	char[] auth = new char[maxlen1];
	pack.ReadString(auth, maxlen1);
	
	int maxlen2 = pack.ReadCell();
	char[] ip = new char[maxlen2];
	pack.ReadString(ip, maxlen2);
	
	int maxlen3 = pack.ReadCell();
	char[] name = new char[maxlen3];
	pack.ReadString(name, maxlen3);
	
	delete pack;
	
	//
	
	if(results == null)
	{
		return;
	}
	
	int position = 0;
	while(results.FetchRow())
	{
		position++;
		
		char row_auth[28];
		results.FetchString(0, row_auth, sizeof(row_auth));
		
		if(StrEqual(row_auth, auth))
		{
			break;
		}
	}
	
	int client;
	if(IsValidClient((client = GetClientOfUserId(userid))))
	{
		g_Player[client].position = position;
	}
	
	int player = 0;
	while((player = FindEntityByClassname(player, "player")) != -1)
	{
		if(IsValidClient(player))
		{
			if(g_Player[player].bPlayConSnd)
			{
				if(position == 1)
				{
					if(strlen(g_sndConnectedTop1) > 0)
					{
						EmitSoundToClient(player, g_sndConnectedTop1, _, _, SNDLEVEL_LIBRARY);
					}
				}
				else if(position <= 10)
				{
					if(strlen(g_sndConnectedTop10) > 0)
					{
						EmitSoundToClient(player, g_sndConnectedTop10, _, _, SNDLEVEL_LIBRARY);
					}
				}
				else
				{
					if(strlen(g_sndConnectedGeneric) > 0)
					{
						EmitSoundToClient(player, g_sndConnectedGeneric, _, _, SNDLEVEL_RUSTLE);
					}
				}
			}
			
			if(position >= 1 && position <= 10)
			{
				if(g_Player[player].bShowTopConMsg)
				{
					char country_name[64];
					GeoipCountryName(player, ip, country_name, sizeof(country_name));
					CPrintToChat(player, "%s %T"
					, g_ChatTag
					, "#SMStats_Player_Connected_TopPlayer", player
					, position
					, name
					, country_name);
				}
			}
		}
	}
}

stock void Send_Player_Disconnected(int client, const char[] event_reason)
{
	char auth[28], ip[16], name[64];
	strcopy(auth, sizeof(auth), g_Player[client].auth);
	strcopy(ip, sizeof(ip), g_Player[client].ip);
	strcopy(name, sizeof(name), g_Player[client].name);
	
	char query[256];
	Format(query, sizeof(query), "select `SteamID`,`Points` from `"...sql_table_playerlist..."` where `StatsID`='%i'", g_StatsID);
	DataPack pack = new DataPack();
	pack.WriteCell(strlen(auth)+1);
	pack.WriteString(auth);
	pack.WriteCell(strlen(ip)+1);
	pack.WriteString(ip);
	pack.WriteCell(strlen(name)+1);
	pack.WriteString(name);
	pack.WriteCell(strlen(event_reason)+1);
	pack.WriteString(event_reason);
	pack.Reset();
	sql.Query(DBQuery_Send_Player_Disconnected, query, pack);
}

stock void DBQuery_Send_Player_Disconnected(Database database, DBResultSet results, const char[] error, DataPack pack)
{
	int maxlen1 = pack.ReadCell();
	char[] auth = new char[maxlen1];
	pack.ReadString(auth, maxlen1);
	
	int maxlen2 = pack.ReadCell();
	char[] ip = new char[maxlen2];
	pack.ReadString(ip, maxlen2);
	
	int maxlen3 = pack.ReadCell();
	char[] name = new char[maxlen3];
	pack.ReadString(name, maxlen3);
	
	int maxlen4 = pack.ReadCell();
	char[] event_reason = new char[maxlen4];
	pack.ReadString(event_reason, maxlen4);
	
	delete pack;
	
	//
	
	if(results == null)
	{
		return;
	}
	
	int position = 0;
	int points = 0;
	while(results.FetchRow())
	{
		position++;
		
		char row_auth[28];
		results.FetchString(0, row_auth, sizeof(row_auth));
		
		if(StrEqual(row_auth, auth))
		{
			points = results.FetchInt(1);
			break;
		}
	}
	
	int player = 0;
	while((player = FindEntityByClassname(player, "player")) > 0)
	{
		if(IsValidClient(player))
		{
			if(g_Player[player].bShowConMsg)
			{
				char country_name[64], points_plural[32];
				GeoipCountryName(player, ip, country_name, sizeof(country_name));
				PointsPluralSplitter(player, points, points_plural, sizeof(points_plural));
				
				CPrintToChat(player, "%s %T"
				, g_ChatTag
				, "#SMStats_Player_Disconnected", player
				, name
				, position
				, g_TotalTablePlayers
				, points_plural
				, country_name
				, event_reason);
			}
		}
	}
}

stock void TXNEvent_OnFailed(Database db, int userid, int numQueries, const char[] error, int failIndex, int[] queryId)
{
	PrintToServer("%s TXNEvent_OnFailed:\nQuery for '%s' (userid %i) failed\nError below:\n%s", core_chattag, g_strTXNqueryId[queryId[failIndex]], userid, error);
}

//

/**
 *	Returns the distance between 2 entities in meters.
 *	this is experimental and may be incorrect.
 *	In CS:GO, use "distance" from event "player_death" for more accurate numbers.
 *	this one is very similiar to that one but incorrect at times.
 *
 *	@param	entity		The entity index.
 *	@param	target		The target entity index.
 *
 *	@error	If the entity we use or the one we compare with is invalid, this returns -1.0.
 */
stock float GetEntityDistance(int entity, int target)
{
	if(IsValidEntity(entity) && IsValidEntity(target))
	{
		float pos[2][3];
		GetEntPropVector(entity, Prop_Send, "m_vecOrigin", pos[0]);
		GetEntPropVector(target, Prop_Send, "m_vecOrigin", pos[1]);
		
		//return ((pos[0][0] / pos[1][0]) * 5);
		return (GetVectorDistance(pos[1], pos[0]) / 41.0);
	}
	
	return -1.0;
}

/*
 *	Returns wheter the user is inside a smoke.
 *	Used as alternative for CS:S (Counter-Strike: Source) since 'thru_smoke'
 *	is only available to CS:GO (Counter-Strike: Global Offensive) in 'player_death' event.
 *
 *	@param	client	The users index.
 */
stock bool CS_IsClientInSmoke(int client)
{
	int env_particlesmokegrenade = 0;
	
	while((env_particlesmokegrenade = FindEntityByClassname(env_particlesmokegrenade, "env_particlesmokegrenade")) > 0)
	{
		float distance = GetEntityDistance(client, env_particlesmokegrenade);
		
		if(distance <= 3.0)
		{
			return true;
		}
	}
	
	return false;
}

//

stock void UpdatePlayerName(int client)
{
	if(IsValidClient(client, !bAllowBots ? true : false))
	{
		GetPlayerName(client, g_Player[client].name, sizeof(g_Player[].name));
	}
}

/*
 * Returns the developer role.
 * 1 - owner & founder.
 * 2 - contributor.
 * 3 - tester.
 * 4 - translator.
 */
stock int IsValidDeveloperType(int client)
{
	//char profile_id[24]; // safest way to check
	//GetClientAuthId(client, AuthId_SteamID64, profile_id, sizeof(profile_id));
	
	// founder and creator.
	if(StrEqual(g_Player[client].profileid, "76561198019545164"))
	{
		return 1;
	}
	
	// contributor
	
	// tester
	
	// translator
	if(StrEqual(g_Player[client].profileid, "76561197962831152")) // Neigeflocon
	{
		return 4;
	}
	
	return -1;
}

// time formats, these needs to be fixed and corrected.

stock int TimeFormat_ConvertSeconds(int seconds)
{
	int minutes = ( seconds / 60 );
	int minutes_sec = ( seconds - ( minutes * 60 ) );
	
	if(minutes_sec < 1)
	{
		minutes_sec = 0;
	}
	
	return minutes_sec;
}
stock int TimeFormat_ConvertMinutes(int seconds)
{
	int minutes;
	
	while(seconds >= 60)
	{
		minutes++;
		seconds -= 60;
	}
	
	return minutes;
}
stock int TimeFormat_ConvertHours(int &minutes)
{
	int hours;
	
	while(minutes >= 60)
	{
		hours++;
		minutes -= 60;
	}
	
	return hours;
}
stock int TimeFormat_ConvertDays(int &hours)
{
	int days;
	
	while(hours >= 24) // temporary workaround spaghetti code.
	{
		days++;
		hours -= 24;
	}
	
	return days;
}
stock int TimeFormat_ConvertMonths(int &days)
{
	// workaround needed, cuz we need to detect correct months.
	int months;
	
	while(days >= 31)
	{
		months++;
		days -= 31;
	}
	
	return months;
}
stock int TimeFormat_ConvertYears(int &months)
{
	int years;
	
	while(months >= 12)
	{
		years++;
		months -= 12;
	}
	
	return years;
}
stock void TimeFormat_GetCountStr(int count, char[] yes, int no)
{
	IntToString(count, yes, no);
	if(strlen(yes) == 1)
	{
		Format(yes, no, "0%s", yes);
	}
}
stock void GetTimeFormat(int client, int time_seconds, char[] time_format, int maxlen)
{
	// convert seconds into Year/s Day/s Hour/s Minute/s Second/s
	
	int seconds = TimeFormat_ConvertSeconds(time_seconds);
	int minutes = TimeFormat_ConvertMinutes(time_seconds);
	int hours = TimeFormat_ConvertHours(minutes);
	int days = TimeFormat_ConvertDays(hours);
	int months = TimeFormat_ConvertMonths(days);
	int years = TimeFormat_ConvertYears(months);
	
	//PrintToServer("%i seconds %i minutes %i hours %i days", seconds, minutes, hours, days);
	
	char szYear[16];
	Format(time_format, maxlen, "%T", "#SMStats_TimeFormat_Year", client);
	switch(StrContains(time_format, "#|#") != -1)
	{
		case false: Format(szYear, sizeof(szYear), "%i%s", years, time_format);
		case true:
		{
			bool bPlural = (years < -1 || years > 1);
			char szPlural[2][16];
			if(ExplodeString(time_format, "#|#", szPlural, sizeof(szPlural), 16) == 2)
			{
				ReplaceString(szPlural[0], sizeof(szPlural[]), "#|#", "");
			}
			Format(szYear, sizeof(szYear), "%i%s", years, szPlural[view_as<int>(bPlural)]);
		}
	}
	
	char szMonth[16];
	Format(time_format, maxlen, "%T", "#SMStats_TimeFormat_Month", client);
	switch(StrContains(time_format, "#|#") != -1)
	{
		case false: Format(szMonth, sizeof(szMonth), "%i%s", months, time_format);
		case true:
		{
			bool bPlural = (months < -1 || months > 1);
			char szPlural[2][16];
			if(ExplodeString(time_format, "#|#", szPlural, sizeof(szPlural), 16) == 2)
			{
				ReplaceString(szPlural[0], sizeof(szPlural[]), "#|#", "");
			}
			Format(szMonth, sizeof(szMonth), "%i%s", months, szPlural[view_as<int>(bPlural)]);
		}
	}
	
	char szDay[16];
	Format(time_format, maxlen, "%T", "#SMStats_TimeFormat_Day", client);
	switch(StrContains(time_format, "#|#") != -1)
	{
		case false: Format(szDay, sizeof(szDay), "%i%s", days, time_format);
		case true:
		{
			bool bPlural = (days < -1 || days > 1);
			char szPlural[2][16];
			if(ExplodeString(time_format, "#|#", szPlural, sizeof(szPlural), 16) == 2)
			{
				ReplaceString(szPlural[0], sizeof(szPlural[]), "#|#", "");
			}
			Format(szDay, sizeof(szDay), "%i%s", days, szPlural[view_as<int>(bPlural)]);
		}
	}
	
	char szHour[16];
	Format(time_format, maxlen, "%T", "#SMStats_TimeFormatShort_Hour", client);
	switch(StrContains(time_format, "#|#") != -1)
	{
		case false: Format(szHour, sizeof(szHour), "%i%s", hours, time_format);
		case true:
		{
			bool bPlural = (hours < -1 || hours > 1);
			char szPlural[2][16];
			if(ExplodeString(time_format, "#|#", szPlural, sizeof(szPlural), 16) == 2)
			{
				ReplaceString(szPlural[0], sizeof(szPlural[]), "#|#", "");
			}
			Format(szDay, sizeof(szDay), "%i%s", hours, szPlural[view_as<int>(bPlural)]);
		}
	}
	
	char szMinute[16];
	Format(time_format, maxlen, "%T", "#SMStats_TimeFormatShort_Minute", client);
	switch(StrContains(time_format, "#|#") != -1)
	{
		case false: Format(szMinute, sizeof(szMinute), "%i%s", minutes, time_format);
		case true:
		{
			bool bPlural = (minutes < -1 || minutes > 1);
			char szPlural[2][16];
			if(ExplodeString(time_format, "#|#", szPlural, sizeof(szPlural), 16) == 2)
			{
				ReplaceString(szPlural[0], sizeof(szPlural[]), "#|#", "");
			}
			Format(szDay, sizeof(szDay), "%i%s", minutes, szPlural[view_as<int>(bPlural)]);
		}
	}
	
	char szSecond[16];
	Format(time_format, maxlen, "%T", "#SMStats_TimeFormatShort_Second", client);
	switch(StrContains(time_format, "#|#") != -1)
	{
		case false: Format(szSecond, sizeof(szSecond), "%i%s", seconds, time_format);
		case true:
		{
			bool bPlural = (seconds < -1 || seconds > 1);
			char szPlural[2][16];
			if(ExplodeString(time_format, "#|#", szPlural, sizeof(szPlural), 16) == 2)
			{
				ReplaceString(szPlural[0], sizeof(szPlural[]), "#|#", "");
			}
			Format(szSecond, sizeof(szSecond), "%i%s", seconds, szPlural[view_as<int>(bPlural)]);
		}
	}
	
	//
	
	if(years > 0
	&& months > 0
	&& days > 0
	&& hours > 0
	&& minutes > 0
	&& seconds >= 0)
	{
		Format(time_format, maxlen, "%T", "#SMStats_PlayTimeFormat_Scenario0", client, szYear, szMonth, szDay, szHour, szMinute, szSecond);
	}
	else if(months > 0
	&& days > 0
	&& hours > 0
	&& minutes > 0
	&& seconds >= 0)
	{
		Format(time_format, maxlen, "%T", "#SMStats_PlayTimeFormat_Scenario1", client, szMonth, szDay, szHour, szMinute, szSecond);
	}
	else if(days > 0
	&& hours > 0
	&& minutes > 0
	&& seconds >= 0)
	{
		Format(time_format, maxlen, "%T", "#SMStats_PlayTimeFormat_Scenario2", client, szDay, szHour, szMinute, szSecond);
	}
	else if(hours > 0
	&& minutes > 0
	&& seconds >= 0)
	{
		Format(time_format, maxlen, "%T", "#SMStats_PlayTimeFormat_Scenario3", client, szHour, szMinute, szSecond);
	}
	else if(minutes > 0
	&& seconds >= 0)
	{
		Format(time_format, maxlen, "%T", "#SMStats_PlayTimeFormat_Scenario4", client, szMinute, szSecond);
	}
	else
	{
		Format(time_format, maxlen, szSecond);
	}
	
	//PrintToServer(time_format);
}

stock void GetLastConnectedFormat(int client, char[] timezone_ip, int last_connected, char[] time_format, int maxlen)
{
	Format(time_format, maxlen, "%T", "#SMStats_TimeFormat_LastConnected", client);
	
	int timezone = UT_TIMEZONE_SERVER;
	char str_timezone[32];
	switch(GeoipTimezone(timezone_ip, str_timezone, sizeof(str_timezone)))
	{
		case false:
		{
			PrintToServer("%s GetLastConnectedFormat() Error: Failed to get timezone, using server timezone instead.", core_chattag);
		}
		case true:
		{
			// we need a way to convert the time to the clients timezone.
			//PrintToServer("%s GetLastConnectedFormat() Timezone : %s", core_chattag, str_timezone);
		}
	}
	
	int year, month, day, hour, minute, second;
	UnixToTime(last_connected, year, month, day, hour, minute, second, timezone);
	
	/*
	PrintToServer("LastConnect converted:"
	... "\nUNIX : %i"
	... "\nYear : %i"
	... "\nDays : %i"
	... "\nHour : %i"
	... "\nMins : %i"
	... "\nSecs : %i"
	, last_connected, year, month, day, hour, minute, second);
	*/
	
	if(StrContains(time_format, "{YEAR}") != -1)
	{
		char dummy[11];
		Format(dummy, sizeof(dummy), "%02d", year);
		ReplaceString(time_format, maxlen, "{YEAR}", dummy);
	}
	if(StrContains(time_format, "{MONTH}") != -1)
	{
		char dummy[11];
		Format(dummy, sizeof(dummy), "%02d", month);
		ReplaceString(time_format, maxlen, "{MONTH}", dummy);
	}
	if(StrContains(time_format, "{DAY}") != -1)
	{
		char dummy[11];
		Format(dummy, sizeof(dummy), "%02d", day);
		ReplaceString(time_format, maxlen, "{DAY}", dummy);
	}
	if(StrContains(time_format, "{AM_PM}") != -1)
	{
		char am_pm[64];
		Format(am_pm, sizeof(am_pm), "%T", "#SMStats_TimeFormat_AM_PM", client);
		
		if(StrContains(am_pm, "#|#") != -1)
		{
			bool PM = (hour >= 12);
			char dummy[2][11];
			ExplodeString(am_pm, "#|#", dummy, sizeof(dummy), 11);
			
			if(!PM)
			{
				ReplaceString(dummy[0], sizeof(dummy[]), "#|#", "");
			}
			
			ReplaceString(time_format, maxlen, "{AM_PM}", dummy[view_as<int>(PM)]);
		}
	}
	if(StrContains(time_format, "{12HOUR}") != -1)
	{
		if(hour > 12)
		{
			hour -= hour-12;
		}
		
		char dummy[11];
		Format(dummy, sizeof(dummy), "%02d", hour);
		ReplaceString(time_format, maxlen, "{12HOUR}", dummy);
	}
	if(StrContains(time_format, "{24HOUR}") != -1)
	{
		char dummy[11];
		Format(dummy, sizeof(dummy), "%02d", hour);
		ReplaceString(time_format, maxlen, "{24HOUR}", dummy);
	}
	if(StrContains(time_format, "{MINUTE}") != -1)
	{
		char dummy[11];
		Format(dummy, sizeof(dummy), "%02d", minute);
		ReplaceString(time_format, maxlen, "{MINUTE}", dummy);
	}
	if(StrContains(time_format, "{SECOND}") != -1)
	{
		char dummy[11];
		Format(dummy, sizeof(dummy), "%02d", second);
		ReplaceString(time_format, maxlen, "{SECOND}", dummy);
	}
}

stock int TimestampSeconds(int timestamp)
{
	int time = timestamp - GetTime();
	int seconds = time - 60 * (time / 60);
	return seconds;
}

//

stock int GetFieldValue(DBResultSet results, char[] field_name)
{
	int field;
	if(results.FieldNameToNum(field_name, field))
	{
		return results.FetchInt(field);
	}
	
	return -2;
}

stock bool GetFieldBoolValue(DBResultSet results, char[] field_name)
{
	int field;
	if(results.FieldNameToNum(field_name, field))
	{
		return view_as<bool>(results.FetchInt(field));
	}
	
	return false;
}

stock int GetFieldString(DBResultSet results, char[] field_name, char[] output, int maxlen)
{
	int field;
	if(results.FieldNameToNum(field_name, field))
	{
		return results.FetchString(field, output, maxlen);
	}
	
	return -2;
}

//

stock void PenaltyPlayer(int client, int pPoints)
{
	if(sql == null)
	{
		PrintToServer(core_chattag..." PenaltyPlayer() error : SQL Connection unavailable or invalid.");
		return;
	}
	
	char name[64], auth[28];
	strcopy(name, sizeof(name), g_Player[client].name);
	strcopy(auth, sizeof(auth), g_Player[client].auth);
	
	int points = g_Player[client].points;
	int position = g_Player[client].position;
	int penalty = g_PenaltySeconds;
	int timestamp = GetTime();
	
	g_Player[client].bPenalty = true;
	
	//
	
	char query[256];
	Format(query, sizeof(query), "update `"...sql_table_settings..."` set `Penalty`='1',`LastPenaltyTime`='%i',`PenaltyTime`='%i' where SteamID='%s'", timestamp, penalty, auth);
	DataPack pack = new DataPack();
	pack.WriteCell(g_Player[client].userid);
	pack.WriteCell(strlen(auth)+1);
	pack.WriteString(auth);
	pack.Reset();
	sql.Query(DBQuery_PenaltyPlayer, query, pack);
	
	//
	
	if(bDebug) PrintToServer(core_chattag..." PenaltyPlayer()"
	... "\nUserID : %i ['%s']"
	... "\nPosition : #%i"
	... "\nPenalty : %i seconds"
	... "\nReverted Points : %i"
	... "\n"
	, g_Player[client].name2
	, position
	, penalty
	, pPoints);
	
	//
	
	char penalty_time[128], str_points1[32], str_points2[32];
	GetTimeFormat(client, penalty, penalty_time, sizeof(penalty_time));
	PointsPluralSplitter(client, points, str_points1, sizeof(str_points1));
	PointsPluralSplitter(client, pPoints, str_points2, sizeof(str_points2), PointSplit_Minus);
	
	CPrintToChat(client, "%s %T", g_ChatTag, "#SMStats_Player_Penalty", client
	, name
	, position
	, str_points1
	, penalty_time
	, str_points2);
}

stock void DBQuery_PenaltyPlayer(Database database, DBResultSet results, const char[] error, DataPack pack)
{
	if(!results)
	{
		int userid = pack.ReadCell();
		delete pack;
		PrintToServer(core_chattag..." PenaltyPlayer() error : Failed to query userid %i !"
		..."\nError below:"
		..."\n%s", userid, error);
		return;
	}
	
	CreateTimer(g_PenaltySeconds+0.0, Timer_PenaltyPlayer_Expire, pack);
}

stock Action Timer_PenaltyPlayer_Expire(Handle timer, DataPack pack)
{
	int userid = pack.ReadCell();
	int maxlen = pack.ReadCell();
	char[] auth = new char[maxlen];
	delete pack;
	
	char query[256];
	Format(query, sizeof(query), "update `"...sql_table_settings..."` set `Penalty`='0', `PenaltyTime`='-1' where SteamID='%s'", auth);
	sql.Query(DBQuery_PenaltyPlayer_Expire, query, userid);
	
	int client;
	if(IsValidClient((client = GetClientOfUserId(userid))))
	{
		g_Player[client].bPenalty = false;
		
		char penalty_time[128];
		GetTimeFormat(client, g_PenaltySeconds, penalty_time, sizeof(penalty_time));
		
		CPrintToChat(client, "%s %T", g_ChatTag, "#SMStats_Player_Penalty_Expired", client, penalty_time);
	}
	
	return Plugin_Continue;
}

stock void DBQuery_PenaltyPlayer_Expire(Database database, DBResultSet results, const char[] error, int userid)
{
	if(!results)
	{
		PrintToServer(core_chattag..." PenaltyPlayer_Expire() error : Failed to query userid %i !"
		... "\nError below:"
		... "\n%s", userid, error);
		return;
	}
}

// work in progress

stock void SaveServerInfo()
{
	char path[64];
	BuildPath(Path_SM, path, sizeof(path), "/configs/sm_stats/server_info.sm_stats");
	
	if(!FileExists(path))
	{
		File file = OpenFile(path, "w+");
		delete file;
	}
	
	KeyValues kv = new KeyValues("ServerInfo");
	if(!kv.ImportFromFile(path))
	{
		delete kv;
		PrintToServer("%s SaveServerInfo() : Failed saving info!\nReason below:\nUnable to import KeyValues file path '%s'", core_chattag, path);
		return;
	}
	
	int client;
	while((client = FindEntityByClassname(client, "player")) != -1)
	{
		SMStats_PlayerInfo player;
		player = g_Player[client];
		//SMStats_TF2GameInfo game = g_Game[client];
		
		if(kv.JumpToKey("g_Player[]" , true))
		{
			if(kv.JumpToKey(player.auth, true))
			{
				kv.SetNum("userid", player.userid);
				kv.SetString("auth", player.auth);
				kv.SetString("profileid", player.profileid);
				kv.SetString("name", player.name);
				kv.SetString("name2", player.name2);
				kv.SetString("ip", player.ip);
				//kv.SetNum("bAlreadyConnected", view_as<int>(player.bAlreadyConnected));
				kv.SetNum("bPenalty", view_as<int>(player.bPenalty));
				kv.SetNum("points", player.points);
				kv.SetNum("position", player.position);
				kv.SetNum("active_page_mainmenu", player.active_page_mainmenu);
				kv.SetNum("active_page_menu", player.active_page_menu);
				kv.SetNum("active_page_session", player.active_page_session);
				kv.SetNum("active_page_activestats", player.active_page_activestats);
				kv.SetNum("active_page_topstats", player.active_page_topstats);
				kv.SetNum("bMenuCheckPosition", view_as<int>(player.bMenuCheckPosition));
				
				// settings
				kv.SetNum("bPlayConSnd", view_as<int>(player.bPlayConSnd));
				kv.SetNum("bPlayConSndUpdated", view_as<int>(player.bPlayConSndUpdated));
				kv.SetNum("bShowConMsg", view_as<int>(player.bShowConMsg));
				kv.SetNum("bShowConMsgUpdated", view_as<int>(player.bShowConMsgUpdated));
				kv.SetNum("bShowTopConMsg", view_as<int>(player.bShowTopConMsg));
				kv.SetNum("bShowTopConMsgUpdated", view_as<int>(player.bShowTopConMsgUpdated));
				kv.SetNum("bShowFragMsg", view_as<int>(player.bShowFragMsg));
				kv.SetNum("bShowFragMsgUpdated", view_as<int>(player.bShowFragMsgUpdated));
				kv.SetNum("bShowAssistMsg", view_as<int>(player.bShowAssistMsg));
				kv.SetNum("bShowAssistMsgUpdated", view_as<int>(player.bShowAssistMsgUpdated));
				kv.SetNum("bShowDeathMsg", view_as<int>(player.bShowDeathMsg));
				kv.SetNum("bShowDeathMsgUpdated", view_as<int>(player.bShowDeathMsgUpdated));
				
				if(kv.JumpToKey("session[]", true))
				{
					for(int i = 0; i < SMStats_StatsSize; i++)
					{
						char str_id[4];
						IntToString(i, str_id, sizeof(str_id));
						kv.SetNum(str_id, player.session[i]);
					}
					
					kv.GoBack();
				}
				if(kv.JumpToKey("menustats[]", true))
				{
					for(int i = 0; i < SMStats_StatsSize; i++)
					{
						char str_id[4];
						IntToString(i, str_id, sizeof(str_id));
						kv.SetNum(str_id, player.menustats[i]);
					}
				}
				
				kv.GoBack();
			}
			
			kv.GoBack();
		}
	}
}