[h1]Description[/h1]

This mod allows you to modify any item (vanilla and modded ones).

[h1]Variables[/h1]

[b][u]Items[/u][/b]

[u]TemplateName[/u] - [i]String[/i]
[b]Required[/b] - Name of the template being modified.

[u]PointsToComplete[/u] - [i]Integer[/i]
[b]Optional[/b] - Time neede to complete building.

[u]TradingPostValue[/u] - [i]Integer[/i]
[b]Optional[/b] - Supplies received when sold at the trading post.

[u]ResourceQuantity[/u] - [i]Integer[/i]
[b]Optional[/b] - The amount of that Resource to be acquired.

[u]ResourceTemplateName[/u] - [i]String[/i]
[b]Optional[/b] - This item awards the specified Resource when it is acquired.

[u]CreatorTemplateName[/u] - [i]String[/i]
[b]Optional[/b] - This item is created by this template (normally a schematic or tech).

[u]HideIfResearched[/u] - [i]String[/i]
[b]Optional[/b] - If this tech is researched, do not display in Build Items. If you want to remove the existing one put FALSE.

[u]HideIfPurchased[/u] - [i]String[/i]
[b]Optional[/b] - If the referenced item is purchased, do not display in Build Items. If you want to remove the existing one put FALSE.

[u]CanBeBuilt[/u] - [i]Bool[/i]
[b]Optional[/b] - Can XCom HQ build this item.

[u]DestroyedWithExplosive[/u] - [i]Bool[/i]
[b]Optional[/b] - if true, if the unit carrying this item as loot is killed by an explosive, the player gets NOTHING.

[u]RemoveFromRewardDeck[/u] - [i]Bool[/i]
[b]Optional[/b] - Remove this item from Proving Ground rewards.

[u]RewardDecks[/u] - [i]Array (string)[/i]
[b]Optional[/b] - This item template should be added to all of these reward decks.

[u]InfiniteItem[/u] - [i]Bool[/i]
[b]Optional[/b] - Does this item have infinite quantity in the inventory (Starting Items are assumed to work this way).

[u]HideInInventory[/u] - [i]Bool[/i]
[b]Optional[/b] - Should the item appear in HQ's inventory screen.

[u]OneTimeBuild[/u] - [i]Bool[/i]
[b]Optional[/b] - This item can only be built once (Story Items, Schematic Projects).

[u]StartingItem[/u] - [i]Bool[/i]
[b]Optional[/b] - Does XCom HQ start with this item.

[u]DontGiveItem[/u] - [i]Bool[/i]
[b]Optional[/b] - If True, removes the function in OnBuiltFn.

[u]OnBuilt[/u] - [i]String[/i]
[b]Optional[/b] - If DontGiveItem, will apply one of these functions.
Accepted values:
[list]
    [*] GiveItem - Building this item will grant items added to ItemRewards.
    [*] UpgradeItems - Upgrade the item.
[/list]

[u]RequiredTechs[/u] - [i]Array (string)[/i]
[b]Optional[/b] - Names of tech required to be able to build.

[u]iNeedEngineer[/u] - [i]Integer[/i]
[b]Optional[/b] - Number of Engineers needed to build this item.

[u]iNeedSciencist[/u] - [i]Integer[/i]
[b]Optional[/b] - Number of Sciencists needed to build this item.

[u]bVisibleIfPersonnelGatesNotMet[/u] - [i]Bool[/i]
[b]Optional[/b] - Display a message if the staff requirements are not met.

[u]RequiredSoldierClass[/u] - [i]String[/i]
[b]Optional[/b] - Class needed to build this item. If you want to remove the existing one put FALSE.

[u]Cost[/u] - [i]Array[/i]
[list]
    [*] [u]ResourceCosts[/u] - [i]Array[/i].
    [list]
        [*] [u]ItemTemplateName[/u] - [i]Name[/i]
        [*] [u]Quantity[/u] - [i]Integer[/i]
    [/list]
    [*] [u]ArtifactCosts[/u] - [i]Array[/i]
    [list]
        [*] [u]ItemTemplateName[/u] - [i]Name[/i]
        [*] [u]Quantity[/u] - [i]Integer[/i]
    [/list]
[/list]
[b]Optional[/b] - Cost to build this item.

[u]RemovePreviousCost[/u] - [i]Bool[/i]
[b]Optional[/b] - If True, removes previous costs for the item.

[b][u]Schematics[/u][/b]

[u]SquadUpgrade[/u] - [i]Bool[/i]
[b]Optional[/b] - Does this schematic provide an upgrade for the entire squad.

[u]ItemRewards[/u] - [i]Array (string)[/i]
[b]Optional[/b] - Items which should be given to the player when this schematic is built.


[b][u]Equipments[/u][/b]

[u]bUseBoostIncrement[/u] - [i]Bool[/i]
[b]Optional[/b] - If the item should boost stats using a hard increment value instead of a percentage. Used by some PCSs (HP, mobility).

