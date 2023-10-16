enum struct StatsMenuInfo
{
	int lol;
	
	void Main(int client)
	{
		if(!bLoaded)
		{
			CPrintToChat(client, "%s %T", core_chattag, "#SMStats_Error_NotInitialized", client);
			return;
		}
		else if(!sql)
		{
			CPrintToChat(client, "%s %T", core_chattag, "#SMStats_Error_SQLNotInitialized", client);
			return;
		}
		
		Panel panel = new Panel();
		panel.DrawItem("SourceMod Stats - " ... VersionAlt ... " by Teamkiller324 ( Work in progress )");
		
		PanelText(panel, "%T", "#SMStats_Menu_Playername", client, client);
		PanelText(panel, "%T\n ", "#SMStats_Menu_Positioned", client, (g_Player[client].position = GetClientPosition(g_Player[client].auth)), g_TotalTablePlayers);		
		PanelItem(panel, "%T"
		... "\n  > %T"
		... "\n "
		, "#SMStats_Menu_Session", client
		, "#SMStats_Menu_SessionInfo", client);
		PanelItem(panel, "%T"
		... "\n  > %T"
		... "\n "
		, "#SMStats_Menu_ActiveStats", client
		, "#SMStats_Menu_ActiveStatsInfo", client);
		PanelItem(panel, "%T"
		... "\n  > %T"
		... "\n "
		, "#SMStats_Menu_Top10", client
		, "#SMStats_Menu_Top10Info", client);
		
		panel.Send(client, StatsMenu_Main, MENU_TIME_FOREVER);
		delete panel;
	}
	
	void Session(int client, int page=1)
	{
		Panel panel = new Panel();
		PanelItem(panel, "SourceMod Stats - " ... VersionAlt ... " > %T > %T"
		, "#SMStats_Menu_Session", client
		, "#SMStats_Menu_Page", client, page);
		
		switch(page)
		{
			case 1:
			{
				PanelText(panel, "  %T", "#SMStats_MenuInfo_PlayTime", client, g_Player[client].session[Stats_PlayTime]);
				switch(g_Player[client].session[Stats_Points] >= 0)
				{
					case false: PanelText(panel, "  %T", "#SMStats_MenuInfo_PointsLost", client, g_Player[client].session[Stats_Points]);
					case true: PanelText(panel, "  %T", "#SMStats_MenuInfo_PointsEarned", client, g_Player[client].session[Stats_Points]);
				}
				
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Frags", client, g_Player[client].session[Stats_Frags]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Assists", client, g_Player[client].session[Stats_Assists]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Deaths", client, g_Player[client].session[Stats_Deaths]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Suicides", client, g_Player[client].session[Stats_Suicides]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_DamageDone", client, g_Player[client].session[Stats_DamageDone]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_AchievementsEarned", client, g_Player[client].session[Stats_Achievements]);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_PreviousPage", client);
				PanelItem(panel, "%T", "#SMStats_Menu_NextPage", client);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_ExitPage", client);
			}
			
			case 2:
			{
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Dominations", client, g_Player[client].session[Stats_Dominations]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Revenges", client, g_Player[client].session[Stats_Revenges]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Airshots", client, g_Player[client].session[Stats_Airshots]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Headshots", client, g_Player[client].session[Stats_Headshots]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Noscopes", client, g_Player[client].session[Stats_Noscopes]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Backstabs", client, g_Player[client].session[Stats_Backstabs]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_TauntFrags", client, g_Player[client].session[Stats_TauntFrags]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_GibFrags", client, g_Player[client].session[Stats_GibFrags]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_DeflectFrags", client, g_Player[client].session[Stats_Deflects]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_TeleFrags", client, g_Player[client].session[Stats_TeleFrags]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Collaterals", client, g_Player[client].session[Stats_Collaterals]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_MidAirFrags", client, g_Player[client].session[Stats_MidAirFrags]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_CritFrags", client, g_Player[client].session[Stats_CritFrags]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_MiniCritFrags", client, g_Player[client].session[Stats_MiniCritFrags]);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_PreviousPage", client);
				PanelItem(panel, "%T", "#SMStats_Menu_NextPage", client);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_ExitPage", client);
			}
			
			case 3:
			{
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Scout", client, g_Player[client].session[Stats_ScoutFrags], g_Player[client].session[Stats_ScoutDeaths]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Soldier", client, g_Player[client].session[Stats_SoldierFrags], g_Player[client].session[Stats_SoldierDeaths]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Pyro", client, g_Player[client].session[Stats_PyroFrags], g_Player[client].session[Stats_PyroDeaths]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Demoman", client, g_Player[client].session[Stats_DemoFrags], g_Player[client].session[Stats_DemoDeaths]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Heavy", client, g_Player[client].session[Stats_HeavyFrags], g_Player[client].session[Stats_HeavyDeaths]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Engineer", client, g_Player[client].session[Stats_EngieFrags], g_Player[client].session[Stats_EngieDeaths]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Medic", client, g_Player[client].session[Stats_MedicFrags], g_Player[client].session[Stats_MedicDeaths]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Sniper", client, g_Player[client].session[Stats_SniperFrags], g_Player[client].session[Stats_SniperDeaths]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Spy", client, g_Player[client].session[Stats_SpyFrags], g_Player[client].session[Stats_SpyDeaths]);			
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_PreviousPage", client);
				PanelItem(panel, "%T", "#SMStats_Menu_NextPage", client);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_ExitPage", client);
			}
			
			case 4:
			{
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Buildings", client, g_Player[client].session[Stats_BuildingsPlaced], g_Player[client].session[Stats_BuildingsDestroyed]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Dispenser", client, g_Player[client].session[Stats_DispensersPlaced], g_Player[client].session[Stats_DispensersDestroyed]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_SentryGun", client, g_Player[client].session[Stats_SentryGunsPlaced], g_Player[client].session[Stats_SentryGunsDestroyed]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_TeleporterEntrance", client, g_Player[client].session[Stats_TeleporterEntrancesPlaced], g_Player[client].session[Stats_TeleporterEntrancesDestroyed]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_TeleporterExit", client, g_Player[client].session[Stats_TeleporterExitsPlaced], g_Player[client].session[Stats_TeleporterExitsDestroyed]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_MiniSentryGun", client, g_Player[client].session[Stats_MiniSentryGunsPlaced], g_Player[client].session[Stats_MiniSentryGunsDestroyed]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Sapper", client, g_Player[client].session[Stats_SappersPlaced], g_Player[client].session[Stats_SappersDestroyed]);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_PreviousPage", client);
				PanelItem(panel, "%T", "#SMStats_Menu_NextPage", client);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_ExitPage", client);
			}
			
			case 5:
			{
				PanelText(panel, "  %T", "#SMStats_MenuInfo_CP_Captured", client, g_Player[client].session[Stats_PointsCaptured]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_CP_Defended", client, g_Player[client].session[Stats_PointsDefended]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_CTF_Stolen", client, g_Player[client].session[Stats_FlagsStolen]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_CTF_PickedUp", client, g_Player[client].session[Stats_FlagsPickedUp]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_CTF_Captured", client, g_Player[client].session[Stats_FlagsCaptured]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_CTF_Defended", client, g_Player[client].session[Stats_FlagsDefended]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_CTF_Dropped", client, g_Player[client].session[Stats_FlagsDropped]);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_PreviousPage", client);
				PanelItem(panel, "%T", "#SMStats_Menu_NextPage", client);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_ExitPage", client);
			}
			
			case 6:
			{
				PanelText(panel, "  %T", "#SMStats_MenuInfo_TeleportersUsed", client, g_Player[client].session[Stats_TeleportersUsed]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_PlayersTeleported", client, g_Player[client].session[Stats_PlayersTeleported]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_CoatedMilk", client, g_Player[client].session[Stats_CoatedMilk]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_CoatedPiss", client, g_Player[client].session[Stats_CoatedPiss]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Coated", client, g_Player[client].session[Stats_Coated]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Extinguished", client, g_Player[client].session[Stats_Extinguished]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Ignited", client, g_Player[client].session[Stats_Ignited]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Ubercharged", client, g_Player[client].session[Stats_Ubercharged]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_SandvichesStolen", client, g_Player[client].session[Stats_SandvichesStolen]);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_PreviousPage", client);
				PanelItem(panel, "%T", "#SMStats_Menu_NextPage", client);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_ExitPage", client);
			}
			
			case 7:
			{
				PanelText(panel, "  %T", "#SMStats_MenuInfo_HWN_Monoculus", client, g_Player[client].session[Stats_MonoculusFragged], g_Player[client].session[Stats_MonoculusStunned]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_HWN_Merasmus", client, g_Player[client].session[Stats_MerasmusFragged], g_Player[client].session[Stats_MerasmusStunned]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_HWN_HHH", client, g_Player[client].session[Stats_HHHFragged]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_HWN_SkeletonKing", client, g_Player[client].session[Stats_SkeletonKingsFragged]);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_PreviousPage", client);
				PanelItem(panel, "%T", "#SMStats_Menu_NextPage", client);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_ExitPage", client);
			}
			
			case 8:
			{
				PanelText(panel, "  %T", "#SMStats_MenuInfo_MvM_TanksDestroyed", client, g_Player[client].session[Stats_TanksDestroyed]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_MvM_SentryBustersFragged", client, g_Player[client].session[Stats_SentryBustersFragged]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_MvM_BombsResetted", client, g_Player[client].session[Stats_BombsResetted]);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_PreviousPage", client);
				//PanelItem(panel, "%T", "#SMStats_Menu_NextPage", client);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_ExitPage", client);
			}
		}
		
		panel.Send(client, StatsMenu_Session, MENU_TIME_FOREVER);
		delete panel;
	}
	
	void Top10(int client, int display_at=0)
	{
		char[][] SteamID = new char[10][64];
		char[][] PlayerName = new char[10][64];
		int Points[10];
		int Players = 0;
		
		SQL_LockDatabase(sql);
		//char error[256];
		DBResultSet results = SQL_Query(sql, "select PlayerName, SteamID, Points from `"... sql_table_playerlist ... "` order by 'Points' asc limit 10");
		if(results == null)
		{
			SQL_UnlockDatabase(sql);
			delete results;
			CPrintToChat(client, "%s SQL Error parsing top 10 players", g_ChatTag);
			return;
		}
		
		while(results.FetchRow())
		{
			results.FetchString(0, PlayerName[Players], 64);
			results.FetchString(1, SteamID[Players], 64);
			Points[Players] = results.FetchInt(2);
			
			Players++
		}
		delete results;
		SQL_UnlockDatabase(sql);
		
		if(Players < 1)
		{
			CPrintToChat(client, "%s found no players on the leaderboard.", g_ChatTag);
			return;
		}
		
		Menu menu = new Menu(StatsMenu_Top10);
		menu.SetTitle("SourceMod Stats - " ... VersionAlt ... " > %T", "#SMStats_Menu_Top10", client);
		
		for(int i = 0; i < Players; i++)
		{
			char dummy[96];
			Format(dummy, sizeof(dummy), "%T", "#SMStats_MenuInfo_TopPlayer", client, i+1, PlayerName[i], Points[i]);
			menu.AddItem(SteamID[i], dummy);
		}
		
		menu.ExitBackButton = true;
		menu.DisplayAt(client, display_at, MENU_TIME_FOREVER);
	}
	
	void Top10Info(int client, int page=1)
	{
		Panel panel = new Panel();
		PanelItem(panel, "SourceMod Stats - " ... VersionAlt ... " > %T > %s > %T"
		, "#SMStats_Menu_Top10", client
		, g_Player[client].top10name
		, "#SMStats_Menu_Page", client, page);
		
		switch(page)
		{
			case 1:
			{
				PanelText(panel, "  %T", "#SMStats_MenuInfo_PlayTime", client, g_Player[client].top10[Stats_PlayTime]);
				switch(g_Player[client].top10[Stats_Points] >= 0)
				{
					case false: PanelText(panel, "  %T", "#SMStats_MenuInfo_PointsLost", client, g_Player[client].top10[Stats_Points]);
					case true: PanelText(panel, "  %T", "#SMStats_MenuInfo_PointsEarned", client, g_Player[client].top10[Stats_Points]);
				}
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Frags", client, g_Player[client].top10[Stats_Frags]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Assists", client, g_Player[client].top10[Stats_Assists]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Deaths", client, g_Player[client].top10[Stats_Deaths]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Suicides", client, g_Player[client].top10[Stats_Suicides]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_DamageDone", client, g_Player[client].top10[Stats_DamageDone]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_AchievementsEarned", client, g_Player[client].top10[Stats_Achievements]);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_PreviousPage", client);
				PanelItem(panel, "%T", "#SMStats_Menu_NextPage", client);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_ExitPage", client);
			}
			
			case 2:
			{
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Dominations", client, g_Player[client].top10[Stats_Dominations]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Revenges", client, g_Player[client].top10[Stats_Revenges]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Airshots", client, g_Player[client].top10[Stats_Airshots]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Headshots", client, g_Player[client].top10[Stats_Headshots]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Noscopes", client, g_Player[client].top10[Stats_Noscopes]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Backstabs", client, g_Player[client].top10[Stats_Backstabs]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_TauntFrags", client, g_Player[client].top10[Stats_TauntFrags]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_GibFrags", client, g_Player[client].top10[Stats_GibFrags]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_DeflectFrags", client, g_Player[client].top10[Stats_Deflects]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_TeleFrags", client, g_Player[client].top10[Stats_TeleFrags]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Collaterals", client, g_Player[client].top10[Stats_Collaterals]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_MidAirFrags", client, g_Player[client].top10[Stats_MidAirFrags]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_CritFrags", client, g_Player[client].top10[Stats_CritFrags]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_MiniCritFrags", client, g_Player[client].top10[Stats_MiniCritFrags]);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_PreviousPage", client);
				PanelItem(panel, "%T", "#SMStats_Menu_NextPage", client);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_ExitPage", client);
			}
			
			case 3:
			{
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Scout", client, g_Player[client].top10[Stats_ScoutFrags], g_Player[client].top10[Stats_ScoutDeaths]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Soldier", client, g_Player[client].top10[Stats_SoldierFrags], g_Player[client].top10[Stats_SoldierDeaths]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Pyro", client, g_Player[client].top10[Stats_PyroFrags], g_Player[client].top10[Stats_PyroDeaths]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Demoman", client, g_Player[client].top10[Stats_DemoFrags], g_Player[client].top10[Stats_DemoDeaths]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Heavy", client, g_Player[client].top10[Stats_HeavyFrags], g_Player[client].top10[Stats_HeavyDeaths]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Engineer", client, g_Player[client].top10[Stats_EngieFrags], g_Player[client].top10[Stats_EngieDeaths]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Medic", client, g_Player[client].top10[Stats_MedicFrags], g_Player[client].top10[Stats_MedicDeaths]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Sniper", client, g_Player[client].top10[Stats_SniperFrags], g_Player[client].top10[Stats_SniperDeaths]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Spy", client, g_Player[client].top10[Stats_SpyFrags], g_Player[client].top10[Stats_SpyDeaths]);			
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_PreviousPage", client);
				PanelItem(panel, "%T", "#SMStats_Menu_NextPage", client);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_ExitPage", client);
			}
			
			case 4:
			{
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Buildings", client, g_Player[client].top10[Stats_BuildingsPlaced], g_Player[client].top10[Stats_BuildingsDestroyed]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Dispenser", client, g_Player[client].top10[Stats_DispensersPlaced], g_Player[client].top10[Stats_DispensersDestroyed]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_SentryGun", client, g_Player[client].top10[Stats_SentryGunsPlaced], g_Player[client].top10[Stats_SentryGunsDestroyed]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_TeleporterEntrance", client, g_Player[client].top10[Stats_TeleporterEntrancesPlaced], g_Player[client].top10[Stats_TeleporterEntrancesDestroyed]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_TeleporterExit", client, g_Player[client].top10[Stats_TeleporterExitsPlaced], g_Player[client].top10[Stats_TeleporterExitsDestroyed]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_MiniSentryGun", client, g_Player[client].top10[Stats_MiniSentryGunsPlaced], g_Player[client].top10[Stats_MiniSentryGunsDestroyed]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Sapper", client, g_Player[client].top10[Stats_SappersPlaced], g_Player[client].top10[Stats_SappersDestroyed]);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_PreviousPage", client);
				PanelItem(panel, "%T", "#SMStats_Menu_NextPage", client);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_ExitPage", client);
			}
			
			case 5:
			{
				PanelText(panel, "  %T", "#SMStats_MenuInfo_CP_Captured", client, g_Player[client].top10[Stats_PointsCaptured]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_CP_Defended", client, g_Player[client].top10[Stats_PointsDefended]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_CTF_Stolen", client, g_Player[client].top10[Stats_FlagsStolen]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_CTF_PickedUp", client, g_Player[client].top10[Stats_FlagsPickedUp]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_CTF_Captured", client, g_Player[client].top10[Stats_FlagsCaptured]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_CTF_Defended", client, g_Player[client].top10[Stats_FlagsDefended]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_CTF_Dropped", client, g_Player[client].top10[Stats_FlagsDropped]);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_PreviousPage", client);
				PanelItem(panel, "%T", "#SMStats_Menu_NextPage", client);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_ExitPage", client);
			}
			
			case 6:
			{
				PanelText(panel, "  %T", "#SMStats_MenuInfo_TeleportersUsed", client, g_Player[client].top10[Stats_TeleportersUsed]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_PlayersTeleported", client, g_Player[client].top10[Stats_PlayersTeleported]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_CoatedMilk", client, g_Player[client].top10[Stats_CoatedMilk]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_CoatedPiss", client, g_Player[client].top10[Stats_CoatedPiss]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Coated", client, g_Player[client].top10[Stats_Coated]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Extinguished", client, g_Player[client].top10[Stats_Extinguished]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Ignited", client, g_Player[client].top10[Stats_Ignited]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_Ubercharged", client, g_Player[client].top10[Stats_Ubercharged]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_SandvichesStolen", client, g_Player[client].top10[Stats_SandvichesStolen]);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_PreviousPage", client);
				PanelItem(panel, "%T", "#SMStats_Menu_NextPage", client);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_ExitPage", client);
			}
			
			case 7:
			{
				PanelText(panel, "  %T", "#SMStats_MenuInfo_HWN_Monoculus", client, g_Player[client].top10[Stats_MonoculusFragged], g_Player[client].top10[Stats_MonoculusStunned]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_HWN_Merasmus", client, g_Player[client].top10[Stats_MerasmusFragged], g_Player[client].top10[Stats_MerasmusStunned]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_HWN_HHH", client, g_Player[client].top10[Stats_HHHFragged]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_HWN_SkeletonKing", client, g_Player[client].top10[Stats_SkeletonKingsFragged]);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_PreviousPage", client);
				PanelItem(panel, "%T", "#SMStats_Menu_NextPage", client);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_ExitPage", client);
			}
			
			case 8:
			{
				PanelText(panel, "  %T", "#SMStats_MenuInfo_MvM_TanksDestroyed", client, g_Player[client].top10[Stats_TanksDestroyed]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_MvM_SentryBustersFragged", client, g_Player[client].top10[Stats_SentryBustersFragged]);
				PanelText(panel, "  %T", "#SMStats_MenuInfo_MvM_BombsResetted", client, g_Player[client].top10[Stats_BombsResetted]);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_PreviousPage", client);
				//PanelItem(panel, "%T", "#SMStats_Menu_NextPage", client);
				panel.DrawText(" ");
				PanelItem(panel, "%T", "#SMStats_Menu_ExitPage", client);
			}
		}
		
		panel.Send(client, StatsMenu_Top10Info, MENU_TIME_FOREVER);
		delete panel;
	}
}

