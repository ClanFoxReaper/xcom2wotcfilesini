tags= war of the chosen, gameplay, morale, fatigue, will

[h1][b]OVERVIEW[/b][/h1]
This mod introduces new mechanics to counter the [i][b]Fatigue System[/b][/i].

The concept is that by killing enemies, your troops have a small chance to restore [i][b]Morale[/b][/i].
(AKA Will lost during combat)

Impaired units cannot regain Morale. This includes most status effects, mind-control and units bound by a Viper.

The main motivation behind this mod was to introduce a new feature that would let me do the DLC missions without guaranteeing the Shaken status on all my soldiers.
[i][u]EDIT: Turns out the Community Highlander has a feature to fix this see first page of comments[/u][/i]

[h1][b]CONFIGURATION[/b][/h1]
The configuration file should be in the following location:
[code]<Your Steam Install>
\steamapps\workshop\content\268500\2242584900\Config\XComMoraleSystem.ini[/code]

You can configure the chance to restore Morale when an enemy dies and the amount of Morale restored. You can also create custom settings for specific enemies.

There are three categories of settings:

[u][b]Default Setting[/b][/u]
This is the default setting. When any enemy dies, the event will use these settings to check how often and how much Morale to restore.

[u][b]The Lost Setting[/b][/u]
Bypasses the default setting if dead enemy is a Lost. By default, there is no Morale gain from dead Losts.

[u][b]Specific Enemy Setting[/b][/u]
This setting bypasses all the others.

You can fully configure the Morale gain for any specified enemy.

By default, all vanilla bosses have guaranteed chance to restore Morale when killed.
(Chosen, Rulers, Julian)

[h1][b]COMPANION MODS[/b][/h1]
If you use [url=https://steamcommunity.com/sharedfiles/filedetails/?id=1134266810]WotC: Show Will Loss[/url], a flyover notification will appear when you regain Morale.

If you don't use that mod, the Morale System will happen behind the scenes.

[h1][b]COMPATIBILITY[/b][/h1]
This mod should be compatible with any other mod and can be added/removed mid campaign.