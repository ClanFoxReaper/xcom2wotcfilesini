[h1]Description[/h1]

This mod allows you to attach and/or remove abilities to characters, weapons, armors and items.

[h1]Variables[/h1]

[u]TemplateName[/u] - [i]String[/i]
[b]Optional[/b] - Name of the template being modified.

[u]CharacterGroup[/u] - [i]String[/i]
[b]Optional[/b] - Name of the CharacterGroup being modified.

[u]RemoveOriginal[/u] - [i]Bool[/i]
[b]Optional[/b] - Whether we remove original abilities or not.

[u]AddAbilityName[/u] - [i]Array (string)[/i]
[b]Optional[/b] - Name of abilities we want to add

[u]RemoveAbilityName[/u] - [i]Array (string)[/i]
[b]Optional[/b] - Name of abilities we want to remove

[h1]Usage[/h1]

Can be used by other mods to modify existing templates by adding [u]XComRepurposeAbilities.ini[/u] to the mod config.
Can be used by anyone willing to tweak his game even more.

[u]Examples:[/u]
[code]
[RepurposeAbilities.OPTC_CharactersAbilities]
; Remove Lost Headshot from all Lost
; +Abilities=(CharacterGroup=TheLost, RemoveAbilityName=(LostHeadshotInit))

; Ability attached to character
; Remove original abilities from Andromedon
; +Abilities = (TemplateName=Andromedon, RemoveOriginal=true)
; Remove Blazing Pinions from Archon
; +Abilities = (TemplateName=Archon, RemoveAbilityName[0]=BlazingPinionsStage1)

; Ability attached to weapon
; +Abilities = (TemplateName=ArchonStaff, AddAbilityName[0]=Bladestorm)
; +Abilities = (TemplateName=AdvStunLancerM1_StunLance, AddAbilityName[0]=Bladestorm)
; +Abilities = (TemplateName=AdvStunLancerM2_StunLance, AddAbilityName[0]=Bladestorm)
; +Abilities = (TemplateName=AdvStunLancerM3_StunLance, AddAbilityName[0]=Bladestorm)

; Ability attached to armor
; +Abilities = (TemplateName=LightAlienArmor, RemoveAbilityName[0]=Grapple)

; Ability attached to items
; +Abilities = (TemplateName=MindShield, AddAbilityName[0]=RobotImmunities, RemoveAbilityName[0]=MindShield)
[/code]

[h1]Compatibility[/h1]
It should be compatible with everything.

[h1]Note[/h1]
Some abilties may require animation to work. Don't be surprised when you won't see Troopers perform Bladestorm ¯\(°_o)/¯

[h1]Troubleshooting[/h1]
https://www.reddit.com/r/xcom2mods/wiki/mod_troubleshooting
[url=steamcommunity.com/sharedfiles/filedetails/?id=683218526]Mods not working properly / at all[/url]
[url=steamcommunity.com/sharedfiles/filedetails/?id=625230005]Mod not working? Mods still have their effects after you disable them?[/url]

