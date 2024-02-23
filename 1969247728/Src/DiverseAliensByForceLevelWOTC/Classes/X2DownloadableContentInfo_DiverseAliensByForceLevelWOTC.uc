class X2DownloadableContentInfo_DiverseAliensByForceLevelWOTC extends X2DownloadableContentInfo;

struct Rule {
	var int iMinForceLevel;
	var int iMaxForceLevel;
	var int iChance;
	var int iNumToAdd;
	var int iForceLevelOffset;
};

struct Modifier {
	var name TargetName;
	var bool bExclusion;
	var int iMaxEnemiesInPod;
	var int iForceLevelOffset;
	var int iEnemyCountOffset;
};

struct Variance {
	var int iMinForceLevel;
	var int iPositive;
	var int iNegative;
};

var config(DABFL) bool bLogging;
var config(DABFL) bool bVerbose;

var config(DABFL) bool bAffectSingleUnits;
var config(DABFL) bool bAffectReinforcements;
var config(DABFL) bool bAffectTheLost;

var config(DABFL) bool bIgnoreForcedSpawnNames;
var config(DABFL) bool bIgnoreMaxCharactersPerGroup;
var config(DABFL) bool bIgnoreSupportedFollowers;

var config(DABFL) bool bMergeSitrepLists;

var config(DABFL) Variance ForceLevelVariance;

var config(DABFL) float fDuplicateUnitFavourFactor;

var config(DABFL) array<Modifier> MissionModifiers;
var config(DABFL) array<Modifier> SitRepModifiers;

var config(DABFL) array<Rule> AlienPodSizeRules;
var config(DABFL) array<Rule> ReinforcementRules;
var config(DABFL) array<Rule> TheLostRules;

var config(DABFL) array<name> ExcludedEncounters;
var config(DABFL) array<name> ExcludedFollowers;

`define msg(message) `LOG(`message, default.bLogging, 'DiverseAliensByFL')
`define verb(message) `LOG(`message, default.bLogging && default.bVerbose, 'DiverseAliensByFL')

static event OnPostTemplatesCreated()
{
	if(default.bLogging)
	{
		DumpConfigs();
	}
}

