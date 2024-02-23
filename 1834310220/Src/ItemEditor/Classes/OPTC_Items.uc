class OPTC_Items extends X2DownloadableContentInfo config(ItemEditor);

struct native ResourceCostStruct
{
	var Name ItemTemplateName;
	var int Quantity;
};

struct native ArtifactCostStruct
{
	var Name ItemTemplateName;
	var int Quantity;
};

struct native ItemCostStruct
{
	var array<ResourceCostStruct> ResourceCosts;
	var array<ArtifactCostStruct> ArtifactCosts;
};

struct native ItemStruct
{
	// ITEM VARIABLES
	var Name TemplateName;
	var ItemCostStruct Cost;
	var bool RemovePreviousCost;
	var bool RemoveFromRewardDeck;				// Remove this item from Proving Ground rewards.
	var array<name> RewardDecks;				// This item template should be added to all of these reward decks.
	var array<Name> RequiredTechs;
	var String iNeedEngineer;					// Number of Engineers needed to build this item.
	var String iNeedSciencist;					// Number of Sciencists needed to build this item.
	var Name RequiredSoldierClass;				// Class needed to build this item.
	var Name bVisibleIfPersonnelGatesNotMet;	// Display a message if the staff requirements are not met.
	var Name DestroyedWithExplosive;			// if true, if the unit carrying this item as loot is killed by an explosive, the player gets NOTHING
	var Name InfiniteItem;						// Does this item have infinite quantity in the inventory (Starting Items are assumed to work this way)
	var Name CanBeBuilt;						// Can XCom HQ build this item
	var Name HideInInventory;					// Should the item appear in HQ's inventory screen
	var Name OneTimeBuild;						// This item can only be built once (Story Items, Schematic Projects)
	var bool DontGiveItem;
	var Name OnBuilt;
	var Name StartingItem;						// Does XCom HQ start with this item
	var String PointsToComplete;
	var String TradingPostValue;				// Supplies received when sold at the trading post
	var String ResourceQuantity;				// The amount of that Resource to be acquired
	var Name ResourceTemplateName;				// This item awards the specified Resource when it is acquired
	var Name HideIfResearched;					// If this tech is researched, do not display in Build Items
	var Name HideIfPurchased;					// If the referenced item is purchased, do not display in Build Items
	var Name CreatorTemplateName;				// This item is created by this template (normally a schematic or tech)
	// TODO
	var int Tier;								// The tier this item should be assigned to. Used for sorting lists.
	var bool bAlwaysRecovered;					// When this loot is rolled, auto recover it immediately; don't offer it as normal looting options.
	var bool bOkayToConcealAsObjective;			// Even if this item is an objective item, it's okay to get concealed when carrying it (see: X2Condition_Stealth)
	var bool bBlocked;							// This item must be unblocked before it can be built
	var Name UpgradeItem;						// This item can be upgraded into another item defined by the named template
	var Name BaseItem;							// The item this one was upgraded from
	var Name ItemCat;							// must match one of the entries in X2ItemTemplateManager's ItemCategories
	var bool HideInLootRecovered;				// Should the item appear on the loot recovered screen
	
	// SCHEMATIC VARIABLES
	var Name SquadUpgrade;
	var array<Name> ItemRewards;
	// TODO
	var Name ReferenceItemTemplate;
	
	// WEAPON VARIABLES
	var Name InfiniteAmmo;						// no reloading required!
	var Name bMergeAmmo;						// If this item is in the unit's inventory multiple times, the ammo will be consolidated.
	var Name bCanBeDodged;
	var Name bUseArmorAppearance;				// This weapon will use the armor tinting values instead of the weapons
	var Name bOverrideConcealmentRule;
	var Name ConcealmentRule;					// This is only used if bOverrideConcealmentRule is true
	var String iClipSize;						// ammo amount before a reload is required
	// TODO
	var Name DamageTypeTemplateName;			// Template name for the type of ENVIRONMENT damage this weapon does
	var int iEnvironmentDamage;					// damage to environmental effects; should be 50, 100, or 150.
	var int iRange;								// -1 will mean within the unit's sight, 0 means melee
	var int iRadius;							// radius in METERS for AOE range
	var int iTypicalActionCost;					// typical cost in action points to fire the weapon (only used by some abilities)
	var int Aim;
	var int CritChance;
	var int NumUpgradeSlots;					// Number of weapon slots available

