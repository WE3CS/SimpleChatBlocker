#include <sourcemod>

#define PLUGIN "Simple Chat Blocker"
#define VERSION "1.0"
#define AUTHOR "fezh"

new Handle: cvar_enabled
new Handle: cvar_message
new Handle: cvar_admins_flag

public Plugin:myinfo = 
{
	name = PLUGIN,
	author = AUTHOR,
	description = "Block chatting on server",
	version = VERSION,
	url = "http://forums.alliedmods.net/"
}

public OnPluginStart()
{
	cvar_enabled = CreateConVar("sm_chat_block", "1", "Turns Plugin On/Off", FCVAR_PLUGIN)
	cvar_message = CreateConVar("sm_chat_block_message", "1", "Enable/disable 'not' message while try chatting", FCVAR_PLUGIN)
	cvar_admins_flag = CreateConVar("sm_chat_block_immunity", "1", "Enable/disable chat only for server admins", FCVAR_PLUGIN)

	CreateConVar("sm_chat_block_version", VERSION, "Chat blocker version", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY)

	
	RegConsoleCmd("say", Command_Say)
}

public Action: Command_Say(client, args)
{
	static char menuTriggers[][] = { "666", "haha" };
	
	if (!GetConVarInt(cvar_enabled))
		return Plugin_Continue;

	if (GetConVarInt(cvar_admins_flag) && GetUserAdmin(client))
		return Plugin_Continue;

	if (GetConVarInt(cvar_message))
		{
		char text[24];
        GetCmdArgString(text, sizeof(text));
        StripQuotes(text);
        TrimString(text);
		
			for (int i = 0; i < sizeof(menuTriggers); i++)
			{
            if (!StrEqual(text, menuTriggers[i]))
			PrintToChat(client, "特殊时期本服务器禁止公屏聊天...")
			else
			return Plugin_Stop;
			}	
		}

	return Plugin_Handled;
}