StatsMenuInfo StatsMenu;

int StatsMenu_Main(Menu menu, MenuAction action, int client, int select)
{
	/*
	 * Main page.
	 * 1: Menu title.
	 * 2: Session.
	 * 3: Active stats.
	 * 4: Top 10 players.
	 */
	switch(select)
	{
		case 1:
		{
			g_Player[client].active_page_session = -1;
			g_Player[client].active_page_top10 = -1;
			StatsMenu.Main(client);
		}
		case 2:
		{
			g_Player[client].active_page_session = 1;
			g_Player[client].active_page_top10 = -1;
			StatsMenu.Session(client, 1);
		}
		case 3:
		{
			g_Player[client].active_page_session = -1;
			g_Player[client].active_page_top10 = -1;
			StatsMenu.Main(client);
		}
		case 4:
		{
			g_Player[client].active_page_session = -1;
			g_Player[client].active_page_top10 = -1;
			StatsMenu.Top10(client);
		}
	}
	
	return 0;
}

int StatsMenu_Session(Menu menu, MenuAction action, int client, int select)
{
	switch(g_Player[client].active_page_session)
	{
		case 1:
		{
			/*
			 * Session page 1
			 * 1 : Menu title.
			 * 2 : Previous page.
			 * 3 : Next page.
			 * 4 : Exit.
			 */
			 
			switch(select)
			{
				case 1:
				{
					g_Player[client].active_page_session = 1;
					g_Player[client].active_page_top10 = -1;
					StatsMenu.Session(client, 1);
				}
				case 2:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = -1;
					StatsMenu.Main(client);
				}
				case 3:
				{
					g_Player[client].active_page_session = 2;
					g_Player[client].active_page_top10 = -1;
					StatsMenu.Session(client, 2);
				}
				case 4:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = -1;
				}
			}
		}
		
		case 2:
		{
			/*
			 * Session page 2
			 * 1 : Menu title.
			 * 2 : Previous page.
			 * 3 : Next page.
			 * 4 : Exit.
			 */
			
			switch(select)
			{
				case 1:
				{
					g_Player[client].active_page_session = 2;
					g_Player[client].active_page_top10 = -1;
					StatsMenu.Session(client, 2);
				}
				case 2:
				{
					g_Player[client].active_page_session = 1;
					g_Player[client].active_page_top10 = -1;
					StatsMenu.Session(client, 1);
				}
				case 3:
				{
					g_Player[client].active_page_session = 3;
					g_Player[client].active_page_top10 = -1;
					StatsMenu.Session(client, 3);
				}
				case 4:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = -1;
				}
			}
		}
		
		case 3:
		{
			/*
			 * Session page 3
			 * 1 : Menu title.
			 * 2 : Previous page.
			 * 3 : Next page.
			 * 4 : Exit.
			 */
			
			switch(select)
			{
				case 1:
				{
					g_Player[client].active_page_session = 3;
					g_Player[client].active_page_top10 = -1;
					StatsMenu.Session(client, 3);
				}
				case 2:
				{
					g_Player[client].active_page_session = 2;
					g_Player[client].active_page_top10 = -1;
					StatsMenu.Session(client, 2);
				}
				case 3:
				{
					g_Player[client].active_page_session = 4;
					g_Player[client].active_page_top10 = -1;
					StatsMenu.Session(client, 4);
				}
				case 4:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = -1;
				}
			}
		}
		
		case 4:
		{
			/*
			 * Session page 4
			 * 1 : Menu title.
			 * 2 : Previous page.
			 * 3 : Next page.
			 * 4 : Exit.
			 */
			
			switch(select)
			{
				case 1:
				{
					g_Player[client].active_page_session = 4;
					g_Player[client].active_page_top10 = -1;
					StatsMenu.Session(client, 4);
				}
				case 2:
				{
					g_Player[client].active_page_session = 3;
					g_Player[client].active_page_top10 = -1;
					StatsMenu.Session(client, 3);
				}
				case 3:
				{
					g_Player[client].active_page_session = 5;
					g_Player[client].active_page_top10 = -1;
					StatsMenu.Session(client, 5);
				}
				case 4:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = -1;
				}
			}
		}
		
		case 5:
		{
			/*
			 * Session page 5
			 * 1 : Menu title.
			 * 2 : Previous page.
			 * 3 : Next page.
			 * 4 : Exit.
			 */
			
			switch(select)
			{
				case 1:
				{
					g_Player[client].active_page_session = 5;
					g_Player[client].active_page_top10 = -1;
					StatsMenu.Session(client, 5);
				}
				case 2:
				{
					g_Player[client].active_page_session = 4;
					g_Player[client].active_page_top10 = -1;
					StatsMenu.Session(client, 4);
				}
				case 3:
				{
					g_Player[client].active_page_session = 6;
					g_Player[client].active_page_top10 = -1;
					StatsMenu.Session(client, 6);
				}
				case 4:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = -1;
				}
			}
		}
		
		case 6:
		{
			/*
			 * Session page 6
			 * 1 : Menu title.
			 * 2 : Previous page.
			 * 3 : Next page.
			 * 4 : Exit.
			 */
			
			switch(select)
			{
				case 1:
				{
					g_Player[client].active_page_session = 6;
					g_Player[client].active_page_top10 = -1;
					StatsMenu.Session(client, 6);
				}
				case 2:
				{
					g_Player[client].active_page_session = 5;
					g_Player[client].active_page_top10 = -1;
					StatsMenu.Session(client, 5);
				}
				case 3:
				{
					g_Player[client].active_page_session = 7;
					g_Player[client].active_page_top10 = -1;
					StatsMenu.Session(client, 7);
				}
				case 4:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = -1;
				}
			}
		}
		
		case 7:
		{
			/*
			 * Session page 7
			 * 1 : Menu title.
			 * 2 : Previous page.
			 * 3 : Next page.
			 * 4 : Exit.
			 */
			
			switch(select)
			{
				case 1:
				{
					g_Player[client].active_page_session = 7;
					g_Player[client].active_page_top10 = -1;
					StatsMenu.Session(client, 7);
				}
				case 2:
				{
					g_Player[client].active_page_session = 6;
					g_Player[client].active_page_top10 = -1;
					StatsMenu.Session(client, 6);
				}
				case 3:
				{
					g_Player[client].active_page_session = 8;
					g_Player[client].active_page_top10 = -1;
					StatsMenu.Session(client, 8);
				}
				case 4:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = -1;
				}
			}
		}
		
		case 8:
		{
			/*
			 * Session page 8
			 * 1 : Menu title.
			 * 2 : Previous page.
			 * 3 : Exit.
			 */
			
			switch(select)
			{
				case 1:
				{
					g_Player[client].active_page_session = 8;
					g_Player[client].active_page_top10 = -1;
					StatsMenu.Session(client, 8);
				}
				case 2:
				{
					g_Player[client].active_page_session = 7;
					g_Player[client].active_page_top10 = -1;
					StatsMenu.Session(client, 7);
				}
				case 3:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = -1;
				}
			}
		}
	}
	
	return 0;
}

