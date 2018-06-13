Emoticons_Settings={
	["CHAT_MSG_OFFICER"]=true,		--1
	["CHAT_MSG_GUILD"]=true,		--2
	["CHAT_MSG_PARTY"]=true,		--3
	["CHAT_MSG_PARTY_LEADER"]=true,		--dont count, tie to 3
	["CHAT_MSG_PARTY_GUIDE"]=true,		--dont count, tie to 3
	["CHAT_MSG_RAID"]=true,			--4
	["CHAT_MSG_RAID_LEADER"]=true,		--dont count, tie to 4
	["CHAT_MSG_RAID_WARNING"]=true,		--dont count, tie to 4
	["CHAT_MSG_SAY"]=true,			--5
	["CHAT_MSG_YELL"]=true,			--6
	["CHAT_MSG_WHISPER"]=true,		--7
	["CHAT_MSG_WHISPER_INFORM"]=true,	--dont count, tie to 7
	["CHAT_MSG_CHANNEL"]=true,		--8
	["CHAT_MSG_BN_WHISPER"]=true,	--9
	["CHAT_MSG_BN_WHISPER_INFORM"]=true,--dont count, tie to 9
	["CHAT_MSG_BN_CONVERSATION"]=true,--10
	["CHAT_MSG_INSTANCE_CHAT"]=true,--11
	["CHAT_MSG_INSTANCE_CHAT_LEADER"]=true,--dont count, tie to 11
	["MAIL"]=true,					
	["TWITCHBUTTON"]=true,
	["sliderX"]=-35,
	["sliderY"]=0,
	["MinimapPos"] = 45,
	["MINIMAPBUTTON"] = true,
	["FAVEMOTES"] = {true,true,true,true,true,true,true,true,true,true,
					true,true,true,true,true,true,true,true,true,true,
					true,true,true,true,true,true,true,true,true,true,
					true,true,true,true,true,true}
	
};
Emoticons_Eyecandy = false;



local origsettings = {
	["CHAT_MSG_OFFICER"]=true,
	["CHAT_MSG_GUILD"]=true,
	["CHAT_MSG_PARTY"]=true,
	["CHAT_MSG_PARTY_LEADER"]=true,
	["CHAT_MSG_PARTY_GUIDE"]=true,
	["CHAT_MSG_RAID"]=true,
	["CHAT_MSG_RAID_LEADER"]=true,
	["CHAT_MSG_RAID_WARNING"]=true,
	["CHAT_MSG_SAY"]=true,
	["CHAT_MSG_YELL"]=true,
	["CHAT_MSG_WHISPER"]=true,
	["CHAT_MSG_WHISPER_INFORM"]=true,
	["CHAT_MSG_BN_WHISPER"]=true,
	["CHAT_MSG_BN_WHISPER_INFORM"]=true,
	["CHAT_MSG_BN_CONVERSATION"]=true,
	["CHAT_MSG_CHANNEL"]=true,
	["CHAT_MSG_INSTANCE_CHAT"]=true,
	["MAIL"]=true,
	["TWITCHBUTTON"]=true,
	["sliderX"]=-35,
	["sliderY"]=0,
	["MinimapPos"] = 45,
	["MINIMAPBUTTON"] = true,
	["FAVEMOTES"] = {true,true,true,true,true,true,true,true,true,true,
					true,true,true,true,true,true,true,true,true,true,
					true,true,true,true,true,true,true,true,true,true,
					true,true,true,true,true,true}
};



local ItemTextFrameSetText = ItemTextPageText.SetText;



-- Call this in a mod's initialization to move the minimap button to its saved position (also used in its movement)
-- ** do not call from the mod's OnLoad, VARIABLES_LOADED or later is fine. **
function MyMod_MinimapButton_Reposition()
	MyMod_MinimapButton:SetPoint("TOPLEFT","Minimap","TOPLEFT",52-(80*cos(Emoticons_Settings["MinimapPos"])),(80*sin(Emoticons_Settings["MinimapPos"]))-52)
