Scriptname ODST:Emblems:Preset extends ODST:Type
{A script for holding preset data.}
import ODST
import ODST:Log
import ODST:Papyrus
import ODST:Emblems:Editor

Actor Player

int OptionValue = -1
string SectionValue = ""
MatSwap MaterialValue

string SettingName_EmblemForeground = "iEmblem_Foreground" const
string SettingName_EmblemForeground_ColorPrimary = "iEmblem_Foreground_ColorPrimary" const
string SettingName_EmblemForeground_ColorSecondary = "iEmblem_Foreground_ColorSecondary" const
string SettingName_EmblemBackground = "iEmblem_Background" const
string SettingName_EmblemBackground_Color = "iEmblem_Background_Color" const


; Events
;---------------------------------------------

Event OnQuestInit()
	{The quest initialization event.}
	Player = Game.GetPlayer()
	WriteLine(self, "OnQuestInit")
EndEvent


; Methods
;---------------------------------------------

bool Function Initialize(int optionIndex, string sectionName, int materialFormID)
	{Pseudo constructor for initializing the preset.}
	OptionValue = optionIndex
	If (OptionValue == Invalid)
		WriteUnexpectedValue(ToString(), "Initialize", "OptionValue", "The value cannot invalid.")
		return false
	EndIf

	SectionValue = sectionName
	If (!SectionValue)
		WriteUnexpectedValue(ToString(), "Initialize", "SectionValue", "The value cannot be none or empty.")
		return false
	EndIf

	MaterialValue = GetExternal(Properties.PluginFile, materialFormID) as MatSwap
	If (!MaterialValue)
		WriteUnexpectedValue(ToString(), "Initialize", "MaterialValue", "The value cannot be none.")
		return false
	EndIf

	WriteLine(ToString(), "Initialize")
	return true
EndFunction


bool Function Deserialize(MCM:Menu sender)
	{Deserialize the mod settings from disk.}
	If (sender)
		If (Section)
			Foreground = sender.GetModSettingFor(SettingName_EmblemForeground, Section)
			ForegroundColorPrimary = sender.GetModSettingFor(SettingName_EmblemForeground_ColorPrimary, Section)
			ForegroundColorSecondary = sender.GetModSettingFor(SettingName_EmblemForeground_ColorSecondary, Section)
			Background = sender.GetModSettingFor(SettingName_EmblemBackground, Section)
			BackgroundColor = sender.GetModSettingFor(SettingName_EmblemBackground_Color, Section)
			return true
		Else
			WriteUnexpectedValue(ToString(), "Deserialize", "Section", "Cannot be none or empty.")
			return false
		EndIf
	Else
		WriteUnexpectedValue(ToString(), "Deserialize", "sender", "Cannot be none or empty.")
		return false
	EndIf
EndFunction


bool Function SetValue(MCM:Menu sender, MCM:Menu:OptionEventArgs e)
	{@`Editor` Changes the given preset value.}
	If (sender)
		If (e)
			If (Section)
				If (e.Identifier == sender.GetIdentifier(SettingName_EmblemForeground, Section))
					Foreground = e.Value
					return true
				ElseIf (e.Identifier == sender.GetIdentifier(SettingName_EmblemForeground_ColorPrimary, Section))
					ForegroundColorPrimary = e.Value
					return true
				ElseIf (e.Identifier == sender.GetIdentifier(SettingName_EmblemForeground_ColorSecondary, Section))
					ForegroundColorSecondary = e.Value
					return true
				ElseIf (e.Identifier == sender.GetIdentifier(SettingName_EmblemBackground, Section))
					Background = e.Value
					return true
				ElseIf (e.Identifier == sender.GetIdentifier(SettingName_EmblemBackground_Color, Section))
					BackgroundColor = e.Value
					return true
				Else
					WriteUnexpectedValue(ToString(), "SetValue", "e.Identifier", "The identifier '"+e.Identifier+"' is unhandled.")
					return false
				EndIf
			Else
				WriteUnexpectedValue(ToString(), "SetValue", "Section", "Cannot be none or empty.")
				return false
			EndIf
		Else
			WriteUnexpectedValue(ToString(), "SetValue", "e", "Cannot be none or empty.")
			return false
		EndIf
	Else
		WriteUnexpectedValue(ToString(), "SetValue", "sender", "Cannot be none or empty.")
		return false
	EndIf
