class X2EventListener_APFarming extends X2EventListener
	config(APFarming);

var config array<APFarmingEnemyList>		arrAPFarmingEnemyList;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(AddAPFarmingEvent());

	return Templates;
}

static function X2AbilityPointTemplate AddAPFarmingEvent()
{
	local X2AbilityPointTemplate Template;

	`CREATE_X2TEMPLATE(class'X2AbilityPointTemplate', Template, 'APFarming');
	Template.AddEvent('UnitDied', OnUnitKilled);

	return Template;
}

static protected function EventListenerReturn OnUnitKilled(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_BattleData					BattleData;
	local XComGameState_Unit						DeadUnit;
	local XComGameStateContext_APFarmingEvent		EventContext;
	local int										i;

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

	if (DeadUnit != none && default.arrAPFarmingEnemyList.Length != 0)
	{
		for (i = 0; i < default.arrAPFarmingEnemyList.Length; i++)
		{
			if (default.arrAPFarmingEnemyList[i].CharName == DeadUnit.GetMyTemplateName())
			{				
				// Trigger event to gain Ability Points
				EventContext = XComGameStateContext_APFarmingEvent(class'XComGameStateContext_APFarmingEvent'.static.CreateXComGameStateContext());
				EventContext.AssociatedUnitRef = DeadUnit.GetReference();
				EventContext.APReward = default.arrAPFarmingEnemyList[i].APReward;
				EventContext.Article = default.arrAPFarmingEnemyList[i].Article;

				`TACTICALRULES.SubmitGameStateContext(EventContext);
			}
		}
	}

	return ELR_NoInterrupt;
}