end

-- Only while the button is dragged this is called every frame
function MyMod_MinimapButton_DraggingFrame_OnUpdate()

	local xpos,ypos = GetCursorPosition()
	local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()
	MyMod_MinimapButton:SetToplevel(true)
	xpos = xmin-xpos/UIParent:GetScale()+70 -- get coordinates as differences from the center of the minimap
	ypos = ypos/UIParent:GetScale()-ymin-70

	Emoticons_Settings["MinimapPos"] = math.deg(math.atan2(ypos,xpos)) -- save the degrees we are relative to the minimap center
	MyMod_MinimapButton_Reposition() -- move the button
end

-- Put your code that you want on a minimap button click here.  arg1="LeftButton", "RightButton", etc
function MyMod_MinimapButton_OnClick()
		Lib_ToggleDropDownMenu(1, nil, EmoticonChatFrameDropDown, MyMod_MinimapButton, 0, 0);
end

function ItemTextPageText.SetText(self,msg,...)
	if(Emoticons_Settings["MAIL"] and msg ~= nil) then
		msg = Emoticons_RunReplacement(msg);
	end
	ItemTextFrameSetText(self,msg,...);
end

local OpenMailBodyTextSetText = OpenMailBodyText.SetText;
function OpenMailBodyText.SetText(self,msg,...)
	if(Emoticons_Settings["MAIL"] and msg ~= nil) then
		msg = Emoticons_RunReplacement(msg);
	end
	OpenMailBodyTextSetText(self,msg,...);
end

function Emoticons_LoadChatFrameDropdown(self, level, menuList)
	local info          = Lib_UIDropDownMenu_CreateInfo();
	if (level or 1) == 1 then
		for k,v in ipairs(dropdown_options) do
			if (Emoticons_Settings["FAVEMOTES"][k]) then
				info.hasArrow = true;
				info.text = v[1];
				info.value = false;
				info.menuList = k;
				Lib_UIDropDownMenu_AddButton(info);
			end
		end
	else
		first=true;
		for ke,va in ipairs(dropdown_options[menuList]) do
			if (first) then
				first = false;
			else
				--print(ke.." "..va);
				info.text       = "|T"..defaultpack[va].."|t "..va;
				info.value      = va;
				info.func = Emoticons_Dropdown_OnClick;
				Lib_UIDropDownMenu_AddButton(info, level);
			end
		end
		
	end
end

function Emoticons_Setxposi(x)
	Emoticons_Settings["sliderX"]=x;
	b:SetPoint("TOPLEFT",Emoticons_Settings["sliderX"],Emoticons_Settings["sliderY"]);
end

function Emoticons_Setyposi(y)
	Emoticons_Settings["sliderY"]=y;
	b:SetPoint("TOPLEFT",Emoticons_Settings["sliderX"],Emoticons_Settings["sliderY"]);
end

function Emoticons_Dropdown_OnClick(self,arg1,arg2,arg3)
	if(ACTIVE_CHAT_EDIT_BOX ~= nil) then
		ACTIVE_CHAT_EDIT_BOX:Insert(self.value);
	end
end

function Emoticons_MailFrame_OnChar(self)
	local msg = self:GetText();
	if(Emoticons_Eyecandy and Emoticons_Settings["MAIL"] and string.sub(msg,1,1) ~= "/") then
		self:SetText(Emoticons_RunReplacement(msg));
	end
end

local sm = SendMail;
function SendMail(recipient,subject,msg,...)
	if(Emoticons_Eyecandy and Emoticons_Settings["MAIL"]) then
		msg = Emoticons_Deformat(msg);
	end
	sm(recipient,subject,msg,...);
end



local scm = SendChatMessage;
function SendChatMessage(msg,...)
	if(Emoticons_Eyecandy) then
		msg = Emoticons_Deformat(msg);
	end
	scm(msg,...);
end