// this one is called for every reinforcement
static function PostReinforcementCreation(
	out name EncounterName, 
	out PodSpawnInfo Encounter,
	int ForceLevel,
	int AlertLevel,
	optional XComGameState_BaseObject SourceObject,
	optional XComGameState_BaseObject ReinforcementState)
{
	`msg(" "); // empty line to more easily separate where one pod ends and another one starts

	`msg("Processing reinforcement" @ EncounterName @ "with leader" @ Encounter.SelectedCharacterTemplateNames[0]);
	if(default.bAffectReinforcements)
	{
		ProcessEncounter(
			EncounterName, 
			Encounter, 
			ForceLevel, 
			AlertLevel, 
			XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(XComGameState_BattleData(SourceObject).m_iMissionID)), 
			XComGameState_BattleData(SourceObject)
		);
	} 
	else
	{
		`msg("bAffectReinforcements set to false, skipping...");
	}
}

// this one is for every preplaced encounter
static function PostEncounterCreation(
	out name EncounterName,
	out PodSpawnInfo Encounter,
	int ForceLevel,
	int AlertLevel,
	optional XComGameState_BaseObject SourceObject)
{
	`msg(" "); // empty line to more easily separate where one pod ends and another one starts

	`msg("Processing preplaced encounter" @ EncounterName @ "with leader" @ Encounter.SelectedCharacterTemplateNames[0]);
	ProcessEncounter(
		EncounterName, 
		Encounter, 
		ForceLevel, 
		AlertLevel, 
		XComGameState_MissionSite(SourceObject)
	);
}

// this is where the magic happens
static final function ProcessEncounter(name EncounterName, out PodSpawnInfo Encounter, int ForceLevel, int AlertLevel, XComGameState_MissionSite Mission, optional XComGameState_BattleData BattleData)
{ 
	local Modifier ModifierEntry;
	local name NameEntry;
	local array<Rule> ActiveRules;
	local array<SpawnDistributionListEntry> RollingList;
	local int UnitCap, FLOffset, UnitCountOffset;
	local array<int> CharInGroup;
	local int index, NumToRoll;
	local Rule CurrentRule;
	local int Roll;
	local name MissionName;
	local bool isReinforcement;

	isReinforcement = BattleData != none;

	MissionName = Mission.GeneratedMission.Mission.MissionName;

	// use mission name from battledata if provided, this tracks tactical -> tactical correctly 
	if (isReinforcement)
	{
		MissionName = BattleData.MapData.ActiveMission.MissionName;
		`verb("Using mission name from battle data" @ MissionName);
	}

	// is mission excluded
	foreach default.MissionModifiers(ModifierEntry)
	{
		if(ModifierEntry.bExclusion && ModifierEntry.TargetName == MissionName)
		{
			`msg("Mission" @ Mission.GeneratedMission.Mission.MissionName @ "excluded, skipping...");
			return;
		}
	}

	// is sitrep excluded
	foreach default.SitRepModifiers(ModifierEntry)
	{
		if(ModifierEntry.bExclusion && Mission.GeneratedMission.SitReps.find(ModifierEntry.TargetName) != INDEX_NONE)
		{
			`msg("SitRep" @ ModifierEntry.TargetName @ "excluded, skipping...");
			return;
		}
	}
	
	// check for excluded encounter
	foreach default.ExcludedEncounters(NameEntry)
	{
		if(InStr(EncounterName, NameEntry) > -1)
		{
			`verb("Matched" @ EncounterName @ "with" @ NameEntry);
			`msg("Encounter" @ EncounterName @ "excluded, skipping...");
			return;
		}
	}

	// do not touch the chosen
	if(class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager().FindCharacterTemplate(Encounter.SelectedCharacterTemplateNames[0]).bIsChosen)
	{
		`msg(EncounterName @ "leader is a chosen, skipping...");
		return;
	}

	// check the lost
	if(Encounter.Team == eTeam_TheLost && !default.bAffectTheLost)
	{
		`msg(EncounterName @ "is the Lost and bAffectTheLost is false, skipping...");
		return;
	}

	// check if single unit
	if(!default.bAffectSingleUnits && Encounter.SelectedCharacterTemplateNames.Length == 1)
	{
		`msg(EncounterName @ "has only one unit and bAffectSingleUnits is false, skipping...");
		return;
	}

	// choose the active rules depending on team / reinforcement
	switch(Encounter.Team) 
	{
		case eTeam_Alien:
				
			if(isReinforcement)
			{
				ActiveRules = default.ReinforcementRules;
				`verb("Selected ReinforcementRules length:" @ default.ReinforcementRules.length);
			}
			else
			{
				ActiveRules = default.AlienPodSizeRules;
				`verb("Selected AlienPodSizeRules length:" @ default.AlienPodSizeRules.length);
			}
			break;
		
		case eTeam_TheLost:
			ActiveRules = default.TheLostRules;
			`verb("Selected TheLostRules length:" @ default.TheLostRules.length);
			break;
		
		default:
			`msg("Encounter" @ EncounterName @ "is not in eTeam_Alien or eTeam_TheLost, skipping...");
			return;
	}

	// now were ready to start modifying the pod!
	// no return after this point, unless the pod is complete
	
	`msg("Original pod:");
	LogPod(Encounter);

	// handle mission / sitrep modifier -> unit cap / fl offsets
	HandleModifiers(UnitCap, FLOffset, UnitCountOffset, Mission, EncounterName);

	ForceLevel = ValidateFL(ForceLevel);

	// check for variances
	if(ForceLevel < default.ForceLevelVariance.iMinForceLevel)
	{
		`msg("Current force level under iMinVarianceForceLeve, setting to 0...");
		default.ForceLevelVariance.iPositive = 0;
		default.ForceLevelVariance.iNegative = 0;
	}

	if(ShouldRerollFollowers(Encounter, EncounterName))
	{
		NumToRoll = Encounter.SelectedCharacterTemplateNames.Length - 1;
		Encounter.SelectedCharacterTemplateNames.Length = 1;
		`msg("Removing original" @ NumToRoll @ "followers");
	}

	// create the followerlist for rolling our encounter
	RollingList = CreateRollingList(EncounterName, Mission);
	
	// array for tracking what characters are already in pod
	CharInGroup.length = RollingList.Length;

	// count the initial units for our tracking array
	foreach Encounter.SelectedCharacterTemplateNames(NameEntry)
	{
		index = RollingList.find('Template', NameEntry);
		if(index != INDEX_NONE)
		{
			CharInGroup[index]++;
		}
	}

	// add in the modifier offset
	if(UnitCountOffset != 0)
	{
		`msg("Adjusting pod size from modifiers by" @ UnitCountOffset);
		NumToRoll += UnitCountOffset;
	}

	`msg("Now starting to roll" @ NumToRoll @ "enemies to fill original pod");

	// first add whats missing, if any
	if(NumToRoll > 0)
	{
		`msg("Rolling" @ NumToRoll @ "followers to match the original pod size");
		RollFollowers(Encounter, NumToRoll, RollingList, CharInGroup, ForceLevel + FLOffset);
	}

	// check for unit cap
	if(UnitCapReached(Encounter, UnitCap))
	{
		// we are done
		PodDone(Encounter, EncounterName);
		return;
	}

	// loop over rules
	for(index = 0; index < ActiveRules.length; index++) 
	{
		CurrentRule = ActiveRules[index];

		if(ForceLevel < CurrentRule.iMinForceLevel || ForceLevel > CurrentRule.iMaxForceLevel)
		{
			`msg("Rule" @ index @ "not valid for FL" @ ForceLevel);
			continue;
		}

		// rule is valid, roll for success
		Roll = `SYNC_RAND_STATIC(100);
		`msg("Rolled" @ Roll @ "<" @ CurrentRule.iChance @ "to add" @ CurrentRule.iNumToAdd @ "enemies. Success:" @ Roll < CurrentRule.iChance);

		if(Roll < CurrentRule.iChance)
		{
			if(CurrentRule.iForceLevelOffset != 0)
			{
				`msg("Force level offset by rule:" @ CurrentRule.iForceLevelOffset);
			}

			RollFollowers(Encounter, CurrentRule.iNumToAdd, RollingList, CharInGroup, ForceLevel + FLOffset + CurrentRule.iForceLevelOffset);
		}

		// check for unit cap
		if(UnitCapReached(Encounter, UnitCap))
		{
			break;
		}
	}

	// all rules were rolled
	// we are done and dusted
	PodDone(Encounter, EncounterName);
}

static final function int ValidateFL(int PassedFL)
{
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameStateHistory History;
	local XComGameState_MissionSite MissionSite;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_MissionSite', MissionSite)
	{
		switch (MissionSite.GeneratedMission.BattleDesc)
		{
			case "ChallengeMode":
			case "TQL":
			case "Skirmish Mode":
			case "BenchmarkTestManager":
			case "Ladder Mode":
				`msg("Special BattleDesc '" $ MissionSite.GeneratedMission.BattleDesc $ "' found, using passed in FL");
				return PassedFL;
			default:
				break;
		}
	}

	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	
	// In case where the passed in FL is different than the current FL, it already has sitrep etc changes included.
	// Instead use the HQ number without sitrep changes so we dont apply adjustments multiple times 
	if (PassedFL != AlienHQ.GetForceLevel())
	{
		`verb(`showvar(PassedFL) @ `showvar(AlienHQ.GetForceLevel()));
		`msg("Using ALien HQ FL instead of passed in FL");
		return AlienHQ.GetForceLevel();
	}
	return PassedFL;
}

static final function DumpConfigs()
{
	local int i;

	// if logging is enabled dump config values on load, else return
	
	`msg("Dumping config values...");

	// plain values
	`msg("bAffectSingleUnits" @ default.bAffectSingleUnits);
	`msg("bAffectReinforcements" @ default.bAffectReinforcements);
	`msg("bAffectTheLost" @ default.bAffectTheLost);
	`msg("bIgnoreForcedSpawnNames" @ default.bIgnoreForcedSpawnNames);
	`msg("bIgnoreMaxCharactersPerGroup" @ default.bIgnoreMaxCharactersPerGroup);
	`msg("bIgnoreSupportedFollowers" @ default.bIgnoreSupportedFollowers);
	`msg("bMergeSitrepLists" @ default.bMergeSitrepLists);
	
	`msg("fDuplicateUnitFavourFactor" @ default.fDuplicateUnitFavourFactor);	

	`msg("ForceLevelVariance -> iMinForceLevel:" @ default.ForceLevelVariance.iMinForceLevel @ "iPositive:" @ default.ForceLevelVariance.iPositive @ "iNegative:" @ default.ForceLevelVariance.iNegative);

	// each of the arrays
	for(i = 0; i < default.MissionModifiers.length; i++)
	{
		`msg("MissionModifiers[" $ i $ "] -> TargetName:" @ default.MissionModifiers[i].TargetName @ 
				"bExclusion:" @ default.MissionModifiers[i].bExclusion @
				"iMaxEnemiesInPod:" @ default.MissionModifiers[i].iMaxEnemiesInPod @
				"iForceLevelOffset:" @ default.MissionModifiers[i].iForceLevelOffset @
				"iEnemyCountOffset:" @ default.MissionModifiers[i].iEnemyCountOffset);

				
	}

	for(i = 0; i < default.SitRepModifiers.length; i++)
	{
		`msg("SitRepModifiers[" $ i $ "] -> TargetName:" @ default.SitRepModifiers[i].TargetName @ 
				"bExclusion:" @ default.SitRepModifiers[i].bExclusion @
				"iMaxEnemiesInPod:" @ default.SitRepModifiers[i].iMaxEnemiesInPod @
				"iForceLevelOffset:" @ default.SitRepModifiers[i].iForceLevelOffset @
				"iEnemyCountOffset:" @ default.SitRepModifiers[i].iEnemyCountOffset);
	}
	
	for(i = 0; i < default.AlienPodSizeRules.length; i++)
	{
		`msg("AlienPodSizeRules[" $ i $ "] -> iMinForceLevel:" @ default.AlienPodSizeRules[i].iMinForceLevel @ 
				"iMaxForceLevel:" @ default.AlienPodSizeRules[i].iMaxForceLevel @
				"iChance:" @ default.AlienPodSizeRules[i].iChance @
				"iNumToAdd:" @ default.AlienPodSizeRules[i].iNumToAdd @
				"iForceLevelOffset:" @ default.AlienPodSizeRules[i].iForceLevelOffset);
	}

	for(i = 0; i < default.ReinforcementRules.length; i++)
	{
		`msg("ReinforcementRules[" $ i $ "] -> iMinForceLevel:" @ default.ReinforcementRules[i].iMinForceLevel @ 
				"iMaxForceLevel:" @ default.ReinforcementRules[i].iMaxForceLevel @
				"iChance:" @ default.ReinforcementRules[i].iChance @
				"iNumToAdd:" @ default.ReinforcementRules[i].iNumToAdd @
				"iForceLevelOffset:" @ default.ReinforcementRules[i].iForceLevelOffset);
	}
	
	for(i = 0; i < default.TheLostRules.length; i++)
	{
		`msg("TheLostRules[" $ i $ "] -> iMinForceLevel:" @ default.TheLostRules[i].iMinForceLevel @ 
				"iMaxForceLevel:" @ default.TheLostRules[i].iMaxForceLevel @
				"iChance:" @ default.TheLostRules[i].iChance @
				"iNumToAdd:" @ default.TheLostRules[i].iNumToAdd @
				"iForceLevelOffset:" @ default.TheLostRules[i].iForceLevelOffset);
	}

	for(i = 0; i < default.ExcludedEncounters.length; i++)
	{
		`msg("ExcludedEncounters[" $ i $ "] :" @ default.ExcludedEncounters[i]);
	}

	for(i = 0; i < default.ExcludedFollowers.length; i++)
	{
		`msg("ExcludedFollowers[" $ i $ "] :" @ default.ExcludedFollowers[i]);
	}
}

static final function string names_to_str(array<name> arr)
{
	local string result;
	local name entry;

	foreach arr(entry) result @= entry;

	return result == "" ? "None" : result;
}

// ****************************
// ---- CreateRollingList -----
// ****************************

static final function array<SpawnDistributionListEntry> CreateRollingList(name EncounterName, XComGameState_MissionSite Mission)
{
	local name ScheduleListName, EncounterListName;
	local array<name> SitRepListNames;
	local int selected; // should be an enum but cant be bothered as this is not used anywhere else
	local array<SpawnDistributionListEntry> result;

	// priority order for follower lists 1. Encounter, 2. SitRep, 3. Schedule

	EncounterListName = GetEncounterListName(EncounterName);
	`verb("Follower list from encounter:" @ EncounterListName);

	ScheduleListName = GetScheduleListName(Mission);
	`verb("Follower list from schedule:" @ ScheduleListName);

	// there may be multiple due to mods, we either merge or use the last one
	SitRepListNames = GetSitRepListNames(Mission);
	`verb("Follower list(s) from SitRep(s):" @ names_to_str(SitRepListNames));

	// schedule is always present
	`msg("Selected default schedule follower list:" @ ScheduleListName);
	selected = 0;
	
	// check for sitrep list
	if(SitRepListNames.length > 0)
	{
		selected = 1;
	}

	// check for encounter overridden list
	if(EncounterListName != '')
	{
		selected = 2;
	}

	// create list depending on selected
	switch(selected)
	{
		case 0: // no overrides, use schedule list
			result = DuplicateList(ScheduleListName);
			break;
		case 1: // using sitrep list, may be multiple
			if(default.bMergeSitrepLists)
			{
				`msg("Merging default schedule list with" @ SitRepListNames.length @ "SitRep list(s):" @ names_to_str(SitRepListNames));
		
				// merge sitrep lists to the default
				// sitrep entries overwrite base entries -> no duplicates
				result = MergeLists(ScheduleListName, SitRepListNames);
			}
			else
			{
				// if not merging get last in array = final negative override
				`msg("Selected SitRep overridden follower list:" @ SitRepListNames[SitRepListNames.length - 1]);
				result = DuplicateList(SitRepListNames[SitRepListNames.length - 1]);
			}
			break;
		case 2: // encounter specific list			
			`msg("Encounter specific follower list override:" @ EncounterListName);
			result = DuplicateList(EncounterListName);
			break;
		default:
			`msg("Invalid list selected");
			break;
	}
	
	if(default.bVerbose)
	{
		`msg("Complete follower list for encounter:");
		DumpList(result);
	}

	return result;
}

static final function name GetEncounterListName(name EncounterName)
{
	local int index;
	local XComTacticalMissionManager MissionManager;
	MissionManager = `TACTICALMISSIONMGR;

	index = MissionManager.ConfigurableEncounters.Find('EncounterID', EncounterName);

	if(MissionManager.ConfigurableEncounters[index].EncounterFollowerSpawnList != '') 
	{
		return MissionManager.ConfigurableEncounters[index].EncounterFollowerSpawnList;
	}

	return '';
}

static final function name GetScheduleListName(XComGameState_MissionSite Mission)
{
	local int index;
	local XComTacticalMissionManager MissionManager;
	MissionManager = `TACTICALMISSIONMGR;

	index = MissionManager.MissionSchedules.Find('ScheduleID', Mission.SelectedMissionData.SelectedMissionScheduleName);

	// every schedule has to have a default list so no need to check if exists
	return MissionManager.MissionSchedules[index].DefaultEncounterFollowerSpawnList;
}

static final function array<name> GetSitRepListNames(XComGameState_MissionSite Mission)
{
	local X2SitRepTemplateManager SitRepMgr;
	local X2SitRepTemplate SitRepTemplate;
	local array<name> PositiveListOverrides, NegativeListOverrides;
	local name entry;

	//PositiveListOverrides.length = 0;
	//NegativeListOverrides.length = 0;

	// no sitreps, return empty array
	if (Mission.GeneratedMission.SitReps.Length == 0)
	{
		return PositiveListOverrides;
	}

	SitRepMgr = class'X2SitRepTemplateManager'.static.GetSitRepTemplateManager();

	// parse sitrep list effects
	foreach Mission.GeneratedMission.SitReps(entry)
	{
		SitRepTemplate = SitRepMgr.FindSitRepTemplate(entry);
		ParseListOverrideEffects(PositiveListOverrides, SitRepTemplate.PositiveEffects);
		ParseListOverrideEffects(NegativeListOverrides, SitRepTemplate.NegativeEffects);
	}

	if(PositiveListOverrides.length > 0)
	{
		`verb("Positive SitRep list override(s):" @ names_to_str(PositiveListOverrides));
	}

	if(NegativeListOverrides.length > 0)
	{
		`verb("Negative SitRep list override(s):" @ names_to_str(NegativeListOverrides));
	}

	// append negatives to the end of positives to return all at once
	// we can read the last of array for the final negative override
	foreach NegativeListOverrides(entry)
	{
		PositiveListOverrides.addItem(entry);
	}

	return PositiveListOverrides;
}

static final function ParseListOverrideEffects(out array<name> result,  array<name> EffectNames)
{
	local X2SitRepEffectTemplateManager SitRepEffectMgr;
	local name Effect;
	local X2SitRepEffect_ModifyDefaultEncounterLists EncounterListEffect;
	
	SitRepEffectMgr = class'X2SitRepEffectTemplateManager'.static.GetSitRepEffectTemplateManager();

	foreach EffectNames(Effect)
	{
		EncounterListEffect = X2SitRepEffect_ModifyDefaultEncounterLists(SitRepEffectMgr.FindSitRepEffectTemplate(Effect));
		if(EncounterListEffect != none)
		{
			// separate ifs to avoid accessed none
			if(EncounterListEffect.DefaultFollowerListOverride != '')
			{
				result.additem(EncounterListEffect.DefaultFollowerListOverride);
			}
		}
	}
}

static final function array<SpawnDistributionListEntry> DuplicateList(name ListName)
{
	local array<SpawnDistributionListEntry> result;
	local SpawnDistributionListEntry entry;
	local int index;

	local XComTacticalMissionManager MissionManager;
	MissionManager = `TACTICALMISSIONMGR;
		
	index = MissionManager.SpawnDistributionLists.find('ListID', ListName);
	foreach MissionManager.SpawnDistributionLists[index].SpawnDistribution(entry)
	{
		// check if the entry is valid
		if(entry.Template == '')
		{
			// skip if invalid
			continue;
		}

		result.addItem(entry);
	}
	
	`verb("Duplicated" @ ListName);
	return result;
}

static final function array<SpawnDistributionListEntry> MergeLists(name BaseList, array<name> AdditionalLists)
{
	local array<SpawnDistributionListEntry> result;
	local array<SpawnDistributionListEntry> toMerge;
	local SpawnDistributionListEntry entry;
	local name list;
	local int index;

	result = DuplicateList(BaseList);

	foreach AdditionalLists(list)
	{
		toMerge = DuplicateList(list);

		foreach toMerge(entry)
		{
			`verb("Merging" @ entry.Template);

			// check if unit already present
			index = result.find('Template', entry.Template);

			// remove duplicate(s)
			while(index != INDEX_NONE)
			{
				result.remove(index, 1);
				index = result.find('Template', entry.Template);
			}

			// no more duplicates, add new entry
			result.addItem(entry);
		}
	}

	`verb("Merged" @ BaseList @ "with" @ names_to_str(AdditionalLists));
	return result;
}

static final function DumpList(array<SpawnDistributionListEntry> List)
{
	local SpawnDistributionListEntry entry;

	foreach List(entry)
	{
		`msg(entry.Template @ entry.MinForceLevel @ entry.MaxForceLevel @ entry.SpawnWeight @ entry.MaxCharactersPerGroup);
	}
}

// ***************************
// ---- GetRollingLimits -----
// ***************************

static final function HandleModifiers(out int UnitCap, out int FLOffset, out int UnitCountOffset, XComGameState_MissionSite Mission, name EncounterName)
{
	local int MissionFL, MissionCap, MissionUnitOffset;
	local array<int> SitRepFLs, SitRepCaps, SitRepUnitOffsets;
	local int SitRepFL, SitRepCap, SitRepUnitOffset;
	local int EncounterFL;
	local int index;
	local int number;

	index = default.MissionModifiers.Find('TargetName', Mission.GeneratedMission.Mission.MissionName); 
	if(index != INDEX_NONE)
	{
		MissionFL = default.MissionModifiers[index].iForceLevelOffset;
		MissionCap = default.MissionModifiers[index].iMaxEnemiesInPod;
		MissionUnitOffset = default.MissionModifiers[index].iEnemyCountOffset;
		`verb("Found a modifier for:" @ Mission.GeneratedMission.Mission.MissionName @ "iMaxEnemiesInPod:" @ MissionCap @ "iForceLevelOffset:" @ MissionFL  @ "iEnemyCountOffset:" @ MissionUnitOffset);
	}

	ParseSitRepModifiers(SitRepFLs, SitRepCaps, SitRepUnitOffsets, Mission);

	if(SitRepCaps.length > 0)
	{
		`verb("Found" @ SitRepCaps.length @ "enemy caps");

		// find the smallest
		SitRepCap = SitRepCaps[0];
		foreach SitRepCaps(number)
		{
			SitRepCap = number < SitRepCap ? number : SitRepCap;
		}
		
		`verb("Smallest SitRep enemy cap:" @ SitRepCap);
	}

	if(SitRepFLs.length > 0)
	{
		`verb("Found" @ SitRepFLs.length @ "SitRep FL offsets");
		
		foreach SitRepFLs(number)
		{
			SitRepFL += number;
		}

		`verb("Combined SitRep FL offset:" @ SitRepFL);
	}

	if(SitRepUnitOffsets.length > 0)
	{
		`verb("Found" @ SitRepUnitOffsets.length @ "SitRep enemy count offsets");
		
		foreach SitRepUnitOffsets(number)
		{
			SitRepUnitOffset += number;
		}

		`verb("Combined SitRep enemy count offset:" @ SitRepUnitOffset);
	}

	EncounterFL = GetEncounterFL(EncounterName);

	// if cap < 1, set uncapped
	SitRepCap = SitRepCap < 1 ? 99 : SitRepCap;
	MissionCap = MissionCap < 1 ? 99 : MissionCap;

	// select the smaller cap
	UnitCap = SitRepCap < MissionCap ? SitRepCap : MissionCap;

	FLOffset = SitRepFL + MissionFL + EncounterFL;

	UnitCountOffset = MissionUnitOffset + SitRepUnitOffset;

	`verb("SitRepFL:" @ SitRepFL @ "MissionFL:" @ MissionFL @ "EncounterFL:" @ EncounterFL);
	`verb("MissionUnitOffset:" @  MissionUnitOffset @ "SitRepUnitOffset:" @ SitRepUnitOffset);

	`msg("Combined rolling limits: UnitCap:" @ UnitCap @ "FLOffset:" @ FLOffset @ "UnitCountOffset:" @ UnitCountOffset);
}

static final function ParseSitRepModifiers(out array<int> SitRepFLs, out array<int> SitRepCaps, out array<int> SitRepUnitOffsets, XComGameState_MissionSite Mission)
{
	local X2SitRepTemplateManager SitRepMgr;
	local X2SitRepTemplate SitRepTemplate;
	local name SitRepName;

	local int index;

	if (Mission.GeneratedMission.SitReps.Length == 0)
	{
		`verb("No SitReps present");
		return;
	}

	SitRepMgr = class'X2SitRepTemplateManager'.static.GetSitRepTemplateManager();
		
	foreach Mission.GeneratedMission.SitReps(SitRepName)
	{
		// check for modifiers
		index = default.SitRepModifiers.Find('TargetName', SitRepName); 
		if(index != INDEX_NONE)
		{
			`msg("Found a modifier for" @ SitRepName @ "iMaxEnemiesInPod:" @ default.SitRepModifiers[index].iMaxEnemiesInPod @ "iForceLevelOffset:" @ default.SitRepModifiers[index].iForceLevelOffset  @ "iEnemyCountOffset:" @ default.SitRepModifiers[index].iEnemyCountOffset);

			if(default.SitRepModifiers[index].iMaxEnemiesInPod != 0)
			{
				SitRepCaps.addItem(default.SitRepModifiers[index].iMaxEnemiesInPod);
			}

			if(default.SitRepModifiers[index].iForceLevelOffset != 0)
			{
				SitRepFLs.addItem(default.SitRepModifiers[index].iForceLevelOffset);
			}

			if(default.SitRepModifiers[index].iEnemyCountOffset != 0)
			{
				SitRepUnitOffsets.addItem(default.SitRepModifiers[index].iEnemyCountOffset);
			}
		}

		// check the actual sitrep effects
		SitRepTemplate = SitRepMgr.FindSitRepTemplate(SitRepName);
		ParseFLEffects(SitRepFLs, SitRepTemplate.PositiveEffects);
		ParseFLEffects(SitRepFLs, SitRepTemplate.NegativeEffects);
		ParsePodSizeDelta(SitRepUnitOffsets, SitRepTemplate.PositiveEffects);
		ParsePodSizeDelta(SitRepUnitOffsets, SitRepTemplate.NegativeEffects);
	}
}

static final function ParseFLEffects(out array<int> arr, array<name> EffectNames)
{
	local X2SitRepEffectTemplateManager SitRepEffectMgr;
	local name Effect;
	local X2SitRepEffect_ModifyForceLevel ForceLevelEffect;
	
	SitRepEffectMgr = class'X2SitRepEffectTemplateManager'.static.GetSitRepEffectTemplateManager();

	foreach EffectNames(Effect)
	{
		ForceLevelEffect = X2SitRepEffect_ModifyForceLevel(SitRepEffectMgr.FindSitRepEffectTemplate(Effect));
		if (ForceLevelEffect != none)
		{
			// Separate these ifs so that you can avoid Accessed 'None' warnings
			if (ForceLevelEffect.ForceLevelModification != 0)
			{
				`msg("Found SitRep effect" @ ForceLevelEffect.DataName @ "with ForceLevelModification:" @ ForceLevelEffect.ForceLevelModification);
				arr.addItem(ForceLevelEffect.ForceLevelModification);
			}
		}
	}
}

static final function ParsePodSizeDelta(out array<int> arr, array<name> EffectNames)
{
	local X2SitRepEffectTemplateManager SitRepEffectMgr;
	local name Effect;
	local X2SitRepEffect_ModifyPodSize PodSizeEffect;
	
	SitRepEffectMgr = class'X2SitRepEffectTemplateManager'.static.GetSitRepEffectTemplateManager();

	foreach EffectNames(Effect)
	{
		PodSizeEffect = X2SitRepEffect_ModifyPodSize(SitRepEffectMgr.FindSitRepEffectTemplate(Effect));
		if (PodSizeEffect != none)
		{
			// Separate these ifs so that you can avoid Accessed 'None' warnings
			if (PodSizeEffect.PodSizeDelta != 0)
			{
				`msg("Found SitRep effect" @ PodSizeEffect.DataName @ "with PodSizeDelta:" @ PodSizeEffect.PodSizeDelta);
				arr.addItem(PodSizeEffect.PodSizeDelta);
			}
		}
	}
}

static final function int GetEncounterFL(name EncounterName)
{
	local int index;
	local XComTacticalMissionManager MissionManager;
	MissionManager = `TACTICALMISSIONMGR;

	index = MissionManager.ConfigurableEncounters.find('EncounterID', EncounterName);
	return MissionManager.ConfigurableEncounters[index].OffsetForceLevel;
}

static final function bool ShouldRerollFollowers(PodSpawnInfo Encounter, name EncounterName)
{
	local name entry;
	local int index;
	local XComTacticalMissionManager MissionManager;
	MissionManager = `TACTICALMISSIONMGR;

	// check for excluded followers
	foreach default.ExcludedFollowers(entry)
	{
		if (Encounter.SelectedCharacterTemplateNames.find(entry) != INDEX_NONE)
		{
			`msg("Pod contains" @ entry @ "keeping original followers");
			return false;
		}
	}

	// configured to always reroll
	if(default.bIgnoreForcedSpawnNames)
	{
		return true;
	}

	// check if encounter has forced followers
	index = MissionManager.ConfigurableEncounters.find('EncounterID', EncounterName);
	if(MissionManager.ConfigurableEncounters[index].ForceSpawnTemplateNames.Length != 0)
	{
		return false;
	}

	// we can reroll
	return true;
}

static final function LogPod(PodSpawnInfo Encounter)
{
	local int index;

	`msg("Leader -" @ Encounter.SelectedCharacterTemplateNames[0]);

	for(index = 1; index < Encounter.SelectedCharacterTemplateNames.length; index++)
	{
		`msg("Follower" @ index @ "-" @ Encounter.SelectedCharacterTemplateNames[index]);
	}
}

static final function bool UnitCapReached(out PodSpawnInfo Encounter, int cap)
{
	// cap not reached
	if(Encounter.SelectedCharacterTemplateNames.length < cap)
	{
		return false;
	}

	// we went over cap
	if(Encounter.SelectedCharacterTemplateNames.length > cap)
	{
		`msg("Removing extra followers (cap: " $ cap $ ")");
		Encounter.SelectedCharacterTemplateNames.length = cap;
	}

	return true;
}

static final function PodDone(PodSpawnInfo Encounter, name EncounterName)
{
	`msg("Finished" @ EncounterName @ "with" @ Encounter.SelectedCharacterTemplateNames.length @ "enemies");
	LogPod(Encounter);
}

// *************************
// ----- RollFollowers -----
// *************************

static final function RollFollowers(
	out PodSpawnInfo Encounter,
	int NumToAdd, 
	out array<SpawnDistributionListEntry> RollingList, 
	out array<int> CharInGroup, 
	int ForceLevel)
{
	local array<int> ValidFollowers;
	local float TotalWeight;
	local int index, SelectedFollower;
	local float Roll, Sum;
	
	// this clamp fits the offsetted force level valid force level range so we dont try looking for followers below 0 / above max
	ForceLevel = Clamp(ForceLevel, 1, GetMaxForceLevel());

	// valid followers holds indexes to the rolling list / char in group
	ValidFollowers = GetValidFollowers(Encounter.SelectedCharacterTemplateNames[0], RollingList, CharInGroup, ForceLevel);

	`msg("Found" @ ValidFollowers.length @ "valid followers for" @ Encounter.SelectedCharacterTemplateNames[0] @ "at FL" @ ForceLevel);
	
	for(index = 0; index < ValidFollowers.length; index++)
	{
		`msg(RollingList[ValidFollowers[index]].Template @ "with weight:" @ RollingList[ValidFollowers[index]].SpawnWeight);
		TotalWeight += RollingList[ValidFollowers[index]].SpawnWeight;
	}

	// now roll and add the required amount
	// index = 0 has no effect, but is required for the compiler to let the loop through
	// apparently can't leave first param empty e.g. for(; a < b; a++)
	for(index = 0; NumToAdd > 0; NumToAdd--)
	{
		if(ValidFollowers.length == 0)
		{
			`msg("No more valid followers to add!");
			break;
		}
		
		Sum = 0;
		Roll = `SYNC_FRAND_STATIC() * TotalWeight;

		for(index = 0; index < ValidFollowers.Length; index++)
		{
			Sum += RollingList[ValidFollowers[index]].SpawnWeight;
			
			// we have found the selected unit
			if(Roll < Sum)
			{
				SelectedFollower = ValidFollowers[index];
				break;
			}
		}

		// add the unit and increment number in tracking array
		Encounter.SelectedCharacterTemplateNames.addItem(RollingList[SelectedFollower].Template);
		CharInGroup[SelectedFollower] += 1;
				
		`msg("Rolled" @ RollingList[SelectedFollower].Template @ "now" @ CharInGroup[SelectedFollower] @ "/" @ RollingList[SelectedFollower].MaxCharactersPerGroup @ "in pod");

		// remove unit from further rolls, unless ignored
		if(CharInGroup[SelectedFollower] == RollingList[SelectedFollower].MaxCharactersPerGroup && default.bIgnoreMaxCharactersPerGroup == false)
		{
			`msg("Removed" @ RollingList[SelectedFollower].Template @ "from valid followers");
			TotalWeight -= RollingList[SelectedFollower].SpawnWeight; 
			ValidFollowers.remove(index, 1);
		}
		else if(default.fDuplicateUnitFavourFactor > 0) // if not removed check for weight adjustment
		{
			// remove old spawn weight
			TotalWeight -= RollingList[SelectedFollower].SpawnWeight;

			`msg("Adjusted SpawnWeight for" @ RollingList[SelectedFollower].Template @ "from" @ RollingList[SelectedFollower].SpawnWeight @ "to" @ RollingList[SelectedFollower].SpawnWeight * default.fDuplicateUnitFavourFactor);

			RollingList[SelectedFollower].SpawnWeight = RollingList[SelectedFollower].SpawnWeight * default.fDuplicateUnitFavourFactor;
			
			// add in adjusted weight
			TotalWeight += RollingList[SelectedFollower].SpawnWeight;
		}
	}
}

static final function array<int> GetValidFollowers(name Leader, array<SpawnDistributionListEntry> FollowerList, array<int> CharInGroup, int ForceLevel)
{
	local array<int> FilteredFollowers;
	local SpawnDistributionListEntry entry;
	local X2CharacterTemplateManager CharMgr;
	local X2CharacterTemplate LeaderTemplate, FollowerTemplate;
	local int FollowerIndex;
	local XComGameState_HeadquartersXCom HQ;

	HQ = `XCOMHQ;
	CharMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	LeaderTemplate = CharMgr.FindCharacterTemplate(Leader);

	foreach FollowerList(entry, FollowerIndex)
	{
		FollowerTemplate = CharMgr.FindCharacterTemplate(entry.Template);

		// check strategy requirements
		if(HQ.MeetsAllStrategyRequirements(FollowerTemplate.SpawnRequirements) == false)
		{
			`verb(entry.Template @ "SpawnRequirements not met");
			continue;
		}
		
		// check if max amount already present
		if( CharInGroup[FollowerIndex] >= entry.MaxCharactersPerGroup && default.bIgnoreMaxCharactersPerGroup == false)
		{
			`verb("Maximum number of" @ entry.Template @ "already" @ CharInGroup[FollowerIndex] @ "/" @ entry.MaxCharactersPerGroup);
			continue;
		}

		// check FL
		if(ForceLevel < (entry.MinForceLevel - default.ForceLevelVariance.iPositive) // subtract from min causes more powerful earlier
		|| ForceLevel > (entry.MaxForceLevel + default.ForceLevelVariance.iNegative)) // adding to max keeps weaker in pool for longer
		{
			`verb(entry.Template @ "not valid for FL" @ ForceLevel @ "(" $ entry.MinForceLevel - default.ForceLevelVariance.iPositive $ " - " $ entry.MaxForceLevel + default.ForceLevelVariance.iNegative $ ")");
			continue;
		}

		// if ignored, always add
		if(default.bIgnoreSupportedFollowers)
		{
			`verb("Ignoring SupportedFollowers, adding" @ entry.Template);
			FilteredFollowers.addItem(FollowerIndex);
			continue;
		}

		// finally, add if supported
		if(LeaderTemplate.SupportedFollowers.find(entry.Template) != INDEX_NONE)
		{
			`verb("Found" @ entry.Template @ "as supported follower");
			FilteredFollowers.addItem(FollowerIndex);
		}
		else
		{
			`verb(entry.Template @ "not supported as follower");
		}
	}

	return FilteredFollowers;
}

static final function int GetMaxForceLevel()
{
	local XComGameState_HeadquartersAlien AlienHQ;

	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));

	`verb("Max FL from AlienHQ:" @ AlienHQ.AlienHeadquarters_MaxForceLevel);
	return AlienHQ.AlienHeadquarters_MaxForceLevel;
}
