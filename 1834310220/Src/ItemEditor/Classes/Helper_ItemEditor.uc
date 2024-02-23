class Helper_ItemEditor extends Object;


//   ######    #######  ##    ##  ########  ####    ####      ###      ########  ##    #######
//  ##        ##        ##    ##  ##        ## ##  ## ##     ## ##        ##     ##   ##
//   #####   ##         ########  ####      ##  ####  ##    ## # ##       ##     ##  ##
//       ##   ##        ##    ##  ##        ##        ##   ##     ##      ##     ##   ##
//  ######     #######  ##    ##  ########  ##        ##  ##       ##     ##     ##    #######


static function ModifyItemRewards(X2ItemTemplate Template, array<Name> ItemRewards)
{
	local X2SchematicTemplate SchematicTemplate;
	local Name ItemName;

	SchematicTemplate = X2SchematicTemplate(Template);

	if(SchematicTemplate != none)
	{
		foreach ItemRewards(ItemName)
		{
			SchematicTemplate.ItemRewards.AddItem(ItemName);
		}
	}
}

static function ModifySquadUpgrade(X2ItemTemplate Template, Name SquadUpgrade)
{
	local X2SchematicTemplate SchematicTemplate;

	SchematicTemplate = X2SchematicTemplate(Template);

	if(SchematicTemplate != none)
	{
		if(SquadUpgrade != '')
		{
			if(SquadUpgrade == 'TRUE')
			{
				SchematicTemplate.bSquadUpgrade = true;
			}
			else if(SquadUpgrade == 'FALSE')
			{
				SchematicTemplate.bSquadUpgrade = false;
			}
			else
			{
				`LOG("Item Editor: SquadUpgrade is neither TRUE or FALSE.");
			}
		}
	}
}


//  ##  ########  ########  ####    ####
//  ##     ##     ##        ## ##  ## ##
//  ##     ##     ####      ##  ####  ##
//  ##     ##     ##        ##        ##
//  ##     ##     ########  ##        ##


static function ModifyRewardDecks(X2ItemTemplate Template, array<Name> RewardDecks, optional bool RemoveFromRewardDeck)
{
	local Name RewardDeck;

	if(RemoveFromRewardDeck)
	{
		Template.RewardDecks.Length = 0;
	}

	foreach RewardDecks(RewardDeck)
	{
		Template.RewardDecks.AddItem(RewardDeck);
	}
}

static function ModifyRequiredTechs(X2ItemTemplate Template, array<Name> RequiredTechs)
{
	local Name TechName;

	foreach RequiredTechs(TechName)
	{
		Template.Requirements.RequiredTechs.AddItem(TechName);
	}
}

static function ModifyInfiniteItem(X2ItemTemplate Template, Name InfiniteItem)
{
	if(InfiniteItem != '')
	{
		if(InfiniteItem == 'TRUE')
		{
			Template.bInfiniteItem = true;
		}
			else if(InfiniteItem == 'FALSE')
		{
			Template.bInfiniteItem = false;
		}
		else
		{
			`LOG("Item Editor: InfiniteItem is neither TRUE or FALSE.");
		}
	}
}

static function ModifyLeavesExplosiveRemains(X2ItemTemplate Template, Name DestroyedWithExplosive)
{
	if(DestroyedWithExplosive != '')
	{
		if(DestroyedWithExplosive == 'TRUE')
		{
			Template.LeavesExplosiveRemains = false;
		}
			else if(DestroyedWithExplosive == 'FALSE')
		{
			Template.LeavesExplosiveRemains = true;
		}
		else
		{
			`LOG("Item Editor: DestroyedWithExplosive is neither TRUE or FALSE.");
		}
	}
}

static function ModifyCreatorTemplateName(X2ItemTemplate Template, Name CreatorTemplateName)
{
	if(CreatorTemplateName != '')
	{
		if(CreatorTemplateName == 'None')
		{
			Template.CreatorTemplateName = '';
		}
		else
		{
			Template.CreatorTemplateName = CreatorTemplateName;
		}
	}
}

static function ModifyCanBuildItem(X2ItemTemplate Template, Name CanBeBuilt)
{
	if(CanBeBuilt != '')
	{
		if(CanBeBuilt == 'TRUE')
		{
			Template.CanBeBuilt = true;
		}
		else if(CanBeBuilt == 'FALSE')
		{
			Template.CanBeBuilt = false;
		}
		else
		{
			`LOG("Item Editor: CanBeBuilt is neither TRUE or FALSE.");
		}
	}
}

static function ModifyOneTimeBuildItem(X2ItemTemplate Template, Name OneTimeBuild)
{
	if(OneTimeBuild != '')
	{
		if(OneTimeBuild == 'TRUE')
		{
			Template.bOneTimeBuild = true;
		}
		else if(OneTimeBuild == 'FALSE')
		{
			Template.bOneTimeBuild = false;
		}
		else
		{
			`LOG("Item Editor: OneTimeBuild is neither TRUE or FALSE.");
		}
	}
}

static function ModifyShouldHideInInventory(X2ItemTemplate Template, Name HideInInventory)
{
	if(HideInInventory != '')
	{
		if(HideInInventory == 'TRUE')
		{
			Template.HideInInventory = true;
		}
		else if(HideInInventory == 'FALSE')
		{
			Template.HideInInventory = false;
		}
		else
		{
			`LOG("Item Editor: HideInInventory is neither TRUE or FALSE.");
		}
	}
}

static function ModifyStartingItem(X2ItemTemplate Template, Name StartingItem)
{
	if(StartingItem != '')
	{
		if(StartingItem == 'TRUE')
		{
			Template.StartingItem = true;
		}
		else if(StartingItem == 'FALSE')
		{
			Template.StartingItem = false;
		}
		else
		{
			`LOG("Item Editor: StartingItem is neither TRUE or FALSE.");
		}
	}
}

static function ModifyPointsToComplete(X2ItemTemplate Template, String PointsToComplete)
{
	if(Len(PointsToComplete) != 0)
	{
		Template.PointsToComplete = int(PointsToComplete);
	}
}

static function ModifyHideIfResearched(X2ItemTemplate Template, Name HideIfResearched)
{
	if(HideIfResearched != '')
	{
		if(HideIfResearched == 'FALSE')
		{
			Template.HideIfResearched = '';
		}
		else
		{
			Template.HideIfResearched = HideIfResearched;
		}
	}
}

static function ModifyHideIfPurchased(X2ItemTemplate Template, Name HideIfPurchased)
{
	if(HideIfPurchased != '')
	{
		if(HideIfPurchased == 'FALSE')
		{
			Template.HideIfPurchased = '';
		}
		else
		{
			Template.HideIfPurchased = HideIfPurchased;
		}
	}
}

static function ModifyRequiredSoldierClass(X2ItemTemplate Template, Name RequiredSoldierClass)
{
	if(RequiredSoldierClass != '')
	{
		if(RequiredSoldierClass == 'FALSE')
		{
			Template.Requirements.RequiredSoldierClass = '';
		}
		else
		{
			Template.Requirements.RequiredSoldierClass = RequiredSoldierClass;
		}
	}
}

static function ModifyTradingPostValue(X2ItemTemplate Template, String TradingPostValue)
{
	if(Len(TradingPostValue) != 0)
	{
		Template.TradingPostValue = int(TradingPostValue);
	}
}

static function ModifyResourceTemplateName(X2ItemTemplate Template, Name ResourceTemplateName)
{
	if(ResourceTemplateName != '')
	{
		Template.ResourceTemplateName = ResourceTemplateName;
	}
}

static function ModifyResourceQuantity(X2ItemTemplate Template, String ResourceQuantity)
{
	if(Len(ResourceQuantity) != 0)
	{
		Template.ResourceQuantity = int(ResourceQuantity);
	}
}

static function ModifyRequiredEngineer(X2ItemTemplate Template, String StaffNeeded)
{
	if(Len(StaffNeeded) != 0)
	{
		Template.Requirements.RequiredEngineeringScore = int(StaffNeeded);
	}
}

static function ModifyRequiredScientist(X2ItemTemplate Template, String StaffNeeded)
{
	if(Len(StaffNeeded) != 0)
	{
		Template.Requirements.RequiredScienceScore = int(StaffNeeded);
	}
}

static function ModifyRequirementNotMet(X2ItemTemplate Template, Name AlertOnRequirementNotMet)
{
	if(AlertOnRequirementNotMet != '')
	{
		if(AlertOnRequirementNotMet == 'TRUE')
		{
			Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
		}
		else if(AlertOnRequirementNotMet == 'FALSE')
		{
			Template.Requirements.bVisibleIfPersonnelGatesNotMet = false;
		}
		else
		{
			`LOG("Item Editor: bVisibleIfPersonnelGatesNotMet is neither TRUE or FALSE.");
		}
	}
}

static function ModifyOnBuiltFn(X2ItemTemplate Template, Name OnBuilt = '', optional bool DontGiveItem)
{
	if(DontGiveItem)
	{
		Template.OnBuiltFn = none;
	}
	else
	{
		switch(OnBuilt)
		{
			case 'GiveItem' :
				Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.GiveItems;
				break;
			case 'UpgradeItems' :
				Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;
				break;
		}
	}
}


// ##             ##  ########      ###      #######      #####     ####    ##
//  ##     #     ##   ##           ## ##     ##    ##   ##     ##   ## ##   ##
//   ##   ###   ##    ####        ## # ##    #######   ##       ##  ##  ##  ##
//    ## ## ## ##     ##         ##     ##   ##         ##     ##   ##   ## ##
//     ###   ###      ########  ##       ##  ##           #####     ##    ####


static function ModifyInfiniteAmmo(X2ItemTemplate Template, Name InfiniteAmmo)
{
	local X2WeaponTemplate WeaponTemplate;

	WeaponTemplate = X2WeaponTemplate(Template);

	if(WeaponTemplate != none)
	{
		if(InfiniteAmmo != '')
		{
			if(InfiniteAmmo == 'TRUE')
			{
				WeaponTemplate.InfiniteAmmo = true;
			}
			else if(InfiniteAmmo == 'FALSE')
			{
				WeaponTemplate.InfiniteAmmo = false;
			}
			else
			{
				`LOG("Item Editor: InfiniteAmmo is neither TRUE or FALSE.");
			}
		}
	}
}

static function ModifyClipSize(X2ItemTemplate Template, String ClipSize)
{
	local X2WeaponTemplate WeaponTemplate;

	WeaponTemplate = X2WeaponTemplate(Template);

	if(WeaponTemplate != none)
	{
		if(Len(ClipSize) != 0)
		{
			WeaponTemplate.iClipSize = int(ClipSize);
		}
	}
}

static function ModifyMergeAmmo(X2ItemTemplate Template, Name MergeAmmo)
{
	local X2WeaponTemplate WeaponTemplate;

	WeaponTemplate = X2WeaponTemplate(Template);

	if(WeaponTemplate != none)
	{
		if(MergeAmmo != '')
		{
			if(MergeAmmo == 'TRUE')
			{
				WeaponTemplate.bMergeAmmo = true;
			}
			else if(MergeAmmo == 'FALSE')
			{
				WeaponTemplate.bMergeAmmo = false;
			}
			else
			{
				`LOG("Item Editor: bMergeAmmo is neither TRUE or FALSE.");
			}
		}
	}
}

static function ModifyCanBeDodged(X2ItemTemplate Template, Name CanBeDodged)
{
	local X2WeaponTemplate WeaponTemplate;

	WeaponTemplate = X2WeaponTemplate(Template);

	if(WeaponTemplate != none)
	{
		if(CanBeDodged != '')
		{
			if(CanBeDodged == 'TRUE')
			{
				WeaponTemplate.bCanBeDodged = true;
			}
			else if(CanBeDodged == 'FALSE')
			{
				WeaponTemplate.bCanBeDodged= false;
			}
			else
			{
				`LOG("Item Editor: bCanBeDodged is neither TRUE or FALSE.");
			}
		}
	}
}

static function ModifyUseArmorAppearance(X2ItemTemplate Template, Name UseArmorAppearance)
{
	local X2WeaponTemplate WeaponTemplate;

	WeaponTemplate = X2WeaponTemplate(Template);

	if(WeaponTemplate != none)
	{
		if(UseArmorAppearance != '')
		{
			if(UseArmorAppearance == 'TRUE')
			{
				WeaponTemplate.bUseArmorAppearance = true;
			}
			else if(UseArmorAppearance == 'FALSE')
			{
				WeaponTemplate.bUseArmorAppearance = false;
			}
			else
			{
				`LOG("Item Editor: bUseArmorAppearance is neither TRUE or FALSE.");
			}
		}
	}
}

static function OverrideConcealmentRule(X2ItemTemplate Template, Name bOverrideConcealmentRule, Name ConcealmentRule)
{
	local X2WeaponTemplate WeaponTemplate;

	WeaponTemplate = X2WeaponTemplate(Template);

	if(WeaponTemplate != none)
	{
		if(bOverrideConcealmentRule != '')
		{
			if(bOverrideConcealmentRule == 'TRUE')
			{
				WeaponTemplate.bOverrideConcealmentRule = true;

				if(ConcealmentRule != '')
				{
					switch(ConcealmentRule)
					{
						case 'NonOffensive':
							WeaponTemplate.OverrideConcealmentRule = eConceal_NonOffensive; //  Always retain Concealment if the Hostility != Offensive (default behavior)
							break;
						case 'Always':
							WeaponTemplate.OverrideConcealmentRule = eConceal_Always; //  Always retain Concealment, period
							break;
						case 'Never':
							WeaponTemplate.OverrideConcealmentRule = eConceal_Never; //  Never retain Concealment, period
							break;
						case 'KillShot':
							WeaponTemplate.OverrideConcealmentRule = eConceal_KillShot; //  Retain concealment when killing a single (primary) target
							break;
						case 'Miss':
							WeaponTemplate.OverrideConcealmentRule = eConceal_Miss; //  Retain concealment when the ability misses
							break;
						case 'MissOrKillShot':
							WeaponTemplate.OverrideConcealmentRule = eConceal_MissOrKillShot; //  Retain concealment when the ability misses or when killing a single (primary) target
							break;
						case 'AlwaysEvenWithObjective':
							WeaponTemplate.OverrideConcealmentRule = eConceal_AlwaysEvenWithObjective; //  Always retain Concealment, even if the target is an objective
							break;
					}
				}
			}
			else if(bOverrideConcealmentRule == 'FALSE')
			{
				WeaponTemplate.bOverrideConcealmentRule = false;
			}
			else
			{
				`LOG("Item Editor: bOverrideConcealmentRule is neither TRUE or FALSE.");
			}
		}
	}
}


//      ###      #######   ####    ####     #####     ####### 
//     ## ##     ##    ##  ## ##  ## ##   ##     ##   ##    ##
//    ## # ##    #######   ##  ####  ##  ##       ##  ####### 
//   ##     ##   ##   ##   ##        ##   ##     ##   ##   ## 
//  ##       ##  ##    ##  ##        ##     #####     ##    ##


static function ModifyHeavyWeapon(X2ItemTemplate Template, Name HeavyWeapon)
{
	local X2ArmorTemplate ArmorTemplate;

	ArmorTemplate = X2ArmorTemplate(Template);

	if(ArmorTemplate != none)
	{
		if(HeavyWeapon != '')
		{
			if(HeavyWeapon == 'TRUE')
			{
				ArmorTemplate.bHeavyWeapon = true;
			}
			else if(HeavyWeapon == 'FALSE')
			{
				ArmorTemplate.bHeavyWeapon = false;
			}
			else
			{
				`LOG("Item Editor: bHeavyWeapon is neither TRUE or FALSE.");
			}
		}
	}
}

static function ModifyUtilitySlot(X2ItemTemplate Template, Name AddsUtilitySlot)
{
	local X2ArmorTemplate ArmorTemplate;

	ArmorTemplate = X2ArmorTemplate(Template);

	if(ArmorTemplate != none)
	{
		if(AddsUtilitySlot != '')
		{
			if(AddsUtilitySlot == 'TRUE')
			{
				ArmorTemplate.bAddsUtilitySlot = true;
			}
			else if(AddsUtilitySlot == 'FALSE')
			{
				ArmorTemplate.bAddsUtilitySlot = false;
			}
			else
			{
				`LOG("Item Editor: bAddsUtilitySlot is neither TRUE or FALSE.");
			}
		}
	}
}

//      ###      ####    ####  ####    ####     #####
//     ## ##     ## ##  ## ##  ## ##  ## ##   ##     ##
//    ## # ##    ##  ####  ##  ##  ####  ##  ##       ##
//   ##     ##   ##        ##  ##        ##   ##     ##
//  ##       ##  ##        ##  ##        ##     #####


static function ModifyBypassShields(X2ItemTemplate Template, Name BypassShields)
{
	local X2AmmoTemplate AmmoTemplate;

	AmmoTemplate = X2AmmoTemplate(Template);

	if(AmmoTemplate != none)
	{
		if(BypassShields != '')
		{
			if(BypassShields == 'TRUE')
			{
				AmmoTemplate.bBypassShields = true;
			}
			else if(BypassShields == 'FALSE')
			{
				AmmoTemplate.bBypassShields = false;
			}
			else
			{
				`LOG("Item Editor: bBypassShields is neither TRUE or FALSE.");
			}
		}
	}
}

//  ########     #####     ##     ##  ##  #######   ####    ####  ########  ####    ##  ########
//  ##         ##     ##   ##     ##  ##  ##    ##  ## ##  ## ##  ##        ## ##   ##     ##
//  ####      ##       ##  ##     ##  ##  #######   ##  ####  ##  ####      ##  ##  ##     ##
//  ##         ##   # ##   ##     ##  ##  ##        ##        ##  ##        ##   ## ##     ##
//  ########     ##### #    #######   ##  ##        ##        ##  ########  ##    ####     ##


static function ModifyUseBoostIncrement(X2ItemTemplate Template, Name UseBoostIncrement)
{
	local X2EquipmentTemplate EquipmentTemplate;

	EquipmentTemplate = X2EquipmentTemplate(Template);

	if(EquipmentTemplate != none)
	{
		if(UseBoostIncrement != '')
		{
			if(UseBoostIncrement == 'TRUE')
			{
				EquipmentTemplate.bUseBoostIncrement = true;
			}
			else if(UseBoostIncrement == 'FALSE')
			{
				EquipmentTemplate.bUseBoostIncrement = false;
			}
			else
			{
				`LOG("Item Editor: bUseBoostIncrement is neither TRUE or FALSE.");
			}
		}
	}
}

static function ModifyStatsToBoost(X2ItemTemplate Template, array<Name> StatsToBoost)
{
	local X2EquipmentTemplate EquipmentTemplate;
	local Name StatName;

	EquipmentTemplate = X2EquipmentTemplate(Template);

	if(EquipmentTemplate != none)
	{
		foreach StatsToBoost(StatName)
		{
			switch(StatName)
			{
				case 'HP':
					EquipmentTemplate.StatsToBoost.AddItem(eStat_HP);
					break;
				case 'Offense':
					EquipmentTemplate.StatsToBoost.AddItem(eStat_Offense);
					break;
				case 'Mobility':
					EquipmentTemplate.StatsToBoost.AddItem(eStat_Mobility);
					break;
				case 'Dodge':
					EquipmentTemplate.StatsToBoost.AddItem(eStat_Dodge);
					break;
				case 'Will':
					EquipmentTemplate.StatsToBoost.AddItem(eStat_Will);
					break;
				case 'Hacking':
					EquipmentTemplate.StatsToBoost.AddItem(eStat_Hacking);
					break;
				case 'ArmorMitigation':
					EquipmentTemplate.StatsToBoost.AddItem(eStat_ArmorMitigation);
					break;
				case 'CritChance':
					EquipmentTemplate.StatsToBoost.AddItem(eStat_CritChance);
					break;
				case 'Defense':
					EquipmentTemplate.StatsToBoost.AddItem(eStat_Defense);
					break;
				case 'PsiOffense':
					EquipmentTemplate.StatsToBoost.AddItem(eStat_PsiOffense);
					break;
			}
		}
	}
}

static function ModifyInventorySlot(X2ItemTemplate Template, Name InventorySlot)
{
	local X2EquipmentTemplate EquipmentTemplate;

	EquipmentTemplate = X2EquipmentTemplate(Template);

	if(EquipmentTemplate != none)
	{
		if(InventorySlot != '')
		{
			switch(InventorySlot)
			{
				case 'PrimaryWeapon':
					EquipmentTemplate.InventorySlot = eInvSlot_PrimaryWeapon;
					break;
				case 'SecondaryWeapon':
					EquipmentTemplate.InventorySlot = eInvSlot_SecondaryWeapon;
					break;
				case 'TertiaryWeapon':
					EquipmentTemplate.InventorySlot = eInvSlot_TertiaryWeapon;
					break;
				case 'Utility':
					EquipmentTemplate.InventorySlot = eInvSlot_Utility;
					break;
				case 'Mission':
					EquipmentTemplate.InventorySlot = eInvSlot_Mission;
					break;
				case 'CombatSim':
					EquipmentTemplate.InventorySlot = eInvSlot_CombatSim;
					break;
				case 'HeavyWeapon':
					EquipmentTemplate.InventorySlot = eInvSlot_HeavyWeapon;
					break;
				case 'Backpack':
					EquipmentTemplate.InventorySlot = eInvSlot_Backpack;
					break;
				// Support for modded slot (require CHL)
				case 'Vest':
					EquipmentTemplate.InventorySlot = eInvSlot_Vest;
					break;
				case 'AugmentationHead':
					EquipmentTemplate.InventorySlot = eInvSlot_AugmentationHead;
					break;
				case 'AugmentationTorso':
					EquipmentTemplate.InventorySlot = eInvSlot_AugmentationTorso;
					break;
				case 'AugmentationArms':
					EquipmentTemplate.InventorySlot = eInvSlot_AugmentationArms;
					break;
				case 'AugmentationLegs':
					EquipmentTemplate.InventorySlot = eInvSlot_AugmentationLegs;
					break;
				case 'CombatDrugs':
					EquipmentTemplate.InventorySlot = eInvSlot_CombatDrugs;
					break;
				case 'Decorations':
					EquipmentTemplate.InventorySlot = eInvSlot_Decorations;
					break;
				case 'PsiAmp':
					EquipmentTemplate.InventorySlot = eInvSlot_PsiAmp;
					break;
				case 'Plating':
					EquipmentTemplate.InventorySlot = eInvSlot_Plating;
					break;
				case 'SparkLauncher':
					EquipmentTemplate.InventorySlot = eInvSlot_SparkLauncher;
					break;
				case 'ExtraSecondary':
					EquipmentTemplate.InventorySlot = eInvSlot_ExtraSecondary;
					break;
				case 'PrimaryPayload':
					EquipmentTemplate.InventorySlot = eInvSlot_PrimaryPayload;
					break;
				case 'SecondaryPayload':
					EquipmentTemplate.InventorySlot = eInvSlot_SecondaryPayload;
					break;
				case 'ExtraRocket1':
					EquipmentTemplate.InventorySlot = eInvSlot_ExtraRocket1;
					break;
				case 'ExtraRocket2':
					EquipmentTemplate.InventorySlot = eInvSlot_ExtraRocket2;
					break;
				case 'ExtraRocket3':
					EquipmentTemplate.InventorySlot = eInvSlot_ExtraRocket3;
					break;
				case 'ExtraRocket4':
					EquipmentTemplate.InventorySlot = eInvSlot_ExtraRocket4;
					break;
				case 'Pistol':
					EquipmentTemplate.InventorySlot = eInvSlot_Pistol;
					break;
			}
		}
	}
}