local bnsw = BNSendWhisper;
function BNSendWhisper(id,msg,...)
	if(Emoticons_Eyecandy) then
		msg = Emoticons_Deformat(msg);
	end
	bnsw(id,msg,...);
end

function Emoticons_UpdateChatFilters()
	for k,v in pairs(Emoticons_Settings) do
		if(k ~= "MAIL" and k ~= "TWITCHBUTTON" and k ~= "sliderX" and k ~= "sliderY") then
			if(v) then
				ChatFrame_AddMessageEventFilter(k,Emoticons_MessageFilter)
			else
				ChatFrame_RemoveMessageEventFilter(k,Emoticons_MessageFilter);
			end
		end
	end
end

function Emoticons_MessageFilter(self, event, msg, ...)
	
	msg = Emoticons_RunReplacement(msg);
	
	return false, msg, ...
end
-- addon hat saved vars geladen
function Emoticons_OnEvent(self,event,...)
	if(event == "ADDON_LOADED" and select(1,...) == "SaunanTaakseEmotes") then
		for k,v in pairs(origsettings) do
			if(Emoticons_Settings[k] == nil) then
				Emoticons_Settings[k] = v;
			end
		end
		Emoticons_UpdateChatFilters();
		

b:SetPoint("TOPLEFT",Emoticons_Settings["sliderX"],Emoticons_Settings["sliderY"]);
b:SetWidth(24);
b:SetHeight(24);
b:RegisterForClicks("AnyUp", "AnyDown");
b:SetNormalTexture("Interface\\AddOns\\SaunanTaakseEmotes\\1337.tga");
Emoticons_SetTwitchButton(Emoticons_Settings["TWITCHBUTTON"]);
Emoticons_SetMinimapButton(Emoticons_Settings["MINIMAPBUTTON"]);
MyMod_MinimapButton_Reposition();		
		
		
		
		
		
	end
end



function Emoticons_OptionsWindow_OnShow(self)
	for k,v in pairs(Emoticons_Settings) do 
		local cb = getglobal("EmoticonsOptionsControlsPanel"..k);
	
		if(cb ~= nil) then
			cb:SetChecked(Emoticons_Settings[k]);
		end
	end
	SliderXText:SetText("Position X: "..Emoticons_Settings["sliderX"]);
	SliderYText:SetText("Position Y: "..Emoticons_Settings["sliderY"]);
	--EmoticonsOptionsControlsPanelEyecandy:SetChecked(Emoticons_Eyecandy);
	
	favall = CreateFrame("CheckButton", "favall_GlobalName", EmoticonsOptionsControlsPanelTrenner3,"UIRadioButtonTemplate" );
	--getglobal("favall_GlobalName"):SetChecked(false);
	favall:SetPoint("TOPLEFT", 0,-16);
	getglobal(favall:GetName().."Text"):SetText("Check all");
	favall.tooltip = "Check all boxes below.";
	getglobal("favall_GlobalName"):SetScript("OnClick", 
	  function(self)
		if (self:GetChecked()) then
			if (getglobal("favnone_GlobalName"):GetChecked() == true) then
				getglobal("favnone_GlobalName"):SetChecked(false);
			end
			self:SetChecked(true);
			for n,m in ipairs(Emoticons_Settings["FAVEMOTES"]) do
				Emoticons_Settings["FAVEMOTES"][n] = true;
				--print("favCheckButton_"..dropdown_options[n][1]);
				if (getglobal("favCheckButton_"..dropdown_options[n][1]):GetChecked() == false) then
					getglobal("favCheckButton_"..dropdown_options[n][1]):SetChecked(true);
				end
			end
		else
			--Emoticons_Settings["FAVEMOTES"][a] = false;
		end
	  end
	);

	favnone = CreateFrame("CheckButton", "favnone_GlobalName", favall_GlobalName,"UIRadioButtonTemplate" );
	--getglobal("favnone_GlobalName"):SetChecked(false);
	favnone:SetPoint("TOPLEFT", 110,0);
	getglobal(favnone:GetName().."Text"):SetText("Uncheck all");
	favnone.tooltip = "Uncheck all boxes below.";
	getglobal("favnone_GlobalName"):SetScript("OnClick", 
		function(self)
			if (self:GetChecked()) then
				if (getglobal("favall_GlobalName"):GetChecked() == true) then
					getglobal("favall_GlobalName"):SetChecked(false);
				end
				self:SetChecked(true);
				for n,m in ipairs(Emoticons_Settings["FAVEMOTES"]) do
					Emoticons_Settings["FAVEMOTES"][n] = false;
					if (getglobal("favCheckButton_"..dropdown_options[n][1]):GetChecked()==true) then
						getglobal("favCheckButton_"..dropdown_options[n][1]):SetChecked(false);
					end
				end
				--Emoticons_Settings["FAVEMOTES"][a] = true;
			else
				--Emoticons_Settings["FAVEMOTES"][a] = false;
			end
		end
	);

	favframe = CreateFrame("Frame", "favframe_GlobalName", favall_GlobalName);
	favframe:SetPoint("TOPLEFT", 0,-24);
	favframe:SetSize(590,175);
	
	favframe:SetBackdrop({bgFile="Interface\\ChatFrame\\ChatFrameBackground",edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=true,tileSize=5,edgeSize= 2,});
