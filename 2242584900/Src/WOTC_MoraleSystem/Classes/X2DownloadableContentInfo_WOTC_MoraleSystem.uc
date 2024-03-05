class X2DownloadableContentInfo_WOTC_MoraleSystem extends X2DownloadableContentInfo;

struct DefaultMoraleRollData
{
	var int		WillGainChance;
	var int		MinWillRoll;
	var int		MaxWillRoll;
};

struct TheLostMoraleRollData
{
	var int		WillGainChance;
	var int		MinWillRoll;
	var int		MaxWillRoll;
};

struct SpecialEnemyMoraleRollData
{
	var name	CharName;
	var int		WillGainChance;
	var int		MinWillRoll;
	var int		MaxWillRoll;
};

static function bool IsDLCInstalled(name DLCName)
{
	local XComOnlineEventMgr		EventManager;
	local int						i;

	EventManager = `ONLINEEVENTMGR;
	for (i = 0; i < EventManager.GetNumDLC(); ++i)
	{
		if (EventManager.GetDLCNames(i) == DLCName)
		{
			return true;
		}
	}

	return false;
}