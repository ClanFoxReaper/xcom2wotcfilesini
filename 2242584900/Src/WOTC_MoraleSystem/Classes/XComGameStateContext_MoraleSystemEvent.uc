class XComGameStateContext_MoraleSystemEvent extends XComGameStateContext;

var StateObjectReference	AssociatedUnitRef;
var int						WillRoll;
var localized string		strWillGainFlyover;

event string SummaryString()
{
	return "XComGameStateContext_MoraleSystemEvent";
}

function bool Validate(optional EInterruptionStatus InInterruptionStatus)
{
	return true;
}

function XComGameState ContextBuildGameState()
{
	local XComGameState			NewGameState;
	local XComGameState_Unit	XComUnit;
	local int					CurrentWill;

	// Create new Game State
	NewGameState = `XCOMHISTORY.CreateNewGameState(true, self);

	// Access XCom Unit
	XComUnit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', AssociatedUnitRef.ObjectID));

	// Determine new current Will
	CurrentWill = XComUnit.GetCurrentStat(eStat_Will);
	CurrentWill += WillRoll;

	// Increase Unit's Will
	XComUnit.SetCurrentStat(eStat_Will, CurrentWill);

	NewGameState.GetContext().SetAssociatedPlayTiming(SPT_AfterSequential);

	return NewGameState;
}

function XComGameState ContextBuildInterruptedGameState(int InterruptStep, EInterruptionStatus InInterruptionStatus)
{
	return none;
}

protected function ContextBuildVisualization()
{
	local XComGameState_Unit			XComUnit;
	local VisualizationActionMetadata	BuildTrack;
	local X2Action_PlaySoundAndFlyover	FlyoverAction;

	if (class'X2DownloadableContentInfo_WOTC_MoraleSystem'.static.IsDLCInstalled('WotC_VisualizeWillEvents'))
	{
		foreach AssociatedState.IterateByClassType(class'XComGameState_Unit', XComUnit)
		{
			BuildTrack.StateObject_OldState = XComUnit.GetPreviousVersion();
			BuildTrack.StateObject_NewState = XComUnit;
			class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(BuildTrack, self);

			// Show the flyover
			FlyoverAction = X2Action_PlaySoundAndFlyover(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(BuildTrack, self));
			FlyoverAction.SetSoundAndFlyOverParameters(none, Repl(strWillGainFlyover, "%WILLGAIN", WillRoll), '', eColor_Good);
		}
	}
}