favframe:SetBackdropColor(0, 0, 0,0.5);
first=true;
itemcnt=0
for a,c in ipairs(dropdown_options) do
	
	if first then 
		favCheckButton = CreateFrame("CheckButton", "favCheckButton_"..c[1], favframe_GlobalName, "ChatConfigCheckButtonTemplate");
		first=false;
		favCheckButton:SetPoint("TOPLEFT", 0, 3);
	else 
		--favbuttonlist=loadstring("favCheckButton_"..anchor);

		favCheckButton = CreateFrame("CheckButton", "favCheckButton_"..c[1], favframe_GlobalName, "ChatConfigCheckButtonTemplate");
		favCheckButton:SetParent("favCheckButton_"..anchor);
		if ((itemcnt % 10) ~= 0) then
			favCheckButton:SetPoint("TOPLEFT", 0, -16);
		else
		
			favCheckButton:SetPoint("TOPLEFT", 110, 9*16);
		end
	end
	itemcnt=itemcnt+1;
	anchor=c[1];

--code=[[print("favCheckButton_"..b[1]..":SetText(b[1])")]];

	getglobal(favCheckButton:GetName().."Text"):SetText(c[1]);
	if (getglobal("favCheckButton_"..c[1]):GetChecked() ~= Emoticons_Settings["FAVEMOTES"][a]) then
		getglobal("favCheckButton_"..c[1]):SetChecked(Emoticons_Settings["FAVEMOTES"][a]);
	end
	favCheckButton.tooltip = "Checked boxes will show in the dropdownlist.";
	favCheckButton:SetScript("OnClick", 
	  function(self)
		if (self:GetChecked()) then
			Emoticons_Settings["FAVEMOTES"][a] = true;
		else
			Emoticons_Settings["FAVEMOTES"][a] = false;
		end
	  end
	);
	
end

	
	
end

function Emoticons_Deformat(msg)
	for k,v in pairs(emoticons) do
		msg=string.gsub(msg,"|T"..defaultpack[k].."%:28%:28|t",v);
	end
	return msg;
end

function Emoticons_RunReplacement(msg)
	
	--remember to watch out for |H|h|h's
	
	local outstr = "";
	local origlen = string.len(msg);
	local startpos = 1;
	local endpos;

	while(startpos <= origlen) do
		endpos = origlen;
		local pos = string.find(msg,"|H",startpos,true);
		if(pos ~= nil) then
			endpos = pos;
		end
		outstr = outstr .. Emoticons_InsertEmoticons(string.sub(msg,startpos,endpos)); --run replacement on this bit
		startpos = endpos + 1;
		if(pos ~= nil) then
			endpos = string.find(msg,"|h",startpos,true);
			if(endpos == nil) then
				endpos = origlen;
			end
			if(startpos < endpos) then
				outstr = outstr .. string.sub(msg,startpos,endpos); --don't run replacement on this bit
				startpos = endpos + 1;
			end
		end
	end
	
	return outstr;
