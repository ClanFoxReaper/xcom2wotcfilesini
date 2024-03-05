class XComGameStateContext_APFarmingEvent extends XComGameStateContext;

var StateObjectReference	AssociatedUnitRef;
var int						APReward;
var string					Article;

var localized string		strAPRewardFlyoverSingular;
var localized string		strAPRewardFlyoverPlural;
var localized string		strAPRewardBannerSingular;
var localized string		strAPRewardBannerPlural;

event string SummaryString()
{
	return "XComGameStateContext_APFarmingEvent";
}

function bool Validate(optional EInterruptionStatus InInterruptionStatus)
{
	return true;
}

function XComGameState ContextBuildGameState()
{
	local XComGameState						NewGameState;
	local XComGameState_HeadquartersXCom	XComHQ;

	// Adjust AP Reward if Trial by Fire is enabled
	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	APReward *= XComHQ.BonusAbilityPointScalar;

	// Create new Game State
	NewGameState = `XCOMHISTORY.CreateNewGameState(true, self);

	// Add the AP Reward
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom',XComHQ.ObjectID));
	XComHQ.AddResource(NewGameState, 'AbilityPoint', APReward);

	// Add a copy of the Dead Unit for the visualization
	NewGameState.ModifyStateObject(class'XComGameState_Unit', AssociatedUnitRef.ObjectID);

	NewGameState.GetContext().SetAssociatedPlayTiming(SPT_AfterSequential);

	return NewGameState;
}

function XComGameState ContextBuildInterruptedGameState(int InterruptStep, EInterruptionStatus InInterruptionStatus)
{
	return none;
}

protected function ContextBuildVisualization()
{
	local XComGameState_Unit			SourceUnit;
	local VisualizationActionMetadata	BuildTrack;
	local X2Action_PlaySoundAndFlyover	FlyoverAction;
	local X2Action_PlayMessageBanner	WorldMessageAction;
	local XGParamTag					Tag;

	foreach AssociatedState.IterateByClassType(class'XComGameState_Unit', SourceUnit)
	{
		BuildTrack.StateObject_OldState = SourceUnit.GetPreviousVersion();
		BuildTrack.StateObject_NewState = SourceUnit;
		class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(BuildTrack, self);

		// Set up localization
		Tag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
		Tag.StrValue0 = Article;
		Tag.StrValue1 = SourceUnit.GetName(eNameType_RankFull);
		Tag.IntValue0 = APReward;
		
		// Show the flyover
		FlyoverAction = X2Action_PlaySoundAndFlyover(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(BuildTrack, self));
		FlyoverAction.SetSoundAndFlyOverParameters(none, `XEXPAND.ExpandString(Tag.IntValue0 == 1 ? default.strAPRewardFlyoverSingular : default.strAPRewardFlyoverPlural), '', eColor_Good);

		// Show the world message banner
		WorldMessageAction = X2Action_PlayMessageBanner(class'X2Action_PlayMessageBanner'.static.AddToVisualizationTree(BuildTrack, self));
		WorldMessageAction.AddMessageBanner(class'UIEventNoticesTactical'.default.AbilityPointGainedTitle,
											,
											SourceUnit.GetName(eNameType_RankFull),
											`XEXPAND.ExpandString(Tag.IntValue0 == 1 ? default.strAPRewardBannerSingular : default.strAPRewardBannerPlural),
											eUIState_Good);
	}
}