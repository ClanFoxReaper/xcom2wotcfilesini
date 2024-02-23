[h1]Description[/h1]

This mod allows you to create your own abilities. These abilities can grant stats buff/debuff.
Modify [u]XComCSA[/u] to do so.

[h1]Variables[/h1]

[u]TemplateName[/u] - [i]String[/i]
[b]Required[/b] - Name of the template being created. You can't have two similar template names.

[u][STAT][/u] - [i]Int[/i]
[b]Optional[/b] - Use stat from the pool bellow.

[u]Availables stats:[/u]
[list]
[*] [u]ModHP[/u] = eStat_HP
[*] [u]ModOffense[/u] = eStat_Offense
[*] [u]ModDefense[/u] = eStat_Defense
[*] [u]ModMobility[/u] = eStat_Mobility
[*] [u]ModWill[/u] = eStat_Will
[*] [u]ModHacking[/u] = eStat_Hacking
[*] [u]ModDodge[/u] = eStat_Dodge
[*] [u]ModShieldHP[/u] = eStat_ShieldHP
[*] [u]ModArmorMitigation[/u] = eStat_ArmorMitigation
[*] [u]ModPsiOffense[/u] = eStat_PsiOffense
[*] [u]ModDetectionRadius[/u] = eStat_DetectionRadius - [i]Untested[/i]
[*] [u]ModHackDefense[/u] = eStat_HackDefense - [i]Untested[/i]
[*] [u]ModCritChance[/u] = eStat_CritChance - [i]Untested[/i]
[*] [u]ModStrength[/u] = eStat_Strength - [i]Untested[/i]
[*] [u]ModUtilityItems[/u] = eStat_UtilityItems - [i]Untested[/i]
[*] [u]ModBackpackSize[/u] = eStat_BackpackSize - [i]Untested[/i]
[*] [u]ModFlankingAimBonus[/u] = eStat_FlankingAimBonus - [i]Untested[/i]
[*] [u]ModFlankingCritChance[/u] = eStat_FlankingCritChance - [i]Untested[/i]
[/list]

[h1]Usage[/h1]

Can be used by other mods to create customizable abilties by adding [u]XComCSA.ini[/u] to the mod config.
Can be used by anyone willing to tweak his game even more.

[u]Examples:[/u]
[code]
[CreateStatsAbilities.CSA_Abilities]
+Abilities=(TemplateName=BirthdayTwenty, ModHP=20, ModHacking=55)
+Abilities=(TemplateName=BirthdayNinety, ModOffense=-40, ModShieldHP=5)
+Abilities=(TemplateName=BirthdaySix, ModDefense=20, ModArmorMitigation=5)
+Abilities=(TemplateName=BirthdaySixteen, ModMobility=10, ModDodge=20)
+Abilities=(TemplateName=BirthdayThirty, ModWill=15, ModPsiOffense=50)
[/code]

[h1]Compatibility[/h1]
It should be compatible with everything.

[h1]Note[/h1]
No icon being displayed. I may add that future. It would then require an ability name and a description.
Were not added the following stats:
[list]
[*] eStat_ArmorPiercing
[*] eStat_Invalid
[*] eStat_SightRadius
[*] eStat_AlertLevel
[*] eStat_DetectionModifier
[*] eStat_SeeMovement
[*] eStat_HearingRadius
[*] eStat_CombatSims
[*] eStat_Job
[/list]

[h1]Troubleshooting[/h1]
https://www.reddit.com/r/xcom2mods/wiki/mod_troubleshooting
[url=steamcommunity.com/sharedfiles/filedetails/?id=683218526]Mods not working properly / at all[/url]
[url=steamcommunity.com/sharedfiles/filedetails/?id=625230005]Mod not working? Mods still have their effects after you disable them?[/url]

