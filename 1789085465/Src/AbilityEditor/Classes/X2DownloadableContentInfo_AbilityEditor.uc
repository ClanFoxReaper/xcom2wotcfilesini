//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_AbilityEditor.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_AbilityEditor extends X2DownloadableContentInfo;

static event OnPostTemplatesCreated()
{
    class'OPTC_Abilities'.static.EditAbilityTemplates();
}