EndFunction


bool Function Remap(Emblems:Editor editor)
	{Remaps the material to the current preset values. This does not provide a visual update.}
	If (Material)
		MatSwap:RemapData[] remapping = new MatSwap:RemapData[0]

		MatSwap:RemapData remapPrimary = new MatSwap:RemapData
		remapPrimary.Source = editor.PrimaryDefault
		remapPrimary.Target = editor.PrimaryDefault
		remapping.Add(remapPrimary)

		MatSwap:RemapData remapSecondary = new MatSwap:RemapData
		remapSecondary.Source = editor.SecondaryDefault
		remapSecondary.Target = editor.SecondaryDefault
		remapping.Add(remapSecondary)

		MatSwap:RemapData remapBackground = new MatSwap:RemapData
		remapBackground.Source = editor.BackgroundDefault
		remapBackground.Target = editor.BackgroundDefault
		remapping.Add(remapBackground)

		string sForeground = editor.Symbol.ForegroundToFolder(Foreground)
		If (sForeground != editor.Symbol.Blank)
			string sForegroundColorPrimary = editor.Color.OptionToFolder(ForegroundColorPrimary)
			string sForegroundColorSecondary = editor.Color.OptionToFolder(ForegroundColorSecondary)
			remapPrimary.Target = editor.ToMaterialPath(editor.PrimaryLayer, sForegroundColorPrimary, sForeground)
			remapSecondary.Target = editor.ToMaterialPath(editor.SecondaryLayer, sForegroundColorSecondary, sForeground)
		EndIf

		string sBackground = editor.Symbol.BackgroundToFolder(Background)
		If (sBackground != editor.Symbol.Blank)
			string sBackgroundColor = editor.Color.OptionToFolder(BackgroundColor)
			remapBackground.Target = editor.ToMaterialPath(editor.BackgroundLayer, sBackgroundColor, sBackground)
		EndIf

		Material.SetRemapData(remapping)
		return true
	Else
		WriteUnexpectedValue(ToString(), "Remap", "Material", "The material cannot be none.")
		return false
	EndIf
EndFunction


; Functions
;---------------------------------------------

string Function ToString()
	{The string representation of this type.}
	return parent.ToString()+"[Option:"+OptionValue+", Section:"+SectionValue+", Material:"+Material+"]"
EndFunction


; Properties
;---------------------------------------------

Group Properties
	ODST:Properties Property Properties Auto Const Mandatory
EndGroup

Group Materials
	MatSwap Property Material Hidden
		{The material swap for this preset.}
		MatSwap Function Get()
			return MaterialValue
		EndFunction
	EndProperty
EndGroup

Group Configuration
	int Property Option Hidden
		{The MCM option index for this preset.}
		int Function Get()
			return OptionValue
		EndFunction
	EndProperty

	bool Property Condition = true Auto Hidden
	{@`config.json` The MCM group condition for a hidden switcher control.}

	int Property Foreground = -1 Auto Hidden
	{@`config.json` The current option value.}

	int Property ForegroundColorPrimary = -1 Auto Hidden
	{@`config.json` The current option value.}

	int Property ForegroundColorSecondary = -1 Auto Hidden
	{@`config.json` The current option value.}

	int Property Background = -1 Auto Hidden
	{@`config.json` The current option value.}

	int Property BackgroundColor = -1 Auto Hidden
	{@`config.json` The current option value.}
EndGroup

Group Settings
	string Property Section Hidden
		{The MCM ini section name for these settings.}
		string Function Get()
			return SectionValue
		EndFunction
	EndProperty
EndGroup
