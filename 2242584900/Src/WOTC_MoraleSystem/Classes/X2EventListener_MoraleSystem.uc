class X2EventListener_MoraleSystem extends X2EventListener
	config(MoraleSystem);

var config DefaultMoraleRollData					DefaultMoraleRollData;
var config TheLostMoraleRollData					TheLostMoraleRollData;
var config array<SpecialEnemyMoraleRollData>		arrSpecialEnemyMoraleRollData;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateTacticalTemplate('OnUnitKilled','UnitDied', OnUnitKilled));

	return Templates;
}

static protected function X2EventListenerTemplate CreateTacticalTemplate(name TemplateName, name EventName, delegate<X2EventManager.OnEventDelegate> EventFn)
{
	local X2EventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EventListenerTemplate', Template, TemplateName);
	Template.RegisterInTactical = true;
	Template.AddEvent(EventName, EventFn);

	return Template;
}

// #######################################################################################
// -------------------- EVENT LISTENER FUNCTION ------------------------------------------
// #######################################################################################

static function EventListenerReturn OnUnitKilled(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_BattleData		BattleData;
	local XComGameState_Unit			DeadUnit;
	local array<XComGameState_Unit>		arrXComUnit;
	local bool							bIsSpecialEnemy;
	local int							WillGainChance, MinWillRoll, MaxWillRoll;
	local int							i;

	// Skip if multiplier game
	BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData', true));
	if (BattleData != none && BattleData.m_strDesc ~= "Multiplayer")
	{
		return ELR_NoInterrupt;
	}

	// Skip if Game State is interruped
	if (GameState.GetContext().InterruptionStatus == eInterruptionStatus_Interrupt)
	{
		return ELR_NoInterrupt;
	}

	// Access Dead Unit State
	DeadUnit = XComGameState_Unit(EventSource);

	// Skip if Dead Unit is not an enemy
	if (DeadUnit == none || IsTeamXCom(DeadUnit) || IsTeamResistance(DeadUnit) || IsTeamNeutral(DeadUnit))
	{
		return ELR_NoInterrupt;
	}

	// Check if Dead Unit is special enemy
	bIsSpecialEnemy=false;
	if (default.arrSpecialEnemyMoraleRollData.Length != 0)
	{
		for (i = 0; i < default.arrSpecialEnemyMoraleRollData.Length; i++)
		{
			if (default.arrSpecialEnemyMoraleRollData[i].CharName == DeadUnit.GetMyTemplateName())
			{
				bIsSpecialEnemy=true;
				WillGainChance = default.arrSpecialEnemyMoraleRollData[i].WillGainChance;
				MinWillRoll = default.arrSpecialEnemyMoraleRollData[i].MinWillRoll;
				MAxWillRoll = default.arrSpecialEnemyMoraleRollData[i].MaxWillRoll;
				break;
			}
		}
	}

	// Access XCom Units States
	XGBattle_SP(`BATTLE).GetHumanPlayer().GetOriginalUnits(arrXComUnit, true);
	for (i = 0; i < arrXComUnit.Length; i++)
	{
		// Skip if XCom Unit doesn't use the Will System or if Unit is disabled
		if (arrXComUnit[i].UsesWillSystem() && !IsDisableD(arrXComUnit[i]))
		{
			if (bIsSpecialEnemy)
			{
				// Adjust chance and Will roll if Dead Unit is special enemy
				GainWill(arrXComUnit[i], WillGainChance, MinWillRoll, MaxWillRoll);
			}
			else if (IsTeamLost(DeadUnit))
			{
				// Adjust chance and Will roll if Dead Unit is The Lost
				GainWill(arrXComUnit[i], default.TheLostMoraleRollData.WillGainChance, default.TheLostMoraleRollData.MinWillRoll, default.TheLostMoraleRollData.MaxWillRoll);
			}
			else
			{
				// Adjust chance and Will roll according to Default setting
				GainWill(arrXComUnit[i], default.DefaultMoraleRollData.WillGainChance, default.DefaultMoraleRollData.MinWillRoll, default.DefaultMoraleRollData.MaxWillRoll);
			}
		}
	}

	return ELR_NoInterrupt;
}

static function GainWill(XComGameState_Unit XComUnit, int WillGainChance, int MinWillRoll, int MaxWillRoll)
{
	local XComGameStateContext_MoraleSystemEvent		EventContext;
	local int											WillRoll;

	WillRoll = `SYNC_RAND_STATIC(MaxWillRoll - MinWillRoll) + MinWillRoll;

	if (`SYNC_RAND_STATIC(100) < WillGainChance && WillRoll > 0)
	{
		// Cap Will roll according to Unit's max Will
		if (XComUnit.GetMaxStat(eStat_Will) - XComUnit.GetCurrentStat(eStat_Will) < WillRoll)
		{
			WillRoll = XComUnit.GetMaxStat(eStat_Will) - XComUnit.GetCurrentStat(eStat_Will);
		}

		// Trigger event to gain Will
		EventContext = XComGameStateContext_MoraleSystemEvent(class'XComGameStateContext_MoraleSystemEvent'.static.CreateXComGameStateContext());
		EventContext.AssociatedUnitRef = XComUnit.GetReference();
		EventContext.WillRoll = WillRoll;

		`TACTICALRULES.SubmitGameStateContext(EventContext);
	}
}

// #######################################################################################
// -------------------- FILTER FUNCTIONS -------------------------------------------------
// #######################################################################################

static function bool IsDisabled (XComGameState_Unit UnitState)
{
	
	if (UnitState.IsDead())
	{
		return true;
	}

	if (UnitState.IsMindControlled())
	{
		return true;
	}

	if (UnitState.IsIncapacitated() || UnitState.IsStunned() || UnitState.IsPanicked() || UnitState.IsDazed())
	{
		return true;
	}

	if (UnitState.IsUnitAffectedByEffectName(class'X2Ability_Viper'.default.BindSustainedEffectName))
	{
		return true;
	}

	if (UnitState.IsUnitAffectedByEffectName(class'X2Effect_DLC_Day60Freeze'.default.EffectName))
	{
		return true;
	}

	return false;
}

static function bool IsTeamXCom(XComGameState_Unit UnitState)
{
	if (!UnitState.IsMindControlled() && UnitState.GetTeam() != eTeam_XCom || UnitState.IsMindControlled() && UnitState.GetTeam() == eTeam_XCom)
		return false;

	return true;
}

static function bool IsTeamResistance(XComGameState_Unit UnitState)
{
	if (!UnitState.IsMindControlled() && UnitState.GetTeam() != eTeam_Resistance || UnitState.IsMindControlled() && UnitState.GetTeam() == eTeam_Resistance)
		return false;

	return true;
}

static function bool IsTeamNeutral(XComGameState_Unit UnitState)
{
	if (!UnitState.IsMindControlled() && UnitState.GetTeam() != eTeam_Neutral || UnitState.IsMindControlled() && UnitState.GetTeam() == eTeam_Neutral)
		return false;

	return true;
}

static function bool IsTeamLost(XComGameState_Unit UnitState)
{
	if (UnitState.GetMyTemplate().CharacterGroupName != 'TheLost')
	{
		return false;
	}

	return true;
}