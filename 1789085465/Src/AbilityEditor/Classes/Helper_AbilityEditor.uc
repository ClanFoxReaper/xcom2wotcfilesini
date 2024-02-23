class Helper_AbilityEditor extends Object;


static function X2AbilityCooldown SetCooldown(int iNewCooldown)
{
	local X2AbilityCooldown Cooldown;

	Cooldown = new class'X2AbilityCooldown';

	// No cooldown
	if(iNewCooldown <= 0)
	{
		return none;
	}

	if(iNewCooldown > 9)
	{
		iNewCooldown = 9;
	}

	Cooldown.iNumTurns = iNewCooldown;

	return Cooldown;
}

static function X2AbilityCost_Charges SetChargeCost(bool bKeepChargeOnMiss)
{
	local X2AbilityCost_Charges ChargeCost;

	ChargeCost = new class'X2AbilityCost_Charges';

	ChargeCost.NumCharges = 1;

	if(bKeepChargeOnMiss)
	{
		ChargeCost.bOnlyOnHit = true;
	}

	return ChargeCost;
}

static function X2AbilityCharges SetCharges(int iNumCharge)
{
	local X2AbilityCharges Charges;

	Charges = new class'X2AbilityCharges';

	// No charge
	if(iNumCharge < 0)
	{
		return none;
	}

	if(iNumCharge > 9)
	{
		iNumCharge = 9;
	}

	Charges.InitialCharges = iNumCharge;

	return Charges;
}

static function X2AbilityCharges_GremlinHeal SetGremlinHealCharges(int iNumCharge)
{
	local X2AbilityCharges_GremlinHeal Charges;

	Charges = new class'X2AbilityCharges_GremlinHeal';

	// No charge
	if(iNumCharge < 0)
	{
		return none;
	}

	if(iNumCharge > 9)
	{
		iNumCharge = 9;
	}

	Charges.InitialCharges = iNumCharge;

	return Charges;
}

static function X2AbilityCharges_ScanningProtocol SetScanningProtocolCharges(int iNumCharge)
{
	local X2AbilityCharges_ScanningProtocol Charges;

	Charges = new class'X2AbilityCharges_ScanningProtocol';

	// No charge
	if(iNumCharge < 0)
	{
		return none;
	}

	if(iNumCharge > 9)
	{
		iNumCharge = 9;
	}

	Charges.InitialCharges = iNumCharge;

	return Charges;
}


static function X2AbilityCost_ActionPoints SetActionPointCost(int iAPCost, bool bConsumeAllPoints, optional bool bFreeCost)
{
	local X2AbilityCost_ActionPoints ActionPointCost;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';

	if(bFreeCost == true)
	{
		ActionPointCost.iNumPoints = iAPCost;
		ActionPointCost.bConsumeAllPoints = bConsumeAllPoints;
		ActionPointCost.bFreeCost = true;
	}

	else
	{
		if(iAPCost <= 0)
		{
			ActionPointCost.iNumPoints = 1;
			ActionPointCost.bFreeCost = true;
			ActionPointCost.bConsumeAllPoints = bConsumeAllPoints;
		}

		else
		{
			if(iAPCost > 2)
			{
				iAPCost = 2;
			}

			ActionPointCost.iNumPoints = iAPCost;
			ActionPointCost.bConsumeAllPoints = bConsumeAllPoints;
		}

	}

	return ActionPointCost;
}

static function X2AbilityCost_Ammo SetAmmoCost(int iAmmoCost)
{
	local X2AbilityCost_Ammo AmmoCost;

	AmmoCost = new class'X2AbilityCost_Ammo';

	if(iAmmoCost < 0)
	{
		iAmmoCost = 0;
	}

	else if(iAmmoCost > 9)
	{
		iAmmoCost = 9;
	}

	AmmoCost.iAmmo = iAmmoCost;

	return AmmoCost;
}

static function X2AbilityCost_Focus SetFocusCost(int FocusAmount, optional bool ConsumeAllFocus, optional bool GhostOnlyCost)
{
	local X2AbilityCost_Focus FocusCost;

	FocusCost = new class'X2AbilityCost_Focus';

	FocusCost.FocusAmount = FocusAmount;

	if(ConsumeAllFocus)
	{
		FocusCost.ConsumeAllFocus = ConsumeAllFocus;
	}

	if(GhostOnlyCost)
	{
		FocusCost.GhostOnlyCost = GhostOnlyCost;
	}

	return FocusCost;
}