int StatsMenu_Top10(Menu menu, MenuAction action, int client, int select)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char auth[64];
			menu.GetItem(select, auth, sizeof(auth));
			
			if(strlen(auth) < 1)
			{
				CPrintToChat(client, "%s Encountered a problem reading steam id of the top player.", g_ChatTag);
				return 0;
			}
			
			SQL_LockDatabase(sql);
			
			char query[2048];
			Format(query, sizeof(query), "select "
			/* 0*/... "PlayerName,"
			/* 1*/... "PlayTime,"
			/* 2*/... "Points,"
			/* 3*/... "Frags,"
			/* 4*/... "Assists,"
			/* 5*/... "Deaths,"
			/* 6*/... "Suicides,"
			/* 7*/... "DamageDone,"
			/* 8*/... "Achievements,"
			
			/* 9*/... "Dominations,"
			/*10*/... "Revenges,"
			/*11*/... "Airshots,"
			/*12*/... "Headshots,"
			/*13*/... "Noscopes,"
			/*14*/... "Backstabs,"
			/*15*/... "TauntFrags,"
			/*16*/... "GibFrags,"
			/*17*/... "DeflectFrags,"
			/*18*/... "TeleFrags,"
			/*19*/... "Collaterals,"
			/*20*/... "MidAirFrags,"
			/*21*/... "CritFrags,"
			/*22*/... "MiniCritFrags,"
			
			/*23*/... "ScoutFrags,"
			/*24*/... "SoldierFrags,"
			/*25*/... "PyroFrags,"
			/*26*/... "DemoFrags,"
			/*27*/... "HeavyFrags,"
			/*28*/... "EngieFrags,"
			/*29*/... "MedicFrags,"
			/*30*/... "SniperFrags,"
			/*31*/... "SpyFrags,"
			/*32*/... "ScoutDeaths,"
			/*33*/... "SoldierDeaths,"
			/*34*/... "PyroDeaths,"
			/*35*/... "DemoDeaths,"
			/*36*/... "HeavyDeaths,"
			/*37*/... "EngieDeaths,"
			/*38*/... "MedicDeaths,"
			/*39*/... "SniperDeaths,"
			/*40*/... "SpyDeaths,"
			
			/*41*/... "BuildingsPlaced,"
			/*42*/... "DispensersPlaced,"
			/*43*/... "SentryGunsPlaced,"
			/*44*/... "TeleporterEntrancesPlaced,"
			/*45*/... "TeleporterExitsPlaced,"
			/*46*/... "MiniSentryGunsPlaced,"
			/*47*/... "SappersPlaced,"
			/*48*/... "BuildingsDestroyed,"
			/*49*/... "DispensersDestroyed,"
			/*50*/... "SentryGunsDestroyed,"
			/*51*/... "TeleporterEntrancesDestroyed,"
			/*52*/... "TeleporterExitsDestroyed,"
			/*53*/... "MiniSentryGunsDestroyed,"
			/*54*/... "SappersDestroyed,"
			
			/*55*/... "PointsCaptured,"
			/*56*/... "PointsDefended,"
			/*57*/... "FlagsPickedUp,"
			/*58*/... "FlagsCaptured,"
			/*59*/... "FlagsStolen,"
			/*60*/... "FlagsDefended,"
			/*61*/... "FlagsDropped,"
			
			/*62*/... "TeleportersUsed,"
			/*63*/... "PlayersTeleported,"
			/*64*/... "CoatedMilk,"
			/*65*/... "CoatedPiss,"
			/*66*/... "Coated,"
			/*67*/... "Extinguished,"
			/*XX*///... "Ignited,"
			/*68*/... "Ubercharged,"
			/*69*/... "SandvichesStolen,"
			
			/*70*/... "MonoculusStunned,"
			/*71*/... "MerasmusStunned,"
			/*72*/... "MonoculusFragged,"
			/*73*/... "MerasmusFragged,"
			/*74*/... "HHHFragged,"
			/*75*/... "SkeletonKingsFragged,"
			
			/*XX*///... "RobotsFragged,"
			/*76*/... "TanksDestroyed,"
			/*77*/... "SentryBustersFragged,"
			/*78*/... "BombsResetted"
			
			... " from `%s` where SteamID = '%s' and ServerID = %i"
			, sql_table_playerlist, auth, g_ServerID);
			DBResultSet results = SQL_Query(sql, query);
			switch(results != null && results.FetchRow())
			{
				case false:
				{
					SQL_UnlockDatabase(sql);
					delete results;
					
					char error[255];
					SQL_GetError(sql, error, sizeof(error));
					PrintToServer("%s Failed to query top 10 player\nError below:\n%s", core_chattag, error);
					
					CPrintToChat(client, "%s Failed to query information of the top player", g_ChatTag);
					return 0;
				}
				case true:
				{
					results.FetchString(0, g_Player[client].top10name, sizeof(g_Player[].top10name));
					g_Player[client].top10[Stats_PlayTime] = results.FetchInt(1);
					g_Player[client].top10[Stats_Points] = results.FetchInt(2);
					g_Player[client].top10[Stats_Frags] = results.FetchInt(3);
					g_Player[client].top10[Stats_Assists] = results.FetchInt(4);
					g_Player[client].top10[Stats_Deaths] = results.FetchInt(5);
					g_Player[client].top10[Stats_Suicides] = results.FetchInt(6);
					g_Player[client].top10[Stats_DamageDone] = results.FetchInt(7);
					g_Player[client].top10[Stats_Achievements] = results.FetchInt(8);
					
					g_Player[client].top10[Stats_Dominations] = results.FetchInt(9);
					g_Player[client].top10[Stats_Revenges] = results.FetchInt(10);
					g_Player[client].top10[Stats_Airshots] = results.FetchInt(11);
					g_Player[client].top10[Stats_Headshots] = results.FetchInt(12);
					g_Player[client].top10[Stats_Noscopes] = results.FetchInt(13);
					g_Player[client].top10[Stats_Backstabs] = results.FetchInt(14);
					g_Player[client].top10[Stats_TauntFrags] = results.FetchInt(15);
					g_Player[client].top10[Stats_GibFrags] = results.FetchInt(16);
					g_Player[client].top10[Stats_Deflects] = results.FetchInt(17);
					g_Player[client].top10[Stats_TeleFrags] = results.FetchInt(18);
					g_Player[client].top10[Stats_Collaterals] = results.FetchInt(19);
					g_Player[client].top10[Stats_MidAirFrags] = results.FetchInt(20);
					g_Player[client].top10[Stats_CritFrags] = results.FetchInt(21);
					g_Player[client].top10[Stats_MiniCritFrags] = results.FetchInt(22);
					
					g_Player[client].top10[Stats_ScoutFrags] = results.FetchInt(23);
					g_Player[client].top10[Stats_SoldierFrags] = results.FetchInt(24);
					g_Player[client].top10[Stats_PyroFrags] = results.FetchInt(25);
					g_Player[client].top10[Stats_DemoFrags] = results.FetchInt(26);
					g_Player[client].top10[Stats_HeavyFrags] = results.FetchInt(27);
					g_Player[client].top10[Stats_EngieFrags] = results.FetchInt(28);
					g_Player[client].top10[Stats_MedicFrags] = results.FetchInt(29);
					g_Player[client].top10[Stats_SniperFrags] = results.FetchInt(30);
					g_Player[client].top10[Stats_SpyFrags] = results.FetchInt(31);
					g_Player[client].top10[Stats_ScoutDeaths] = results.FetchInt(32);
					g_Player[client].top10[Stats_SoldierDeaths] = results.FetchInt(33);
					g_Player[client].top10[Stats_PyroDeaths] = results.FetchInt(34);
					g_Player[client].top10[Stats_DemoDeaths] = results.FetchInt(35);
					g_Player[client].top10[Stats_HeavyDeaths] = results.FetchInt(36);
					g_Player[client].top10[Stats_EngieDeaths] = results.FetchInt(37);
					g_Player[client].top10[Stats_MedicDeaths] = results.FetchInt(38);
					g_Player[client].top10[Stats_SniperDeaths] = results.FetchInt(39);
					g_Player[client].top10[Stats_SpyDeaths] = results.FetchInt(40);
					
					g_Player[client].top10[Stats_BuildingsPlaced] = results.FetchInt(41);
					g_Player[client].top10[Stats_DispensersPlaced] = results.FetchInt(42);
					g_Player[client].top10[Stats_SentryGunsPlaced] = results.FetchInt(43);
					g_Player[client].top10[Stats_TeleporterEntrancesPlaced] = results.FetchInt(44);
					g_Player[client].top10[Stats_TeleporterExitsPlaced] = results.FetchInt(44);
					g_Player[client].top10[Stats_MiniSentryGunsPlaced] = results.FetchInt(46);
					g_Player[client].top10[Stats_SappersPlaced] = results.FetchInt(47);
					g_Player[client].top10[Stats_BuildingsDestroyed] = results.FetchInt(48);
					g_Player[client].top10[Stats_DispensersDestroyed] = results.FetchInt(49);
					g_Player[client].top10[Stats_SentryGunsDestroyed] = results.FetchInt(50);
					g_Player[client].top10[Stats_TeleporterEntrancesDestroyed] = results.FetchInt(51);
					g_Player[client].top10[Stats_TeleporterExitsDestroyed] = results.FetchInt(52);
					g_Player[client].top10[Stats_MiniSentryGunsDestroyed] = results.FetchInt(53);
					g_Player[client].top10[Stats_SappersDestroyed] = results.FetchInt(54);
					
					g_Player[client].top10[Stats_PointsCaptured] = results.FetchInt(55);
					g_Player[client].top10[Stats_PointsDefended] = results.FetchInt(56);
					g_Player[client].top10[Stats_FlagsPickedUp] = results.FetchInt(57);
					g_Player[client].top10[Stats_FlagsCaptured] = results.FetchInt(58);
					g_Player[client].top10[Stats_FlagsStolen] = results.FetchInt(59);
					g_Player[client].top10[Stats_FlagsDefended] = results.FetchInt(60);
					g_Player[client].top10[Stats_FlagsDropped] = results.FetchInt(61);
					
					g_Player[client].top10[Stats_TeleportersUsed] = results.FetchInt(62);
					g_Player[client].top10[Stats_PlayersTeleported] = results.FetchInt(63);
					g_Player[client].top10[Stats_CoatedMilk] = results.FetchInt(64);
					g_Player[client].top10[Stats_CoatedPiss] = results.FetchInt(65);
					g_Player[client].top10[Stats_Coated] = results.FetchInt(66);
					g_Player[client].top10[Stats_Extinguished] = results.FetchInt(67);
					//g_Player[client].top10[Stats_Ignited] = results.FetchInt(XX);
					g_Player[client].top10[Stats_Ubercharged] = results.FetchInt(68);
					g_Player[client].top10[Stats_SandvichesStolen] = results.FetchInt(69);
					
					g_Player[client].top10[Stats_MonoculusStunned] = results.FetchInt(70);
					g_Player[client].top10[Stats_MerasmusStunned] = results.FetchInt(71);
					g_Player[client].top10[Stats_MonoculusFragged] = results.FetchInt(72);
					g_Player[client].top10[Stats_MerasmusFragged] = results.FetchInt(73);
					g_Player[client].top10[Stats_HHHFragged] = results.FetchInt(74);
					g_Player[client].top10[Stats_SkeletonKingsFragged] = results.FetchInt(75);
					
					//g_Player[client].top10[Stats_RobotsFragged] = results.FetchInt(XX);
					g_Player[client].top10[Stats_TanksDestroyed] = results.FetchInt(76);
					g_Player[client].top10[Stats_SentryBustersFragged] = results.FetchInt(77);
					g_Player[client].top10[Stats_BombsResetted] = results.FetchInt(78);
					
					//
					
					g_Player[client].active_page_menu = menu.Selection;
					g_Player[client].active_page_top10 = 1;
					StatsMenu.Top10Info(client, 1);
				}
			}
			
			delete results;
			SQL_UnlockDatabase(sql);
		}
		case MenuAction_Cancel:
		{
			if(select == MenuCancel_ExitBack)
			{
				StatsMenu.Main(client);
			}
		}
		case MenuAction_End: delete menu;
	}
	
	return 0;
}