end

function Emoticons_SetEyecandy(state)
	if(state) then
		Emoticons_Eyecandy = true;
		if(ACTIVE_CHAT_EDIT_BOX~=nil) then
			ACTIVE_CHAT_EDIT_BOX:SetText(Emoticons_RunReplacement(ACTIVE_CHAT_EDIT_BOX:GetText()));
		end
	else
		Emoticons_Eyecandy = false;
		if(ACTIVE_CHAT_EDIT_BOX~=nil) then
			ACTIVE_CHAT_EDIT_BOX:SetText(Emoticons_Deformat(ACTIVE_CHAT_EDIT_BOX:GetText()));
		end
	end
end

function Emoticons_SetTwitchButton(state)
	if(state) then
		state = true;
	else
		state = false;
	end
	Emoticons_Settings["TWITCHBUTTON"]=state;
	if(state) then
		TestButton:Show();
	else
		TestButton:Hide();
	end
end

function Emoticons_SetMinimapButton(state)
	if(state) then
		state = true;
	else
		state = false;
	end
	Emoticons_Settings["MINIMAPBUTTON"]=state;
	if(state) then
		MyMod_MinimapButton:Show();
	else
		MyMod_MinimapButton:Hide();
	end
end


function Emoticons_InsertEmoticons(msg)
	

	
	--print(table.getn(words)) ;
	for k,v in pairs(emoticons) do
		if (string.find(msg,k,1,true)) then
			msg = string.gsub(msg,"(%s)"..k.."(%s)","%1|T"..defaultpack[v].."|t%2");
			msg = string.gsub(msg,"(%s)"..k.."$","%1|T"..defaultpack[v].."|t");
			msg = string.gsub(msg,"^"..k.."(%s)","|T"..defaultpack[v].."|t%1");
			msg = string.gsub(msg,"^"..k.."$","|T"..defaultpack[v].."|t");
			msg = string.gsub(msg,"(%s)"..k.."(%c)","%1|T"..defaultpack[v].."|t%2");
			msg = string.gsub(msg,"(%s)"..k.."(%s)","%1|T"..defaultpack[v].."|t%2");
		end
	end
	
	
	
	--print(abc);
	return msg;
end

function Emoticons_SetType(chattype,state)
	if(state) then
		state = true;
	else
		state = false;
	end
	if(chattype == "CHAT_MSG_RAID") then
		Emoticons_Settings["CHAT_MSG_RAID_LEADER"] = state;
		Emoticons_Settings["CHAT_MSG_RAID_WARNING"] = state;
	end
	if(chattype == "CHAT_MSG_PARTY") then
		Emoticons_Settings["CHAT_MSG_PARTY_LEADER"] = state;
		Emoticons_Settings["CHAT_MSG_PARTY_GUIDE"] = state;
	end
	if(chattype == "CHAT_MSG_WHISPER") then
		Emoticons_Settings["CHAT_MSG_WHISPER_INFORM"] = state;
	end
	if(chattype == "CHAT_MSG_INSTANCE_CHAT") then
		Emoticons_Settings["CHAT_MSG_INSTANCE_CHAT_LEADER"] = state;
	end
	if(chattype == "CHAT_MSG_BN_WHISPER") then
		Emoticons_Settings["CHAT_MSG_BN_WHISPER_INFORM"] = state;
	end
	
	Emoticons_Settings[chattype] = state;
	Emoticons_UpdateChatFilters();
end

b = CreateFrame("Button", "TestButton", ChatFrame1, "UIPanelButtonTemplate");

