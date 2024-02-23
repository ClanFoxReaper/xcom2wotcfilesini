class OPTC_Abilities extends Object config(AbilityEditor);

struct native BonusCharges
{
	var Name BonusAbilityName;
	var int NumBonusCharges;
};

struct native AbilityNames
{
	var Name AbilityName;
	var Name ItemSlot;
	var Name RetainConcealment;
	var int AmmoCost;
	var int Cooldown;
	var int APCost;
	var bool EndsTurn;
	var bool FreeAction;
	var bool ConsumeItem;
	var int Charges;
	var bool KeepChargeOnMiss;
	var array<Name> DoNotConsumeAllActionsWith;
	var array<Name> DoNotConsumeAllActionsUnderEffects;
	var array<Name> SharedAbilityCharges;
	var array<AdditionalCooldownInfo> SharedCooldowns;
	var Name bCrossClassEligible;
	var array<Name> AddAbility;
	var array<BonusCharges> BonusChargeWith;
	var array<Name> OverrideAbilities;
	var array<Name> PrerequisiteAbilities;
	var String FocusAmount;
	var bool ConsumeAllFocus;
	var bool GhostOnlyCost;
};

var config array<AbilityNames> Abilities;

static event EditAbilityTemplates()
{
	local X2AbilityTemplateManager			AbilityTemplateManager;
	local array<X2DataTemplate>				TemplateAllDifficulties;
	local X2DataTemplate					Template;
	local X2AbilityTemplate					AbilityTemplate;

	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCost_Focus				FocusCost;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityCost_Ammo				AmmoCost;

	local AbilityNames 						ConfigAbilities;
	local BonusCharges 						ConfigAbilitiesBonusCharge;
	local AdditionalCooldownInfo			AdditionalCooldownInfo, SharedCooldown;
	local Name 								AbilityNameNoEndTurn;
	local Name 								EffectNameNoEndTurn;
	local Name 								SharedChargeAbilityName;
	local Name 								AddAbilityName;
	local Name 								OverrideAbilityName;
	local Name 								PrerequiredAbilityName;

	local X2AbilityCharges_GremlinHeal		GremlinHealCharges;
	local X2AbilityCharges_ScanningProtocol	ScanningProtocolCharges;

	`LOG("Ability Editor loaded");

	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	foreach default.Abilities(ConfigAbilities)
	{
		AbilityTemplateManager.FindDataTemplateAllDifficulties(ConfigAbilities.AbilityName, TemplateAllDifficulties);

		// Iterate over all variants
		foreach TemplateAllDifficulties(Template)
		{
			AbilityTemplate = X2AbilityTemplate(Template);

			if (AbilityTemplate != none)
			{
				// No cost, allows it to be used anytime, even at end of turn if available
				AbilityTemplate.AbilityCosts.Length = 0;
				AbilityTemplate.AbilityCharges = none;
				AbilityTemplate.AbilityCooldown = none;

				if(ConfigAbilities.AmmoCost != 0)
				{
					// Set the ability ammo cost
					AmmoCost = class'Helper_AbilityEditor'.static.SetAmmoCost(ConfigAbilities.AmmoCost);
					AbilityTemplate.AbilityCosts.AddItem(AmmoCost);
				}

				if(ConfigAbilities.ConsumeItem)
				{
					AbilityTemplate.AbilityCosts.AddItem(new class'X2AbilityCost_ConsumeItem');
				}

				// Set the ability focus cost
				if(Len(ConfigAbilities.FocusAmount) != 0)
				{
					FocusCost = class'Helper_AbilityEditor'.static.SetFocusCost(int(ConfigAbilities.FocusAmount), ConfigAbilities.ConsumeAllFocus, ConfigAbilities.GhostOnlyCost);
					AbilityTemplate.AbilityCosts.AddItem(FocusCost);
				}

				if(ConfigAbilities.Cooldown != 0)
				{
					// Set the ability cooldown
					Cooldown = class'Helper_AbilityEditor'.static.SetCooldown(ConfigAbilities.Cooldown);
					
					foreach ConfigAbilities.SharedCooldowns(AdditionalCooldownInfo)
					{
						SharedCooldown.AbilityName = AdditionalCooldownInfo.AbilityName;
						SharedCooldown.NumTurns = AdditionalCooldownInfo.NumTurns;

						Cooldown.AditionalAbilityCooldowns.AddItem(SharedCooldown);
					}

					AbilityTemplate.AbilityCooldown = Cooldown;
				}

				if(ConfigAbilities.Charges != 0)
				{
					// Use X2AbilityCharges_GremlinHeal instead of X2AbilityCharges
					if( ConfigAbilities.AbilityName == 'GremlinHeal' ||
						ConfigAbilities.AbilityName == 'GremlinStabilize' ||
						ConfigAbilities.AbilityName == 'GremlinHeal_Shen' ||
						ConfigAbilities.AbilityName == 'GremlinStabilize_Shen')
					{
						// Set the ability initial charges
						GremlinHealCharges = class'Helper_AbilityEditor'.static.SetGremlinHealCharges(ConfigAbilities.Charges);
						if(GremlinHealCharges != none)
						{
							// Add bonus charges abilities
							foreach ConfigAbilities.BonusChargeWith(ConfigAbilitiesBonusCharge)
							{
								GremlinHealCharges.AddBonusCharge(ConfigAbilitiesBonusCharge.BonusAbilityName, ConfigAbilitiesBonusCharge.NumBonusCharges);
							}
							AbilityTemplate.AbilityCharges = GremlinHealCharges;
						}
					}

					if(ConfigAbilities.bCrossClassEligible != '')
					{
						if(ConfigAbilities.bCrossClassEligible == 'TRUE')
						{
							AbilityTemplate.bCrossClassEligible = true;
						}
						else if(ConfigAbilities.bCrossClassEligible == 'FALSE')
						{
							AbilityTemplate.bCrossClassEligible = false;
						}
						else
						{
							`LOG("bCrossClassEligible is neither true or false", , 'Ability Editor');
						}
					}

					// Use X2AbilityCharges_ScanningProtocol instead of X2AbilityCharges
					else if(ConfigAbilities.AbilityName == 'ScanningProtocol')
					{
						// Set the ability initial charges
						ScanningProtocolCharges = class'Helper_AbilityEditor'.static.SetScanningProtocolCharges(ConfigAbilities.Charges);
						if(ScanningProtocolCharges != none)
						{
							// Add bonus charges abilities
							foreach ConfigAbilities.BonusChargeWith(ConfigAbilitiesBonusCharge)
							{
								ScanningProtocolCharges.AddBonusCharge(ConfigAbilitiesBonusCharge.BonusAbilityName, ConfigAbilitiesBonusCharge.NumBonusCharges);
							}
							AbilityTemplate.AbilityCharges = ScanningProtocolCharges;
						}
					}
					else
					{
						// Set the ability initial charges
						Charges = class'Helper_AbilityEditor'.static.SetCharges(ConfigAbilities.Charges);
						if(Charges != none)
						{
							// Add bonus charges abilities
							foreach ConfigAbilities.BonusChargeWith(ConfigAbilitiesBonusCharge)
							{
								Charges.AddBonusCharge(ConfigAbilitiesBonusCharge.BonusAbilityName, ConfigAbilitiesBonusCharge.NumBonusCharges);
							}
							AbilityTemplate.AbilityCharges = Charges;
						}
					}

					// Set the ability charges cost
					ChargeCost = class'Helper_AbilityEditor'.static.SetChargeCost(ConfigAbilities.KeepChargeOnMiss);
					
					// Check for shared charges abilities
					foreach ConfigAbilities.SharedAbilityCharges(SharedChargeAbilityName)
					{
						ChargeCost.SharedAbilityCharges.AddItem(SharedChargeAbilityName);
					}

					AbilityTemplate.AbilityCosts.AddItem(ChargeCost);
				}

				// Set the ability action point cost
				ActionPointCost = class'Helper_AbilityEditor'.static.SetActionPointCost(ConfigAbilities.APCost, ConfigAbilities.EndsTurn, ConfigAbilities.FreeAction);
				
				// Check if there are abilities set that would prevent end of turn
				if(ConfigAbilities.EndsTurn)
				{
					foreach ConfigAbilities.DoNotConsumeAllActionsWith(AbilityNameNoEndTurn)
					{
						ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem(AbilityNameNoEndTurn);
					}

					// Hotfix. Since we removed AbilityCosts we also removed DLC OPTC change on Overdrive.
					ActionPointCost.DoNotConsumeAllEffects.AddItem('DLC_3Overdrive');

					foreach ConfigAbilities.DoNotConsumeAllActionsUnderEffects(EffectNameNoEndTurn)
					{
						ActionPointCost.DoNotConsumeAllEffects.AddItem(EffectNameNoEndTurn);
					}
				}
				AbilityTemplate.AbilityCosts.AddItem(ActionPointCost);

				// Will attach additional abilities to the existing one
				foreach ConfigAbilities.AddAbility(AddAbilityName)
				{
					AbilityTemplate.AdditionalAbilities.AddItem(AddAbilityName);
					`LOG("Adding" @ AddAbilityName @ "to" @ ConfigAbilities.AbilityName, , 'Ability Editor');
				}

				// Getting one of those abilities will override the original ability
				foreach ConfigAbilities.OverrideAbilities(OverrideAbilityName)
				{
					AbilityTemplate.OverrideAbilities.AddItem(OverrideAbilityName);
					`LOG("Overriding" @ ConfigAbilities.AbilityName @ "with" @ OverrideAbilityName, , 'Ability Editor');
				}

				// If this ability is a modifier on another ability, its listed here
				foreach ConfigAbilities.PrerequisiteAbilities(PrerequiredAbilityName)
				{
					AbilityTemplate.PrerequisiteAbilities.AddItem(PrerequiredAbilityName);
					`LOG("Ability" @ PrerequiredAbilityName @ "is now required for" @ ConfigAbilities.AbilityName, , 'Ability Editor');
				}

				// For abilities that require an item but are not sourced from one, specifies a default slot to use.
				if(ConfigAbilities.ItemSlot != '')
				{
					switch(ConfigAbilities.ItemSlot)
					{
						case 'Unknown':
							AbilityTemplate.DefaultSourceItemSlot = eInvSlot_Unknown;
							break;
						case 'PrimaryWeapon':
							AbilityTemplate.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;
							break;
						case 'SecondaryWeapon':
							AbilityTemplate.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;
							break;
						case 'HeavyWeapon':
							AbilityTemplate.DefaultSourceItemSlot = eInvSlot_HeavyWeapon;
							break;
					}
				}

				// Checked after the ability is activated to determine if the unit can remain concealed.
				if(ConfigAbilities.RetainConcealment != '')
				{
					switch(ConfigAbilities.RetainConcealment)
					{
						case 'NonOffensive':
							AbilityTemplate.ConcealmentRule = eConceal_NonOffensive; //  Always retain Concealment if the Hostility != Offensive (default behavior)
							break;
						case 'Always':
							AbilityTemplate.ConcealmentRule = eConceal_Always; //  Always retain Concealment, period
							break;
						case 'Never':
							AbilityTemplate.ConcealmentRule = eConceal_Never; //  Never retain Concealment, period
							break;
						case 'KillShot':
							AbilityTemplate.ConcealmentRule = eConceal_KillShot; //  Retain concealment when killing a single (primary) target
							break;
						case 'Miss':
							AbilityTemplate.ConcealmentRule = eConceal_Miss; //  Retain concealment when the ability misses
							break;
						case 'MissOrKillShot':
							AbilityTemplate.ConcealmentRule = eConceal_MissOrKillShot; //  Retain concealment when the ability misses or when killing a single (primary) target
							break;
						case 'AlwaysEvenWithObjective':
							AbilityTemplate.ConcealmentRule = eConceal_AlwaysEvenWithObjective; //  Always retain Concealment, even if the target is an objective
							break;
					}
				}

				`LOG("Patched" @ ConfigAbilities.AbilityName, , 'Ability Editor');
			}
		}
	}
}
