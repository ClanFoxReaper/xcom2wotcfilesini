[h1]Description[/h1]

This mod allows you to modify any ability (vanilla and modded ones).
You will be able to change cooldowns, charges, action cost and other.

[h1]Variables[/h1]

[u]AbilityName[/u] - [i]String[/i]
[b]Required[/b] - Name of the ability being modified

[u]Cooldown[/u] - [i]Integer[/i]
[b]Optional[/b] - Number of turns between two uses

[u]APCost[/u] - [i]Integer[/i]
[b]Optional[/b] - Number of action it will take

[u]EndsTurn[/u] - [i]Bool[/i]
[b]Optional[/b] - Should this ability end your turn?

[u]FreeAction[/u] - [i]Bool[/i]
[b]Optional[/b] - Should this ability cost an action?

[u]FocusAmount[/u] - [i]Integer[/i]
[b]Optional[/b] - Number of focus it will take

[u]ConsumeAllFocus[/u] - [i]Bool[/i]
[b]Optional[/b] - Should this ability require all you focus?

[u]GhostOnlyCost[/u] - [i]Bool[/i]
[b]Optional[/b] - Should this ability cost focus for Ghost only?

[u]DoNotConsumeAllActionsWith[/u] - [i]Array (string)[/i]
[b]Optional[/b] - If the ability owner has any of these abilities, the ability will not consume all points if EndsTurn was set to true. (e.g. Salvo)

[u]AmmoCost[/u] - [i]Integer[/i]
[b]Optional[/b] - Number of ammo needed (e.g. HailOfBullets:3, ThrowGrenade:1 etc..)

[u]Charges[/u] - [i]Integer[/i]
[b]Optional[/b] - Number of usage granted

[u]KeepChargeOnMiss[/u] - [i]Bool[/i]
[b]Optional[/b] - Recover your charge if the ability misses (e.g. Domination)

[u]ConsumeItem[/u] - [i]Bool[/i]
[b]Optional[/b] - Will consume the item granting this ability.

[u]SharedAbilityCharges[/u] - [i]Array (string)[/i]
[b]Optional[/b] - Abilities which should all have their charges deducted as well (e.g. Skulljack & Skullmine).

[u]AddAbility[/u] - [i]Array (string)[/i]
[b]Optional[/b] - When a unit is granted this ability, it will be granted all of these abilities as well.

[u]OverrideAbilities[/u] - [i]Array (string)[/i]
[b]Optional[/b] - Getting one of those abilities will override the original ability.

[u]PrerequisiteAbilities[/u] - [i]Array (string)[/i]
[b]Optional[/b] - Ability required to unlock current ability.

[u]BonusChargeWith[/u] - [i]Array[/i]
[list]
    [*] [u]BonusAbilityName[/u] - [i]String[/i] - Name of the ability granting extra charges.
    [*] [u]NumBonusCharges[/u] - [i]Integer[/i] - Number of bonus charge to add.
[/list]
[b]Optional[/b] - Abilities which should grant extra charges.

[u]SharedCooldowns[/u] - [i]Array[/i]
[list]
    [*] [u]AbilityName[/u] - [i]String[/i] - Name of the ability getting a cooldown.
    [*] [u]NumTurns[/u] - [i]Integer[/i] - Number of turns before use.
[/list]
[b]Optional[/b] - Abilities which will get a cooldown.

[u]ItemSlot[/u] - [i]String[/i]
[b]Optional[/b] - For abilities that require an item but are not sourced from one, specifies a default slot to use.
Accepted values:
[list]
    [*] Unknown
    [*] PrimaryWeapon
    [*] SecondaryWeapon
    [*] HeavyWeapon
[/list]

[u]RetainConcealment[/u] - [i]String[/i]
[b]Optional[/b] - Determine if the unit can remain concealed after the ability is activated
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


[h1]Usage[/h1]

Can be used by other mods to modify existing abilitiy templates by adding [u]XComAbilityEditor.ini[/u] to the mod config.
Can be used by anyone willing to tweak his game even more.

[u]Examples:[/u]
[code]
[AbilityEditor.OPTC_Abilities]
;This will replace Combat Protocol charges to 3 turns cooldown
;+Abilities = (AbilityName=CombatProtocol, Cooldown=3, EndsTurn=true)

; This will allow Ranger to have an action after Slash
;+Abilities = (AbilityName=SwordSlice, APCost=1, EndsTurn=true, DoNotConsumeAllActionsWith[0]=Blademaster)

; Gives 9 charges of Scanning Protocol, is a free action and can be used every two turns
;+Abilities = (AbilityName=ScanningProtocol, Cooldown=2, Charges=9, FreeAction=true)

; Restoration grants 3 extra charges of Heals
;+Abilities = (AbilityName=GremlinHeal, Charges=2, BonusChargeWith[0]=(BonusAbilityName=RestorativeMist, NumBonusCharges=3) )
[/code]

[h1]Compatibility[/h1]
It should be compatible with everything.
Changes are taken into account if using [url=steamcommunity.com/sharedfiles/filedetails/?id=1289686596][WOTC] Cost-Based Ability Colors[/url]

[h1]Note[/h1]
I did not focus on damages because they are mainly editable from ini files.

[h1]Troubleshooting[/h1]
https://www.reddit.com/r/xcom2mods/wiki/mod_troubleshooting
[url=steamcommunity.com/sharedfiles/filedetails/?id=683218526]Mods not working properly / at all[/url]
[url=steamcommunity.com/sharedfiles/filedetails/?id=625230005]Mod not working? Mods still have their effects after you disable them?[/url]