	// ARMOR VARIABLES
	var Name bHeavyWeapon;						// Armor will allow access to HeavyWeapon slot and restrict use of the backpack.
	var Name bAddsUtilitySlot;					// Allows soldier to bring a second utility item.
	// TODO
	var Name ArmorCat;							// If the armor has a specialized category, so it is only usable by certain classes
	var Name ArmorClass;
	var Name ArmorTechCat;

	// AMMO VARIABLES
	var Name bBypassShields;

	// EQUIPMENT VARIABLES
	var Name bUseBoostIncrement;				// If the item should boost stats using a hard increment value instead of a percentage. Used by some PCSs (HP, mobility)
	var array<Name> StatsToBoost;				// What character stats does this item apply the boosts to?
	var Name InventorySlot;
	// TODO
	var int StatBoostPowerLevel;				// corresponds to "rarity" of item, used for Personal Combat Sims

};

var config array<ItemStruct> Items;

static event OnPostTemplatesCreated()
{
	local X2ItemTemplateManager ItemMgr;
	local array<X2DataTemplate> TemplateAllDifficulties;
	local X2DataTemplate Template;
	local X2ItemTemplate ItemTemplate;

	local ItemStruct ItemConfig;
	local ResourceCostStruct ResourceCost;
	local ArtifactCostStruct ArtifactCost;
	local ArtifactCost Resources, RemoveResource, RemoveArtifact;

	`LOG("Item Editor loaded");

	ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	foreach default.Items(ItemConfig)
	{
		ItemMgr.FindDataTemplateAllDifficulties(ItemConfig.TemplateName, TemplateAllDifficulties);

		foreach TemplateAllDifficulties(Template)
		{
			ItemTemplate = X2ItemTemplate(Template);

			if (ItemTemplate != none)
			{
				// SCHEMATICS
				class'Helper_ItemEditor'.static.ModifySquadUpgrade(ItemTemplate, ItemConfig.SquadUpgrade);
				class'Helper_ItemEditor'.static.ModifyItemRewards(ItemTemplate, ItemConfig.ItemRewards);

				// ITEMS
				class'Helper_ItemEditor'.static.ModifyLeavesExplosiveRemains(ItemTemplate, ItemConfig.DestroyedWithExplosive);
				class'Helper_ItemEditor'.static.ModifyInfiniteItem(ItemTemplate, ItemConfig.InfiniteItem);
				class'Helper_ItemEditor'.static.ModifyCanBuildItem(ItemTemplate, ItemConfig.CanBeBuilt);
				class'Helper_ItemEditor'.static.ModifyOneTimeBuildItem(ItemTemplate, ItemConfig.OneTimeBuild);
				class'Helper_ItemEditor'.static.ModifyShouldHideInInventory(ItemTemplate, ItemConfig.HideInInventory);
				class'Helper_ItemEditor'.static.ModifyRewardDecks(ItemTemplate, ItemConfig.RewardDecks, ItemConfig.RemoveFromRewardDeck);
				class'Helper_ItemEditor'.static.ModifyRequiredTechs(ItemTemplate, ItemConfig.RequiredTechs);
				class'Helper_ItemEditor'.static.ModifyRequiredEngineer(ItemTemplate, ItemConfig.iNeedEngineer);
				class'Helper_ItemEditor'.static.ModifyRequiredScientist(ItemTemplate, ItemConfig.iNeedSciencist);
				class'Helper_ItemEditor'.static.ModifyRequirementNotMet(ItemTemplate, ItemConfig.bVisibleIfPersonnelGatesNotMet);
				class'Helper_ItemEditor'.static.ModifyRequiredSoldierClass(ItemTemplate, ItemConfig.RequiredSoldierClass);
				class'Helper_ItemEditor'.static.ModifyOnBuiltFn(ItemTemplate, ItemConfig.OnBuilt, ItemConfig.DontGiveItem);
				class'Helper_ItemEditor'.static.ModifyStartingItem(ItemTemplate, ItemConfig.StartingItem);
				class'Helper_ItemEditor'.static.ModifyPointsToComplete(ItemTemplate, ItemConfig.PointsToComplete);
				class'Helper_ItemEditor'.static.ModifyTradingPostValue(ItemTemplate, ItemConfig.TradingPostValue);
				class'Helper_ItemEditor'.static.ModifyResourceTemplateName(ItemTemplate, ItemConfig.ResourceTemplateName);
				class'Helper_ItemEditor'.static.ModifyResourceQuantity(ItemTemplate, ItemConfig.ResourceQuantity);
				class'Helper_ItemEditor'.static.ModifyHideIfResearched(ItemTemplate, ItemConfig.HideIfResearched);
				class'Helper_ItemEditor'.static.ModifyHideIfPurchased(ItemTemplate, ItemConfig.HideIfPurchased);
				class'Helper_ItemEditor'.static.ModifyCreatorTemplateName(ItemTemplate, ItemConfig.CreatorTemplateName);

				if(ItemConfig.RemovePreviousCost)
				{
					foreach ItemTemplate.Cost.ArtifactCosts(RemoveArtifact)
					{
						ItemTemplate.Cost.ArtifactCosts.RemoveItem(RemoveArtifact);
					}
					ItemTemplate.Cost.ArtifactCosts.Length = 0;

					foreach ItemTemplate.Cost.ResourceCosts(RemoveResource)
					{
						ItemTemplate.Cost.ResourceCosts.RemoveItem(RemoveResource);
					}
					ItemTemplate.Cost.ResourceCosts.Length = 0;
				}

				foreach ItemConfig.Cost.ResourceCosts(ResourceCost)
				{
					Resources.ItemTemplateName = ResourceCost.ItemTemplateName;
					Resources.Quantity = ResourceCost.Quantity;
					ItemTemplate.Cost.ResourceCosts.AddItem(Resources);
				}

				foreach ItemConfig.Cost.ArtifactCosts(ArtifactCost)
				{
					Resources.ItemTemplateName = ArtifactCost.ItemTemplateName;
					Resources.Quantity = ArtifactCost.Quantity;
					ItemTemplate.Cost.ArtifactCosts.AddItem(Resources);
				}

				// WEAPONS
				class'Helper_ItemEditor'.static.ModifyInfiniteAmmo(ItemTemplate, ItemConfig.InfiniteAmmo);
				class'Helper_ItemEditor'.static.ModifyClipSize(ItemTemplate, ItemConfig.iClipSize);
				class'Helper_ItemEditor'.static.ModifyMergeAmmo(ItemTemplate, ItemConfig.bMergeAmmo);
				class'Helper_ItemEditor'.static.ModifyCanBeDodged(ItemTemplate, ItemConfig.bCanBeDodged);
				class'Helper_ItemEditor'.static.ModifyUseArmorAppearance(ItemTemplate, ItemConfig.bUseArmorAppearance);
				class'Helper_ItemEditor'.static.OverrideConcealmentRule(ItemTemplate, ItemConfig.bOverrideConcealmentRule, ItemConfig.ConcealmentRule);

				// ARMORS
				class'Helper_ItemEditor'.static.ModifyHeavyWeapon(ItemTemplate, ItemConfig.bHeavyWeapon);
				class'Helper_ItemEditor'.static.ModifyUtilitySlot(ItemTemplate, ItemConfig.bAddsUtilitySlot);

				// AMMOS
				class'Helper_ItemEditor'.static.ModifyBypassShields(ItemTemplate, ItemConfig.bBypassShields);

				// EQUIPMENTS
				class'Helper_ItemEditor'.static.ModifyUseBoostIncrement(ItemTemplate, ItemConfig.bUseBoostIncrement);
				class'Helper_ItemEditor'.static.ModifyStatsToBoost(ItemTemplate, ItemConfig.StatsToBoost);
				class'Helper_ItemEditor'.static.ModifyInventorySlot(ItemTemplate, ItemConfig.InventorySlot);
			}
		}
	}
}