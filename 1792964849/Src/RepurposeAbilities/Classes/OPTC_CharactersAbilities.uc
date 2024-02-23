class OPTC_CharactersAbilities extends X2DownloadableContentInfo config(RepurposeAbilities);

`define REP_Log(msg) `Log(`msg,, 'Repurpose Abilities')

struct native TemplateAbilitiesNames
{
	var Name TemplateName;
	var Name CharacterGroup;
	var bool RemoveOriginal;
	var array<Name> AddAbilityName;
	var array<Name> RemoveAbilityName;
};

var config array<TemplateAbilitiesNames> Abilities;

static event OnPostTemplatesCreated()
{
	`REP_Log("Repurpose Abilities loaded");

	PatchCharacterTemplates();
	PatchItemTemplates();
}

static function PatchCharacterTemplates()
{
	local X2CharacterTemplateManager CharacterMgr;
	local X2CharacterTemplate CharacterTemplate;
	local array<X2DataTemplate> TemplateAllDifficulties;
	local int ScanTemplates, ScanGroup, ScanCharacter;
	local array<name> AllTemplateNames;
	local name TemplateName;

	CharacterMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	
	CharacterMgr.GetTemplateNames(AllTemplateNames);

	foreach AllTemplateNames(TemplateName)
	{
		CharacterMgr.FindDataTemplateAllDifficulties(TemplateName, TemplateAllDifficulties);

		for ( ScanTemplates = 0; ScanTemplates < TemplateAllDifficulties.Length; ++ScanTemplates )
		{
			CharacterTemplate = X2CharacterTemplate(TemplateAllDifficulties[ScanTemplates]);
			if (CharacterTemplate != none)
			{
				ScanGroup = default.Abilities.Find('CharacterGroup', CharacterTemplate.CharacterGroupName);
				if (ScanGroup != INDEX_NONE && default.Abilities[ScanGroup].CharacterGroup != '')
				{
					// `REP_Log("Modifying CharacterGroup" @ default.Abilities[ScanGroup].CharacterGroup);
					ModifyCharaterTemplate(CharacterTemplate, default.Abilities[ScanGroup]);
				}

				ScanCharacter = default.Abilities.Find('TemplateName', CharacterTemplate.DataName);
				if (ScanCharacter != INDEX_NONE && default.Abilities[ScanCharacter].TemplateName != '')
				{
					// `REP_Log("Modifying CharacterTemplate");
					ModifyCharaterTemplate(CharacterTemplate, default.Abilities[ScanCharacter]);
				}
			}
		}
	}
}

static function PatchItemTemplates()
{
	local X2ItemTemplateManager ItemMgr;
	local array<X2DataTemplate> TemplateAllDifficulties;
	local X2DataTemplate Template;
	local X2EquipmentTemplate EquipmentTemplate;
	local TemplateAbilitiesNames TemplateConfig;
	local Name AbilityName;

	ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	foreach default.Abilities(TemplateConfig)
	{
		ItemMgr.FindDataTemplateAllDifficulties(TemplateConfig.TemplateName, TemplateAllDifficulties);

		foreach TemplateAllDifficulties(Template)
		{
			EquipmentTemplate = X2EquipmentTemplate(Template);

			if (EquipmentTemplate != none)
			{
				if(TemplateConfig.RemoveOriginal)
				{
					EquipmentTemplate.Abilities.length = 0;
					`REP_Log("Removed previous abilities from" @ EquipmentTemplate.DataName);
				}

				foreach TemplateConfig.AddAbilityName(AbilityName)
				{
					EquipmentTemplate.Abilities.AddItem(AbilityName);
					`REP_Log("Added" @ AbilityName @ "to" @ EquipmentTemplate.DataName);
				}

				foreach TemplateConfig.RemoveAbilityName(AbilityName)
				{
					EquipmentTemplate.Abilities.RemoveItem(AbilityName);
					`REP_Log("Removed" @ AbilityName @ "from" @ EquipmentTemplate.DataName);
				}
			}
		}
	}
}

static function ModifyCharaterTemplate(X2CharacterTemplate CharacterTemplate, TemplateAbilitiesNames TemplateConfig)
{
	local Name AbilityName;

	if(TemplateConfig.RemoveOriginal)
	{
		CharacterTemplate.Abilities.length = 0;
		`REP_Log("Removed previous abilities from" @ CharacterTemplate.DataName);
	}

	foreach TemplateConfig.AddAbilityName(AbilityName)
	{
		CharacterTemplate.Abilities.AddItem(AbilityName);
		`REP_Log("Added" @ AbilityName @ "to" @ CharacterTemplate.DataName);
	}

	foreach TemplateConfig.RemoveAbilityName(AbilityName)
	{
		CharacterTemplate.Abilities.RemoveItem(AbilityName);
		`REP_Log("Removed" @ AbilityName @ "from" @ CharacterTemplate.DataName);
	}
}