int StatsMenu_Top10Info(Menu menu, MenuAction action, int client, int select)
{
	switch(g_Player[client].active_page_top10)
	{
		case 1:
		{
			/*
			 * Top 10 player page 1
			 * 1 : Menu title.
			 * 2 : Previous page.
			 * 3 : Next page.
			 * 4 : Exit.
			 */
			 
			switch(select)
			{
				case 1:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = 1;
					StatsMenu.Top10Info(client, 1);
				}
				case 2:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = -1;
					StatsMenu.Top10(client, g_Player[client].active_page_menu);
				}
				case 3:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = 2;
					StatsMenu.Top10Info(client, 2);
				}
				case 4:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = -1;
					g_Player[client].top10name = "";
					for(int i = 0; i < SMStats_StatsSize; i++)
					{
						g_Player[client].top10[i] = -1;
					}
				}
			}
		}
		
		case 2:
		{
			/*
			 * Top 10 player page 2
			 * 1 : Menu title.
			 * 2 : Previous page.
			 * 3 : Next page.
			 * 4 : Exit.
			 */
			
			switch(select)
			{
				case 1:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = 2;
					StatsMenu.Top10Info(client, 2);
				}
				case 2:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = 1;
					StatsMenu.Top10Info(client, 1);
				}
				case 3:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = 3;
					StatsMenu.Top10Info(client, 3);
				}
				case 4:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = -1;
					g_Player[client].top10name = "";
					for(int i = 0; i < SMStats_StatsSize; i++)
					{
						g_Player[client].top10[i] = -1;
					}
				}
			}
		}
		
		case 3:
		{
			/*
			 * Top 10 player page 3
			 * 1 : Menu title.
			 * 2 : Previous page.
			 * 3 : Next page.
			 * 4 : Exit.
			 */
			
			switch(select)
			{
				case 1:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = 3;
					StatsMenu.Top10Info(client, 3);
				}
				case 2:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = 2;
					StatsMenu.Top10Info(client, 2);
				}
				case 3:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = 4;
					StatsMenu.Top10Info(client, 4);
				}
				case 4:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = -1;
					g_Player[client].top10name = "";
					for(int i = 0; i < SMStats_StatsSize; i++)
					{
						g_Player[client].top10[i] = -1;
					}
				}
			}
		}
		
		case 4:
		{
			/*
			 * Top 10 player page 4
			 * 1 : Menu title.
			 * 2 : Previous page.
			 * 3 : Next page.
			 * 4 : Exit.
			 */
			
			switch(select)
			{
				case 1:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = 4;
					StatsMenu.Top10Info(client, 4);
				}
				case 2:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = 3;
					StatsMenu.Top10Info(client, 3);
				}
				case 3:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = 5;
					StatsMenu.Top10Info(client, 5);
				}
				case 4:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = -1;
					g_Player[client].top10name = "";
					for(int i = 0; i < SMStats_StatsSize; i++)
					{
						g_Player[client].top10[i] = -1;
					}
				}
			}
		}
		
		case 5:
		{
			/*
			 * Top 10 player page 5
			 * 1 : Menu title.
			 * 2 : Previous page.
			 * 3 : Next page.
			 * 4 : Exit.
			 */
			
			switch(select)
			{
				case 1:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = 5;
					StatsMenu.Top10Info(client, 5);
				}
				case 2:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = 4;
					StatsMenu.Top10Info(client, 4);
				}
				case 3:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = 6;
					StatsMenu.Top10Info(client, 6);
				}
				case 4:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = -1;
					g_Player[client].top10name = "";
					for(int i = 0; i < SMStats_StatsSize; i++)
					{
						g_Player[client].top10[i] = -1;
					}
				}
			}
		}
		
		case 6:
		{
			/*
			 * Top 10 player page 6
			 * 1 : Menu title.
			 * 2 : Previous page.
			 * 3 : Next page.
			 * 4 : Exit.
			 */
			
			switch(select)
			{
				case 1:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = 6;
					StatsMenu.Top10Info(client, 6);
				}
				case 2:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = 5;
					StatsMenu.Top10Info(client, 5);
				}
				case 3:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = 7;
					StatsMenu.Top10Info(client, 7);
				}
				case 4:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = -1;
					g_Player[client].top10name = "";
					for(int i = 0; i < SMStats_StatsSize; i++)
					{
						g_Player[client].top10[i] = -1;
					}
				}
			}
		}
		
		case 7:
		{
			/*
			 * Top 10 player page 7
			 * 1 : Menu title.
			 * 2 : Previous page.
			 * 3 : Next page.
			 * 4 : Exit.
			 */
			
			switch(select)
			{
				case 1:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = 7;
					StatsMenu.Top10Info(client, 7);
				}
				case 2:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = 6;
					StatsMenu.Top10Info(client, 6);
				}
				case 3:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = 8;
					StatsMenu.Top10Info(client, 8);
				}
				case 4:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = -1;
					g_Player[client].top10name = "";
					for(int i = 0; i < SMStats_StatsSize; i++)
					{
						g_Player[client].top10[i] = -1;
					}
				}
			}
		}
		
		case 8:
		{
			/*
			 * Top 10 player page 8
			 * 1 : Menu title.
			 * 2 : Previous page.
			 * 3 : Exit.
			 */
			
			switch(select)
			{
				case 1:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = 8;
					StatsMenu.Top10Info(client, 8);
				}
				case 2:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = 7;
					StatsMenu.Top10Info(client, 7);
				}
				case 3:
				{
					g_Player[client].active_page_session = -1;
					g_Player[client].active_page_top10 = -1;
					g_Player[client].top10name = "";
					for(int i = 0; i < SMStats_StatsSize; i++)
					{
						g_Player[client].top10[i] = -1;
					}
				}
			}
		}
	}
	
	return 0;
}

/* =================================================== */

void LoadMenus()
{
	for(int i = 0; i < sizeof(str_cmdMenu); i++)
	{
		RegConsoleCmd(str_cmdMenu[i], StatsMenuCmd, "SM Stats: TF2 - Statistical menu.");
	}
}

Action StatsMenuCmd(int client, int args)
{
	switch(client == 0)
	{
		case false: StatsMenu.Main(client);
		case true: ReplyToCommand(client, "[SM Stats: TF2] This command may only be used in-game!");
	}
	
	return Plugin_Handled;
}

/* =================================================== */