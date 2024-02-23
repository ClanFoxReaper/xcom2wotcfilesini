class CSA_Abilities extends X2Ability
	config(CSA);

struct native CustomAbilities
{
	var Name TemplateName;

	// Stats Modifiers
	var int ModHP;
	var int ModOffense;
	var int ModDefense;
	var int ModMobility;
	var int ModWill;
	var int ModHacking;
	var int ModDodge;
	var int ModShieldHP;
	var int ModArmorMitigation;
	var int ModPsiOffense;
	// Untested
	var int ModDetectionRadius;
	var int ModHackDefense;
	var int ModCritChance;
	var int ModStrength;
	var int ModUtilityItems;
	var int ModBackpackSize;
	var int ModFlankingAimBonus;
	var int ModFlankingCritChance;
};

var config array<CustomAbilities> Abilities;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	local CustomAbilities AbilityConfig;
	
	foreach default.Abilities(AbilityConfig)
	{
		Templates.AddItem(CreateCustomAbilityStats(AbilityConfig));
	}

	return Templates;
}


static function X2AbilityTemplate CreateCustomAbilityStats(CustomAbilities AbilityInfos)
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, AbilityInfos.TemplateName);
	// Template.IconImage  -- no icon

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);

	if(AbilityInfos.ModHP != 0)
	{
		PersistentStatChangeEffect.AddPersistentStatChange(eStat_HP, AbilityInfos.ModHP);
	}
	if(AbilityInfos.ModOffense != 0)
	{
		PersistentStatChangeEffect.AddPersistentStatChange(eStat_Offense, AbilityInfos.ModOffense);
	}
	if(AbilityInfos.ModDefense != 0)
	{
		PersistentStatChangeEffect.AddPersistentStatChange(eStat_Defense, AbilityInfos.ModDefense);
	}
	if(AbilityInfos.ModMobility != 0)
	{
		PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, AbilityInfos.ModMobility);
	}
	if(AbilityInfos.ModWill != 0)
	{
		PersistentStatChangeEffect.AddPersistentStatChange(eStat_Will, AbilityInfos.ModWill);
	}
	if(AbilityInfos.ModHacking != 0)
	{
		PersistentStatChangeEffect.AddPersistentStatChange(eStat_Hacking, AbilityInfos.ModHacking);
	}
	if(AbilityInfos.ModDodge != 0)
	{
		PersistentStatChangeEffect.AddPersistentStatChange(eStat_Dodge, AbilityInfos.ModDodge);
	}
	if(AbilityInfos.ModShieldHP != 0)
	{
		PersistentStatChangeEffect.AddPersistentStatChange(eStat_ShieldHP, AbilityInfos.ModShieldHP);
	}
	if(AbilityInfos.ModArmorMitigation != 0)
	{
		PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, AbilityInfos.ModArmorMitigation);
	}
	if(AbilityInfos.ModPsiOffense != 0)
	{
		PersistentStatChangeEffect.AddPersistentStatChange(eStat_PsiOffense, AbilityInfos.ModPsiOffense);
	}
	if(AbilityInfos.ModDetectionRadius != 0)
	{
		PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionRadius, AbilityInfos.ModDetectionRadius);
	}
	if(AbilityInfos.ModHackDefense != 0)
	{
		PersistentStatChangeEffect.AddPersistentStatChange(eStat_HackDefense, AbilityInfos.ModHackDefense);
	}
	if(AbilityInfos.ModCritChance != 0)
	{
		PersistentStatChangeEffect.AddPersistentStatChange(eStat_CritChance, AbilityInfos.ModCritChance);
	}
	if(AbilityInfos.ModStrength != 0)
	{
		PersistentStatChangeEffect.AddPersistentStatChange(eStat_Strength, AbilityInfos.ModStrength);
	}
	if(AbilityInfos.ModUtilityItems != 0)
	{
		PersistentStatChangeEffect.AddPersistentStatChange(eStat_UtilityItems, AbilityInfos.ModUtilityItems);
	}
	if(AbilityInfos.ModBackpackSize != 0)
	{
		PersistentStatChangeEffect.AddPersistentStatChange(eStat_BackpackSize, AbilityInfos.ModBackpackSize);
	}
	if(AbilityInfos.ModFlankingAimBonus != 0)
	{
		PersistentStatChangeEffect.AddPersistentStatChange(eStat_FlankingAimBonus, AbilityInfos.ModFlankingAimBonus);
	}
	if(AbilityInfos.ModFlankingAimBonus != 0)
	{
		PersistentStatChangeEffect.AddPersistentStatChange(eStat_FlankingCritChance, AbilityInfos.ModFlankingCritChance);
	}

	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}