[u]InventorySlot[/u] - [i]String[/i]
[b]Optional[/b] - Place occupied by this item.
Accepted values:
[list]
    [*] PrimaryWeapon
    [*] SecondaryWeapon
    [*] TertiaryWeapon
    [*] Utility
    [*] Mission
    [*] CombatSim
    [*] HeavyWeapon
    [*] Backpack
[/list]
Modded values accepted:
[list]
    [*] Vest
    [*] AugmentationHead
    [*] AugmentationTorso
    [*] AugmentationArms
    [*] AugmentationLegs
    [*] CombatDrugs
    [*] Decorations
    [*] PsiAmp
    [*] Plating
    [*] SparkLauncher
    [*] ExtraSecondary
    [*] PrimaryPayload
    [*] SecondaryPayload
    [*] ExtraRocket1
    [*] ExtraRocket2
    [*] ExtraRocket3
    [*] ExtraRocket4
    [*] Pistol
[/list]

[u]StatsToBoost[/u] - [i]String[/i]
[b]Optional[/b] - What character stats does this item apply the boosts to?
Accepted values:
[list]
    [*] HP - eStat_HP
    [*] Offense - eStat_Offense
    [*] Mobility - eStat_Mobility
    [*] Dodge - eStat_Dodge
    [*] Will - eStat_Will
    [*] Hacking - eStat_Hacking
    [*] ArmorMitigation - eStat_ArmorMitigation
    [*] CritChance - eStat_CritChance
    [*] Defense - eStat_Defense
    [*] PsiOffense - eStat_PsiOffense
[/list]


[b][u]Weapons[/u][/b]

[u]InfiniteAmmo[/u] - [i]Bool[/i]
[b]Optional[/b] - No reloading required.

[u]bMergeAmmo[/u] - [i]Bool[/i]
[b]Optional[/b] - If this item is in the unit's inventory multiple times, the ammo will be consolidated.

[u]bCanBeDodged[/u] - [i]Bool[/i]
[b]Optional[/b] - Can an enemy dodge a shot from this weapon?

[u]bUseArmorAppearance[/u] - [i]Bool[/i]
[b]Optional[/b] - This weapon will use the armor tinting values instead of the weapons.

[u]bOverrideConcealmentRule[/u] - [i]Bool[/i]
[b]Optional[/b] - Determine if the unit can remain concealed after using this item

[u]ConcealmentRule[/u] - [i]String[/i]
[b]Optional[/b] - This is only used if bOverrideConcealmentRule is true
Accepted values:
[list]
    [*] NonOffensive - Always retain Concealment if the Hostility != Offensive (default behavior)
    [*] Always - Always retain Concealment, period
    [*] Never - Never retain Concealment, period
    [*] KillShot - Retain concealment when killing a single (primary) target
    [*] Miss - Retain concealment when the ability misses
    [*] MissOrKillShot - Retain concealment when the ability misses or when killing a single (primary) target
    [*] AlwaysEvenWithObjective - Always retain Concealment, even if the target is an objective
[/list]

[u]iClipSize[/u] - [i]Integer[/i]
[b]Optional[/b] - The ammo amount.


[b][u]Armors[/u][/b]

[u]bHeavyWeapon[/u] - [i]Bool[/i]
[b]Optional[/b] - Armor will allow access to HeavyWeapon slot and restrict use of the backpack.

[u]bAddsUtilitySlot[/u] - [i]Bool[/i]
[b]Optional[/b] - Allows soldier to bring a second utility item.


[b][u]Ammos[/u][/b]

[u]bBypassShields[/u] - [i]Bool[/i]
[b]Optional[/b] - This ammo type will ignore shields.


[h1]Usage[/h1]

Can be used by other mods to modify existing item templates by adding [u]XComItemEditor.ini[/u] to the mod config.
Can be used by anyone willing to tweak his game even more.

[u]Examples[/u]
[code]
[ItemEditor.OPTC_Items]
AP rounds will ignore shields
+Items=(TemplateName=APRounds, bBypassShields=true)
Bluescreen rounds will no longer ignore shields
+Items=(TemplateName=BluescreenRounds, bBypassShields=false)

Grant Psi stat bonus to Focus PSC as well as Will
+Items=(TemplateName=CommonPCSFocus, StatsToBoost[0]=PsiOffense)
+Items=(TemplateName=RarePCSFocus, StatsToBoost[0]=PsiOffense)
+Items=(TemplateName=EpicPCSFocus, StatsToBoost[0]=PsiOffense)
[/code]


[h1]Compatibility[/h1]
It should be compatible with everything.

[h1]Troubleshooting[/h1]
https://www.reddit.com/r/xcom2mods/wiki/mod_troubleshooting
[url=steamcommunity.com/sharedfiles/filedetails/?id=683218526]Mods not working properly / at all[/url]
[url=steamcommunity.com/sharedfiles/filedetails/?id=625230005]Mod not working? Mods still have their effects after you disable them?[/url]
